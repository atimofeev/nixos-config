{
  pkgs,
  lib,
  ...
}:

# NOTE: should be obsolete once Asus fixes the BIOS

let
  ssdt-gu605c-spi-cs-gpio-patch = pkgs.runCommand "ssdt-gu605c-spi-cs-gpio" { } ''
    mkdir iasl
    cp ${./gu605c-spi-cs-gpio.asl} iasl/gu605c-spi-cs-gpio.asl
    ${lib.getExe' pkgs.acpica-tools "iasl"} iasl/gu605c-spi-cs-gpio.asl

    mkdir -p kernel/firmware/acpi
    cp iasl/gu605c-spi-cs-gpio.aml kernel/firmware/acpi/
    find kernel | ${lib.getExe pkgs.cpio} -H newc --create > patched-acpi-tables.cpio

    cp patched-acpi-tables.cpio $out
  '';
in
{

  boot.initrd.prepend = [ (toString ssdt-gu605c-spi-cs-gpio-patch) ];

}
