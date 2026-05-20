# Patch NetworkManager-openconnect to actually forward CSD and usergroup
# arguments to the openconnect binary it spawns at connect time.
#
# Upstream gates the --csd-wrapper / --csd-user forwarding behind
# `if (FALSE && priv->tun_name)` (intentional dead code, see source TODO),
# so the running openconnect never receives those flags even when the
# connection profile sets `enable_csd_trojan=yes` and `csd_wrapper=...`.
# It also has no support for forwarding `usergroup`.
#
# For the GlobalProtect protocol the gateway requires a HIP report at
# tunnel-up time (hipreportcheck.esp); without --csd-wrapper the gateway
# silently applies a degraded ACL. Some GP deployments also require
# --usergroup to target the correct gateway.
#
# See ./patches/nm-openconnect-gp-csd.patch for the diff.
_final: prev:
{
  networkmanager-openconnect = prev.networkmanager-openconnect.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./patches/nm-openconnect-gp-csd.patch
    ];
  });
}
