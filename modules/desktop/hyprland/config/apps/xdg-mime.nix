# NOTE: finish config
# example: https://github.com/gytis-ivaskevicius/nixfiles/blob/f644edf7abbc5c8190421b88408a23ce73f53a4b/home-manager/common.nix#L48
let
  editor = [ "nvim.desktop" ];
  browser = [ "zen-beta.desktop" ];
  fileBrowser = [ "yazi.desktop" ];
  imageViewer = [ "org.gnome.Loupe.desktop" ]; # TODO: change to sxiv/feh
  # https://www.youtube.com/watch?v=GYW9i_u5PYs
  pdfViewer = [ "org.pwmt.zathura.desktop" ];
  tg = [ "org.telegram.desktop.desktop" ];
  add_associations = {
    "application/pdf" = pdfViewer;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "image/avif" = imageViewer;
    "image/bmp" = imageViewer;
    "image/gif" = imageViewer;
    "image/heic" = imageViewer;
    "image/jpeg" = imageViewer;
    "image/jxl" = imageViewer;
    "image/png" = imageViewer;
    "image/svg+xml" = imageViewer;
    "image/svg+xml-compressed" = imageViewer;
    "image/tiff" = imageViewer;
    "image/vnd-ms.dds" = imageViewer;
    "image/vnd.microsoft.icon" = imageViewer;
    "image/vnd.radiance" = imageViewer;
    "image/webp" = imageViewer;
    "image/x-dds" = imageViewer;
    "image/x-exr" = imageViewer;
    "image/x-portable-anymap" = imageViewer;
    "image/x-portable-bitmap" = imageViewer;
    "image/x-portable-graymap" = imageViewer;
    "image/x-portable-pixmap" = imageViewer;
    "image/x-qoi" = imageViewer;
    "image/x-tga" = imageViewer;
    "inode/directory" = fileBrowser;
    "text/html" = browser;
    "text/x-dbus-service" = editor;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/tg" = tg;
  };
  remove_associations = {
    "inode/directory" = [
      "kitty-open.desktop"
      "org.pwmt.zathura-cb.desktop"
    ];
  };
in
{
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = add_associations;
      associations = {
        added = add_associations;
        removed = remove_associations;
      };
    };
  };
}
