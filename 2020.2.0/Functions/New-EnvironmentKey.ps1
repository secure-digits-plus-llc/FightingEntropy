Function New-EnvironmentKey
{
    [CmdLetBinding()]
    Param(
    [Parameter()][String] $Organization = "Default",
    [Parameter()][String]   $CommonName = "test.localhost",
    [Parameter()][String]   $Background ,
    [Parameter()][String]         $Logo ,
    [Parameter()][String]        $Phone ,
    [Parameter()][String]      $Website = "support.microsoft.com",
    [Parameter()][String]        $Hours )

    Class _Icons
    {
        [Object]         $Item
        [String]         $Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
        [Object]     $Property

        [Hashtable]      $Hash = @{
    
            Computer           = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
            ControlPanel       = "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
            Documents          = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
            Libraries          = "{031E4825-7B94-4dc3-B131-E946B44C8DD5}"
            Network            = "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
        }

        [Int32]      $Computer
        [Int32]  $ControlPanel
        [Int32]     $Documents
        [Int32]     $Libraries
        [Int32]       $Network

        _Icons([Int32]$Computer,[Int32]$ControlPanel,[Int32]$Documents,[Int32]$Libraries,[Int32]$Network)
        {
            $This.Computer     = $Computer
            $This.ControlPanel = $ControlPanel
            $This.Documents    = $Documents
            $This.Libraries    = $Libraries
            $This.Network      = $Network

            $This.Item         = Get-Item         -Path $This.Path
            $This.Property     = Get-ItemProperty -Path $This.Path

            ForEach ( $I in "Computer ControlPanel Documents Libraries Network".Split(" ") )
            {
                Set-ItemProperty -Path $This.Path -Name $This.Hash.$I -Value $This.$I -Verbose
            }
        }
    }

    Class _Shortcut
    {
        [Object]               $Item
    
        _Shortcut(
        [String]               $Path ,
        [String]         $TargetPath ,
        [String[]]        $Arguments ,
        [String]       $IconLocation ,
        [String]        $Description ,
        [String]   $WorkingDirectory )
        {
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            If ( Test-Path $TargetPath )
            {
                Throw "Path exists"
            }

            $This.Item                  = (New-Object -ComObject WScript.Shell).CreateShortcut($TargetPath)

            $This.Item.TargetPath       = $Path
            $This.Item.Arguments        = $Arguments
            $This.Item.IconLocation     = $IconLocation
            $This.Item.Description      = $Description
            $This.Item.WorkingDirectory = $WorkingDirectory
            $This.Item.Save()
        }
    }

    Class _Graphics
    {
        [Object] $Background
        [Object]       $Logo

        _Graphics([String]$Background,[String]$Logo)
        {
            $This.Background = $Background
            $This.Logo       = $Logo
        }
    }

    Class _Certificate
    {
        [String]       $ExternalIP
        [Object]             $Ping
        [String]     $Organization
        [String]       $CommonName
        [String]         $Location
        [String]           $Region
        [String]          $Country
        [Int32]            $Postal
        [String]         $TimeZone
        [String]         $SiteLink

        _Certificate(
        [String]       $ExternalIP ,
        [Object]             $Ping ,
        [String]     $Organization ,
        [String]       $CommonName )
        {
            $This.ExternalIP       = $ExternalIP
            $This.Ping             = $Ping
            $This.Organization     = $Organization
            $This.CommonName       = $CommonName
            $This.Location         = $This.Ping.City
            $This.Region           = $This.Ping.Region
            $This.Country          = $This.Ping.Country
            $This.Postal           = $This.Ping.Postal
            $This.TimeZone         = $This.Ping.TimeZone

            $This.SiteLink         = $This.GetSiteLink($Ping)
        }

        [String] GetSiteLink([Object]$Ping)
        {
            $Return = @( )
            $Return += ( $Ping.City -Split " " | % { $_[0] } ) -join ''
            $Return += ( $Ping.Region -Split " " | % { $_[0] } ) -join ''
            $Return += $Ping.Country
            $Return += $Ping.Postal

            Return $Return -join '-'
        }
    }

    Class _Brand
    {
        [String] $Path
        [String] $Name
        [Object] $Value

        _Brand([String]$Path,[String]$Name,[Object]$Value)
        {
            $This.Path  = $Path
            $This.Name  = $Name
            $This.Value = $Value
        }
    }

    Class _Company
    {
        Hidden [Object] $Certificate
        [String]       $Name
        [String]     $Branch
        [String]   $Location
        [String]     $Region
        [String]    $Country
        [String]     $Postal
        [String]   $TimeZone
        [String]   $SiteLink

        [Object] $Background
        [Object]       $Logo
        [String]    $Website
        [String]      $Phone
        [String]      $Hours

        _Company([Object]$Certificate,[Object]$Graphics)
        {
            $This.Certificate  = $Certificate      
            
            $Certificate       | % { 
            
                $This.Name     = $_.Organization                        #: Secure Digits Plus LLC
                $This.Branch   = $_.Sitelink.Replace("-",".").tolower(), $_.CommonName -join '.' #: cp.ny.us.12065
                $This.Location = $_.Location                            #: Clifton Park
                $This.Region   = $_.Region                              #: New York
                $This.Country  = $_.Country                             #: US
                $This.Postal   = $_.Postal                              #: 12065
                $This.TimeZone = $_.TimeZone                            #: America/New_York
                $This.SiteLink = $_.SiteLink                            #: CP-NY-US-12065
                $This.Website  = $_.CommonName
            }

            $This.Background   = $Graphics.Background
            $This.Logo         = $Graphics.Logo
        }
    }

    Class _Branding
    {
        Hidden [Object] $Company
        Hidden [String[]] $Names = ("{0};{0}Style;Logo;Manufacturer;{1}Phone;{1}Hours;{1}URL;LockScreenImage;OEMBackground") -f "Wallpaper","Support" -Split ";"
        Hidden [Object]   $Items 
        Hidden [Object]  $Values

        [Object]    $Certificate
        [Object]         $Branch
        [String]       $Provider
        [String]       $SiteLink
        [String]     $Background
        [String]           $Logo
        [String]        $Website
        [String]          $Phone
        [String]          $Hours
        [Object]         $Output

        [String[]]     $FilePath = ("{0}\{1};{0}\{1}\{2};{0}\{1}\{2}\Backgrounds;{0}\Web\Screen;{0}\Web\Wallpaper\Windows;C:\ProgramData\Microsoft\" + 
                                    "User Account Pictures") -f "C:\Windows" , "System32" , "OOBE\Info" -Split ";"

        [String[]] $RegistryPath = @(("HKCU:\{0}\{1}\Policies\System;HKLM:\{0}\{1}\OEMInformation;HKLM:\{0}\{1}\Authentication\LogonUI\Background;" +
                                      "HKLM:\{0}\Policies\Microsoft\Windows\Personalization") -f "Software","Microsoft\Windows\CurrentVersion" -Split ";")

        _Branding([Object]$Company)
        {
            $This.Company        = $Company
            $This.Certificate    = $Company.Certificate
            $This.Branch         = $Company.Branch
            $This.Provider       = $Company.Name
            $This.SiteLink       = $Company.SiteLink
            $This.Background     = $Company.Background
            $This.Logo           = $Company.Logo
            $This.Website        = $Company.Website
            $This.Phone          = $Company.Phone
            $This.Hours          = $Company.Hours

            $This.Items           = $This.RegistryPath[0,0,1,1,1,1,1,3,2]
            $This.Values          = @($This.Background,2,$This.Logo,$This.Provider,$This.Phone,$This.Hours,$This.Website,$This.Background,1)
            $This.Output          = @( )

            ForEach ( $I in 0..8 ) 
            {
                $This.Output     += [_Brand]::New($This.Items[$I],$This.Names[$I],$This.Values[$I])
            }
        }

        Scaffold()
        {
            ForEach ( $I in 0..( $This.FilePath.Count - 1 ) )
            {                
                If ( ! ( Test-Path $This.FilePath[$I] ) )
                {
                    New-Item -Path $This.FilePath[$I] -Verbose
                }

                Copy-Item -Path @( $This.Logo, $This.Background )[[Int32]( $I -in 2..4 )] -Destination $This.FilePath[$I] -Verbose
            }

            ForEach ( $I in 0..( $This.RegistryPath.Count - 1 ) )
            {
                $Item            = $This.RegistryPath[$I]

                If ( !(Test-Path $Item))
                {
                    New-Item -Path ($Item | Split-Path -Parent) -Name ($Item | Split-Path -Leaf) -Verbose
                }
            }
        }
         
        Register()
        {
            $This.Output  | % { Set-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -Verbose }
        }
    }

    Class _EnvironmentKey
    {
        [Object]         $Module
        [Object]       $Graphics
        [Object]    $Certificate
        [Object]        $Company
        [Object]       $Branding

        _EnvironmentKey([Object]$Module,[String]$Organization,[String]$CommonName,[String]$Background,[String]$Logo)
        {
            $This.Module        = $Module
            $This.Graphics      = [_Graphics]::New($Background,$Logo)
            
            $ExternalIP         = Invoke-RestMethod http://ifconfig.me/ip
            $Ping               = Invoke-RestMethod http://ipinfo.io/$ExternalIP
            
            $This.Certificate   = [_Certificate]::New($ExternalIP,$Ping,$Organization,$CommonName)
            $This.Company       = [_Company]::New($This.Certificate,$This.Graphics)
        }

        SetBranding()
        {
            $This.Branding      = [_Branding]::New($This.Company)
            $This.Branding.Scaffold()
            $This.Branding.Register()
        }
    }

    $Module = Get-FEModule

    If ( !$Background )
    {
        $Background = $Module.Graphics | ? Name -match OEMbg   | % FullName
    }

    If ( !$Logo )
    {
        $Logo       = $Module.Graphics | ? Name -match OEMlogo | % FullName
    }

    $Key   = [_EnvironmentKey]::New((Get-FEModule),$Organization,$CommonName,$Background,$Logo)

    If ( $Phone )
    {
        $Key.Company.Phone = $Phone
    }

    If ( $Hours )
    {
        $Key.Company.Hours = $Hours
    }

    $Key.SetBranding()

    $Key
}
