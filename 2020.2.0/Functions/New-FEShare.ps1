Function New-FEShare
{
    [CmdLetBinding()]
    Param(
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]        $Path ,
    [ValidateNotNullOrEmpty()]
    [Parameter(Mandatory)][String]   $ShareName ,
    [Parameter()]         [String] $Description = "[FightingEntropy]://Development Share" )

    Class _Share
    {
        Hidden [Object] $Shares
        [String]          $Path
        [String]      $Hostname
        [String]          $Name
        [Object]          $Root
        [String]     $ShareName
        [String]   $NetworkPath
        [String]   $Description = $Null

        _Share([String]$Path,[String]$SMBName,[String]$Description)
        {
            If (!(Test-Path $Path))
            {
                 New-Item -Path $Path -ItemType Directory -Verbose
            }

            $This.Root         = Get-Item -Path $Path
        
            If ($This.Root)
            {
                $This.Path     = $Path
            }

            $This.Description  = $Description
         
            Import-Module (Get-MDTModule)

            $This.Shares       = Get-MDTPersistentDrive

            $This.Hostname     = [Environment]::MachineName
            $This.ShareName    = "{0}$" -f $SMBName.TrimEnd("$")

            $This.Name         = $This.GetLabel()
            $This.NetworkPath  = "\\{0}\{1}" -f $This.HostName, $This.ShareName
        }

        [String] GetLabel()
        {                
            Return @( If ($This.Shares)
            {
                $This.Shares | % Name | % { @($_,$_[-1])[[Int32]($_.Count -gt 1)].Replace("DS","") } | % { "FE{0:d3}" -f ( [Int32]$_ + 1 ) }
            }

            Else
            {
                "FE001"
            })
        }

        [Object] CheckPath()
        {
            Return @( If ( $This.Root -in $This.Shares.Path )
            {
                $This.Shares | ? Path -eq $This.Root    
            }

            ElseIf ( $This.Name -in $This.Shares.Name )
            { 
                $This.Shares | ? Name -eq $This.Name
            })
        }

        NewSMB()
        {
            If ( $This.ShareName -notin ( Get-SMBShare | % Name ) )
            {
                Write-Host "New-SMBShare $($This.ShareName)"

                @{ 
                    Name        = $This.ShareName
                    Path        = $This.Root
                    Description = $This.Description 
                   
                }               | % { New-SMBShare @_ -FullAccess Administrators -Verbose }
            }
        }

        NewPSD()
        {
            If ( $This.Name -notin ( Get-PSDrive | % Name ) )
            {
                Write-Host "New-PSDrive $($This.Name)"

                @{  
                    Name           = $This.Name
                    PSProvider     = "MDTProvider"
                    Root           = $This.Root
                    Description    = $This.Description
                    NetworkPath    = $This.NetworkPath 

                }                  | % { New-PSDrive @_ | Add-MDTPersistentDrive -Verbose }
            }

            Else
            {
                Write-Host "Drive exists"
                New-PSDrive -Name $This.Name -Verbose
            }
        }
    }

    Import-Module (Get-MDTModule)

    $Item = [_Share]::New($Path,$ShareName,$Description)
    $Item.NewSMB()
    $Item.NewPSD()
}
