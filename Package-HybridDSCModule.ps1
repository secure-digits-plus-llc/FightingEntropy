
    # Declare  Root
    "$Home\Documents\WindowsPowerShell\Modules" | % { 
    
        $Package                    = [ PSCustomObject ]@{ 
    
            Name                    = "Hybrid-DSC"
            Root                    = $_
            Full                    = ""
            Folders                 = ""
            Files                   = ""
            Install                 = "Install-HybridDSCModule"
        }
        
        $Package                    | % {

            $_.Full                 = $_.Root , $_.Name -join '\'
            $_.Folders              = $_.Full | % { GCI $_ -Directory }
            $_.Folders.FullName     | % { 

                $Splat              = @{

                    Path            = "$_"
                    DestinationPath = "$_.zip"
                }

                $Splat.DestinationPath | ? { Test-Path $_ } | % { RI $_ -Force }

                Compress-Archive @Splat -VB
            }

            $_.Files                = GCI $_.Full -File
            $_.Files.FullName       | % { 
            
                $Splat              = @{
                
                    Path            = "$_"
                    DestinationPath = $Package | % { $_.Full.Replace( $_.Name , $_.Install ) }
                    Update          = $True
                }
                
                Compress-Archive @Splat -VB
            }

            $_.Folders.FullName     | % { RI "$_.zip" -Force } 

            $Path                    = $Package | % { $_.Root , $_.Install -join '\' }

            SC -Path "$Path.ps1" -Value @'
    
            Function Get-ScriptDirectory 
            {
                $( If ( $psise ) { $psise.CurrentFile.FullPath } Else { $PSScriptRoot } ) | % {
        
                    [ PSCustomObject ]@{

                        Path = Split-Path $_ -Parent
                        File = Split-Path $_ -Leaf
                    }
                }
            }
    
            Function Install-HybridDSCModule
            {
                $Path  = $env:USERPROFILE
                $Tree  = "Documents\WindowsPowerShell\Modules\Hybrid-DSC"
                $Split = $Tree.Split( '\' )

                ForEach ( $I in 0..( $Split.Count - 1 ) ) 
                {
                    "$Path\$( $Split[$I] )" | % {

                        If ( ! ( Test-Path $_ ) )
                        {
                            NI $_ -ItemType Directory | Out-Null
                            Write-Host "   Created [+] $_" -F 11
                        }

                        Else 
                        {
                            Write-Host "  Detected [~] $_" -F 14
                        }

                        $Path = $_
                    }
                }

                GCI $Path | % { 
        
                    If ( $_ -ne $Null ) 
                    { 
                        Write-Host " Detected [!] $( $_.Name ), removing" -F 11 
                        RI $_.FullName -Recurse -Force 
                    }
                }

                $Source = Get-ScriptDirectory | % { $_.Path }
    
                'Hybrid-DSC' | % { 
        
                    If ( Test-Path "$Source\$_.zip" ) 
                    {
                        Write-Host "Extracting [~] $Path\$_" -F 14

                        Expand-Archive "$Source\$_.zip" "$Path" -VB
                    }

                    Else
                    {
                        Write-Host " Exception [!] Zip file not found"
                    }
                }

                "Graphics" , "Control" , "Map" , "Services" | % { 

                    Write-Host "Extracting [~] $Path\$_.zip" -F 11

                    Expand-Archive "$Path\$_.zip" $Path

                    RI "$Path\$_.zip"
                }
    
                IPMO Hybrid-DSC -Force
            }

            Install-HybridDSCModule
'@

            $Output = "$( $Package.Full ).zip"

            If ( Test-Path $Output )
            {
                RI $Output -Force -VB
            }

            ForEach ( $i in "ps1" , "zip" )
            {
                "$Path.$I" | % { 

                    $Splat              = @{

                        Path            = $_
                        DestinationPath = $Output
                        Update          = $True
                        
                    }

                    Compress-Archive @Splat -VB
                
                    RI $_ -Force -VB
                }
            }
        }
    }
