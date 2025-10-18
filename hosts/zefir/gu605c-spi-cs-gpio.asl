/*
 * This is an SSDT file.
 */

DefinitionBlock ("", "SSDT", 2, "Cirrus", "CsGpios", 0x00001000)
{
    External (_SB_.PC00.SPI0, DeviceObj)
    External (_SB_.PC00.SPI0.SPK1, DeviceObj)

    Scope (_SB.PC00.SPI0)
    {
        Name (_DSD, Package ()
        {
            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),

            Package ()
            {
                Package ()
                {
                    "cs-gpios",
                    Package ()
                    {
                        0,             // Native CS0
                        SPK1, 0, 0, 0, // first GPIO declared in SPK1
                    }
                },
            }
        })
    }
}
