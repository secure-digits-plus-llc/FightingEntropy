
Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        # $Xaml                                 = $Xaml_Input1
        
        # Regex Cleanup (Probably looks overly messy... but it's changing all special markup characters)
    
        $Xaml      = @{ 
        
            $True  = $Xaml -Replace "'" , '&apos;'
            $False = $Xaml -Replace "'" , '"'      }[ $Xaml.Split( '"' ).Count -gt $Xaml.Split( "'" ).Count ] 
    
        ("([*])","&star;"),("(\s+<)","<"),('(="\s+)','="'),("(=')"," = '"),("><",">`n<") | % { $Xaml = $Xaml -Replace $_[0] , $_[1] }
        
        ("quot",34),("amp",38),("apos",39),("star",42),("lt",60),("gt",62)               | % { $Xaml = $Xaml -Replace "&$($_[0]);" , "&#$($_[1]);" }
    
        $Return    = [ PSCustomObject ]@{ This = @( ) ; That = @( ) }
        
        ( [ Regex ] "(&#x)+([0-9A-Fa-f]*;)" ).Matches( $Xaml ) | ? { $_.Value -notin $Return.This } | % {
    
            $Return.This += $_.Value 
            $Return.That += "&#{0};" -f ( $_.Value -Replace "&#x","" -Replace ";","" | % { [ Convert ]::ToInt64( $_ , 16 ) } )
        }
    
        $Return    | % { $Xaml = $Xaml -Replace $_.This , $_.That }
    
        $Xaml                                   = $Xaml -join "`n" 

        $Script                                 = [ PSCustomObject ]@{

            Character                           = {

                Param ( $I )

                [ PSCustomObject ]@{

                    Index       = $I
                    Tag         = ""
                    Character   = [ Char ] $I
                    Decimal     = "{0:D}" -f $I
                    Hexidecimal = "{0:X}" -f $I 
                }
            }

            Block                               = {

                
            }

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
                    Depth                       = ""
                    Indent                      = ""
                    Tag                         = ""
                    Property                    = $Null
                    Value                       = $Null
                }
            }
        }
                
        $Drive                                  = "DSC:"
        $Name                                   = $Null
        $Path                                   = $Null
        $Root                                   = & $Script.Object $Xaml
        $Depth                                  = 0
        $Type                                   = "@"
        $Indent                                 = 0
        $Return                                 = $Root.Items -match "<"
        $Count                                  = $Return.Count - 1
        $Index                                  = 0
        $X                                      = 0
        $I                                      = 0
        $T                                      = @( )

        ForEach ( $X in 0..$Count )
        {
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

            $T[$X].Track                    = $T[$X].Track -Replace  "(\s+)"  , " " -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"
        }

        ForEach ( $X in 0..$Count )
        {
            Write-Progress -Activity "Collecting [~] Track Information" -PercentComplete ( ( $X / $Count ) * 100 )

            $T[$X].Tag                      = $Return[$X] -Replace "(\s*)" , ""
            $T[$X].Type                     = $Type
            $S                              = $T[$X].Track -Replace ( $T[$X].Tag + " " ) , "" -Replace "' " , "';"  -Split ";"

            If ( $S -match "=" )
            {
                If ( $S.Count -eq 1 )
                {
                    $T[$X].Property         = ( $S -Split ' ' )[0]
                    $T[$X].Value            =   $S -Replace ( $T[$X].Property + " = " ) , ''
                }

                If ( $S.Count -gt 1 )
                {
                    $T[$X].Property         = ForEach ( $J in 0..( $S.Count - 1 ) ) { ( $S[$J] -Split ' '  )[0] }
                    $T[$X].Value            = ForEach ( $J in 0..( $S.Count - 1 ) ) {  $S[$J] -Replace ( $T[$X].Property[$J] + " = " ) , '' }
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
                $Sw0                        = $True
            }

            If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" )
            {
                $Sw0                        = $False
            }

            $T[$X].Indent                   = @{
                    
                "@"                         = 0
                "/"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                "-"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                "+"                         = $Depth

            }[ $Type ]
        }

        $Max                                = [ PSCustomObject ]@{

            Indent                          = ( $T.Indent                                             | Sort )[ -1 ] * 4
            Tag                             = ( $T.Tag      | % { $_.Length }                         | Sort )[ -1 ]
            Buffer                          = ( $T          | % { $_.Tag.Length + ( $_.Indent * 4 ) } | Sort )[ -1 ]
            Property                        = ( $T.Property | % { $_.Length }                         | Sort )[ -1 ]
        
        }

        $X                                  = 0
        $Output                             = New-Object System.Collections.ObjectModel.Collection[Object]

        ForEach ( $X in 0..$Count )
        {
            $OP                             = [ PSCustomObject ]@{

                Indent                      = " " * ( $T[$X].Indent * 4 )
                Tag                         = $T[$X].Tag
                Remain                      = $Max.Buffer - ( ( $T[$X].Indent * 4 ) + $T[$X].Tag.Length )
                Buffer                      = $Max.Buffer
            }

            $Slot                           = @{ 

                $True                       = "{0}{1}" -f $OP.Indent , $OP.Tag , ( " " * $OP.Remain )
                $False                      = "{0}{1}" -f $OP.Indent , $OP.Tag
                
            }[ $OP.Remain -gt 0 ]

            If ( $T[$X].Property.Count -gt 0 )
            {
                If ( $T[$X].Property.Count -eq 1 )
                {
                    [ PSCustomObject ]@{

                        Object              = $Slot
                        Property            = $T[$X].Property + ( " " * ( $Max.Property - $T[$X].Property.Length ) )
                        Value               = $T[$X].Value
                            
                    } | % { $Output        += "{0} {1} = {2}" -f $_.Object , $_.Property , $( $_.Value ) }
                }
            
                If ( $T[$X].Property.Count -gt 1 )
                {
                    ForEach ( $J in 0..( $T[$X].Property.Count - 1 ) )
                    {    
                        [ PSCustomObject ]@{

                            Object          = If ( $J -eq 0 ) { $Slot } Else { " " * $OP.Buffer }
                            Property        = $T[$X].Property[$J] + ( " " * ( $Max.Property - $T[$X].Property[$J].Length ) )
                            Value           = $T[$X].Value[$J]
                                
                        } | % { $Output    += "{0} {1} = {2}" -f $_.Object , $_.Property , $( $_.Value ) }
                    }
                }
            }

            If ( $T[$X].Property.Count -eq 0 )
            {
                $Output                    += $Slot
            }
        }
}
