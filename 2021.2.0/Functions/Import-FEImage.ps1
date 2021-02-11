Function Import-FEImage
{
    [CmdLetBinding()]
    Param(
    [Parameter(Mandatory)][String]$ShareName,
    [Parameter(Mandatory)][String]$Source)

    If ( ! ( Test-Path $Source ) )
    {
        Throw "Invalid path"
    }

    $Images = @( )
    
    ForEach ( $Image in Get-FEImage -Source $Source )
    {
        $Images  += $Image
    }
    
    If (!$Images)
    {
        Throw "No images detected"
    }

    $Images  | Format-Table

    Import-Module (Get-MDTModule) -Verbose

    $Share   = Get-FEShare -Name $ShareName
    $Share   | % { New-PSDrive -Name $_.Label -PSProvider MDTProvider -Root $_.Path -Verbose -EA 0 } 

    # Operating Systems ------------
    $OS      = "$($Share.Label):\Operating Systems"
    $TS      = "$($Share.Label):\Task Sequences"
    $Comment = Get-Date -UFormat "[%Y-%m%d (MCC/SDP)]"

    "Client","Server" | % { 
    
        If (!(Test-Path "$OS\$_"))
        {
            New-Item -Path $OS -Enable True -Name $_ -Comments $Comment -ItemType Folder -Verbose
        }

        If (!(Test-Path "$TS\$_"))
        {
            New-Item -Path $TS -Enable True -Name $_ -Comments $Comment -ItemType Folder -Verbose
        }

        $Version = $Images | ? InstallationType -eq $_ | % Version | Select-Object -Unique

        If (!(Test-Path "$OS\$_\$Version"))
        {
            New-Item -Path "$OS\$_" -Enable True -Name $Version -Comments $Comment -ItemType Folder -Verbose
        }

        If (!(Test-Path "$TS\$_\$Version"))
        {
            New-Item -Path "$TS\$_" -Enable True -Name $Version -Comments $Comment -ItemType Folder -Verbose
        }
    }

    $Control                    = Get-FEModule -Control

    ForEach ( $Image in $Images )
    {
        $Type                   = $Image.InstallationType

        $OperatingSystem        = @{

            Path                = $OS,$Type,$Image.Version -join '\'
            SourceFile          = $Image.SourceImagePath
            DestinationFolder   = $Image.Label
        }
        
        Import-MDTOperatingSystem @OperatingSystem -Move -Verbose

        $Guid                   = Get-ChildItem $OperatingSystem.Path | ? Name -match $Image.Label | % Guid
        $Swap                   = $Control | ? Name -match "MDT$Type" | Get-Content 
        $Line                   = [Regex]::Matches($Swap,("{"+((8,4,4,4,12|%{"[0-9a-f]{$_}"}) -join '-')+"}")).Value | Select-Object -Unique
        $Swap                   = $Guid.Swap -Replace $Line, $Guid

        $TaskSequence           = @{ 
            
            Path                = "$TS\$Type\$Version"
            Name                = $Image.ImageName
            Template            = $Swap
            Comments            = $Comments
            ID                  = $Image.Label
            Version             = "1.0"
            OperatingSystemPath = Get-ChildItem -Path $OperatingSystem.Path | ? Name -match $Image.Label | % { "{0}\{1}" -f $Splat.Path, $_.Name }
            FullName            = "Administrator"
            OrgName             = "Secure Digits Plus"
            HomePage            = "www.securedigitsplus.com"
            AdminPassword       = "password"
        }

        Import-MDTTaskSequence @TaskSequence -Verbose
    }
}
