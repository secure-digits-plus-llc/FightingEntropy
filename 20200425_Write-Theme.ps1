Class Charm
    {
           [Int] $Guide
          [Char] $Char
        [String] $Name
        [String] $Dec
        [String] $Hex

        Charm([Int]$Guide)
        {
            $This.Guide =  [Int] $Guide
            $This.Char = [Char] $Guide

            $This.Name = @{ 
            
                $True  = @{
                
                    32 = "nbsp" 
                    34 = "quot" 
                    38 = "amp" 
                    39 = "apos" 
                    42 = "star" 
                    60 = "lt" 
                    62 = "gt"  
                
                }[$Guide] | % { "&{0};" -f $_ }

                $False = ""
            
            }[$Guide -in 32,34,38,39,42,60,62]

            $This.Dec  = [ String ](  "&#{0:d};" -f $Guide )
            $This.Hex  = [ String ]( "&#x{0:X};" -f $Guide )
        }
    }
    
    $String        = "    ,____,¯¯¯¯,----,   /,\   ,   \,/   ,/¯¯\,\__/,¯¯¯\,/¯¯¯,___/,\___" -Split ','
    
    $Chart         = 0..175 | % { [Charm]::New($_) }
    
    $Collect       = ForEach ( $I in 0..13 )
    {
        [ PSCustomObject ]@{
                
            Index  = [Int] $I
            String = [String]$String[$I]
            Char   = $String[$I][0..3]
            Int    = ForEach ( $L in 0..3 )
            {
                [Int] $Chart[$String[$I][$L]].Guide
            }
        }
    }
