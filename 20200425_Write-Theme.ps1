Function Write-Theme
{ 
    [ CmdLetBinding ( <# DefaultParameterSetName = "" #> ) ] Param (

        #[ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=     "XML" )][String]       $XML ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]  $Function ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=   "Action" )][String]    $Action ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=    "Stack" )][String]     $Stack ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]     $Table )
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=   "Action" )]
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]      $Slot ,
        #[ Parameter (            Position=2, ValueFromPipeline=$True, ParameterSetName=   "Action" )]
        #[ Parameter (            Position=2, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]      $Info ,
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=    "Stack" )]
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]     $Title ,
        #[ Parameter ( Mandatory, Position=2, ValueFromPipeline=$True, ParameterSetName=    "Stack" )]
        #[ Parameter ( Mandatory, Position=2, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]    $Prompt ,
        #[ Parameter ( Mandatory, Position=3, ValueFromPipeline=$True, ParameterSetName=    "Color" )][HashTable] $Colors )

        # Development Objective... refine the prior 1000 line function into < 200 using classes.
        # Using this cmdlet in it's prior version, would allow for the creation of colorized console objects
        # This re-write will incorporate a way to use a serializable XML string to reproduce those same messages

        # (1) [Int] odd/even track index [Complete]
        # (2) 120 unit length Track w/ default string used for buffer [Complete]

        # *(3) dynamic mask for string interpolation
        # *(4) BackgroundColor
        # *(5) ForegroundColor

        # [Masking/Color]
        # Each line has 120/124 positions/arrays, which are all switchable (120 is current, 124 is adds a couple pixels per margin)
        # Each item within a line 
        # Each pixel has 3 values, string, int(0..15), int(0..15),
        # Each pixel becomes an object within the line/track object
        # The depth/dimension/bit should convert to hex, so the hex switch defines the track with no overhead needed to calculate a track, or minimal.

        # ____________________________________________________________________________________________________________________________________________________________  
        # [Function] ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ | 
        # ##### |   1|   2|   3|   4|   5|   6|   7|   8|   9|  10|  11|  12|  13|  14|  15|  16|  17|  18|  19|  20|  21|  22|  23|  24|  25|  26|  27|  28|  29|  30| 
        
        #   0 : |    |____|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |____|    |____|    |____|    |____|    |____|    | 
        #   1 : |   /|/¯¯\|\___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\   | 
        #   2 : |   \|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/   | 
        #   3 : |    |¯¯¯\|\__[| Pre|ss E|nter| to |Cont|inue| ]__|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯¯|    | 
        #   4 : |    |    |¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |    | 

        # ____________________________________________________________________________________________________________________________________________________________  
        # [Action] ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ | 
        # ##### |   1|   2|   3|   4|   5|   6|   7|   8|   9|  10|  11|  12|  13|  14|  15|  16|  17|  18|  19|  20|  21|  22|  23|  24|  25|  26|  27|  28|  29|  30| 

        #   0 : |    |____|    |____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|    |    | 
        #   1 : |   /|/¯¯\|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\___|    | 
        #   2 : |   \|\__/|/¯¯¯|    |    |    |    |  St|uff |: Ha|ppen|ing |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |___/|/¯¯\|\   | 
        #   3 : |    |¯¯¯\|\___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/   | 
        #   4 : |    |    |¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|    |¯¯¯¯|    | 

        #_____________________________________________________________________________________________________________________________________________________________  
        # [Stack] ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ | 
        # ##### |   1|   2|   3|   4|   5|   6|   7|   8|   9|  10|  11|  12|  13|  14|  15|  16|  17|  18|  19|  20|  21|  22|  23|  24|  25|  26|  27|  28|  29|  30| 

        #   0 : |    |____|    |____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|    |    | 
        #   1 : |   /|/¯¯\|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\___|    | 
        #   2 : |   \|\__/|/¯¯¯|    |    |    |    |  St|uff |: Ha|ppen|ing |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |___/|/¯¯\|\   | [ Header ]
        #   3 : |   /|/¯¯\|\___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/   | {Available to Array and Hashtable}

        #   $Test   = [Ordered]@{ 
        #       
        #       Example1 = [Ordered]@{ Item1_1 = "Value1_1"; Item1_2 = "Value1_2"; Item1_3 = "Value1_3" }
        #       Example2 = [Ordered]@{ Item2_1 = "Value2_1"; Item2_2 = "Value2_2"; Item2_3 = "Value2_3" }
        #       Example3 = [Ordered]@{ Item3_1 = "Value3_1"; Item3_2 = "Value3_2"; Item3_3 = "Value3_3" }
        #}

        #   0 : |   \|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\__/|/¯¯\|\   | [ Section 1 ]
        #   1 : |   /|/¯¯\|\__[|Cont|ent |]___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/   | [ Name of Section 1 ]
        #   2 : |   \|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\__/|/¯¯\|\   | 
        #   3 : |   /|/¯¯\|\   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |   /|¯¯¯\|\__/|/   | 

        #   0 : |   \|\__/|/   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |   \|\__/|/¯¯\|\   | 
        #   1 : |   /|/¯¯\|\   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |   /|/¯¯\|\__/|/   |

        #   0 : |   /|/¯¯\|\___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\   | 
        #   1 : |   \|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/   | 
        #   2 : |    |¯¯¯\|\__[| Pre|ss E|nter| to |Cont|inue| ]__|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯\|\__/|/¯¯¯|    | [ Prompt ]
        #   3 : |    |    |¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |¯¯¯¯|    |    | 

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
    
    
