            Function Get-ScriptDirectory 
            {
                ( $PSCommandPath , $PSISE.CurrentFile.FullPath )[ $PSISE -ne $Null ] | % {

                    If ( $_.Length -gt 0 )
                    {
                        [ PSCustomObject ]@{ 
                
                            Parent = Split-Path $_ -Parent
                            Leaf   = Split-Path $_ -Leaf 
                        }
                    }

                    Else 
                    {
                        Write-Host "Exception [!] File Path not detected. Dot Source the file, or Right-Click the file, Run w/ PowerShell" -F 12
                    }
                }
            }
        
            Function Install-HybridDSCModule
            {
                $Source                    = Get-ScriptDirectory | % { If ( $_.Parent -ne $Null ) { $_.Parent } Else { Break } }
                $Module                    = "HybridDSC"
                $Version                   = "2020.3.0"
                $Root                      = "SOFTWARE\Policies\Secure Digits Plus LLC"
                $Path                      = "HKLM:"
                $Full                      = "$Path\$Root"
                
                $Root.Split('\')           | % { If ( ! ( Test-Path "$Path\$_" ) ) { NI $Path -Name $_ -VB } ; $Path += "\$_" }
        
                SP $Path           -Name    "Date" -Value                   ( Get-Date -UFormat "%m/%d/%Y %T" ) -VB
                NI $Path           -Name   $Module                                                              -VB

                $Path                      = "$Full\$Module\Module"

                NI "$Full\$Module" -Name  "Module"                                                              -VB
                SP $Path           -Name    "Path" -Value "$Env:ProgramFiles\WindowsPowerShell\Modules\$Module" -VB
                SP $Path           -Name    "Date" -Value                   ( Get-Date -UFormat "%m/%d/%Y %T" ) -VB
                SP $Path           -Name "Version" -Value                                             $Version  -VB
                    
                $Mod                       = GP $Path | % { $_.Path }

                If ( ! ( Test-Path $Mod ) )
                {
                    NI $Mod -ItemType Directory -VB
                }

                Expand-Archive $Source $Mod -Force -VB

                GCI $Mod *zip* | % { Expand-Archive $_.FullName $Mod -Force -VB ; RI $_.FullName -Force -VB }

                GCI $Mod *ps1* | % { IPMO $_.FullName -Force }
            }

            Install-HybridDSCModule
