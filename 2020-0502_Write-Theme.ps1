

    [Environment]::GetEnvironmentVariables().GetEnumerator() | Sort Name 
    [System.Management.Automation.Host.Size]::new(128,5000)

Function Write-Theme
{ 
    [ CmdLetBinding ( <# DefaultParameterSetName = "" #> ) ] Param (

        #[ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=     "XML" )][String]       $XML ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]  $Function ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=   "Action" )][String]    $Action ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=  "Section" )][String]   $Section ,
        [ Parameter ( Mandatory, Position=0, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]     $Table )
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=   "Action" )]
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]      $Slot ,
        #[ Parameter (            Position=2, ValueFromPipeline=$True, ParameterSetName=   "Action" )]
        #[ Parameter (            Position=2, ValueFromPipeline=$True, ParameterSetName= "Function" )][String]      $Info ,
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=  "Section" )]
        #[ Parameter ( Mandatory, Position=1, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]     $Title ,
        #[ Parameter ( Mandatory, Position=2, ValueFromPipeline=$True, ParameterSetName=  "Section" )]
        #[ Parameter ( Mandatory, Position=2, ValueFromPipeline=$True, ParameterSetName=    "Table" )][String]    $Prompt ,
        #[ Parameter ( Mandatory, Position=3, ValueFromPipeline=$True, ParameterSetName=    "Color" )][HashTable] $Colors )

    Class Range 
    {
        [Int32]   $Total
        [Int32[]] $Range

        Range([Int32]$Total)
        {
            $This.Total = $Total
            $This.Range = $( If ( $Total -gt 1 ) { 0..( $Total - 1 ) } Else { Throw "Not a range" } )
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

        Charm([Int]$Index)
        {
            $This.Index        = [Int]   $Index
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

    Class Track
    {
                  [Int32] $Index
                 [String] $Track
        static [String[]] $Block   = "    ","____","¯¯¯¯","----"
               [String]   $Mask 
               [String[]] $Base
               [String[]] $Margin
               [String[]] $Fill

        Track([Int32]$Index,[String]$Track)
        {
            $This.Index     = [Int32]  $Index
            $This.Track     = [String] $Track
            $This.Base      = @{ 0 = "\__/","/¯¯\" ; 1 = "/¯¯\","\__/" }[ $Index % 2 ]
            $This.Margin    = @{ 0 = "   /","\   " ; 1 = "   \","/   " }[ $Index % 2 ]
            $This.Fill      = @{ 0 = "/¯¯¯","¯¯¯\" ; 1 = "\___","___/" }[ $Index % 2 ]
        }
    }

    Class Section
    { 
        [String]  $Title
        [Int32[]] $Index
        [Track[]] $Stack

        Stack([Int32[]]$Index,[Track[]]$Stack)
        {
            $This.Index        = ForEach ( $I in $Index ) { $Index[$I] }
            $This.Stack        = ForEach ( $I in $Index ) { $S[$I]     }
        }
    }

    $Type        = @{
                
        Function = "Function"
        Action   = "Action"
        Section  = "Section"
        Table    = "Table"
            
    }[ $PsCmdlet.ParameterSetName ]
    
    $Obj = [ PSCustomObject ]@{ 

        
        Charm = ([Range]255).Range | % { [Charm]$_ }
        Track = ([Range]  5).Range | % { [Track]::New($_,$Array[$_]) }

    }
    # ------

        $Test        = [Ordered]@{
               
            Example1 = [Ordered]@{ Item1_1 = "Value1_1"; Item1_2 = "Value1_2"; Item1_3 = "Value1_3" }
            Example2 = [Ordered]@{ Item2_1 = "Value2_1"; Item2_2 = "Value2_2"; Item2_3 = "Value2_3" }
            Example3 = [Ordered]@{ Item3_1 = "Value3_1"; Item3_2 = "Value3_2"; Item3_3 = "Value3_3" }
        }
            
        $Type        = @{
                
            Function = "Function"
            Action   = "Action"
            Section  = "Section"
            Table    = "Table"
            
        }[ $PsCmdlet.ParameterSetName ]

        If ( $Type -match "(Action|Function)" )
        {
            
        }

        Else
        {
            
        }
    
    }


        If ( $Table )
        {
            $Keys = $Table | Select Keys

            ForEach ( $Hashtable in $Hashtables )
            {
                
            }
        }

        # ----------



    # 0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30
    # 0    4    8   12   16   20   24   28   32   36   40   44   48   52   56   60   64   68   72   76   80   84   88   92   96  100   104 108  112  116  120
    # |    |____|    |____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|    |    "
    # |   /|/¯¯\|\__/|/¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯\|\___|    "
    # |   \|\__/|/¯¯¯|   _|__[ |Tabl|e of| Con|tent|s ] |____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|_   |___/|/¯¯\|\   "
    # |    |¯¯¯\|\___|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|___/|/¯¯\|\__/|/   "
    # |    |    |¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|¯¯¯¯|    |¯¯¯¯|    "
    # |    |____|    |____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|____|    |    "

    $Sample  = "    ____    ____________________________________________________________________________________________________        ",
               "   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    ",
               "   \\__//¯¯¯   ___[ Content... For all tablekind. ( A normal, yet dramatic, table of content...) ]_______   ___//¯¯\\   ",
               "    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   ",
               "        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    "
    

    $Array   = "    ____    ____________________________________________________________________________________________________        ",
               "   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___    ",
               "   \\__//¯¯¯   ___[ Table of Contents ] _________________________________________________________________   ___//¯¯\\   ",
               "    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__//   ",
               "        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯    "

               "   \\__//                                                                                                  \\__//¯¯\\   " 
               "   //¯¯\\                                                                                                  //¯¯\\__//   " 

               "   \",
               "\__/",
               "/  "


    $Test   = @{ 
               
        Example1 = @{
        
            Item1_1 = "Value1_1"
            Item1_2 = "Value1_2"
            Item1_3 = "Value1_3"
        }

        Example2 = @{
        
            Item2_1 = "Value2_1"
            Item2_2 = "Value2_2"
            Item2_3 = "Value2_3"
        }

        Example3 = @{
        
            Item3_1 = "Value3_1"
            Item3_2 = "Value3_2"
            Item3_3 = "Value3_3"
        }
    }


    
