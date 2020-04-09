

$VDI                 = [ PSCustomObject ]@{ 

    Base             = "C:\VDI"
}

GCI $VDI.Base        | % { 

    [ PSCustomObject ]@{ 

        VHD          = GCI $_.FullName *VHD*
        VMC          = GCI $_.FullName *VM*
    }
}

$Machine             = [ PSCustomObject ]@{ 

    Name             = "mail"
    Generation       = 2
    Memory           = 4096MB
    DynamicMemory    = $True
    Connection       = "Hyper-V"

    Disk             = @{

        New          = @{ 
        
            Name     = "mail.vhdx"
            Location = "C:\VDI\VHD"
            Size     = 64GB
        }

        Existing     = @{ 

            Location = ""

        }

        Attach       = @{
        
            Location = "N/A" 
        }
    }

    OS               = @{

        Network      = ""
        ISOPath      = "C:\Images\CentOS-8.1.1911-x86_64-dvd1.iso"
        Later        = ""
    }

    Security         = @{ 

        SecureBoot   = @{ 

            Enabled  = $False
            Template = ""
        }

        Encryption   = @{

            TPM      = @{

                Enabled = $False
            }
        }
    }
}
