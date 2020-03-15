Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script             = [ PSCustomObject ]@{

            Reg             = "(?<=\<).+?(?=\>)"

            Obj                            = {

                Param ( $Xaml )

                [ PSCustomObject ]@{

                    Track                  = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) ) 
                    {
                        [ PSCustomObject ]@{
                
                            Index          = $I
                            Line           = $Xaml.Split("`n")[$I]
                        }
                    }
                    Xaml                   = $Xaml
                    Array                  = $Xaml.Split( "`n" )
                    Items                  = $Xaml.Split( "`n" ).Split(' ') | ? { $_.Length -gt 0 }
                }
            }
        }

        $Template                           = {

            Param ( $Index , $Drive )

            [ PSCustomObject ]@{ 
                    
                Drive                       = $Drive
                Parent                      = ""
                Path                        = ""
                Name                        = ""
                Depth                       = ""
                Track                       = ""
                Index                       = $Index
                Slice                       = ""
                Property                    = @( )
                Value                       = @( )
                Children                    = @( )
            }
        }

        $Root                               = & $Script.Obj <#$Xaml#> $Xaml
        $Drive                              = "DSC:"
        $Return                             = $Root.Items -match "<"
        $Index                              = 0
        $Track                              = 0..( $Return.Count - 1 ) | % { & $Template $I $Drive }
        $Split                              = ""
        $Parent                             = $Null
        $Child                              = $Null
        $Path                               = $Null
        $Depth                              = 0
        $X                                  = 0
        $Y                                  = 0
        $I                                  = 0

        #\_____________________________________________________________________________________________________________________________________________/#
        ForEach ( $I in 0..( $Return.Count - 1 ) ) #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯[ Declaring the output array & rules to process ]
        {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\#
            $Track[$I]                  = & $Template $I $Drive #                                              For retrieving the custom object/class

            #   $Track[$I]              | ( % -or- ForEach-Object ) {                                          If commented, disabled
            
            #       $_.Track            = $Return[$I]                                                        - Starts each line with an open bracket
            #       $_.Name             = $Return[$I].Replace("<",'').Replace(">",'').Replace("/",'')        - Filters out the name of the item/object
            #       $_.Path             = $Path , $Track[$I].Name -join '\'                                  - Combines the path with the object name
            #       $_.Parent           = $Path.Split('\')[-1]                                               - Parent Item
            #       $_.Depth            = $Track[$I].Path.Split('\').Count                                   - Levels/Folders inward

            # [ Concatenate entire string ]

            $Track[$I].Track            = $Return[$I]

            If ( $Track[$I].Track -notmatch ">" ) 
            {
                While ( $Track[$I].Track -notmatch ">" )
                {
                    $X ++
                    $Track[$I].Track    = $Track[$I].Track , $Root.Items[$X] -join ' '
                }
            }
            $X ++

            # [ Retrieve Object Name ]

            $Track[$I].Name                 = $Return[$I].Replace("<",'').Replace(">",'').Replace("/",'')

            # [ Determine Path/Parent/Child ]

            If ( $Parent -ne $Null )
            {
                $Path                       = $Parent
                $Parent                     = $Null
            }

            If ( $Child  -ne $Null )
            {
                $Path                       = $Path.Replace( "\$Child" , '' )
                $Child                      = $Null
            }

            If ( $Path   -eq $Null ) 
            {
                $Path                       = $Drive
            }

            $Track[$I].Path                 = $Path ,  $Track[$I].Name -join "\"

            If ( $Track[$I].Track -match "'\>" )
            {
                $Parent                     = $Track[$I].Path
            }

            If ( $Track[$I].Track -match "'/\>" -or $Track[$I].Track -match "</" )
            {
                $Child                      = Split-Path $Track[$I].Path -Leaf
            }

            $Track[$I].Parent               = Split-Path $Track[$I].Path -Parent
        
            $Track[$I].Track                = $Track[$I].Track -Replace "\'\s\/>" , "'/>" -Replace "\'\s>" , "'/>"
            $Track[$I].Depth                = $Track[$I].Path.Split('\').Count - 1
            $Track[$I].Slice                = $Track[$I].Track.Replace( "$( $Return[$I] ) " , '' ).Replace("' ","';").Split(';')
            
            If ( $Track[$I].Slice.Count -gt 1 )   
            {
                $Track[$I].Property         = @( )
                $Track[$I].Value            = @( )
                $J                          = 0

                While ( $J -ne $Track[$I].Slice.Count - 1 )
                {
                    $Track[$I].Slice[$J].Split("=")[0].Replace(" ","") | % { 

                        $Track[$I].Property    += $_
                        $Track[$I].Value       += $Track[$I].Slice[$J].Replace( "$_ = " , "" )
                    }

                    $J ++
                }

                # Insert Output code here
            }

            If ( $Track[$I].Slice.Count -eq 1 )
            {
                If ( $Track[$I].Slice.Split('=').Count -gt 1 )
                {
                    $Slice               = $Track[$I].Slice.Split('=')[0].Replace(" ","")

                    $Track[$I].Property  = $Slice
                    $Track[$I].Value     = $Track[$I].Slice.Replace( "$Slice = " , "" )
                }

                # Insert Output code here
            }

            $Slice                      = $Null
        }

        $Track
}
