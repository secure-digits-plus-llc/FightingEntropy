Function New-FEImage
{
    [CmdLetBinding()]Param(
    [Parameter(Mandatory)][String]$Source,
    [Parameter(Mandatory)][String]$Target)
    
    Class _ImageIndex
    {
        [UInt32] $Rank
        [UInt32] $SourceIndex
        [String] $SourceImagePath
        [String] $Path
        [String] $DestinationImagePath
        [String] $DestinationName
        [Object] $Disk
        [Object] $Label

        [UInt32] $ImageIndex            = 1
        [String] $ImageName
        [String] $ImageDescription
        [String] $Version
        [String] $Architecture
        [String] $InstallationType

        _ImageIndex([Object]$Iso)
        {
            $This.SourceIndex           = $Iso.SourceIndex
            $This.SourceImagePath       = $Iso.SourceImagePath
            $This.DestinationImagePath  = $Iso.DestinationImagePath
            $This.DestinationName       = $Iso.DestinationName
            $This.Disk                  = Get-DiskImage -ImagePath $This.SourceImagePath
        }

        Load()
        {
            $This.Image                 = Get-WindowsImage -ImagePath $This.DestinationImagePath -Index $This.SourceIndex
            $This.Image                 | % {

                $This.ImageName         = $_.ImageName
                $This.ImageDescription  = $_.ImageDescription
                $This.Architecture      = $_.Architecture
                $This.Version           = $_.Version
                $This.InstallationType  = $_.InstallationType
            }
        }
    }

    Class _ImageFile
    {
        [ValidateSet("Client","Server")]
        [String]        $Type
        [String]        $Name
        [String] $DisplayName
        [String]        $Path
        [UInt32[]]     $Index

        _ImageFile([String]$Type,[String]$Path)
        {
            $This.Type  = $Type
        
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            $This.Name        = ($Path -Split "\\")[-1]
            $This.DisplayName = "($Type)($($This.Name))"
            $This.Path        = $Path
            $This.Index       = @( )
        }

        AddMap([UInt32[]]$Index)
        {
            ForEach ( $I in $Index )
            {
                $This.Index  += $I
            }
        }
    }

    Class _ImageStore
    {
        [String]   $Source
        [String]   $Target
        [Object[]]  $Store
        [Object[]]   $Swap
        [Object[]] $Output

        _ImageStore([String]$Source,[String]$Target)
        {
            If ( ! ( Test-Path $Source ) )
            {
                Throw "Invalid image base path"
            }

            If ( !(Test-Path $Target) )
            {
                New-Item -Path $Target -ItemType Directory -Verbose
            }

            $This.Source = $Source
            $This.Target = $Target
            $This.Store  = @( )
        }

        AddImage([String]$Type,[String]$Name)
        {
            $This.Store += [_ImageFile]::New($Type,"$($This.Source)\$Name")
        }

        GetSwap()
        {
            $This.Swap = @( )
            $Ct        = 0

            ForEach ( $Image in $This.Store )
            {
                ForEach ( $Index in $Image.Index )
                {
                    $Iso                     = @{ 

                        SourceIndex          = $Index
                        SourceImagePath      = $Image.Path
                        DestinationImagePath = "{0}\({1}){2}({3}).wim" -f $This.Target, $Ct, $Image.DisplayName, $Index
                        DestinationName      = "{0}({1})" -f $Image.DisplayName,$Index
                    }

                    $Item                    = [_ImageIndex]::New($Iso)
                    $Item.Rank               = $Ct
                    $This.Swap              += $Item
                    $Ct                     ++
                }
            }
        }

        [String] GetImagePath([String]$Path)
        {
            Return @( "{0}:\sources\install.wim" -f (Get-DiskImage -ImagePath $Path | Get-Volume | % DriveLetter) )
        }

        GetOutput()
        {
            $Last = $Null

            ForEach ( $X in 0..( $This.Swap.Count - 1 ) )
            {
                $Image       = $This.Swap[$X]

                If ( $Last -ne $Null -and $Last -notmatch $Image.SourceImagePath )
                {
                    Write-Theme "Dismounting... $Last"
                    Dismount-DiskImage -ImagePath $Last -Verbose
                }

                If (!(Get-DiskImage -ImagePath $Image.SourceImagePath | % Attached))
                {
                    Write-Theme ("Mounting [+] {0}" -f $Image.SourceImagePath)
                    Mount-DiskImage -ImagePath $Image.SourceImagePath
                }

                $Image.Path                 = $This.GetImagePath($Image.SourceImagePath)

                Get-WindowsImage -ImagePath $Image.Path -Index $Image.SourceIndex | % {

                    $Image.ImageName        = $_.ImageName
                    $Image.ImageDescription = $_.ImageDescription
                    $Image.Version          = $_.Version
                    $Image.Architecture     = Switch ([UInt32]($_.Architecture -eq 9)) { 0 { 86 } 1 { 64 } }
                    $Image.InstallationType = $_.InstallationType

                    Switch($Image.InstallationType)
                    {
                        Server
                        {
                            $Image.DestinationName = "{0} (x64)" -f [Regex]::Matches($Image.ImageName,"(Windows Server )+(\d){4}( Datacenter| Standard)").Value | Select -First 1
                            $Image.Label           = "{0}{1}" -f $(Switch -Regex ($Image.ImageName){Standard{"SD"}Datacenter{"DC"}}),[Regex]::Matches($Image.ImageName,"(\d{4})").Value
                        }

                        Client
                        {
                            $Image.DestinationName = "{0} (x{1})" -f $Image.ImageName, $Image.Architecture
                            $Image.Label           = "10{0}{1}"   -f $(Switch -Regex ($Image.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }),$Image.Architecture
                        }
                    }
                }

                $Slot                              = [Regex]::Matches($Image.DestinationImagePath,"(\\\(\d+\))").Value
                $Path                              = "{0}{1}{2}" -f $This.Target, $Slot, $Image.Label

                If ( ! ( Test-Path $Path ) )
                {
                    New-Item $Path -ItemType Directory -Verbose
                }

                $Image.DestinationImagePath        = "{0}\{1}.wim" -f $Path,$Image.Label

                $ISO                        = @{
        
                    SourceIndex             = $Image.SourceIndex
                    SourceImagePath         = $Image.Path
                    DestinationImagePath    = $Image.DestinationImagePath
                    DestinationName         = $Image.DestinationName
                }
                
                Write-Theme "Extracting [~] $($Iso.DestinationImagePath)"

                Export-WindowsImage @ISO

                Write-Theme "Extracted [+] $($Iso.DestinationName)"

                $Last = $Image.SourceImagePath

                $This.Output += $Image
            }

            Dismount-DiskImage -ImagePath $Last
        }
    }

    $Images = [_ImageStore]::New($Source,$Target)

    $Index  = 0
    $Images.AddImage("Server","Windows Server 2016.iso")
    $Images.Store[$Index].AddMap(4)
    $Index ++

    $Images.AddImage("Client","Win10_20H2_English_x64.iso")
    $Images.Store[$Index].AddMap((4,1,6))
    $Index ++

    $Images.AddImage("Client","Win10_20H2_English_x32.iso")
    $Images.Store[$Index].AddMap((4,1,6))
    $Index ++

    $Images.GetSwap()
    $Images.GetOutput()
    $Images
}
