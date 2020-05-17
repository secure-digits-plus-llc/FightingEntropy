    Class Range
    {
        [Int32[]] $Range

        Range([Int32]$Total) 
        { 
            If ( $Total -gt 1 ) { $This.Range = [Int32[]]@( 0..( $Total - 1 ) ) } Else { Throw "Input must be greater than 1" }
        }
    }

    Class Charm
    {
          [Char]  $Char
        [String]  $Name
        [String]  $Decimal
        [String]  $Dec
        [String]  $Hexidecimal
        [String]  $Hex

        Charm([Int32]$Index)
        {
            $This.Char         = [Char]$Index
            $This.Name         = $Index | ? { $_ -in 32,34,38,39,42,60,62 } | % {
            @{ 
                32 = "nbsp" ; 34 = "quot" ; 38 = "amp" ; 39 = "apos" ; 42 = "star" ; 60 = "lt" ; 62 = "gt" 
                
            }[ $Index ] }      | % { "&{0};" -f $_ }

            $This.Decimal      = $Index
            $This.Dec          = [String](  "&#{0:d};" -f $Index )
            $This.Hexidecimal  = [String](    "{0:X}"  -f $Index )
            $This.Hex          = [String]( "&#x{0:X};" -f $Index )
        }
    }

    Class Block
    {
        static [String[]]     $Full = "    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,\__/,/¯¯\,/¯¯¯,¯¯¯\,\___,___/,[ __,__ ]".Split(",")
        static [String[]] $Function = 
            "    ____                                                                                                    _________   " ,
            "   //¯¯\\__________________________________________________________________________________________________//¯¯\\__//   " , 
            "   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    " , 
            "    ¯¯¯\\___[ ________________________________________________________________________________________ ]___//¯¯¯        " , # Function/92
            "        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            " 
        static [String[]]   $Action =
            "    ____    ____________________________________________________________________________________________________        " , 
            "   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    " , 
            "   \\__//¯¯¯[ ________________________________________________________________________________________ ]    ___//¯¯\\   " , # Action/25, Message/64
            "    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   " , 
            "        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    "
        Static [String[]]    $Title =
            "    ____    ____________________________________________________________________________________________________        " , 
            "   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    " , 
            "   \\__//¯¯¯[ ________________________________________________________________________________________ ]    ___//¯¯\\   " # Title/92 -Center
        Static [String[]] $Headless = 
            "    ¯¯¯\\__________________________________________________________________________________________________//¯¯¯   //   " ,
            "    ___//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯       \\   " 
        static [String[]]   $Header =
            "    ¯¯¯\\__________________________________________________________________________________________________//¯¯¯   //   " ,
            "    ___//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___   \\   " ,
            "   //¯¯\\___[ ________________________________________________________________________________________ ]___//¯¯\\__//   " , # Header/92 -Right
            "   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯\\   " 
        static [String[]]     $Body =     
            "   //¯¯¯                                                                                                           //   " ,
            "   \\                                                                                                              \\   " , # Keys/25, Status/3, Values/64 | Width/92
            "   //                                                                                                           ___//   " 
        static [String[]]   $Footer = 
            "   \\___                                                                                                    ___//¯¯\\   " ,
            "   //¯¯\\__________________________________________________________________________________________________//¯¯¯___//   " , 
            "   \\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//¯¯¯    " , 
            "    ¯¯¯\\___[ ________________________________________________________________________________________ ]___//¯¯¯        " , # Prompt/92 [Optional]
            "        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯            "
    }

    Class Face
    {
               [Int32]    $Rank
               [String]   $String
        hidden [String[]] $Block  = [Block]::Full
        hidden [Int32[]]  $Range  = ([Range][Block]::Full.Count).Range

        Face([String]$String)
        {
            $This.String = $String
            $This.Rank   = $This.Range | ? { $This.Block[$_] -eq $This.String }
        }
    }

    Class Mask
    {
        [Int32]  $Index
        [Int32]  $Block
        [String] $String
        [Int32]  $Count

        Mask([Int32]$Index,[Int32]$Block,[String]$String)
        {
            $This.Index  = $Index
            $This.Block  = $Block
            $This.String = $String
            $This.Count  = 1
        }
    }

    Class Track
    {
        [Int32]  $Index
        [String] $Track
        [Array]  $Slot
        [Array]  $Mode
        [Array]  $Mask
        [Array]  $Return

        Track([Int32]$Index,[String]$Track)
        {
            If ( $Track.Length -lt 120 ) { Throw "Does not meet minimum length" } 
            
            $This.Index = $Index
            $This.Track = $Track

            $This.Slot  = ([Range]$This.Track.Length).Range | ? { $_ % 4 -eq 0 } | % { [Face]::New($This.Track.Substring($_,4)) }

            $This.Mode  = ([Range]$This.Slot.Count).Range | % { [Mask]::new($_,$This.Slot[$_].Rank,$This.Slot[$_].String) }
            $This.Mask  = @( )
            
            $In         = -1 
            $St         = -1 
            $Last       = $Null
            $Table      = @{ }

            ForEach ( $X in 0..( $This.Slot.Count - 1 ) )
            {
                If ( $This.Mode[$X] | % { $_.Index -eq 0 -or $_.String -ne $This.Mode[$X-1].String } )
                {
                    $Switch             = 1
                    $In                ++
                    $This.Mask         += $This.Mode[$X]
                }
                
                Else 
                {
                    $Switch             = 0
                    $This.Mask[$In].Count ++
                }

                $This.Mask[$In].Index   = $In

                If ( $Last -eq $Null -or $Last -ne $Switch )
                {
                    $St                ++
                    $Table.Add( $St , @( ) )
                }

                $Table[$St]            += $In

                $Last                   = $Switch
            }

            $This.Return                = ForEach ( $X in 0..( $Table.Count - 1 ) )
            {
                $Total                  = $Table[$X] 

                If ( $Total.Count -gt 1 )
                {
                    "{0}..{1}" -f $Total[0,-1] 
                }

                Else
                {
                    "@({0}*{1}" -f $Total, $Table[$X].Count
                }
            }

            $This.Return                = "@({0})" -f ( $This.Return -join ';' )
        }
    }

    Class Model
    {
             [String] $Type
           [String[]] $Model
            [Charm[]] $Charm
           [String[]] $Block
            [Track[]] $Stack
            [Int32]   $Width
            [Int32]   $Height

        Model([String]$Type)
        {
            $This.Type             = $Type
            
            $This.Model            = @{

                Function           = "Function"
                Action             = "Action"
                Section            = "Title","Headless","Body","Footer"
                Table              = "Title","Header",  "Body","Footer" 
            
            }[ $Type ]             | % { [Block]::$_ }

            $This.Charm            = 0..255 | % { [Charm]$_ }
            $This.Block            = @( [Block]::Full )
            $This.Stack            = ForEach ( $X in 0..( $This.Model.Count - 1 ) ) { [Track]::New( $X, $This.Model[$X]) }
            $This.Width            = $This.Stack.Track | % { $_.Length } | Select -Unique
            $This.Height           = $This.Model.Count
        }
    }

    $Model                         = [Model]::new("Action")
    $Model                         = [Model]::new("Function")
    $Model                         = [Model]::new("Section")
    $Model                         = [Model]::new("Table")
#bleh
