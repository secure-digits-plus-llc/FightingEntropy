Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script                                 = [ PSCustomObject ]@{

            Object                              = {

                Param ( $Xaml )                   

                [ PSCustomObject ]@{ 

                    Array                       = $Xaml.Split("`n")
                    Items                       = $Xaml.Split("`n").Split(' ') | ? { $_.Length -gt 0 }
                    Track                       = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) )
                    {
                        [ PSCustomObject ]@{ 

                            Index               = $I
                            Line                = $Xaml.Split("`n")[$I]
                        }
                    }
                    Xaml                        = $Xaml 
                }
            }
        
            Template                            = { 

                Param ( $Index , $Drive )

                [ PSCustomObject ]@{
                        
                    Index                       = $Index
                    Drive                       = $Drive
                    Track                       = ""
                    Type                        = ""
                    Path                        = ""
                    Parent                      = ""
                    Name                        = ""
                    Slice                       = ""
                    Depth                       = ""
                    Indent                      = ""
                    Tag                         = ""
                    Property                    = $Null
                    Value                       = $Null
                }
            }
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯   Begin Parameter [~] : Pull Objects and loads initial process                                 ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Begin
        {
            $Drive                              = "DSC:"
            $Name                               = $Null
            $Path                               = $Null
            $Root                               = & $Script.Object $Xaml  #= $Xaml_Input
            $Depth                              = 0
            $Type                               = "@"
            $Indent                             = 0
            $Return                             = $Root.Items -match "<"
            $Count                              = $Return.Count - 1
            $Index                              = 0
            $X                                  = 0
            $I                                  = 0
            $T                                  = @( )
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯           Process [~] : Re-track and Re-calculate positioning of Objects                       ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Process
        {
            ForEach ( $X in 0..$Count )
            {
                Write-Progress -Activity "Collecting [~] Track Information" -PercentComplete ( ( $X / $Count ) * 100 )

                $T                             += & $Script.Template $X $Drive
                $T[$X].Track                    = $Return[$X]

                If ( $T[$X].Track -notmatch ">" )
                {
                    While( $T[$X].Track -notmatch ">" )
                    {
                        $Index ++
                        $T[$X].Track            = $T[$X].Track , $Root.Items[ $Index ] -join ' '
                    }
                }
                $Index ++

                $T[$X].Tag                      = $Return[$X] -Replace "(\s*)" , ""
                $T[$X].Type                     = $Type
                $T[$X].Track                    = $T[$X].Track -Replace              "(\s+)" , " " -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"
                $T[$X].Slice                    = $T[$X].Track -Replace ( $T[$X].Tag + " " ) ,  "" -Replace        "' " , "';"  -Split   ";"

                If ( $T[$X].Slice.Count -gt 1 )
                {
                    If ( $T[$X].Slice.Count -eq 1 )
                    {
                        $T[$X].Property         = $T[$X].Slice.Split(' ')[0]
                        $T[$X].Value            = $T[$X].Slice -Replace ( $T[$X].Property + " = " ) , ''
                    }

                    Else
                    {
                        $T[$X].Property         = 0..( $T[$X].Slice.Count - 1 ) | % { $T[$X].Slice[$_].Split(' ')[0] }
                        $T[$X].Value            = 0..( $T[$X].Slice.Count - 1 ) | % { $T[$X].Slice[$_] -Replace ( $T[$X].Property[$_] + " = " ) , '' }
                    }
                }

                $Type                           = $T[$X].Track | % {

                    If     ( $_ -Match "(<[^/].+[^/]>)" ) { "+" }
                    ElseIf ( $_ -Match ".+(\/>)"        ) { "/" }
                    ElseIf ( $_ -Match "(<\/).+"        ) { "-" }
                    Else                                  { "?" }
                }

                $T[$X].Name                     = $Return[$X] -Replace "(<*/*\>*)" , ""

                If ( $Path -ne $Null )
                {
                    $T[$X].Path                 = @{ 
                        
                        "+"                     = $Path , $T[$X].Name -join '\'
                        "/"                     = $Path 
                        "-"                     = Split-Path $Path -Parent
                    
                    }[ $T[$X].Type ]

                    $Path                       = $T[$X].Path

                    $T[$X].Parent               = Split-Path $Path -Parent | % {
                        
                        If ( $_.Length -eq "" -or $_ -eq $Drive )
                        {
                            "-"
                        }

                        Else
                        {
                            $_
                        }
                    }
                }

                If ( $Path -eq $Null )
                {
                    $Name                       = $T[$X].Name
                    $Path                       = $Drive , $Name -join '\'
                    $T[$X].Parent               = $Drive
                    $T[$X].Path                 = $Path
                }

                $Depth                          = $Path.Split('\').Count - 2
                $T[$X].Depth                    = $Depth

                If ( $Sw0 -ne $True  -and $T[$X].Tag    -match "(<\/)" -and $T[$X].Type -eq "/" )
                { 
                    $Sw0 = $True
                }

                If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" )
                {
                    $Sw0 = $False
                }

                $T[$X].Indent                   = @{
                    
                    "@"                         = 0
                    "/"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "-"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "+"                         = $Depth

                }[ $Type ]
            }
        }

    #    ____    ____________________________________________________________________________________________________      # 
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  # 
    #   \\__//¯¯¯     End Parameter [~] : Finalize the object arrangement for output                             ___//¯¯\\ # 
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// # 
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  # 
        End
        {
            $Buffer                             = [ PSCustomObject ]@{ 

                Indent                          = (   $T.Indent | Sort )[ -1 ] * 4
                Tag                             = (      $T.Tag | % { $_.Length } | Sort )[ -1 ]
                Left                            = ""
                Property                        = ( $T.Property | % { $_.Length } | Sort )[ -1 ]
            }
            
            $Buffer                             | % { 
                
                $_.Left = $_.Indent + $_.Tag 
            }

            ForEach ( $X in 0..$Count )
            {
                $Indent                         = " " * $T[$X].Indent * 4
                $Tag                            = $T[$X].Tag

                If ( $T[$X].Property.Count -eq 0 )
                {   
                    "{0}{1}" -f $Indent , $Tag
                }
    
                If ( $T[$X].Property.Count -eq 1 )
                {
                    $Space                      = $Buffer.Property - $T[$X].Property.Length
                    $Property                   = $T[$X].Property + ( $Space * " " )

                    "{0}{1}{2} = {3}" -f $Indent , $Tag , $Property , $T[$X].Value
                }
    
                If ( $T[$X].Property.Count -gt 1 )
                {
                    ForEach ( $J in 0..( $T[$X].Property.Count - 1 ) )
                    {
                        $Space                  = $Buffer.Property - $T[$X].Property[$J].Length
                        $Property               = $T[$X].Property[$J] +( $Space * " " )
                            
                        If ( $J -eq 0 )
                        {
                            "{0}{1}{2} = {3}" -f $Indent , $Tag , $Property , $T[$X].Value[$J]
                        }

                        Else 
                        {   
                            "{0}{1} = {2}" -f ( $Buffer.Left * " " ) , $Property , $T[$X].Value[$J]
                        }
                    }
                }
            }
        }/¯¯¯        __/¯¯\__[ Dynamically Engineered Digital Security ]__/¯¯\__         ¯¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__// 
//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\  _________________________ ________________ ___________________________________  //¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\ 
\\__//¯¯\\__//¯¯\\__//¯¯\\__// | Application Development | Virtualization | Network and Hardware Magistration | \\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__// 
//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  //¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\ 
\\__//¯¯\\__//¯¯\\__//¯¯\\__//   https://www.securedigitsplus.com | Server-Client | Seedling-Spawning Script    \\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__// 
//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\___¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ___//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\ 
\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\   [ Provisional Author : Michael C Cook Sr. | "The Buck Stops Here" ]    //¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__// 
//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//   ____    ____    ____    ____    ____    ____    ____    ____    ____   \\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\ 
\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__// 
//¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯  
\\  [ HybridDSC ] @: Assemble and mobilize the module
//   ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____    ____      
\\__//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__//¯¯\\__//==\\__/----\__//==\\__//¯¯\\__//¯¯\\__/----\__//==\\__/----\__//==\\__/----\__//==\\___  
//¯¯\\__________________________________________//¯¯\\__//¯¯\\__________________________//¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯¯ ¯¯ ¯¯¯¯ -- ¯¯¯\\ 
\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__    ____ -- ____ __ ____ -- ____ __ ____ -- ____ __ ___// 
//¯¯\\__[  Declare Namespaces & Load Modules ]___________________________________________//¯\\__//¯¯\\==//¯¯\----/¯¯\\==//¯¯\----/¯¯\\==//¯¯\----/¯¯¯  
¯    ¯¯¯¯                                    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯   ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    #>
        
        "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC\HybridDSC\Module" | % { 
                
            If ( Test-Path $_ )                                                 # Check Path
            { 
                GP $_                                                     | % { # Check path property
                
                    GCI $_.Path *HybridDSC.ps1*                           | % { # Check file
                  
                        IPMO $_.FullName -Force                                 # Load file
                    } 
                }
            }

            Else { Write-Host "Exception [!] Module failed to load" -F 12 }
        }
<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____    ____    ____    ____    ____    ____    ___// 
#//¯¯\\__[ Module Functions ]___________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
¯¯    ¯¯¯¯                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯    ¯¯¯¯      
        Get-HybridDSCRoot           - Gets the current module location
        Get-HybridDSC               - Gets a description of this table/Help
        Get-ScriptRoot              - Gets the current script path
        Export-ISETheme             - Generates ISE XML Theme File for Export/Import/Migration
        Resolve-HybridDSC           - Collects Necessary Script Information            
        Publish-HybridDSC           - Creates a distributable package for HybridDSC   
        New-Subtable                - Converts Key/Value Subtable for Write-Theme      
        New-Table                   - Converts Key/Value Tables for Write-Theme        
        Convert-HashToArray         - Converts a Hashtable to a formatted array        
        Write-Theme                 - Stylizes Command Line Output                     
        Show-Message                - Shows a Message Box                              
        Convert-XAMLToWindow        - Converts a block of XAML to a hash-table object  
        Show-WPFWindow              - Initializes the Window Object                    
        Get-XAML                    - Loads templatized XAML GUI's                     
        Find-XAMLNamedElements      - Looks for XAML 'Named' Items                     
        Get-CharacterMap            - Resolves characters to index, and strings to array of objects
        Format-XamlObject           - [ Experimental ] - Reformats a chunk of XAML or markup 
        Get-LineDepth               - Gets the spacing for clean formatting            
        Confirm-DomainName          - Confirms whether a supplied domain name is valid 
        Show-ToastNotification      - Prepares and sends a Windows toast notification 
        Export-ModuleManifest       - Executes an update to the associated PSM1 (File/Manifest) #>

    Export-ModuleMember -Function Get-HybridDSCRoot, Get-HybridDSC, Get-ScriptRoot, Export-ISETheme, Resolve-HybridDSC, Publish-HybridDSC, New-Subtable, 
    New-Table, Convert-HashToArray, Write-Theme, Show-Message, Convert-XAMLToWindow, Show-WPFWindow, Get-XAML, Find-XAMLNamedElements, Get-CharacterMap,
    Format-XamlObject, Get-LineDepth, Confirm-DomainName, Show-ToastNotification, Export-ModuleManifest

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ Network Functions ]___________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Resolve-NetworkMap          - The Kitchen Sink of Network Mapping
        Get-NetworkInfo             - Collects various network information
        Start-PingSweep             - Scans everything on the local network address
        Get-NBTSCAN                 - This parses out NBTStat to return NBTScan
        Get-NetworkHosts            - Collects the ARP tables for MAC address Info
        Get-TelemetryData           - Collects external information for DNS and AD
        Resolve-MacAddress          - Resolves the vendor of any given MAC address
        Start-NetworkInfo           - Comprehensive combination of these other tools
        Get-NetworkStatistics       - Comprehensive netstat reparsed correctly
        Initialize-PortScan         - Scans some ports                                  #>

    Export-ModuleMember -Function Resolve-NetworkMap, Get-NetworkInfo, Start-PingSweep, Get-NBTSCAN, Get-NetworkHosts, Get-TelemetryData, 
    Resolve-MacAddress, Start-NetworkInfo, Get-NetworkStatistics, Initialize-PortScan

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ Directory Functions ]_________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Invoke-Login                - Initializes a live AD validation login context
        Get-DSCPromoTable           - Retrieves GUI Naming Information
        Get-DSCPromoSelection       - Resets GUI Elements according to selected type
        Initialize-DomainController - Promotes a Domain Controller                      #>
    
    Export-ModuleMember -Function Invoke-Login, Get-DSCPromoTable, Get-DSCPromoSelection, Initialize-DomainController

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ Permissions Functions ]_______________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Add-ACL                     - Adds an Access Control list
        New-ACLObject               - Creates a new ACL Object Template
        Unlock-Script               - Will allow for unlocking a file.                  #>

    Export-ModuleMember -Function Add-ACL, New-ACLObject, Unlock-Script

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ Server Functions ]____________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Initialize-Server           - Orchestrates initial server configuration
        Get-DSCFeatureList          - Obtains the features used for this modification
        Sync-DNSSuffix              - Ensures the DNS Suffix is set
        Register-PDCTimeSource      - Sets the Primary Domain Controller Time Source
        Install-DSCRoot             - Installs dependencies for MDT and Hybrid-DSC
        Install-HybridDSC           - Creates a Hybrid-DSC Deployment Share
        Initialize-HybridIIS        - Automatically Configures IIS for MDT/BITS
        Initialize-HybridDSC        - Will populate Applications,Images,Certificates    #>

    Export-ModuleMember -Function Initialize-Server, Get-DSCFeatureList, Sync-DNSSuffix, Register-PDCTimeSource, Install-DSCRoot, 
    Install-HybridDSC, Initialize-HybridIIS, Initialize-HybridDSC

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ MDT Functions ]_______________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Import-MDTModule            - Loads the Microsoft Deployment Toolkit Module
        Export-Ini                  - Specifically exports an INI file for MDT
        Export-BridgeScript         - Exports the file used to distribute Hybrid-DSC
        Update-HybridDSC            - Recycles all Deployment Share Content
        Update-Branding             - Updates the branding for a child item device      #>

    Export-ModuleMember -Function Import-MDTModule, Export-Ini, Export-BridgeScript, Update-HybridDSC, Update-Branding

<#                                                                                  #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
  ____                                                                            __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
 //¯¯\\__________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
 \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
  ¯¯¯\\ [ Diagnostic Functions ]________________________________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
      ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        Initialize-ViperBomb        - Loads the ViperBomb Service Configuration Tool
        Resolve-UninstallList       - Obtains Uninstall Programs List
        Resolve-LocalMachine        - Retrieves environment variables
        Get-CurrentServices         - Gets a list of the systems current services
        Get-ServiceProfile          - Compares the list of services to a profile type.
        Update-ServiceProfile       - Filters the list of services based on input
        Select-ServiceProfile       - Selects the corresponding service profile
        Save-FileDialog             - Opens a 'Save' file dialog box
        Resolve-Windows             - Obtains Windows Environment Variables
        Get-DiskInfo                - Locates Hard Disk Statistics
        Resolve-ViperBomb           - Collects Information needed for ViperBomb GUI
        Start-ViperBombDiagnostics  - Loads the ViperBomb Console Configuration Panel
        Import-ServiceConfiguration - Collects a Service configuration for import
        New-ServiceTemplate         - Creates a new template instance (Immutable)
        Get-ServiceProfile          - Converts loaded profile into useable GUI object
        Show-Console                - Enables/Disables the Console                      
        Get-CurrentPID              - Collects the (QMark/Processor) ID                 #>

    Export-ModuleMember -Function Initialize-ViperBomb, Resolve-UninstallList, Resolve-LocalMachine, Get-CurrentServices, Get-ServiceProfile, 
    Update-ServiceProfile, Select-ServiceProfile, Save-FileDialog, Resolve-Windows, Get-DiskInfo, Resolve-ViperBomb, Start-ViperBombDiagnostics, 
    Import-ServiceConfiguration, New-ServiceTemplate, Get-ServiceProfile, Show-Console, Get-CurrentPID

                                                                                    #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
<#___                                                                             __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
//¯¯\\___________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
 ¯¯¯#>  Write-Theme -Action "HybridDSC [+]" "Module Loaded" <#__________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯     #>
'@ }

    Set-Content @Hybrid -VB 

    If ( $? -eq $True )
    {
        $Splat = @{ 

            Items  = "Directory,FullName,Name,LastWriteTime".Split(',')
            Values = ""
        }

        $Splat | % { 
            
            $_.Values = $_.Items | % { ( GI $Hybrid.Path ).$_ } 
        }

        $Splat = @{ 

            Title = "Successful [+] : Module Manifest Exported"
            Depth = 1
            ID    = "( Manifest Details )"
            Table = New-SubTable @Splat 
        }
        
        Write-Theme -Table ( New-Table @Splat ) -Prompt "Press Enter to Continue"

    }
                                                                                     #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}#____                                                                             __//¯¯\\__//==\\__/----\__//==\\__/----\__//==\\__/----\__//¯¯\\___  
#//¯¯\\___________________________________________________________________________/¯¯¯    ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯¯ ¯¯ ¯¯¯\\ 
#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯        ____    ____ __ ____ __ ____ __ ____ __ ____ __ ____    ___// 
        Write-Theme -Free # What Free Actually Means ____________________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
     #¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯       
