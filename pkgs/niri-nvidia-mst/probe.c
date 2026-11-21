#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "nv-ioctl.h"
#include "nv_escape.h"
#include "nvos.h"
#include "ctrl/ctrl0000/ctrl0000gpu.h"
#include "nvkms-api.h"
#include "nvkms-ioctl.h"
#include "nvUnixVersion.h"

/* Exit 0: active MST; 1: no active MST; 2: unknown (never disable on error). */
static int kms_query(int fd, enum NvKmsIoctlCommand command, void *data, size_t size)
{
    /* Do not add modesets, ownership, hotplug handling, or EDID overrides here. */
    switch (command) {
    case NVKMS_IOCTL_ALLOC_DEVICE:
    case NVKMS_IOCTL_FREE_DEVICE:
    case NVKMS_IOCTL_QUERY_DISP:
    case NVKMS_IOCTL_QUERY_CONNECTOR_DYNAMIC_DATA:
    case NVKMS_IOCTL_QUERY_DPY_STATIC_DATA:
    case NVKMS_IOCTL_GET_DPY_ATTRIBUTE:
        break;
    default:
        return -1;
    }
    struct NvKmsIoctlParams params = {
        .cmd = command, .size = size, .address = (NvU64)(NvUPtr)data
    };
    if (ioctl(fd, NVKMS_IOCTL_IOWR, &params) < 0) {
        fprintf(stderr, "NVKMS query %u: %s\n", command, strerror(errno));
        return -1;
    }
    return 0;
}
#define QUERY(fd, cmd, params) kms_query(fd, cmd, &(params), sizeof(params))
#define RM_IOCTL(fd, cmd, params) ioctl(fd, _IOWR(NV_IOCTL_MAGIC, cmd, __typeof__(params)), &(params))

static int device_instance(const char *pci, NvU32 *instance)
{
    unsigned domain, bus, slot, function;
    int consumed = 0;
    if (sscanf(pci, "%x:%x:%x.%x%n", &domain, &bus, &slot, &function, &consumed) != 4 ||
        pci[consumed] || domain > 0xffff || bus > 0xff || slot > 31 || function > 7) {
        fprintf(stderr, "Invalid PCI address: %s\n", pci);
        return -1;
    }
    int fd = open("/dev/nvidiactl", O_RDWR | O_CLOEXEC);
    if (fd < 0) { perror("open nvidiactl"); return -1; }
    int result = -1;
    nv_ioctl_card_info_t cards[NV_MAX_DEVICES] = {0};
    NVOS21_PARAMETERS client = {.hClass = NV01_ROOT_CLIENT};
    if (RM_IOCTL(fd, NV_ESC_CARD_INFO, cards) < 0) goto done;
    NvU32 gpu_id = 0;
    NvBool found = NV_FALSE;
    for (size_t i = 0; i < NV_MAX_DEVICES; i++) {
        if (cards[i].valid && cards[i].pci_info.vendor_id == 0x10de &&
            cards[i].pci_info.domain == domain && cards[i].pci_info.bus == bus &&
            cards[i].pci_info.slot == slot && cards[i].pci_info.function == function) {
            gpu_id = cards[i].gpu_id;
            found = NV_TRUE;
            break;
        }
    }
    if (!found) { fprintf(stderr, "NVIDIA GPU not found: %s\n", pci); goto done; }
    if (RM_IOCTL(fd, NV_ESC_RM_ALLOC, client) < 0 || client.status != 0) goto done;
    NV0000_CTRL_GPU_GET_ID_INFO_V2_PARAMS info = {.gpuId = gpu_id};
    NVOS54_PARAMETERS control = {
        .hClient = client.hObjectNew, .hObject = client.hObjectNew,
        .cmd = NV0000_CTRL_CMD_GPU_GET_ID_INFO_V2,
        .params = (NvP64)&info, .paramsSize = sizeof(info)
    };
    if (RM_IOCTL(fd, NV_ESC_RM_CONTROL, control) == 0 && control.status == 0) {
        /* Wait for an existing GPU user rather than initializing an unused GPU. */
        if ((info.gpuFlags & 1U) != 0) {
            *instance = info.deviceInstance;
            result = 0;
        } else {
            fprintf(stderr, "GPU is not in use; wait for compositor attachment\n");
        }
    }
    NVOS00_PARAMETERS release = {
        .hRoot = client.hObjectNew, .hObjectOld = client.hObjectNew
    };
    if (RM_IOCTL(fd, NV_ESC_RM_FREE, release) < 0 || release.status != 0) result = -1;
done:
    if (result != 0) fprintf(stderr, "Cannot resolve RM device for %s\n", pci);
    close(fd);
    return result;
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: nvidia-mst-probe PCI-ADDRESS\n");
        return 2;
    }
    FILE *version = fopen("/sys/module/nvidia/version", "r");
    char loaded[64] = {0};
    if (!version) { perror("NVIDIA version"); return 2; }
    int got_version = fgets(loaded, sizeof(loaded), version) != NULL;
    fclose(version);
    loaded[strcspn(loaded, "\n")] = 0;
    if (!got_version || strcmp(loaded, NV_VERSION_STRING) != 0) {
        fprintf(stderr, "Driver/header mismatch: %s != %s\n", loaded, NV_VERSION_STRING);
        return 2;
    }
    NvU32 instance;
    if (device_instance(argv[1], &instance) < 0) return 2;
    int fd = open("/dev/nvidia-modeset", O_RDWR | O_CLOEXEC);
    if (fd < 0) { perror("open nvidia-modeset"); return 2; }
    int result = 2;
    NvBool active_mst = NV_FALSE;
    struct NvKmsAllocDeviceParams alloc = {0};
    snprintf(alloc.request.versionString, sizeof(alloc.request.versionString), "%s", NV_VERSION_STRING);
    alloc.request.deviceId.rmDeviceId = instance;
    alloc.request.no3d = NV_TRUE;
    alloc.request.enableConsoleHotplugHandling = NV_FALSE;
    if (QUERY(fd, NVKMS_IOCTL_ALLOC_DEVICE, alloc) < 0 ||
        alloc.reply.status != NVKMS_ALLOC_DEVICE_STATUS_SUCCESS) {
        fprintf(stderr, "NVKMS allocation status %u\n", alloc.reply.status);
        goto done;
    }
    if (alloc.reply.numDisps > NVKMS_MAX_SUBDEVICES) goto done;
    for (NvU32 i = 0; i < alloc.reply.numDisps; i++) {
        struct NvKmsQueryDispParams disp = {0};
        disp.request.deviceHandle = alloc.reply.deviceHandle;
        disp.request.dispHandle = alloc.reply.dispHandles[i];
        if (QUERY(fd, NVKMS_IOCTL_QUERY_DISP, disp) < 0) goto done;
        if (disp.reply.numConnectors > NVKMS_MAX_CONNECTORS_PER_DISP) goto done;
        NVDpyIdList ids = disp.reply.validDpys;
        for (NvU32 j = 0; j < disp.reply.numConnectors; j++) {
            struct NvKmsQueryConnectorDynamicDataParams cd = {0};
            cd.request.deviceHandle = alloc.reply.deviceHandle;
            cd.request.dispHandle = disp.request.dispHandle;
            cd.request.connectorHandle = disp.reply.connectorHandles[j];
            if (QUERY(fd, NVKMS_IOCTL_QUERY_CONNECTOR_DYNAMIC_DATA, cd) < 0) goto done;
            if (!cd.reply.detectComplete) {
                fprintf(stderr, "DisplayPort detection still in progress\n");
                goto done;
            }
            ids = nvAddDpyIdListToDpyIdList(ids, cd.reply.dynamicDpyIdList);
        }
        NVDpyId id = nvInvalidDpyId();
        while (!nvDpyIdIsInvalid(id = nvNextDpyIdInDpyIdListUnsorted(id, ids))) {
            struct NvKmsQueryDpyStaticDataParams ds = {0};
            ds.request.deviceHandle = alloc.reply.deviceHandle;
            ds.request.dispHandle = disp.request.dispHandle;
            ds.request.dpyId = id;
            if (QUERY(fd, NVKMS_IOCTL_QUERY_DPY_STATIC_DATA, ds) < 0) goto done;
            if (!ds.reply.isDpMST) continue;
            struct NvKmsGetDpyAttributeParams head = {0};
            head.request.deviceHandle = ds.request.deviceHandle;
            head.request.dispHandle = ds.request.dispHandle;
            head.request.dpyId = id;
            head.request.attribute = NV_KMS_DPY_ATTRIBUTE_HEAD;
            if (QUERY(fd, NVKMS_IOCTL_GET_DPY_ATTRIBUTE, head) < 0) goto done;
            /* Dynamic MST objects can survive unplugging; only count scanout. */
            if (head.reply.value >= 0 && (NvU64)head.reply.value < alloc.reply.numHeads)
                active_mst = NV_TRUE;
        }
    }
    struct NvKmsFreeDeviceParams release = {0};
    release.request.deviceHandle = alloc.reply.deviceHandle;
    if (QUERY(fd, NVKMS_IOCTL_FREE_DEVICE, release) < 0) goto done;
    puts(active_mst ? "active" : "inactive");
    result = active_mst ? 0 : 1;
done:
    /* The fd also releases this client's allocation on every error path. */
    close(fd);
    return result;
}
