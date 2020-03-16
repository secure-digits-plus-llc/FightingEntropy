Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( # Still revising
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        # [ Custom Types / Script Blocks ]

        $Script                                 = [ PSCustomObject ]@{ # I'm the first script property. 
                                                                       # I'm a variable that works like a command/function, but I'm local, not global.

                                                                       # I could be a global variable if you use $Global:Script...? But, it's whatev's.
        
            Reg                                 = "(?<=\<).+?(?=\>)"   # Some regex. Grabs long strings in '<','>' Not like the type of strings for 
                                                                       # guitar or violin, oh, no no no. These strings..? They're some XAML strings.

            Object                              = { # Script Property, used as an initial (class/template) for the XAML. Sorta like a cookie cutter.

                Param ( $Xaml )                   # [ Script Property Parameter ] - The here-string version of the block of (XAML/Markup Language) 

                [ PSCustomObject ]@{ # It *is* some stuff..? And then, it *does* some stuff... But, only when it is *told* to *do* some stuff. 
                # Which... admittedly, that's a lot of stuff! Might be *a lot of stuff* it (is/can do)..? But, that's why it's pretty cool.

                    Track                       = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) ) # Count based stuff 

                    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\#
                        [ PSCustomObject ]@{ # Hi! I'm a nested object. I can *do* some other stuff, AND *be* some other stuff too.      /#
                                                                                                                                        #\#
                            Index               = $I #_ _ _ _ _ _ _ _ _ _ _      Line Index                                              /# 
                            Line                = $Xaml.Split("`n")[$I] #_ \     Line Data/String                                        \#
                        }#\ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _/                                                             /#
                    }#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\                                                             \#
                    Xaml                        = $Xaml # _ _ _ _ _ _ _ _ _/     Here String "Oooo look at me. I'm special aren't I?"    /# 
                    Array                       = $Xaml.Split("`n") #_ _ _ \     Don't mind ^ Here String... he's a one string pony...   \#
                    Items                       = $Xaml.Split("`n").Split(' ') | ? { $_.Length -gt 0 } #  Most important track           /# 
                }#\# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ \#
            }
        }#\______________________________________________________________________________________________________________________________/#
        $Template                               = { # Whats up dude? I'm a variable named $Template ! I'm *another object*, but, I'm used 
                                                    # for sculpting output. Sorta like a mask. I can have properties that lead to other 
                                                    # objects. Such as XAML strings. 

            Param ( $Index , $Drive )               # [ Script Property Parameter ] - Numerical Index and the Drive label

                [ PSCustomObject ]@{                # Usually, an objects' property names may lend away what type of object it is.
                        
                    Drive                           = $Drive
                    Parent                          = ""
                    Path                            = ""
                    Name                            = ""
                    Depth                           = ""
                    Track                           = ""
                    Index                           = $Index
                    Slice                           = ""
                    Property                        = @( )
                    Value                           = @( )
                    Children                        = @( )
                }                                                     
        }#\_______________________________________________________________________________________________________________________________________________/#
        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\#
        
            $Root                                   = & $Script.Object $Xaml_Input                           # This is sort-of a Begin-Parameter Block
            $Drive                                  = "DSC:"                                                  # In this instance, these variables all have
            $Return                                 = $Root.Items -match "<"                                  # a direct influence on the success of the 
            $Index                                  = 0                                                       # process and it's output. 
            $Track                                  = 0..( $Return.Count - 1 )                                
            $Parent                                 = $Null                                                   # A CustomObject/Class could be used here.
            $Path                                   = $Null
            $X                                      = 0
            $I                                      = 0

        #\________________________________________________________________________________________________________________________________________________/#
        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\#
        # [ Entering the Gauntlet ]_______________________________________________________________________________________________________________  ____   \# 
        ForEach ( $I in 0..( $Return.Count - 1 ) ) #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\[ Declaring the output array & rules to process ]//¯¯\\   \#
        {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__//   /# 
        #                                                                                                                                           ¯¯¯¯   /#
                $Index                          = $I # Index, and then start object injection. ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\#
                                                                                                                                                           #\#
                $Track[$I]                      = & $Template $Index $Drive | % { # Loads the template, and loops until the delimiter [$I] is reached      #/#

        <#  #[ ForEach-Object | % ] - There are a couple of derivatives of this looping technique, called "ForEach-Object"    [ Object Looping Example ]  \#>

            #       **** NOTE ****      Used in this way, you are able to accomplish the selection and execution of a property and/or array of 
            #   properties/values. Everything between these curly braces, is all referred to by $_, and those curly braces can be extended, and re-used 
            #   to the Nth number of times, so long as the braces resynchronize an output with similar properties.

            #   If entering a new nested loop, the default token ("$_") cannot be re-used to reference that particular object/property/etc.
            #   You *may* nest the null variable even farther inward...? But, it will be (unscoped/able) until you return to that particular 
            #   (scope/break).
            
            #   You can use a ($NewVariable) OR, a ($_.Property/$NewVariable.Property) to re-(select/reference) it within that 
            #   (reference/scope), or any other scope... If the values are synchronized, they are typically matched by a numerical index value, OR, 
            #   an object's ranking. 
            
            #   - Using a numerical index as indicated with [$I] above, will synchronize the output content. 
            #   - Other object properties can also be used/changed when (Selecting/Sorting/Comparing/Filtering)
            #   - Using a combination of these methods is also possible while using the same reference
            #   - Using it in addition to a template or class that is already in memory, increases the effectiveness/responsiveness of the loop.

            #\____________________________________________________________________________________________________________________________________________/#
            # Here, we can extract the full string of characters based on the close bracket. Using a combination of outer-loop, and (If/While)
            #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ #
                   $_.Track                     = $Return[$I]             # Starts each line of the ($Script.Object Output/$Root) with an open bracket   / #

                   If ( $_.Track -notmatch ">" )                       # If the string passes the filter, it skips this and pushes in the $X ++ count
                    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ #
                        #\_______________________________________________________________________________________________________________________________/ #
                        While ( $_.Track -notmatch ">" )                        # For each iteration, it adds the $X ++ until the string ends in ">".
                        {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\ #
                                $X ++                                                                                                                  # / #
                                $_.Track            = $_.Track , $Root.Items[$X] -join ' '       # $Root.Items is the complete whitespace split array  # \ #
                                                                                                                                                     #___/ #
                        }#\__________________________________________________________________________________________________________________________//¯¯\ #

                    }#\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\__/ #
                                $X ++                                                                          # Keeps track (index/count) in sync   
                    $_.Name                     = $Return[$I].Replace("<",'').Replace(">",'').Replace("/",'')  # Filter out the name of the object
                    $_.Name                     = $Return[$I].Replace("<",'').Replace(">",'').Replace("/",'')
                    $_.Parent                   = If ( $Parent -eq $Null -or $Parent -eq $Drive ) { $Drive } Else { Split-Path $Parent -Parent }
                    $_.Path                     = If ( $Parent -eq $Null ) { $_.Parent , $_.Name -join '\' } Else { $Parent , $_.Name -join '\' }

                    If ( $_.Track -match "(?<=\<\w).+?(?=\>)" ) #    "([^/]'\>)"     "<X>"  -match "(?<=\<\w)"
                    {
                        $Parent                         = $_.Path
                    }

                    If ( $_.Track -match  "(?<=\</)" )    # [ Test ] "</X> " -match "(?<=\</\w)" ".+?(?=\>)" "([</]\w)"
                    {

                        $Parent                         = $_.Parent
                    }

                        $_.Depth                        = $_.Path.Split('\').Count - 1


                    If ( $_.Track -match "(?<=\/>)" )    # [ Test ] "'      />" -match "([']\s/>)"
                    {                                           
                        $Parent                         = $_.Parent
                    }

                    $_.Track                            = $_.Track -Replace "\'\s\/>" , "'/>" -Replace "\'\s>" , "'/>"

                # Converts all found properties to key/value pairs -----------------------------------------------------------------
                    $_.Slice                            = $_.Track.Replace( "$( $Return[$I] ) " , '' ).Replace("' ","';").Split(';')
                
                    If ( $_.Slice.Count -gt 1 )   
                    {
                        $_.Property                     = @( )
                        $_.Value                        = @( )
                        $J                              = 0

                        While ( $J -ne $_.Slice.Count - 1 )
                        {
                            $K                          = $_.Slice[$J].Split("=")[0].Replace(" ","") 

                                $_.Property            += $K
                                $_.Value               += $_.Slice[$J].Replace( "$K = " , "" )
                        }

                        $J ++
                    }
                    # Insert Output code here
                }

                If ( $_.Slice.Count -eq 1 )
                {
                    If ( $_.Slice.Split('=').Count -gt 1 )
                    {
                        $Slice                   = $_.Slice.Split('=')[0].Replace(" ","")

                        $_.Property              = $Slice
                        $_.Value                 = $_.Slice.Replace( "$Slice = " , "" )

                        $Slice               = $Null
                    }

                    # Insert Output code here
                } # ----------------------------------------------------------------------------------------------------------------
            }

        $Track
    }
}
