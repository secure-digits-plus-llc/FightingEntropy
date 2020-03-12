    Function Format-XamlObject # Formats a Xaml Object to have a clean structure
    {
        [ CmdLetBinding () ] Param ( 
            
            [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script       = [ PSCustomObject ]@{

            Tab       = {

                Param ( $Line )

                $X , $Y = 0 , 0

                Do 
                {
                    If ( $Line[$X] -match "\s" ) { $X ++ } Else { $Y = 1 }
                }
                Until ( $Y -eq 1 )

                $X
            }

            Focus = {

                Param ( $Obj )

                ForEach ( $I in 0..( $Obj.Split("`n").Count - 1 ) )
                {
                    $Obj.Split("`n")[$I] | % {
                    
                        [ PSCustomObject ]@{

                            Track = $I
                            Tab   = & $Script.Tab $_
                            Line  = $_
                            Items = $_.Split(" ") | ? { $_.Length -gt 0 }
                        }
                    }
                }
            }

            Items = {

                Param ( $Focus )

                $List         = $Focus | ? { $_.Items -match "<" }

                $St           = [ PSCustomObject ]@{

                    Index     = 0
                    Track     = 0..( $List.Count - 1 )
                    List      = $List
                    Tabs      = $List.Tab
                    Items     = $Focus.Items    -match "<"
                    Props     = $Focus.Items -notmatch "<"
                    Format    = @( )
                }

                ForEach ( $X in $St.Track )
                {
                    $Ct          = [ PSCustomObject ]@{

                        Index         = $X
                        Indent        = $St.Tabs[$X]
                        Item          = $St.Items[$X]
                        Buffer        = $St.Tabs[$X] + $St.Items[$X].Length + 1
                        Property      = @( )
                        Value         = @( )
                    }

                    $Sw = 0

                    If ( $Ct.Item -notmatch ">" )
                    {
                        Do
                        {
                            $Sp = $St.Props[ $St.Index ]

                            If ( $Sp -notmatch "\s" -and $Sp -match "\w" )
                            {
                                $Ct.Property += $SP

                                $Value = ""

                                Do
                                {
                                    $St.Index ++
                                    $Sp = $St.Props[ $St.Index ]
                                            
                                    If ( $Sp -match "\w" )
                                    {
                                        If ( $Sp -match "['{2}]" )
                                        {
                                            $Value = $Sp
                                        }
                                                
                                        Else 
                                        {
                                            $Value += $Sp
                                        }
                                    }
                                }
                                Until ( $Value -match "['{2}]" )

                                $Ct.Value += $Value
                                $Sw = 0
                            }

                            $St.Index  ++
                        }
                        Until ( $SP -match ">" )
                    }

                    $Ct.Value = ( $Ct.Value -join ' ' ).Replace("' />","'/>").Replace("' >","'>").Replace("' ","';").Split(';')

                        If ( $Ct.Value -ne $Null )
                        {
                            If ( $Ct.Value.Count -eq 1 )
                            {
                                $Sp                  = $Ct.Value.Split(' = ')

                                $Ct.Property         = $Sp[0]
                                $Ct.Value            = $Sp[1]
                            }

                            If ( $Ct.Value.Count -gt 1 )
                            {
                                $Ct.Property         = 0..( $Ct.Value.Count - 1 ) 

                                0..( $Ct.Value.Count - 1 ) | % {

                                    $Sp              = $Ct.Value[$_].Split(' = ')

                                    $Ct.Property[$_] = $Sp[0]
                                    $Ct.Value[$_]    = $Sp[1]
                                }
                            }
                        }
                    }

                    $St.Format += $Ct
                    $St.Index  ++
                }
                
                $St.Format
            }

            Format      = { # Prepares a chunk of XAML for Clean Object Handling/Production

                Param ( $Full )

                $MaxBuff  = ( $Full.Buffer                     | Sort )[-1]
                $MaxSpace = ( $Full.Property | % { $_.Length } | Sort )[-1]
                
                $Space    = { # Internal Script Property for item spacing (Can be easily switched/reversed)
        
                    Param ( $Property )
                
                    $MaxSpace - $Property.Length | % { 
        
                        If ( $_ -gt 0 )
                        {
                            "{0}{1}" -f $Property , ( " " * $_ )
                        }
        
                        If ( $_ -eq 0 )
                        {
                            $Property
                        }
                    }
                }
        
                ForEach ( $L in 0..( $Full.Count - 1 ) )
                {
                    $Full[$L] | % { 
                                
                        $Item = If ( $_.Indent -gt 0 ) { "{0} {1}" -f ( " " * $_.Indent ) , $_.Item } Else { $_.Item }
                        $Buff = " " * ( $MaxBuff - $Item.Length )
        
                        If ( $_.Property.Count -eq 0 )
                        {
                            $Item
                        }
        
                        If ( $_.Property.Count -eq 1 )
                        {
                            $Prop = & $Space $_.Property
                            "{0} {1} {2} = {3}" -f $Item , $Buff , $Prop , $_.Value
                        }
        
                        If ( $_.Property.Count -gt 1 )
                        {
                            $Prop = & $Space $_.Property[0]
                            "{0} {1} {2} = {3}" -f $Item , $Buff , $Prop , $_.Value[0]
        
                            $Buff = " " * ( $MaxBuff + 1 )
        
                            $Z = 1
                            Do
                            {
                                $Prop = & $Space $_.Property[$Z]
                                "{0} {1} = {2}" -f $Buff , $Prop , $_.Value[$Z]
                                $Z ++
                            }
                            Until ( $Z -eq $_.Property.Count )
                        }
                    }
                }
            }
        }

        $Focus  = & $Script.Focus  $Xaml
        $Items  = & $Script.Items  $Focus
        $Format = & $Script.Format $Items

        [ PSCustomObject ]@{

            Track             = 0..( $Xaml.Split("`n").Count - 1 )
            Split             = $Xaml.Split("`n")               
            Focus             = $Focus
            Items             = $Items
            Format            = $Format
        }
}
