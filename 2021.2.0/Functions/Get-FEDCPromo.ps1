Function Get-FEDCPromo
{
    [CmdLetBinding(DefaultParameterSetName=0)]
    Param(
    [ValidateSet(0,1,2,3)]
    [Parameter(ParameterSetName=0)][UInt32]$Mode = 0,
    [ValidateSet("Forest","Tree","Child","Clone")]
    [Parameter(ParameterSetname=1)][String]$Type)

    Class _DomainName
    {
        [String]             $String
        [String]               $Type
    
        Hidden [Object]        $Slot = @{ NetBIOS = @{ Min = 1; Max = 15 }; Domain = @{ Min = 2; Max = 63 }; SiteName = @{ Min = 2; Max = 63 } }
        Hidden [Char[]]       $Allow = [Char[]]@(45,46;48..57;65..90;97..122)
        Hidden [Char[]]        $Deny = [Char[]]@(32..44;47;58..64;91..96;123..126)
        Hidden [Hashtable] $Reserved = @{
    
            Words             = ( "ANONYMOUS;AUTHENTICATED USER;BATCH;BUILTIN;CREATOR GROUP;CREATOR GROUP SERVER;CREATOR OWNER;CREATOR OWNER SERVER;" + 
                                  "DIALUP;DIGEST AUTH;INTERACTIVE;INTERNET;LOCAL;LOCAL SYSTEM;NETWORK;NETWORK SERVICE;NT AUTHORITY;NT DOMAIN;NTLM AU" + 
                                  "TH;NULL;PROXY;REMOTE INTERACTIVE;RESTRICTED;SCHANNEL AUTH;SELF;SERVER;SERVICE;SYSTEM;TERMINAL SERVER;THIS ORGANIZ" + 
                                  "ATION;USERS;WORLD") -Split ";"
            DNSHost           = ( "-GATEWAY","-GW","-TAC" )
            SDDL              = ( "AN,AO,AU,BA,BG,BO,BU,CA,CD,CG,CO,DA,DC,DD,DG,DU,EA,ED,HI,IU,LA,LG,LS,LW,ME,MU,NO,NS,NU,PA,PO,PS,PU,RC,RD,RE,RO,RS," + 
                                  "RU,SA,SI,SO,SU,SY,WD") -Split ','
        }

        _DomainName([String]$Type,[String]$String)
        {
            If ( $Type -notin $This.Slot.Keys )
            {
                Throw "Invalid type"
            }

            $This.String = $String
            $This.Type   = $Type
            $This.Slot   = $This.Slot["$($Type)"]

            If ( $This.String -in $This.Reserved.Words )
            {
                Throw "Entry is reserved"
            }

            If ( $This.String.Length -le $This.Slot.Min )
            {
                Throw "Input does not meet minimum length"
            }

            If ( $This.String.Length -ge $This.Slot.Max )
            {
                Throw "Input exceeds maximum length"
            }

            If ( $This.String.ToCharArray() | ? { $_ -notin $This.Allow -or $_ -in $This.Deny } )
            { 
                Throw "Name has invalid characters"
            }
        
            If ( $This.String[0,-1] -notmatch "(\w)" )
            {
                Throw "First/Last Character not alphanumeric" 
            }

            Switch($This.Type)
            {
                NetBIOS  
                { 
                    If ( "." -in $This.String.ToCharArray() ) 
                    { 
                        Throw "Period found in NetBIOS Domain Name, breaking" 
                    }
                }

                Domain
                { 
                    If ( $This.String.Split('.').Count -lt 2 )
                    {
                        Throw "Not a valid domain name, single label domain names are disabled"
                    }
                
                    If ( $This.String -in $This.Reserved.SDDL )
                    { 
                        Throw "Name is reserved" 
                    }

                    If ( ( $This.String.Split('.')[-1].ToCharArray() | ? { $_ -match "(\D)" } ).Count -eq 0 )
                    {
                        Throw "Top Level Domain must contain a non-numeric."   
                    }
                }

                Default {}
            }
        }
    }

    Class _ServerFeature
    {
        [String] $Name
        [String] $DisplayName
        [Bool]   $Installed

        _ServerFeature([String]$Name,[String]$DisplayName,[Int32]$Installed)
        {
            $This.Name           = $Name -Replace "-","_"
            $This.DisplayName    = $Displayname
            $This.Installed      = $Installed
        }
    }

    Class _ServerFeatures
    {
        Static [String[]] $Names = ("AD-Domain-Services DHCP DNS GPMC RSAT RSAT-AD-AdminCenter RSAT-AD-PowerShell RSAT-AD-T" +
                                    "ools RSAT-ADDS RSAT-ADDS-Tools RSAT-DHCP RSAT-DNS-Server RSAT-Role-Tools WDS WDS-Admin" + 
                                    "Pack WDS-Deployment WDS-Transport").Split(" ")
        [Object[]]       $Output

        _ServerFeatures()
        { 
            $This.Output         =  @( )
            Get-WindowsFeature   | ? Name -in ([_ServerFeatures]::Names) | % { 
        
                $This.Output    += [_ServerFeature]::New($_.Name, $_.DisplayName, $_.Installed)
            }    
        }
    }

    Class _ADConnection
    {
        [Object] $Primary
        [Object] $Secondary
        [Object] $Swap
        [Object] $Target
        [Object] $Credential
        [Object] $Output
        [Object] $Return

        _ADConnection([Object]$Hostmap)
        {
            $This.Primary                        = $Hostmap | ? { "<1C>" -in $_.NBT.ID }
            $This.Secondary                      = $Hostmap | ? { "<1B>" -in $_.NBT.ID }
            $This.Swap                           = @( )
        
            $This.Target                         = $Null
            $This.Credential                     = $Null

            If ( $This.Primary )
            { 
                $This.Swap += $This.Primary   
            }
        
            If ( $This.Secondary )
            { 
                $This.Swap += $This.Secondary 
            }

            $This.Output                         = @( ) 
        
            ForEach ( $Item in $This.Swap ) 
            {
                If ( $Item.IPAddress -notin $This.Output.IPAddress )
                {
                    $This.Output += $Item
                }
            }
        }
    }

    Class _ADLogin
    {
        [Object]                              $Window
        [Object]                                  $IO

        [String]                           $IPAddress
        [String]                             $DNSName
        [String]                              $Domain
        [String]                             $NetBIOS
        [UInt32]                                $Port

        [Object]                          $Credential
        [String]                            $Username
        [Object]                            $Password
        [Object]                             $Confirm

        [Object]                                $Test
        [String]                                  $DC
        [String]                           $Directory

        [Object]                            $Searcher
        [Object]                              $Result

        _ADLogin([Object]$Target)
        {
            $This.Window       = Get-XamlWindow -Type ADLogin
            $This.IO           = $This.Window.IO
            $This.IPAddress    = $Target.IPAddress
            $This.DNSName      = $Target.Hostname
            $This.NetBIOS      = $Target.NetBIOS
            $This.Port         = 389
            $This.DC           = $This.DNSName.Split(".")[0]
            $This.Domain       = $This.DNSName.Replace($This.DC + '.','')
            $This.Directory    = "LDAP://$( $This.DNSName )/CN=Partitions,CN=Configuration,DC=$( $This.Domain.Split( '.' ) -join ',DC=' )"
        }

        ClearADCredential()
        {
            $This.Credential   = $Null
            $This.Username     = $Null
            $This.Password     = $Null
            $This.Confirm      = $Null
        }

        CheckADCredential()
        {
            $This.Username     = $This.IO.Username.Text
            $This.Password     = $This.IO.Password.Password
            $This.Confirm      = $This.IO.Confirm.Password
        
            If (!$This.Username)
            {
                [System.Windows.Messagebox]::Show("Username","Error")
                $This.ClearADCredential()
            }
        
            ElseIf (!$This.Password)
            {
                [System.Windows.MessageBox]::Show("Password","Error")
                $This.ClearADCredential()
            }
        
            ElseIf ($This.Password -ne $This.Confirm)
            {
                [System.Windows.Messagebox]::Show("Confirm","Error")
                $This.ClearADCredential()
            }

            Else
            {
                $This.Credential   = [System.Management.Automation.PSCredential]::New($This.Username,$This.IO.Password.SecurePassword)
            
                Try 
                {
                    $This.Test                = [System.DirectoryServices.DirectoryEntry]::New($This.Directory,$This.Credential.Username,$This.Credential.GetNetworkCredential().Password)
                }

                Catch
                {
                    [System.Windows.Messagebox]::Show("Login","Error")
                    $This.ClearADCredential()
                }
            }
        }

        [Object] Search([String]$Field)
        {
            Return @( ForEach ( $Item in $This.Result ) { $Item.Properties | ? $Field.ToLower() } )
        }

        [String] GetSiteName()
        {
            Return @( $This.Search("fsmoroleowner").fsmoroleowner.Split(",")[3].Split("=")[1] )
        }

        [String] GetNetBIOSName()
        {
            Return @( $This.Search("netbiosname").netbiosname )
        }
    }

    Class _DCFound
    {
        [Object]  $Window
        [Object]      $IO
        [Object] $Control

        _DCFound([Object]$Connection)
        {
            $This.Window  = Get-XamlWindow -Type FEDCFound
            $This.IO      = $This.Window.IO
            $This.Control = $Connection
        }
    }

    Class _FEDCPromo
    {
        [Object]                              $Window
        [Object]                                  $IO
        [Object]                              $Module
        [Object]                             $Control
        [Object]                             $HostMap
        [Object]                          $Connection
        [Object]                            $Features
        [String]                             $Command
        [Int32]                                 $Mode
        [Object]                             $Profile
        [Object]                          $ForestMode
        [Object]                          $DomainMode
        [Object]                          $DomainType
        [Object]                          $InstallDNS
        [Object]                 $CreateDNSDelegation
        [Object]                     $NoGlobalCatalog
        [Object]             $CriticalReplicationOnly
        [Object]                    $ParentDomainName
        [Object]                          $DomainName
        [Object]                   $DomainNetBIOSName
        [Object]                       $NewDomainName
        [Object]                $NewDomainNetBIOSName
        [Object]                 $ReplicationSourceDC
        [Object]                            $SiteName
        [Object]                        $DatabasePath
        [Object]                             $LogPath
        [Object]                          $SysvolPath
        [Object]       $SafeModeAdministratorPassword
        [Object]                          $Credential

        [Object]                              $Output

        _FEDCPromo([Object]$Module)
        {
            $This.Window                            = Get-XamlWindow -Type FEDCPromo
            $This.IO                                = $This.Window.IO
            $This.Module                            = $Module
        
            If ( !$This.Module.Role.Network)
            {
                $This.Module.Role.GetNetwork()

                $This.Control                       = $This.Module.Role.Network

                If ( !$This.Control )
                {
                    Throw "No network detected"
                }

                Write-Host "Scanning [~] Detected network hosts for NetBIOS Nodes"
                $This.Control.NetBIOSScan()

                $This.HostMap                       = $This.Control.NbtScan | ? NetBIOS
            }

            $This.Features                          = [_ServerFeatures]::New().Output

            $This.IO.DataGrid.ItemsSource           = $This.Features

            "$Env:SystemRoot\NTDS"                  | % {

                $This.DatabasePath                  = $_
                $This.IO.DatabasePath.Text          = $_
                $This.LogPath                       = $_
                $This.IO.LogPath.Text               = $_
                $This.SysvolPath                    = $_.Replace("NTDS","SYSVOL")
                $This.IO.SysvolPath.Text            = $_.Replace("NTDS","SYSVOL")
            }
        }

        SetMode([Int32]$Mode)
        {
            $This.Command                              = ("{0}Forest {0}{1} {0}{1} {0}{1}Controller" -f "Install-ADDS","Domain").Split(" ")[$Mode]
            $This.Mode                                 = $Mode
            $This.Profile                              = (Get-FEDCPromoProfile -Mode $Mode)

            $This.IO.Forest.IsChecked                  = $False
            $This.IO.Tree.IsChecked                    = $False
            $This.IO.Child.IsChecked                   = $False
            $This.IO.Clone.IsChecked                   = $False

            $This.IO.$($This.Profile.Slot).IsChecked   = $True

            # Domain Type/Parent/RepDC
            ForEach ( $Type in $This.Profile.Type )
            {
                $This.IO."_$($Type.Name)".Visibility   = @("Collapsed","Visible")[$Type.IsEnabled]
            
                If ( $Type.IsEnabled )
                {
                    $Type.Value                        = Switch($Type.Name)
                    {
                        ForestMode          { $This.IO.ForestMode.SelectedIndex  }
                        DomainMode          { $This.IO.DomainMode.SelectedIndex  }
                        ParentDomainName    {                         "<Domain>" }
                        ReplicationSourceDC {                            "<Any>" }
                    }
                }

                Else 
                {
                    $Type.Value                        = ""
                }

                $This.IO.$($Type.Name).IsEnabled       = $Type.IsEnabled
            
                @("Text","SelectedIndex")[$Type.Name -match "Mode"] | % { 
            
                    $This.IO.$($Type.Name).$($_)       = $Type.Value
                }
            }

            # Domain/Text
            ForEach ( $Text in $This.Profile.Text )
            {
                $This.IO.$(   $Text.Name ).IsEnabled  = $Text.IsEnabled
                $This.IO."_$( $Text.Name )".Visibility = @("Collapsed","Visible")[$Text.IsEnabled]
                $This.IO.$(   $Text.Name ).Text       = $Text.Text
            }

            # Roles
            ForEach ( $Role in $This.Profile.Role )
            {
                $This.IO.$( $Role.Name ).IsEnabled     = $Role.IsEnabled
                $This.IO.$( $Role.Name ).IsChecked     = $Role.IsChecked
            }

            # Credential
            If ( $Mode -eq 0 )
            {
                $This.IO._Credential.Visibility        = "Collapsed"
                $This.IO.Credential.Text               = ""
                $This.IO.Credential.IsEnabled          = $False
            }

            Else
            {
                $This.IO._Credential.Visibility        = "Visible"
                $This.IO.Credential.Text               = $This.Connection.Credential | ? Username | % Username
                $This.IO.Credential.IsEnabled          = $False
            }

            $This.Output                               = @( )
        }
    
        GetADConnection()
        {
            $This.Connection                         = [_ADConnection]::New($This.Hostmap)
        }
    }

    Write-Host "Loading Network [~] FightingEntropy Domain Controller Promotion Tool"

    $UI                   = [_FEDCPromo]::New((Get-FEModule))
    If ( $Type )
    {
        $Mode = Switch ($Type) { Forest {0} Tree {1} Child {2} Clone {3} }
    }

    $UI.SetMode($Mode)

    $UI.IO.Forest.Add_Click({$UI.SetMode(0)})
    $UI.IO.Tree.Add_Click({$UI.SetMode(1)})
    $UI.IO.Child.Add_Click({$UI.SetMode(2)})
    $UI.IO.Clone.Add_Click({$UI.SetMode(3)})
    $UI.IO.Cancel.Add_Click({$UI.IO.DialogResult = $False})

    $Max                  = Switch -Regex ($UI.Module.Role.Caption)
    {
        "(2000)"         { 0 }
        "(2003)"         { 1 }
        "(2008)+(R2){0}" { 2 }
        "(2008 R2){1}"   { 3 }
        "(2012)+(R2){0}" { 4 }
        "(2012 R2){1}"   { 5 }
        "(2016|2019)"    { 6 }
    }

    $UI.IO.ForestMode.SelectedIndex = $Max
    $UI.IO.DomainMode.SelectedIndex = $Max
    $UI.GetADConnection()

    $UI.IO.CredentialButton.Add_Click({

        $UI.Connection.Target           = $Null
        $DC                             = [_DCFound]::New($UI.Connection)
        $DC.IO.DataGrid.ItemsSource     = $DC.Control.Output
        $DC.IO.DataGrid.SelectedIndex   = 0
        [Void]$DC.IO.DataGrid.Focus()

        $DC.IO.Cancel.Add_Click(
        {
            $DC.IO.DialogResult         = $False
        })

        $DC.IO.Ok.Add_Click(
        {
            $UI.Connection.Target       = $UI.Connection.Output[$DC.IO.DataGrid.SelectedIndex]
            $DC.IO.DialogResult         = $True
        })

        $DC.Window.Invoke()

        If ( $UI.Connection.Target )
        {
            $DC                         = [_ADLogin]::New($UI.Connection.Target)

            $DC.IO.Cancel.Add_Click(
            {
                $UI.Credential          = $Null
                $UI.IO.Credential.Text  = ""
                $DC.IO.DialogResult     = $False
            })

            $DC.IO.Ok.Add_Click(
            {
                $DC.CheckADCredential()

                If ( $DC.Test.distinguishedName )
                {
                    $DC.Searcher            = [System.DirectoryServices.DirectorySearcher]::New()
                    $DC.Searcher            | % { 
                    
                        $_.SearchRoot       = [System.DirectoryServices.DirectoryEntry]::New($DC.Directory,$DC.Credential.Username,$DC.Credential.GetNetworkCredential().Password)
                        $_.PageSize         = 1000
                        $_.PropertiestoLoad.Clear()
                    }

                    $DC.Result              = $DC.Searcher | % FindAll
                    $DC.IO.DialogResult     = $True
                }

                Else
                {
                    [System.Windows.MessageBox]::Show("Invalid Credentials")
                }
            })

            $DC.Window.Invoke()

            $UI.Credential             = $DC.Credential
                                         $DC.ClearADCredential()

            $UI.Connection.Return      = $DC
            $UI.IO.Credential          | % {
                
                $_.Text                = $UI.Credential.UserName
                $_.IsEnabled           = $False
            }

            Switch ($UI.Mode)
            {
                0
                {
                    $UI.IO.ParentDomainName.Text     = ""
                    $UI.IO.DomainName.Text           = "<New Forest Name>"
                    $UI.IO.DomainNetBIOSName.Text    = "<New Forest NetBIOS Name>"
                    $UI.IO.SiteName.Text             = "<New Forest Sitename>"
                    $UI.IO.NewDomainName.Text        = ""
                    $UI.IO.NewDomainNetBIOSName.Text = ""
                    $UI.ReplicationSourceDC.Text     = ""
                }

                1
                {
                    $UI.IO.ParentDomainName.Text     = $DC.Domain
                    $UI.IO.DomainName.Text           = ""
                    $UI.IO.DomainNetBIOSName.Text    = ""
                    $UI.IO.Sitename.Text             = $DC.GetSiteName()
                    $UI.IO.NewDomainName.Text        = "<New Domain Name>"
                    $UI.IO.NewDomainNetBIOSName.Text = "<New Domain NetBIOS Name"
                    $UI.IO.ReplicationSourceDC.Text  = ""
                }

                2
                {
                    $UI.IO.ParentDomainName.Text     = $DC.Domain
                    $UI.IO.DomainName.Text           = ""
                    $UI.IO.DomainNetBIOSName.Text    = ""
                    $UI.IO.Sitename.Text             = $DC.GetSiteName()
                    $UI.IO.NewDomainName.Text        = "<New Domain Name>"
                    $UI.IO.NewDomainNetBIOSName.Text = "<New Domain NetBIOS Name"
                    $UI.IO.ReplicationSourceDC.Text  = ""
                }

                3
                {
                    $UI.IO.ParentDomainName.Text     = ""
                    $UI.IO.DomainName.Text           = $DC.Domain
                    $UI.IO.DomainNetBIOSName         = $DC.GetNetBIOSName()
                    $UI.IO.SiteName.Text             = $DC.GetSiteName()
                    $UI.IO.NewDomainName.Text        = ""
                    $UI.IO.NewDomainNetBIOSName.Text = ""
                    $UI.IO.ReplicationSourceDC.Text  = $UI.Connection.Target.Hostname
                }
            }
        }
    })

    $UI.IO.Start.Add_Click(
    {
        $Password                             = $UI.IO.SafeModeAdministratorPassword
        $Confirm                              = $UI.IO.Confirm

        If (!$Password.Password)
        {
            [System.Windows.MessageBox]::Show("Invalid password")
        }

        ElseIf ($Password.Password -ne $Confirm.Password)
        {
            [System.Windows.Messagebox]::Show("Password does not match")
        }

        Else
        {
            $UI.SafeModeAdministratorPassword = $Password.SecurePassword
            # Types

            $UI.DomainType = @("-","TreeDomain","ChildDomain","-")[$UI.Mode]

            ForEach ( $Type in $UI.Profile.Type )
            {
                If ($Type.IsEnabled)
                {
                    Switch ($Type.Name)
                    {
                        ForestMode          
                        { 
                            $UI.ForestMode          = $UI.IO.ForestMode.SelectedIndex
                        }

                        DomainMode
                        { 
                            $UI.DomainMode          = $UI.IO.DomainMode.SelectedIndex
                        }

                        ReplicationSourceDC 
                        {
                            $UI.ReplicationSourceDC = [_DomainName]::New("Domain",$UI.IO.ReplicationSourceDC.Text).String
                        }

                        ParentDomainName    
                        { 
                            $UI.ParentDomainName    = [_DomainName]::New("Domain",$UI.IO.ParentDomainName.Text).String
                        }
                    }
                }

                If (!$Type.IsEnabled)
                {
                    Switch($Type.Name)
                    {
                        ForestMode          { $UI.ForestMode          = "-" }
                        DomainMode          { $UI.DomainMode          = "-" }
                        ReplicationSourceDC { $UI.ReplicationSourceDC = "-" }
                        ParentDomainName    { $UI.ParentDomainName    = "-" }
                    }
                }
            }

            ForEach ( $Type in $UI.Profile.Text )
            {
                If ( $Type.IsEnabled )
                {
                    Switch ($Type.Name)
                    {
                        ParentDomainName     
                        { 
                            $UI.ParentDomainName     = [_DomainName]::New("Domain",$UI.IO.ParentDomainName.Text).String
                        }

                        DomainName
                        {
                            $UI.DomainName           = [_DomainName]::New("Domain",$UI.IO.DomainName.Text).String
                        }

                        DomainNetBIOSName
                        { 
                            $UI.DomainNetBIOSName    = [_DomainName]::New("NetBIOS",$UI.IO.DomainNetBIOSName.Text).String
                        }

                        SiteName             
                        {
                            $UI.SiteName             = [_DomainName]::New("SiteName",$UI.IO.SiteName.Text).String
                        }

                        NewDomainName        
                        { 
                            $UI.NewDomainName        = [_DomainName]::New("Domain",$UI.IO.NewDomainName.Text).String
                        }

                        NewDomainNetBIOSName 
                        { 
                            $UI.NewDomainNetBIOSName = [_DomainName]::New("NetBIOS",$UI.IO.NewDomainNetBIOSName.Text).String
                        }
                    }
                }

                If (!$Type.IsEnabled)
                {
                    Switch($Type.Name)
                    {
                        ParentDomainName     { $UI.ForestMode           = "-" }
                        DomainName           { $UI.DomainMode           = "-" }
                        DomainNetBIOSName    { $UI.DomainNetBIOSName    = "-" }
                        Sitename             { $UI.ParentDomainName     = "-" }
                        NewDomainName        { $UI.NewDomainName        = "-" }
                        NewDomainNetBIOSName { $UI.NewDomainNetBIOSName = "-" }
                    }
                }
            }

            ForEach ( $Type in $UI.Profile.Role )
            {
                If ( $Type.IsEnabled )
                {
                    Switch ($Type.Name)
                    {
                        InstallDns              
                        {
                            $UI.InstallDNS              = $UI.IO.InstallDNS.IsChecked
                        }

                        CreateDnsDelegation     
                        {
                            $UI.CreateDnsDelegation     = $UI.IO.CreateDnsDelegation.IsChecked
                        }

                        CriticalReplicationOnly
                        {
                            $UI.CriticalReplicationOnly = $UI.IO.CriticalReplicationOnly.IsChecked
                        }

                        NoGlobalCatalog         
                        {
                            $UI.NoGlobalCatalog         = $UI.IO.NoGlobalCatalog.IsChecked
                        }
                    }
                }

                If (!$Type.IsEnabled)
                {
                    Switch($Type.Name)
                    {
                        InstallDns               { $UI.InstallDNS              = $False }
                        CreateDnsDelegation      { $UI.CreateDNSDelegation     = $False }
                        CriticalReplicationOnly  { $UI.CriticalReplicationOnly = $False }
                        NoGlobalCatalog          { $UI.NoGlobalCatalog         = $False }
                    }
                }
            }

            $UI.IO.DialogResult               = $True
        }
    })

    $UI.Window.Invoke()

    ForEach ( $Feature in $UI.Features )
    {
        $Feature.Name = $Feature.Name -Replace "_","-"
        $X            = $Feature.Installed

        Write-Host ( "[{0}] {1} is {2} installed" -f @("~","+")[$X], $Feature.Name, @("now being","already")[$X] ) -ForegroundColor Cyan
        
        If (!$X)
        { 
            Write-Host ( "Install-WindowsFeature -Name {0} -IncludeAllSubFeature -IncludeManagementTools" -f $Feature.Name )
        }
    }

    $UI.Output = @{ }

    ForEach ( $Group in $UI.Profile.Type, $UI.Profile.Role, $UI.Profile.Text )
    {
        ForEach ( $Item in $Group )
        {
            If ( $Item.IsEnabled )
            {
                If ( !$UI.Output[$Item.Name] )
                {
                    $UI.Output.Add($Item.Name,$UI.$($Item.Name))
                }
            }
        }
    }

    "Database Log Sysvol".Split(" ") | % { "$_`Path"} | % { $UI.Output.Add($_,$UI.$_) }

    If ( $UI.Credential )
    {
        $UI.Output.Add("Credential",$UI.Credential)
        $UI.Output.Add("SafeModeAdministratorPassword",$UI.SafeModeAdministratorPassword)
    }

    $Splat = $UI.Output
    
    Switch ( $UI.Mode )
    {
        0 { Test-ADDSForestInstallation @Splat }
        1 { Test-ADDSDomainInstallation @Splat }
        2 { Test-ADDSDomainInstallation @Splat }
        3 { Test-ADDSDomainControllerInstallation @Splat }
    }
}
