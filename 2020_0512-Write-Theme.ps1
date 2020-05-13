
    Class Range
    {
        [Int32[]] $Range

        Range([Int32]$Total) 
        { 
            If ( $Total -gt 1 ) 
            { 
                $This.Range = [Int32[]]@( 0..( $Total - 1 ) )
            }
            
            Else 
            { 
                Throw "Not a range" 
            }
        }
    }

    Class Charm
    {
         [Int32]  $Index
          [Char]  $Char
        [String]  $Name
        [String]  $Decimal
        [String]  $Dec
        [String]  $Hexidecimal
        [String]  $Hex

        Charm([Int32]$Index)
        {
            $This.Index        = [Int32] $Index
            $This.Char         = [Char]  $Index
            $This.Name         = @{
            
                $True          = @{ 
                
                    32         = "nbsp"
                    34         = "quot"
                    38         = "amp"
                    39         = "apos"
                    42         = "star"
                    60         = "lt"
                    62         = "gt"

                }[$Index]      | % { "&{0};" -f $_ }

                $False         = "" 
                
            }[$Index -in 32,34,38,39,42,60,62]
            
            $This.Decimal      = $Index
            $This.Dec          = [String](  "&#{0:d};" -f $Index )
            $This.Hexidecimal  = [String](    "{0:X}"  -f $Index )
            $This.Hex          = [String]( "&#x{0:X};" -f $Index )
        }
    }

    Class Block
    {
        static [String[]] $Full = "    ","____","¯¯¯¯","----","   /","\   ","   \","/   ","\__/","/¯¯\","/¯¯¯","¯¯¯\","\___","___/"
    }

    Class Stock
    {
        [String[]] $Margin
        [String[]] $Face
        [String[]] $Fill

        Stock([Int32]$Index)
        {
            $This.Margin = [Block]::Full[@{ 0 =  4,  5 ; 1 =  6,  7 }[ $Index % 2 ] ]
            $This.Face   = [Block]::Full[@{ 0 =  8,  9 ; 1 =  9,  8 }[ $Index % 2 ] ]
            $This.Fill   = [Block]::Full[@{ 0 = 10, 11 ; 1 = 12, 13 }[ $Index % 2 ] ]
        }
    }

    Class Track
    {
        [Int32]    $Index
        [String]   $Track
        [String[]] $Face
        [String[]] $Items
        [Int32[]]  $Guide
        [String[]] $String
        [String[]] $Fill
        [String]   $Serial
        [String]   $Mask

        Track([Int32]$Index,[String]$Track)
        {
            If ( $Track.Length -lt 120 ) { Throw "Does not meet minimum length" }

            $This.Index    = $Index
            $This.Track    = $Track
            $This.Face     = 0..( $Track.Length - 1 ) | ? { $_ % 4 -eq 0 } | % { $Track.Substring( $_ , 4 ) }
            $This.Items    = $This.Face | ? { $_ -in [Block]::Full } | Select -Unique
            $This.Guide    = 0..( $This.Face.Count - 1 ) | ? { $This.Face[$_] -in $This.Items } | % { $I = $_ ; 0..( $This.Items.Count - 1 ) | ? { $This.Items[$_] -eq $This.Face[$I] } }
            $This.String   = $This.Serial = $This.Guide -join ';'
            $This.Fill     = ( [Regex]"([\d])+([;]\1){2,}" ).Matches( $This.String ).Value

            If ( $This.Fill.Count -gt 1 )
            {
                ForEach ( $I in 0..( $This.Fill.Count - 1 ) )
                {
                    $This.String = $This.Fill[$I] | % { $This.String.Replace( $_ , ( "@({0})*{1}" -f ( $_.Split(";")[0] , $_.Split(";").Count ) ) ) }
                }
            }

            Else
            {
                $This.String = $This.Fill | % { 
                
                    $This.String.Replace( $_ , ( "@({0})*{1}" -f ( $_.Split(";")[0] , $_.Split(";").Count ) ) ) }
            }

            $This.Mask     = ( $This.Serial.Split(';') | % { "{$_}" } ) -join ""

        }
    }
