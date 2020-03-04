    Function Get-XAML # XAML Glossary and Generation Engine _____________________________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
    {#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
        [ CmdLetBinding () ][ OutputType ( "String" ) ] Param ( 
        
            [ Parameter ( ParameterSetName =     "Certificate" ) ][ Switch ] $Certificate    ,
            [ Parameter ( ParameterSetName =           "Login" ) ][ Switch ] $Login          ,
            [ Parameter ( ParameterSetName =     "New Account" ) ][ Switch ] $NewAccount     ,
            [ Parameter ( ParameterSetName =  "HybridDSCPromo" ) ][ Switch ] $HybridDSCPromo ,
            [ Parameter ( ParameterSetName =         "DCFound" ) ][ Switch ] $DCFound        ,
            [ Parameter ( ParameterSetName =         "DSCRoot" ) ][ Switch ] $DSCRoot        ,
            [ Parameter ( ParameterSetName =    "ProvisionDSC" ) ][ Switch ] $ProvisionDSC   ,
            [ Parameter ( ParameterSetName =         "Service" ) ][ Switch ] $Service        ,       
            [ Parameter ( ) ]                                     [ Switch ] $Testing        )

            $XML                        = @{ }
            $Schema                     = "http://schemas.microsoft.com/winfx/2006/xaml"
            $Author                     = "Secure Digits Plus LLC"

            $CS                         = GCIM Win32_OperatingSystem | % { $_.Caption }
            $B                          = $False , $True 
            $YZ                         = "[X]" , "[_]"

            $M                          = 0..3 | % { IEX "`$M$_ = 0..120 | % { @( '¯' , '_' , ' ' , '-' )[$_] * `$_ }" }

            $Glossary                   = 
            "   `$W = 'Width'             " , "   `$H = 'Height'            " , "  `$MA = 'Margin'          " , 
            "  `$MN = 'Menu'              " , " `$MNI = 'MenuItem'          " , "  `$HD = 'Header'          " , 
            "  `$GB = 'GroupBox'          " , " `$GBI = 'GroupBoxItem'      " , "  `$CB = 'ComboBox'        " , 
            " `$CBI = 'ComboBoxItem'      " , " `$CHK = 'CheckBox'          " , "  `$TB = 'TextBox'         " , 
            " `$TBL = 'TextBlock'         " , "   `$G = 'Grid'              " , "  `$RD = 'RowDefinition'   " , 
            "  `$CD = 'ColumnDefinition'  " , "  `$GC = 'Grid.Column'       " , " `$GCS = 'Grid.ColumnSpan' " , 
            "  `$GR = 'Grid.Row'          " , " `$GRS = 'Grid.RowSpan'      " , "  `$SI = 'SelectedIndex'   " , 
            "  `$LA = 'Label'             " , "  `$BU = 'Button'            " , "  `$CO = 'Content'         " , 
            "   `$Q = 'Name'              " , "  `$SE = 'Setter'            " , "  `$PR = 'Property'        " , 
            "  `$BG = 'Background'        " , "  `$RB = 'RadioButton'       " , "  `$TW = 'TextWrapping'    " , 
            "  `$BO = 'Border'            "
            
            $Glossary                   | % { IEX $_ }

            $GRD , $GCD                 = $RD , $CD | % { "$G.$_`s" }

            $Glossary                  += " `$GRD = '$GRD'" , " `$GCD = '$GCD'" 

            $HAL                        = "Left" ,   "Center" ,  "Right" | % { "HorizontalAlignment = '$_'" }
            
            $HCAL                       = $HAL | % { $_.Replace( 'lA' , 'lContentA' ) }

            $VAL                        =   "Top" ,   "Center" , "Bottom" | % { "VerticalAlignment = '$_'" }
            
            $VCAL                       =  $VAL | % { $_.Replace( 'lA' , 'lContentA' ) } 

            $SP                         = 0..20 | % { "    " * $_ }

            $VC , $VV                   = "Collapsed" , "Visible" | % { "Visibility = '$_'" }

            $CF ,  $OK ,  $CA           = "Confirm" , "Start" , "Cancel"
                    
            $PW , $PWB , $PWC           = "Password" | % { "$_" , "$_`Box" , "$_`Char" }

            $GFX                        = Resolve-HybridDSC -Graphics

            $Z                          = 0

        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $Certificate ) # Certificate/Domain XAML                                [
        {#___________________________________________________________________________/

            $Title                      = "Certificate Info"       
                
             # ____   _________________________
             #//¯¯\\__[_______ Header ________] 
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 ; @( 13 ) * 7 ; 10 , 9 ) | % { $SP[$_] }

                $Y      = @( "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , "  Title = '$Author | Hybrid @ $Title'" ,  
                             "  $W = '350'" , " $H = '200'" , "Topmost = 'True' " , "   Icon = '$( $GFX.Icon )'" , "$( $HAL[1] )" , 
                             "  WindowStartupLocation = 'CenterScreen' >" )

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 3 , 9 , 9 , 9 , 6 , 4 , 5 , 6 , 6 , 5 , 5 , 6 , 7 , 7 , 6 , 6 , 7 , 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "<$GB" , " $HD = 'Company Information / Certificate Generation'" , "  $W = '330'" , " $H = '160'" , "  $( $VAL[0] ) >" , 
                             "<$G>" , "<$GRD>" ; 2 , "" | % { "<$RD $H = '$_*' />" } ; "</$GRD>" , "<$G $GR = '0' >" , "<$GCD>" ; 
                             "" , "2.5" | % { "<$CD $W = '$_*' />" } ; "</$GCD>" , "<$GRD>" ; 0..1 | % { "<$RD $H = '*' />" } ; "</$GRD>" )

                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[      User Input       ]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( @( 6 ) * 4 ) | % { $SP[$_] }

                $Y      = @( ( 0 , "Company" ) , ( 1 , "Domain" ) | % { 

                            "<$TBL $GR = '$( $_[0] )' $GC = '0' $MA = '10' TextAlignment = 'Right' >$( $_[1] ):</$TBL>" ,
                            "<$TB $Q = '$( $_[1] )' $GR = '$( $_[0] )' $GC = '1' $H = '24' $MA = '5' />" } )

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[        Framing        ]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 5 ; 5..7 ; 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "</$G>" , "<$G $GR = '1' >" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" )

                $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Controls ______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 6 , 6 ) | % { $SP[$_] }

                $Y      = @( ( 0 , "Ok" ) , ( 1 , "Cancel" ) | % { "<$BU $Q =  '$( $_[1] )' $CO = '$( $_[1] )' $GC = '$( $_[0] )' $MA = '10' />" } )

                $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Header ________]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 5..2 ) | % { $SP[$_] }

                $Y      = @( "</$G>" , "</$G>" , "</$GB>" , "</Window>" )

                $XML[5] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
        }

        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $Login -or $NewAccount ) # Login / New Account                          [
        {#___________________________________________________________________________/

            If ( $Login )
            { 
                $Title  = "AD Login"
                $Header = "Enter Directory Services Admin Account"
                $VX     = ""
            }
            
            If ( $NewAccount )
            {
                $Title  = "Account Designation"
                $Header = "Enter Username and Password"
                $VX     = $VC
            }

            $X          = @( 2 ; @( 13 ) * 7 ; 10 , 9 ) | % { $SP[$_] }

            $Y          = @( "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , 
                             "  Title = '$Author | Hybrid @ $Title'" , "  $W = '480'" , " $H = '280'" , "Topmost = 'True' " , 
                             "   Icon = '$( $GFX.Icon )'" , "$( $HAL[1] )" , "  WindowStartupLocation = 'CenterScreen' >" )

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
                $X      = @( 3 , 9 , 9 , 9 , 6 , 4 , 5 , 6 , 6 , 5 , 5 , 6 , 7 , 7 , 6 , 6 , 7 , 7 , 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "<$GB" , " $HD = '$Header'" , "  $W = '450'" , " $H = '240' $MA = '5'" , "  $( $VAL[1] )>" ,
                             "<$G>" , "<$GRD>" ; "2" , "1.25" | % { "<$RD $H = '$_*' />" } ; "</$GRD>" , "<$G $GR = '0' >" ,
                             "<$GCD>" ; "" , "3" | % { "<$CD $W = '$_*' />" } ; "</$GCD>" ; "<$GRD>" ;
                             0..2 | % { "<$RD $H = '*' />" } ; "</$GRD>" )

                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_____ User Input ______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( @( 6 , 7 ) * 6 ) | % { $SP[$_] }

                $Y      = @( "<$TBL $GC = '0' $GR = '0' $MA = '10' TextAlignment = 'Right' >" , "Username:</$TBL>" ,
                             "<$TB $Q = 'Username' $GC = '1' $GR = '0' $H = '24' $MA = '5' >" , "</$TB>" ,
                             "<$TBL $GC = '0' $GR = '1' $MA = '10' TextAlignment = 'Right' >" , "Password:</$TBL>" ,
                             "<$PWB $Q = 'Password' $GC = '1' $GR = '1' $H = '24' $MA = '5' $PWC = '*' >" , "</$PWB>" ,
                             "<$TBL $GC = '0' $GR = '2' $MA = '10' TextAlignment = 'Right' >" , "Confirm:</$TBL>" ,
                             "<$PWB $Q =  'Confirm' $GC = '1' $GR = '2' $H = '24' $MA = '5' $PWC = '*' >" , "</$PWB>" )

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 5 ; 5..7 ; 7 , 6 , 6 , 7 , 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "</$G>" , "<$G $GR = '1' >" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" , "<$GRD>" ;
                             0..1 | % { "<$RD $H = '*'/>" } ; "</$GRD>" )

                $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Controls ______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 6 ; @( 6 , 7 ) * 3 ; 6..3 ) | % { $SP[$_] }

                $Y      = @( "<RadioButton $Q = 'Switch' $GR = '0' $GC = '0' $CO = 'Change' $($VAL[1]) $($HAL[1]) $VX/>" ,
                              "<$TB $Q = 'Port' $GR = '0' $GC = '1' $($VAL[1]) $($HAL[1]) $W = '120' IsEnabled = 'False' $VX>" ,
                              "389</TextBox>" , "<$BU $Q = 'Ok' $CO = 'Ok' $GC = '0' $GR = '1' $MA = '5' >" , "</$BU>" ,
                              "<$BU $Q = 'Cancel' $CO = 'Cancel' $GC = '1' $GR = '1' $MA = '5' >" , "</$BU>" , "</$G>" ,
                              "</$G>" , "</$GB>" , "</Window>" )

                $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
        }

        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $HybridDSCPromo ) # Domain Controller Promotion Configuration           [
        {#___________________________________________________________________________/
             
             $Title     = "Desired State Controller Promotion"
             # ____   _________________________
             #//¯¯\\__[_______ Header ________]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 ; @( 13 ) * 7 ; 10 , 9 ) | % { $SP[$_] }

                $Y      = @( "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , 
                             "  Title = '$Author | Hybrid @ $Title'" , "  $W = '800'" , " $H = '800'" , "Topmost = 'True' " ,
                             "   Icon = '$( $GFX.Icon )'" , "$( $HAL[1] )" , "  WindowStartupLocation = 'CenterScreen' >" )

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Framing _______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2..4 ; 4 , 3 ) | % { $SP[$_] } 

                $Y      = @( "<$G>" , "<$GRD>" ; '20' , '*' | % { "<$RD $H = '$_' />" } ; "</$GRD>" )

                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[________ Menu _________]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $Menu   = 'Forest' , 'Tree' , 'Child' , 'Clone'

                $Action = "Domain" | % { "Forest" , "$_ Tree" , "$_ Child" , "$_`Controller" } | % { "Install-ADDS$_" }

                $X      = @( 3..5 ; 5 , 5 ; 5..3 ) | % { $SP[$_] }

                $Y      = @( "<$MN $GR = '0' $H = '20' >" , "<$MNI $HD = 'New' >" ;
                          0..3 | % { "<$MNI $Q = '$($Menu[$_])' $HD = '$($Action[$_])' IsCheckable = 'True' />" } ;
                          "</$MNI>" , "</$MN>" )

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[______ Open Body ______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = 3 , 12 , 13 , 10 , 10 , 13 , 13 | % { $SP[$_] }

                $Y      = "<$GB" , "   $GR = '1'" , " $HD = '[ Hybrid-DSC Domain Service Configuration ]'" ,
                          "$( $HAL[1] )" , "  $( $VAL[1] )" , "  $W = '760'" , " $H = '740' >"

                $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Framing _______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 4..7 ; 7 , 6 ; 6..8 ; 8 , 7 ) | % { $SP[$_] }

                $Y      = @( "<$G>" , "<$G $GR = '1' $MA = '10' >" , "<$GRD>" ; '' , '10' | % { "<$RD $H = '$_*' />" } ;
                          "</$GRD>" , "<$G $GR = '0' >" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" )

                $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_____ Domain Mode _____]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $LI     = @( ) ; $ED = @( "00" , "03" ; "08" , 12 | % { $_ , "$_ R2" } ; 16 , 19 )

                $R2     = $( If ( $CS -like "*R2*" ) { 1 } Else { 0 } )

                0..7    | % { $I  = $ED[$_] ; $J  = "False"
                        If ( $CS -like "*$I*" ) { If ( $R2 -eq 1 -and $_ -in    3 , 5 ) { $J = "True" }
                                                  If ( $R2 -eq 0 -and $_ -notin 3 , 5 ) { $J = "True" } }

                $LI    += "<$CBI $CO = 'Windows Server 20$I' IsSelected = '$J' />" }

                $LI[0]  = $LI[0].Replace( "2000" ,"2000 ( Default )" )

                0..1 | % {

                    $J  = ( "ForestMode" , "DomainMode" )[$_]

                    $X  = @( 7 , 8 ; @( 9 ) * 8 ; 8 , 7 ) | % { $SP[$_] }

                    $Y  = @( "<$GB $Q = '$J`Box' $HD = '$J' $GC = '$_' $MA = '5' $VC >" ,
                          "<$CB $Q = '$J' $H = '24' $SI = '0' >" ; @( $LI ) ; "</$CB>" , "</$GB>" )

                    $Z  = 0..11 | % { $X[$_] + $Y[$_] }

                    If ( $_ -eq 0 ) { $ForID = $Z } Else { $DomID = $Z } 
                }

                $ParID  = "ParentDomainName" | % {

                $X  = @( 6 , 7 , 6 ) | % { $SP[$_] } ;

                $Y  = "<$GB $Q = '$_`Box' $HD = '$($_.Replace('D',' D').Replace('N',' N'))' $GC = '0' $MA = '5' $VC >" ,
                      "<$TB $Q = '$_' Text = '&lt;Domain Name&gt;' $H = '20' $MA = '5' />" , "</$GB>"

                Return 0..2 | % { $X[$_] + $Y[$_] } }

                    $XML[5] = @( $ForID ; $DomID ; $ParID )

                    $X  = @( 6 , 6 , 7 , 8 , 8 , 7 , 7 , 8 , 8 , 7 ) | % { $SP[$_] }

                    $Y  = @( "</$G>" , "<$G $GR = '1' >" , "<$GCD>" ; '' , '2.5' | % { "<$CD $W = '$_*' />" } ;"</$GCD>" ,
                             "<$GRD>" ; '3.5' , '' | % { "<$RD $H = '$_*' />" } ; "</$GRD>" )

                    $XML[6] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[__ Services Selection _]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                    $FT = Get-DSCFeatureList ; $FTL = Get-DSCFeatureList -Underscore

                    $SVC = 0..16 | % { "<$TBL $GC = '0' $GR = '$_' $MA = '5' TextAlignment = 'Right' >$( $FT[$_] ):</$TBL>" ,
                      "<$CHK $GC = '1' $GR = '$_' $MA = '5' $Q = '$( $FTL[$_] )' IsEnabled = 'True' IsChecked = 'False' />" }

                    $X  = @( 6..9 ; 9 , 8 , 8 ; @( 9 ) * 17 ; @( 8 ) * 35 ; 7 , 6 ) | % { $SP[$_] }

                    $Y  = @( "<$GB $HD = 'Service Options' $GR = '0' $GC = '0' $MA = '5' >" , "<$G $GR = '0' $GC = '0' >" ,
                             "<$GCD>" ; '5' , '' | % { "<$CD $W = '$_*' />" } ; "</$GCD>" , "<$GRD>" ;
                             0..16 | % { "<$RD $H =  '*' />" } ; "</$GRD>" ; @( $SVC ) ; "</$G>" , "</$GB>" )

                    $XML[7] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_ Domain Name Options _]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                    $VA = '10 , 0 , 10 , 0' ; $BB = "BorderBrush = '{x:Null}'"

                    $VX = @( "Database" , "Sysvol" , "Log" | % { "$_`Path" } ; "Credential" ;
                          @( "Domain" | % { $_ , "New$_" } | % { $_ , "$_`NetBIOS" } ; "Site" ) | % { "$_`Name" } ;
                          "ReplicationSourceDC" )

                    $DomID  = ForEach ( $k in 0..9 )
                    {
                        $WX = $VX[$K]

                        If ( $K -eq 3 )
                        {
                            "<$GB $GR = '3' $HD = '$WX' Name = '$WX`Box' $VV $BB >" , "<$G>" , "<$GCD>" ;
                            "" , "3" | % { "<$CD $W = '$_*' />" } ; "</$GCD>" ,
                            "<$BU $CO = '$WX' $Q = '$WX`Button' $GC = '0' />" ,
                            "<$TB $H = '20' $MA = '$VA' Name = '$WX' $GC = '1' />" , "</$G>" , "</$GB>"
                        }

                        Else
                        {
                            "<$GB $GR = '$K' $HD = '$WX`' $Q = '$WX`Box' $VV $BB >" ,
                            "<$TB $H = '20' $MA = '$VA' $Q = '$WX' />" , "</$GB>"
                        }
                    }

                    $X  = @( 6 , 7 ; @( 8 ) * 10 ; 7 ; @( 7 , 8 , 7 ) * 3 ; 7..10 ; 10 , 9 , 9 , 9 , 8 , 7 ; @( 7 , 8 , 7 ) * 6 ; 6 ) | % { $SP[$_] }

                    $Y  = @( "<$G $GR = '0' $GC = '1' $MA = '$VA' >" , "<$GRD>" ; 0..9 | % { "<$RD $H = '*' />" } ;
                             "</$GRD>" ; @( $DomID ) ; "</$G>" )

                    $XML[8] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[__ Role Designations __]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                   $RCN = "Install DNS" , "Create DNS Delegation" , "No Global Catalog" , "Critical Replication Only"
                   $RID = $RCN | % { $_.Replace( " " , "" ) }

                    $Roles = 0..3 | % { "<$TBL $GR = '$_' TextAlignment = 'Right' $MA = '5' IsEnabled = 'True' >$( $RCN[$_] ):</$TBL>" ,
                                        "<$CHK $Q = '$( $RID[$_] )' $GR = '$_' $GC = '1' $MA = '5' IsEnabled = 'True' IsChecked = 'False' />" }

                    $X  = @( 6..9 ; 9 , 9 , 9 , 8 , 8 , 9 , 9 ; @( 8 ) * 9 ; 7 , 6 ) | % { $SP[$_] }

                    $Y  = @( "<$GB $GR = '1' $HD = 'Roles' $MA = '5' >" , "<$G>" , "<$GRD>" ; 0..3 | % { "<$RD $H = '*' />" } ; 
                             "</$GRD>" , "<$GCD>" ; '5' , '' | % { "<$CD $W = '$_*' />" } ; "</$GCD>" ; @( $Roles ) ; "</$G>" , "</$GB>" ) 

                    $XML[9] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_ DSRM/Initialization _]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                    $CF ,  $OK ,  $CA = "Confirm" , "Start" , "Cancel"
                    $PW , $PWB , $PWC = "Password" | % { "SafeModeAdministrator$_" , "$_`Box" , "$_`Char" }

                    $X  = @( 6..9 ; 9 , 8 , 8 , 9 , 9 , 8 , 8 , 9 , 8 , 8 , 9 , 8 , 8 ; 8..6 ) | % { $SP[$_] }

                    $Y  = @( "<$GB $GR = '1' $GC = '1' $HD = 'Initialization' $MA = '5' >" , "<$G>" , "<$GRD>" ;
                          0..1 | % { "<$RD $H = '*' />" } ; "</$GRD>" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ;
                          "</$GCD>" )

                    $C  = 0
                    $Y += $PW , $CF | % { "<$GB $GR = '0' $GC = '$C' $HD = '$_' >" , "<$PWB $Q = '$_' $H = '20' $MA = '5' $PWC = '*' />" , "</$GB>"
                        
                        [ Void ]$C ++ 
                    }

                    $C  = 0
                    $Y += $OK , $CA | % { "<$BU $Q = '$_' $GR = '1' $GC = '$C' $CO = '$_' $MA = '5' $W = '100' $H = '20' />"
                        [ Void ]$C ++ 
                    }

                    $Y += "</$G>" , "</$GB>"

                    $XML[10] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Framing _______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
                    $X  = @( 5..0 ) | % { $SP[$_] }

                    $Y  = "</$G>" , "</$G>" , "</$G>" , "</$GB>" , "</$G>" , "</Window>"

                    $XML[11] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
        }

        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $DCFound ) # Domain Controller Found                                    [
        {#___________________________________________________________________________/

             #  ____   _________________________
             # //¯¯\\__[________ Header _______]
             # ¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 ; @( 13 ) * 4 ; 10 , 13 , 13 , 9 ) | % { $SP[$_] }

                $Y      = "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , "  $W = '350'" ,
                          "  $H = '200'" , "$( $HAL[1] )" , "Topmost = 'True' " , "   Icon = '$( $GFX.Icon )'" ,
                          "  WindowStartupLocation = 'CenterScreen' >"

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #  ____   _________________________
             # //¯¯\\__[_______ Framing _______]
             # ¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 4 , 5 , 6 , 6 , 5 , 5 , 6 , 7 , 7 , 6 , 6 , 7 , 7 , 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "<$G>" , "<$GRD>" ; "3" , "" | % { "<$RD $H = '$_*' />" } ; "</$GRD>" , "<$G $GR = '0' >" ,
                          "<$GCD>" ; "" , "2" | % { "<$CD $W = '$_*' />" } ; "</$GCD>" , "<$GRD>" ;
                          0..2 | % { "<$RD $H = '*' />" } ; "</$GRD>" )

                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #  ____   _________________________
             # //¯¯\\__[      User Input       ]
             # ¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = 0..2 | % { 6 , 7 , 6 } | % { $SP[$_] }

                $Y      = ( 0 , "Controller" , "DC" ) , ( 1 , "DNS" , "Domain" ) , ( 2 , "NetBIOS" , "NetBIOS" ) | % {
                        "<$TBL $GC = '0' $GR = '$($_[0])' $MA = '10' $($VAL[1]) $($HAL[2]) >" , "$($_[1]) Name:</$TBL>" ,
                        "<$LA $Q = '$($_[2])' $GC = '1' $GR = '$($_[0])' $($VAL[1]) $H = '24' $MA = '10' />" }

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 5 , 5 , 6 , 7 , 7 , 6 ) | % { $SP[$_] }

                $Y      = @( "</$G>" , "<$G $GR = '1' >" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" )

                $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Controls ______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 6 ; 6..3 ) | % { $SP[$_] }

                $Y      = @( ( 0 , "Ok" ) , ( 1 , "Cancel" ) | % { "<$BU $Q = '$( $_[1] )' $CO = '$( $_[1] )' $GC = '$( $_[0] )' $GR = '1' $MA = '10' />" } ; 
                          "</$G>" , "</$G>" , "</Window>" )

                $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] } 
            }
        
        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $DSCRoot ) # Desired State Controller Root Install                      [
        {#___________________________________________________________________________/

             $Title = "DSC Root Installation"

             # ____   _________________________
             #//¯¯\\__[_______ Header ________]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 ; @( 13 ) * 7 ; 10 , 9 ) | % { $SP[$_] }

                $Y      = @( "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , "  Title = '$Author | Hybrid @ $Title'" , 
                             "  $W = '640'" , " $H = '450'" , "Topmost = 'True' " , 
                             "   Icon = '$( $GFX.Icon )'" , "$( $HAL[1] )" ,  "  WindowStartupLocation = 'CenterScreen' >" )

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 , 4 , 5 , 4 , 4 ; @( 5 ) * 5 ; 4 , 4 ; @( 5 ) * 4 ; 4 ) | % { $SP[$_] }

                $Y      = @( "<$G>" , "<$G.Background>" , "<ImageBrush Stretch = 'UniformToFill' ImageSource = '$( $GFX.Background )' />" ,
                          "</$G.Background>" , "<$GRD>" ; 250 , "*" , "*" , 40 , 20 | % { "<$RD $H = '$_' />" } ; "</$GRD>" , "<$GCD>" ;
                          "" , 2 , 2 , "" | % { "<$CD $W = '$_*' />" } ; "</$GCD>" )

                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             #_    ____________________________
             #\\__//¯¯[_______ Framing _______]
             # ¯¯¯¯   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 4 , 4 , 5 , 4 , 4 , 6 , 5 , 4 , 4 , 4 , 3 , 3 , 2 ) | % { $SP[$_] }

                $Y      = @( "<Image $GR = '0' $GC`Span = '4' $( $HAL[1] ) $W = '640' $H = '250' Source = '$( $GFX.Banner )' />" ,
                       "<$TBL $GR = '1' $GC = '1' $GC`Span = '2' $( $HAL[1] ) Padding = '5' Foreground = '#00FF00' FontWeight = 'Bold' $( $VAL[1] )>" , 
                       "Hybrid - Desired State Controller - Dependency Installation Path" , "</$TBL>" , 
                       "<$TB $GR = '2' $GC = '1' $GC`Span = '2' $H = '22' TextWrapping = 'Wrap' $MA = '10' $( $HCAL[1] ) $Q = 'Install' >" ,
                       "<$TB.Effect>" , "<DropShadowEffect/>" , "</$TB.Effect>" , "</$TB>" ; 
                    
                       ( 1 , "Start" ) , ( 2 , "Cancel" ) | % { "<$BU $GR = '3' $GC = '$( $_[0] )' $Q = '$( $_[1] )' $CO = '$( $_[1] )' $MA = '10' />" } ; 
                    
                       "</$G>" , "</Window>" )

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
            }


        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $ProvisionDSC ) # Provision Desired State Controller Server             [
        {#___________________________________________________________________________/

            $Title = "DSC Deployment Share"

             # ____   _________________________
             #//¯¯\\__[_______ Header ________]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                $X      = @( 2 ; @( 13 ) * 7 ; 12 , 10 , 9 ) | % { $SP[$_] }

                $Y      = @( "<Window" , "  xmlns = '$Schema/presentation'" , "xmlns:x = '$Schema'" , "  Title = '$Author | Hybrid @ $Title'" , 
                             "  $W = '640'" , " $H = '960'" , "Topmost = 'True' " , "   Icon = '$( $GFX.Icon )'" , " ResizeMode = 'NoResize'" , "$( $HAL[1] )" ,  
                             "  WindowStartupLocation = 'CenterScreen' >" )

                $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[__ Window Resources ___]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
                 $X = @(1..3;@(3)*4;3..6;8,8,8,7,11,11;6..2;2,3,3,3,2,2,3,3,3,3,3,2,1) | % { $SP[$_] }

                 $Y = @( "<Window.Resources>" , "<Style TargetType    = 'Label' x:Key = 'HeadLabel' >" ; 
    
                      ( "$TBL.TextAlignment" , "Center" ) , ( "FontWeight" , "Heavy" ) , ( "FontSize" , 18 ) , ( $MA , 5 ) , 
                      ( "Foreground" , "White" ) | % { "<$SE $PR = '$( $_[0] )' Value = '$( $_[1] )' />" } ;

                        "<$SE $PR = 'Template' >" , "<$SE.Value>" , "<ControlTemplate TargetType = 'Label' >" , "<$BO CornerRadius = '2,2,2,2' " ,
                        "$BG = '#FF0080FF' ", "$BO`Brush = 'Black'"  , "$BO`Thickness = '3'>" , "<ContentPresenter x:Name = 'contentPresenter'" , 
                        "  ContentTemplate = '{ TemplateBinding ContentTemplate }'" , "  $MA = '5' /> " , "</$BO>" , "</ControlTemplate>" , 
                        "</$SE.Value>" , "</$SE>" , "</Style>" , "<Style TargetType = 'RadioButton' x:Key = 'RadButton' >" ;

                      ( "HorizontalAlignment" , "Center" ) , ( "VerticalAlignment" , "Center" ) , ( "Foreground" , "Black" ) | % { 
                        
                        "<$SE $PR = '$( $_[0] )' Value = '$( $_[1] )' />" } ; "</Style>" , "<Style TargetType = '$TB' x:Key = 'TextBro'>" ; 

                      ( "VerticalContentAlignment" , "Center" ) , ( "Margin" , 2 ) , ( "TextWrapping" , "Wrap" ) , ( "Height" , 24 ) | % { 

                        "<$SE $PR = '$( $_[0] )' Value = '$( $_[1] )' />" } ; "</Style>" , "</Window.Resources>" )
        
                $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

                $X = @(1,2,3,3,3,2,2,3,6,2,2,3,2,5,5,5,5,3,5,5,4,5,4) | % { $SP[$_] }

                $Y = @( "<$G>" , "<$GRD>" ; 250, "*" , 40 | % { "<$RD $H = '$_' />" } ; "</$GRD>" , "<$G.$BG>" ; 
                        "<ImageBrush Stretch = 'UniformToFill'" , "ImageSource = '$( $GFX.Background )' />" , "</$G.$BG>" , 
                        "<Image $GR = '0'" , "   Source = '$( $GFX.Banner )'/>" , "<TabControl $GR = '1'" ; 
            
                        "{x:Null}" | % { "$BG = '$_'" , "$BO`Brush = '$_'" , "Foreground = '$_'" } ; "$( $HAL[1] )>" ;
                        "<TabItem $HD = 'Stage Deployment Server'" , "$BO`Brush = '{x:Null}'" , "$W = '280' >" , 
                        "<TabItem.Effect>" , "<DropShadowEffect/>" , "</TabItem.Effect>" )

                $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[_______ Staging _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

                $X = @( 4,5,6,6,5,5;@(8)*4;6,7;@(8)*6;7,7;@(10)*3;7,8,9,9,8,8,8,7;@(7,8,7)*3;7,8,9,9,8;@(8,9,8)*2;7,6,5 ) | % { $SP[$_] }

                $Y = @( "<$G>" , "<$GRD>" ; 6 , 5 | % { "<$RD $H = '$_*' />" } ; "</$GRD>" , "<$GB $GR = '0'" , "$MA = '10'" , 
                        "Padding = '5'" , "Foreground = 'Black'" , "$BG = 'White'>" , "<$G $GR = '0'>" , "<$GRD>" ;
            
                        "50,30,*,*,*,*".Split(',') | % { "<$RD $H = '$_'/>" } ; "</$GRD>" , 
                        "<$LA $CO = 'Deployment Share Settings'" , "Style = '{ StaticResource HeadLabel }'" , "Foreground = 'White'" , 
                        "$GR = '0'/>" , "<$G $GR = '1'>" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" ; 
            
                        ( 0 , "Legacy MDT" , "Legacy" ) , ( 1 , "PSD-Remaster" , "Remaster" ) | % { 
            
                        "<RadioButton $GC = '$( $_[0] )' $CO = '$( $_[1] )' $Q = '$( $_[2] )' Style = '{ StaticResource RadButton }' />" } ; "</$G>" ; 

                        ( 2 , "Drive Label" , "Drive" ) , ( 3 , "Directory Path" , "Directory" ) , ( 4 , "Samba Share" , "Samba" ) | % { 
                        
                            "<$GB $GR = '$( $_[0] )' $HD = '$( $_[1] )'>" , 
                            "<$( If ( $_[0] -eq 2 ) { "$CB $H = '24' $MA = '2'" } Else { "$TB Style = '{ StaticResource TextBro }'" }) $Q = '$( $_[2] )' />" , "</$GB>"
                        
                        } ; "<$G $GR = '5'>" , "<$GCD>" ; "" , 2 | % { "<$CD $W = '$_*' />" } ; "</$GCD>"

                        ( 0 , "PS Drive" , "DSDrive" ) , ( 1 , "Description" , "Description" ) | % { 
                        
                            "<$GB $GC = '$( $_[0] )' $HD = '$( $_[1] )'>" , "<$TB Style = '{ StaticResource TextBro }' $Q = '$( $_[2] )' />" , "</$GB>" } ; 
                            
                        "</$G>" , "</$G>" , "</$GB>" )

                $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[__ BITS / IIS Setup ___]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

                $X = @(5;@(7)*4;6..8;@(8)*4;7,7,7,8,9,9,8,8,8,7;@(7,8,7)*3;6..3) | % { $SP[$_] }
            
                $Y = @( "<$GB $GR = '1' " , "  $MA = '10'" , "  Padding = '5' " , "  Foreground = 'Black'" , "  $BG = 'White'>" , 
                        "<$G>" , "<$GRD>" ; "50,30,*,*,*".Split(',') | % { "<$RD $H = '$_' />" } ; "</$GRD>" , 
                        "<$LA $CO = 'BITS / IIS Settings' Style = '{ StaticResource HeadLabel }' Foreground = 'White' $GR = '0'/>" , 
                        "<$G $GR = '1'>" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" ;

                        ( 0 , "Install" , "Install / Configure IIS" ) , ( 1 , "Skip" , "Skip IIS Setup" ) | % { 

                            "<RadioButton $GC = '$( $_[0] )' $Q = 'IIS_$( $_[1] )' $CO = '$( $_[2] )' Style = '{ StaticResource RadButton }'/>"

                        } ; "</$G>" ;

                        ( 2 , "Name" , "Name" ) , ( 3 , "App Pool" , "AppPool" ) , ( 4 , "Virtual Host" , "Proxy" ) | % { 
                        
                            "<$GB $GR = '$( $_[0] )' Header = '$( $_[1] )'>" , "<$TB Style = '{ StaticResource TextBro }' $Q = 'IIS_$( $_[2] )' />" , "</$GB>"
                    
                        } ; "</$G>" , "</$GB>" , "</$G>" , "</TabItem>" )

                $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[____ Company Info _____]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

            $X = @(3..5;4;4..6;6,5,5;@(7)*4;6,7;@(8)*6;7,7;@(7,8,7)*2;7,8,9,9,8;@(8,9,8)*2;7,7;@(8,9,9,8)*2;@(8,9,8,8)*2;7..5 ) | % { $SP[$_] }

            $Y = @( "<TabItem $HD = 'Image Info' $( $HAL[1] ) $W = '280' BorderBrush = '{x:Null}' >" , "<TabItem.Effect>" , "<DropShadowEffect/>" , "</TabItem.Effect>" , 
            
            "<$G>" , "<$GRD>" ; 7 , 5 | % { "<$RD $H = '$_*'/>" } ; "</$GRD>" , "<$GB $GR = '0'" , "  $MA = '10'" , "  Padding = '5' " , "  Foreground = 'Black'" , "  $BG = 'White'>" , 
            
            "<$G>" , "<$GRD>" ; "50,*,*,*,*,*".Split(',') | % { "<$RD $H = '$_' />" } ; "</$GRD>" , 
            
            "<$LA $GR = '0' Style = '{ StaticResource HeadLabel }' $CO = 'Image Branding Settings' />" ;
            "<$GB $GR = '1' $HD = 'Company $Q'>"       , "<$TB Style = '{ StaticResource TextBro }' $Q = 'Company' />" , "</$GB>" , 
            "<$GB $GR = '2' $HD = 'Support Website' >" , "<$TB Style = '{ StaticResource TextBro }' $Q = 'WWW' />" , "</$GB>" ; 
             "<$G $GR = '3'>" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" ; 
            
            ( 0 , "Phone" ) , ( 1 , "Hours" ) | % {
            
                "<$GB $GC = '$( $_[0] )' $HD = 'Support $( $_[1] )'>" , "<$TB Style = '{ StaticResource TextBro }' $Q = '$( $_[1] )' />" , "</$GB>" 
                
            } ; "</$G>" , "<$G $GR = '4' $GR`Span = '2' >" , "<$GCD>" ;
            
            "*" , 100 | % { "<$CD $W = '$_'/>" } ; "</$GCD>" , "<$GRD>" ; 0..1 | % { "<$RD $H = '*' />" } ; "</$GRD>" ; 
            
            ( "Logo [ 120x120 ]" , 0 , "Logo" ) , ( "Background" , 1 , "Background" ) | % {
            
                "<$GB $HD = '$( $_[0] )' $GR = '$( $_[1] )' $GC = '0'>" , 
                "<$TB Style = '{ StaticResource TextBro }' $W = '400' $GC = '1' $Q = '$( $_[2] )' />" , 
                "</$GB>" , "<$BU $MA = '5,15,5,5' $H = '20' $GR = '$( $_[1] )' $GC = '1' $CO = '$( $_[2] )' $Q = '$( $_[2] )Browse' />" 
                
            } ; "</$G>" , "</$G>" , "</$GB>" )

            $XML[5] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[_ Network Credentials _]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
        
            $X = @(5;@(7)*4;6,7;@(8)*4;7,7;@(7,8,7)*2;7,8,9,9,8;@(8,9,8)*2;7..2) | % { $SP[$_] }
            
            $Y = @( "<$GB $GR = '1'" , "  $MA = '10'" , "  Padding = '5'" , "  Foreground = 'Black'" , "  $BG = 'White'>" , "<$G>" , "<$GRD>" ; 
            "50,*,*,*".Split(',') | % { "<$RD $H = '$_' />" } ; "</$GRD>" ,
                    
            "<$LA $GR = '0' Style = '{ StaticResource HeadLabel }' $CO = 'Domain / Network Credentials' />" ;
                    
                    ( 1 , "Branch Name" , "Branch" ) , ( 2 , "NetBIOS Domain" , "NetBIOS" ) | % { 

                        "<$GB $GR = '$( $_[0] )' $HD = '$( $_[1] )' >" , "<$TB Style = '{ StaticResource TextBro }' $Q = '$( $_[2] )' />" , "</$GB>" 
                        
                    } ; "<$G $GR = '3'>" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" ; 
                    
                    ( 0 , "Account" , "$TB Style = '{ StaticResource TextBro }'" , "User" ) , ( 1 , "Password" , "$PWB $MA = '5'" , "Pass' PasswordChar = '*" ) | % { 

                        "<$GB $GC = '$( $_[0] )' $HD = 'Administrator $( $_[1] )'>" , "<$( $_[2] ) $Q = 'LMCred_$( $_[3] )' />" , "</$GB>" 
                    
                    } ; "</$G>" , "</$G>" , "</$GB>" , "</$G>" , "</TabItem>" , "</TabControl>" )

            $XML[6] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

            $X = @( 2,3,4,4,3,3;3..0 )|% { $SP[$_] }
        
            $Y = @( "<$G $GR = '2' >" , "<$GCD>" ; 0..1 | % { "<$CD $W = '*' />" } ; "</$GCD>" ; 

            ( 0 , "Start" ) , ( 1 , "Cancel" ) | % { 
            
                "<$BU $GC = '$( $_[0] )' $Q = '$( $_[1] )' $CO = '$( $_[1] )' $W = '100' $H = '24' />" 
            
            } ; "</$G>" , "</$G>" , "</Window>" )

            $XML[7] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
        }

        #/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\
        If ( $Service ) # ViperBomb Service Configuration Utility                    [
        {#___________________________________________________________________________/

            $Title                      = "ViperBomb Service Configuration Utility"

             # ____   _________________________
             #//¯¯\\__[_______ Header ________] 
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

            $X = @( 2 ; @( 11 ) * 4 ; 10 , 11 , 11 , 12 ,10 , 10 , 8 , 7 ) | % { $SP[$_] }
                
            $Y = "<Window " , "   xmlns = '$Schema/presentation'" , " xmlns:x = '$Schema'" , "   Title = '$Author | Hybrid @ $Title'" , 
            "  $H = '600'" , "   Min$H = '600'" , "   $W = '800'" , "Min$W = '800'" , "Icon = '$( $GFX.Icon )'" , " BorderBrush = 'Black'" , "  ResizeMode = 'CanResize'" , 
            " $( $HAL[1] )" , "   WindowStartupLocation = 'CenterScreen'>"

            $XML[0] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[__ Window Resources ___] 
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
            
            $X = @( 3 , 4 , 5 , 5 , 7 , 5 , 7 , 5 , 6 , 7 , 8 ; @( 10 ) * 5 ; 7 , 6 , 5 , 4 , 4 , 5 , 7 , 4 , 3 , 3 , 4 , 3 ) | % { $SP[$_] }
            $Y = @( "<Window.Resources> " , "<Style x:Key         = 'SeparatorStyle1' " , "   TargetType    = '{x:Type Separator}'>" , 
                    "<$SE $PR = 'SnapsToDevicePixels' " , "Value    = 'True'/>" , "<$SE $PR = '$MA'" , "Value    = '0,0,0,0'/>" , "<$SE $PR = 'Template'>" , 
                    "<$SE.Value>" , "<ControlTemplate TargetType     = '{x:Type Separator}'>" , "<Border $H        = '24' " , "SnapsToDevicePixels = 'True' " , 
                    "$BG          = '#FF4D4D4D'" , "$BO`Brush         = 'Azure'" , "$BO`Thickness     = '1,1,1,1'" , "CornerRadius        = '5,5,5,5'/>" , 
                    "</ControlTemplate>" , "</$SE.Value>" , "</Setter>" , "</Style>" , "<Style  TargetType    = '{x:Type ToolTip}'>" , "<$SE $PR = '$BG'" , 
                    "Value    = '#000000'/>" , "</Style>" , "</Window.Resources>" , "<Window.Effect>" , "<DropShadowEffect/>" , "</Window.Effect>" )

            $XML[1] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
            
             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 3 , 4 , 5 , 5 , 5 , 4 ) | % { $SP[$_] }
             $Y = @( "<$G>" , "<$GRD>" ; 20 , "*" , 60 | % { "<$RD $H        = '$_'/>" } ; "</$GRD>" )

             $XML[2] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[____ Menu Controls ____]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 4,7,5,6,7,9,7,9,6,6,7,9,7,9,6,6,7,9,7,9,7,9,7,9,6,6,7,9,7,9,6,5,5,6,8,6,8,6,8,6,8,6,7,9,7,9,6,6,9,6,9,5,4 ) | % { $SP[$_] }

             $Y = @( "<$MN $GR                   = '0'" , "  IsMainMenu         = 'True'>" , "<$MNI     $HD         = 'Configuration'>" ) ;

             $Slot = [ PSCustomObject ]@{ Home = "Default" ; Pro = "Default" ; Desktop = "Safe" , "Tweaked" ; Laptop  = "Safe" }

             $Y += "Home" , "Pro" , "Desktop" , "Laptop" | % { 

                "<$MNI $HD         = '$_'>" ;

                    ForEach ( $J in $Slot.$_ )
                    {
                        ForEach ( $K in "Max" , "Min" )
                        {
                            "<$MNI $Q       = 'MenuConfig$_$J$K'" ,
                            "  $HD     = '$J $K`imum'/>"
                        }
                    }
                    "</$MNI>" ;
                }

            $Y += @( "</$MNI>" , "<$MNI     $HD         = 'Info'>" ; "Feedback" , "FAQ" , "About" , "Copyright" | % { "<$MNI $Q           = 'MenuInfo$_'" , "  $HD         = '$_'/>" } ; 
            
                     "<$MNI $HD         = 'MadBomb122'>" ; ( "Donate" , "Donate to MadBomb122" ) , ( "GitHub" , "Original GUI/Script Source -> GitHub" ) | % { 
                     
                     "<$MNI $Q       = 'MenuInfoMadBomb$( $_[0] )'" , "  $HD     = '$( $_[1] )'/>" } ; "</$MNI>" ; 

                     ( "BlackViper" , "BlackViper Service Configuration Website" ) , ( "SecureDigitsPlus" , "Secure Digits Plus: Fighting Entropy" ) | % {

                        "<$MNI     $Q       = 'MenuInfo$( $_[0] )'" , "  $HD     = '$( $_[1] )'/>" } ; "</$MNI>" , "</$MN>" )

            $XML[3] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 4,5,8,8,6,7,8,9,10,11,13,13,13,13,12,16,16,16,16,11,11,12,14,13,15,15,12,12,14,13,15,15,12,11,10,9,8,7,6 ) | % { $SP[$_] } 

             $Y = @( "<$G $GR                   = '1'>" , "<TabControl $BO`Brush      = 'Gainsboro' " , "$GR         = '1'" , "$Q             = 'TabControl'>" , 
                     "<TabControl.Resources>" , "<Style TargetType    = 'TabItem'>" , "<$SE $PR = 'Template'>" , "<$SE.Value>" , 
                     "<ControlTemplate TargetType                   = 'TabItem'>" , "<$BO $Q                              = '$BO'" , 
                     "$BO`Thickness                   = '1,1,1,0'" , "$BO`Brush                       = 'Gainsboro'" , "CornerRadius                      = '4,4,0,0'" ,
                     "$MA                            = '2,0'>" , "<ContentPresenter x:Name              = 'ContentSite'" , "  $( $VAL[1] )", "  $( $HAL[1] )" , 
                     "  ContentSource       = '$HD'" , "  $MA              = '10,2'/>" , "</$BO>" , "<ControlTemplate.Triggers>" , "<Trigger $PR      = 'IsSelected'" , 
                     " Value         = 'True'>" , "<$SE TargetName = 'Border'" , "$PR   = '$BG'" , "Value      = 'LightSkyBlue'/>" , "</Trigger>" , 
                     "<Trigger $PR      = 'IsSelected'" , " Value         = 'False'>" , "<$SE TargetName = '$BO'" , "$PR   = '$BG'" , "Value      = 'GhostWhite'/>" , 
                     "</Trigger>" , "</ControlTemplate.Triggers>" , "</ControlTemplate>" , "</$SE.Value>" , "</$SE>" , "</Style>" , "</TabControl.Resources>" )

             $XML[4] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[___ Service Dialog ____]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @(9,7,8,9,9,9,8,8,9;@(10)*4;@(9,9,11,11,10,12,12,9,9,11,11,10,12,12)*2;9,8,8,9;@(10)*4;@(9)*4;@(10)*4;9,9,11,11,11,10,11,10,11,10,11,9,8,8;@(10)*11;
                    9,10,11,12,14,13,14,15;@(17)*4;14,13,13,15,12,12,16,13,16,12,12,16,13,16,12,12,16,13,16,12,11,10,9,9;
                    
                    @(10;@(15)*4)*2;
                    @(7;@(15)*3;10..13;20,20,13,20;12..10);
                    @(10;@(15)*4)*7;
                    
                    9,8,8,7,6) | % { $SP[$_] }

             $Y = @( " <TabItem Header = 'Service Dialog'>" , 
             "<$G>" , 
             "<$GRD>" ; 
             60 , 35 , "*" | % { "<$RD $H = '$_'/>" } ; 
             "</$GRD>" , 
             "<$G $GR = '0' >" , 
             "<$GCD>" ; 
             1.25 , 1.75 , 0.75 , 0.75 | % { "<$CD $W = '$_*' />" } ; 
             "</$GCD>" , 
             "<$GB $GC         = '0'" , 
             "  $HD              = 'Selected Profile' " , 
             "  $MA              = '5'>" , 
             "<$TBL $Q           = 'CurrentProfile'" , 
             "   TextAlignment  = 'Center'" , 
             "   $MA         = '5'/>" , 
             "</$GB>" , 
             "<$GB $GC         = '1' " , 
             "  $HD              = 'Operating System' " , 
             "  $MA              = '5' >" , 
             "<$TBL $Q           = 'CurrentOS'" , 
             "   TextAlignment  = 'Center'" , 
             "   $MA         = '5'/>" , 
             "</$GB>" , 
             "<$GB $GC         = '2' " , 
             "  $HD              = 'Current Build' " , 
             "  $MA              = '5' >" , 
             "<$TBL $Q           = 'CurrentBuild'" , 
             "   TextAlignment  = 'Center'" , 
             "   $MA         = '5'/>" , 
             "</$GB>" , 
             "<$GB $GC         = '3' " , 
             "  $HD              = 'Chassis' " , 
             "  $MA              = '5' >" , 
             "<$TBL $Q           = 'CurrentChassis'" , 
             "   TextAlignment  = 'Center'" , "   $MA         = '5'/>" , 
             "</$GB>" , 
             "</$G>" , 
             "<$G $GR                  = '1'>" , 
             "<$GCD>" ; 
             50 , "*" , 150 , 200 | % { "<$CD $W = '$_'/>" } ; 
             "</$GCD>" , 
             "<$TBL $GC = '0' $MA = '5' $( $VAL[1] ) FontSize = '12' >Search:</$TBL>" ; 
             ( "$TB " , 1 , "Search' TextWrapping = 'Wrap' /" ) , ( "$CB" , 2 , "Select' $( $VAL[1] )" ) | % { "<$( $_[0] )  $GC = '$( $_[1] )' $MA = '5' $H = '22' $Q = 'ServiceDialog$( $_[2] )>" } ; 
                     "$Q' IsSelected = 'True" , "Display$Q" , "Path$Q" , "Description" | % { "<$CBI $CO = '$_'/>" } ; 
                     "</$CB>" , "<$TBL $GC       = '3' " , "   $MA            = '5' " , "   TextAlignment     = 'Center'" , "   $( $VAL[1] )>" ;
                     ( "66FF66" , "Scoped" ) , ( "FFFF66" , "Unspecified" ) , ( "FF6666" , "Non Scoped" ) | % {
                     "<Run   $BG        = '#$( $_[0] )'" , "   Text              = '$( $_[1] )'/>" } ; 
                     "</$TBL>" , "</$G>" , "<Data$G $GR                   = '2'" , "  $GC                = '0'" , "  $Q                       = 'ServiceDialogGrid'" , 
                     "  FrozenColumnCount          = '2' " , "  AutoGenerateColumns        = 'False' " , "  AlternationCount           = '2' " , 
                     "  HeadersVisibility          = 'Column' " , "  CanUserResizeRows          = 'False' " , "  CanUserAddRows             = 'False' " , 
                     "  IsTabStop                  = 'True'" , "  IsTextSearchEnabled        = 'True'" , "  SelectionMode              = 'Extended'>" , 
                     "<Data$GR`Style>" , "<Style TargetType            = '{x:Type DataGridRow}'>" , "<Style.Triggers>" , "<Trigger Property    = 'IsMouseOver'" , 
                     " Value       = 'True'>" , "<$SE $PR = 'ToolTip'>" , "<$SE.Value>" , "<$TBL Text         = '{Binding Description}'" , "   TextWrapping = 'Wrap'" , 
                     "   $W        = '400'" , "   $BG   = '#000000'" , "   Foreground   = '#FFFFFF'/>" , "</$SE.Value>" , "</$SE>" , 
                     "<$SE $PR                = 'ToolTipService.ShowDuration'" , "Value                   = '360000000'/>" , "</Trigger>" ; 
                     ( "@" , "66FF66" ) , ( "+" , "FFFF66" ) , ( "-" , "FF6666" ) | % { "<DataTrigger      Binding           = '{Binding Scoped}'" , 
                     "  Value             = '$( $_[0] )'>" ,  "<$SE       $PR          = '$BG'" , "  Value             = '#$( $_[1] )'/>" , "</DataTrigger>" } ;
                     "</Style.Triggers>" , "</Style>" , "</Data$GR`Style>" , "<Data$GC`s>" ; 

                        ( "Index" , 40 ) , ( "Scoped" , 20 ) , ( "Profile" , 75 ) , ( $Q , 150 ) , ( "Status" , 75 ) , ( "StartType" , 75 ) , ( "Delay" , 50 ) , ( "Display$Q" , 150 ) , 
                        ( "Path$Q" , 150 ) , ( "Description" , 150 ) | % { 
                     
                        $Z = $( If ( $_[0] -eq "Scoped" ) { "@" } If ( $_[0] -eq "Delay" ) { "DelayedAutoStart" } Else { $_[0] } )
                        
                        If ( $_[0] -ne "Profile" ) 
                        { 
                            "<Data$G`TextColumn $HD                  = '$Z'" , "$W                   = '$( $_[1] )'" , 
                                "Binding                 = '{Binding $( $_[0] )}'" , 
                                "CanUserSort             = 'True'" , 
                                "IsReadOnly              = 'True'/>"
                        }
                        
                        Else 
                        {   
                            "<DataGridTemplateColumn     Header                  = '$( $_[0] )' " ,
                                                        "Width                   = '$( $_[1] )' " ,
                                                        "SortMemberPath          = '$( $_[0] )' " ,
                                                        "CanUserSort             = 'True'>" ,
                                        "<DataGridTemplateColumn.CellTemplate>" ,
                                            "<DataTemplate>" ,
                                                 "<ComboBox ItemsSource = '{ Binding $( $_[0] )}' " ,
                                                            "Text       = '{ Binding Path                = $( $_[0] ), " ,
                                                                                    "Mode                = TwoWay, " ,
                                                                                    "UpdateSourceTrigger = PropertyChanged }' " ,
                                                           "IsEnabled   = '{ Binding ElementName         = $( $_[0] )Output, " ,
                                                                                 "   Path                = IsChecked }'/>" ,
                                                 "</DataTemplate>" ,
                                             "</DataGridTemplateColumn.CellTemplate>" ,
                                         "</DataGridTemplateColumn>" 
                        }
                    } ; "</Data$GC`s>" , "</Data$G>" , "<$TBL $GR = '2' $Q = 'ServiceDialogEmpty' $MA = '20' $( $VAL[1] ) $( $HAL[1] ) FontSize = '20'/>" , "</$G>" , "</TabItem>" )

            $XML[5] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[____ Preferences ______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

            $X = @(6..9;9,8,8,9;@(10)*3;9;9..11;11,10,10,11;@(12,13,13,13,12)*2;12,12,11,10;10..12;@(13)*3;@(@(12)*4;11..9;9..11;11,10;10..12;12..10;10..12;
            @(13)*4;12)*2;@(12)*4;11..8;8..10;10;@(9;9..12;12,12,11,11,12,12;@(11)*7;10)*2;9..6) | % { $SP[$_] }

            $Y = @( "<TabItem $HD = 'Preferences'>" , "<$G>" , "<$GRD>" ; 

            1.25 , "" | % { "<$RD $H = '$_*'/>" } ; "</$GRD>" , "<$G $GR = '0'>" , "<$GCD>" ; 
            0..2      | % { "<$CD $W = '*'/>"   } ; "</$GCD>" , "<$G $GC = '2'>" , "<$GRD>" ; 
            0..1      | % { "<$RD $H = '*'/>"   } ; "</$GRD>" , "<$GB $GR = '0' $HD = 'Bypass / Checks [ Risky Options ]' $MA = '5'>" , "<$G>" , "<$GRD>" ; 
            0..2      | % { "<$RD $H = '*'/>"   } ; "</$GRD>" , "<$CB   $GR = '0' $($VAL[1]) $H = '24' $Q = 'BypassEdition'>" ; 

            @( "Override Edition Check' IsSelected = 'True" ; "Home" , "Pro" | % { "Windows 10 $_" } ) | % { "<$CBI $CO = '$_'/>" } ; "</$CB>" ; 

            ( 1 , "Build" , "Skip Build/Version Check" ) , ( 2 , "Laptop" , "Enable Laptop Tweaks" ) | % { 

                "<$CHK   $GR = '$($_[0])' $MA = '5' $Q = 'Bypass$($_[1])' $CO = '$($_[2])'/>" } ; 
    
            "</$G>" , "</$GB>" , "<$GB $GR = '1' $HD = 'Display' $MA = '5' >" , "<$G>" , "<$GRD>" ; 

            0..2      | % { "<$RD $H = '30'/>" } ; "</$GRD>" ; 

            ( 0 , "Active" ) , ( 1 , "Inactive" ) , ( 2 , "Skipped" ) | % { 
            
                "<$CHK  $GR = '$($_[0])' $MA = '5' $Q = 'Display$($_[1])' $CO = 'Show $($_[1]) Services' />" } ; 

            "</$G>" , "</$GB>" , "</$G>" , "<$G $GC = '0'>" , "<$GRD>" ;

            1.5 , 2   | % { "<$RD $H = '*'/>" } ; "</$GRD>" ; 
            "<$GB $GR = '0' $HD = 'Service Configuration' $MA = '5'>" , 
            "<$CB  $GR = '1' $Q = 'ServiceProfile' $H ='24'>" ; 
            "Black Viper (Sparks v1.0)' IsSelected = 'True" , "DevOPS (MC/SDP v1.0)' IsEnabled = 'False" | % { "<$CBI $CO = '$_'/>" } ; 
            "</$CB>" , "</$GB>" , "<$GB $GR = '1' $HD = 'Miscellaneous' $MA = '5'>" , "<$G>" , "<$GRD>" ; 
            0..3      | % { "<$RD $H = '30'/>" } ; "</$GRD>" ;

            ( 0 , "Simulate" , "Simulate Changes [ Dry Run ]" ) , ( 1 , "Xbox" , "Skip All Xbox Services" ) , ( 2 , "Change" , "Allow Change of Service State" ) , 
            ( 3 , "StopDisabled" , "Stop Disabled Services" ) | % { "<$CHK  $GR = '$( $_[0] )' $MA = '5' $Q = 'Misc$( $_[1] )'     $CO = '$( $_[2] )'   />" } ; 

            "</$G>" , "</$GB>" , "</$G>" , "<$G $GC = '1'>" , "<$GRD>" ; 
            
            1.5 , 2   | % { "<$RD $H = '*'/>" } ; 
            
            "</$GRD>" , "<$GB $GR = '0' $HD = 'User Interface' $MA = '5'>" , 
            
            "<$CB  $GR = '1' $Q = 'ScriptProfile' $H = '24' >" ;
            "DevOPS (MC/SDP v1.0)' IsSelected =  'True" , "MadBomb (MadBomb122 v1.0)' IsEnabled  = 'False" | % { 
            "<$CBI $CO = '$_'/>" } ; "</$CB>" , "</$GB>" , "<$GB $GR = '1' $HD = 'Development' $MA = '5'>" , "<$G>" , "<$GRD>" ; 
            
            0..3 | % { "<$RD $H = '30'/>" } ; "</$GRD>" ; 
            
            ( 0 , "DiagErrors" , "Diagnostic Output [ On Error ]" ) , ( 1 , "Log" , "Enable Development Logging" ) , ( 2 , "Console" , "Enable Console" ) , 
            ( 3 , "DiagReport" , "Enable Diagnostic" ) | % { "<$CHK  $GR = '$( $_[0] )' $MA = '5' $Q = 'Devel$( $_[1] )'  $CO = '$( $_[2] )' />" } ; "</$G>" , "</$GB>" , 
            "</$G>" , "</$G>" , "<$G $GR = '1'>" , "<$GRD>" ; 0..1 | % { "<$RD $H = '*'/>" } ; "</$GRD>" , 
            "<$GB $GR = '0' $HD = 'Logging: Create logs for all changes made via this utility' $MA = '5'>" , "<$G>" , "<$GCD>" ; 
            
            75 , "*" , "6*" | % { "<$CD $W = '$_'/>" } ; "</$GCD>" , "<$GRD>" ; 0..1 | % { "<$RD $H = '*' />" } ; "</$GRD>" ; 
            
            ( 0 , "Service" ) , ( 1 , "Script" ) | % { 

                "<$LA    $GR = '$( $_[0] )' $GC = '0' $CO = '$( $_[1] ):' $( $VAL[1] ) $( $HAL[2] )/>" , 
                "<$BU   $GR = '$( $_[0] )' $GC = '1' $MA  = '5' $Q = 'Logging$( $_[1] )Browse' $CO = 'Browse'  />" , 
                "<$TB  $GR = '$( $_[0] )' $GC = '2' $MA  = '5' $Q = 'Logging$( $_[1] )File' IsEnabled = 'False' />" } ; 
                
            "</$G>" , "</$GB>" , "<$GB $GR = '1' $HD = 'Backup: Save your current Service Configuration' $MA = '5'>" , "<$G>" , "<$GCD>" ; 

            75 , "*" , "6*" | % { "<$CD $W = '$_'/>" } ; "</$GCD>" , "<$GRD>" ; 0..1 | % { "<$RD $H = '*' />" } ; "</$GRD>" ; 
            
            ( 0 , "Registry" ) , ( 1 , "Template" ) | % {

                "<$LA    $GR = '$( $_[0] )' $GC = '0' $CO = '$( $_[1] ):' $( $VAL[1] ) $( $HAL[2] )/>" , 
                "<$BU   $GR = '$( $_[0] )' $GC = '1' $MA  = '5' $Q = 'Backup$( $_[1] )Browse' $CO   = 'Browse'  />" , 
                "<$TB  $GR = '$( $_[0] )' $GC = '2' $MA  = '5' $Q = 'Backup$( $_[1] )File'   IsEnabled = 'False'   />" } ;

            "</$G>" , "</$GB>" , "</$G>" , "</$G>" , "</TabItem>" )

            $XML[6] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[__ Integrated Console _]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 6..8;8,9,8;8..6 ) | % { $SP[$_] } 

             $Y = @( "<TabItem $HD = 'Console'>" , "<$G $MA = '5'>" , "<$GB $HD = 'Embedded Console'>" , "<ScrollViewer VerticalScrollBarVisibility = 'Visible' $MA = '5'>" , 
             "<$TBL $Q = 'ConsoleOutput' TextTrimming = 'CharacterEllipsis' Foreground = 'White' $BG = 'DarkBlue' FontFamily = 'Lucida Console'/>" , "</ScrollViewer>" , 
             "</$GB>" , "</$G>" , "</TabItem>" ) 

            $XML[7] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[__ Diagnostics Panel __]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 6..8 ; 9..4 ) | % { $SP[$_] }

             $Y = @( "<TabItem Header = 'Diagnostics'>" , "<$G $BG = '#FFE5E5E5'>" , "<ScrollViewer VerticalScrollBarVisibility = 'Visible'>" , 
             "<TextBlock Name = 'DiagnosticOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>" , "</ScrollViewer>" , 
             "</$G>" , "</TabItem>" , "</TabControl>" , "</$G>" )

             $XML[8] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }

             # ____   _________________________
             #//¯¯\\__[_______ Framing _______]
             #¯    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

             $X = @( 4..6;6,6,6,5,5,6;@(5)*4;6..2) | % { $SP[$_] }

             $Y = @( "<$G $GR = '2'>" , "<$GCD>" ; "" , 0.5 , 0.5 , "" | % { "<$CD $W = '$_*'/>" } ; "</$GCD>" , "<$GB $HD = 'Service Config' $MA = '5' $GC = '0'>" ; 
             "<$TBL $Q ='ServiceLabel' TextAlignment = 'Center' $MA = '5'/>" , "</$GB>" ; ( 1 , "Start" ) , ( 2 , "Cancel" ) | % { 
             "<$BU    $GC = '$( $_[0] )' $Q =  '$( $_[1] )' $CO  = '$( $_[1] )'  $H = '20' $MA = '5'/>" } ; "<$GB $HD = 'Script/Module' Margin = '5' $GC = '3'>" , 
             "<$TBL $Q = 'ScriptLabel' TextAlignment = 'Center' $MA = '5' />" , "</$GB>" , "</$G>" , "</$G>" , "</Window>" )

             $XML[9] = 0..( $X.Count - 1 ) | % { $X[$_] + $Y[$_] }
        }
        
        If ( $Testing )
        {
            $XML
        }

        Else 
        {
            $Item   = ForEach ( $i in 0..( $XML.Count - 1 ) ) { 0..( $XML[$I].Count - 1 ) | % { $XML[$I][$_] } } 
            $Return = ""
            0..( $Item.Count - 1 ) | % { $Return += "$( $Item[$_] )`n" }

            If ( $Certificate    ) { Write-Theme -Action "Loaded [+]" "Certificate Panel" }
            If ( $Login          ) { Write-Theme -Action "Loaded [+]" "Login Panel" }
            If ( $NewAccount     ) { Write-Theme -Action "Loaded [+]" "New Account Panel" }
            If ( $HybridDSCPromo ) { Write-Theme -Action "Loaded [+]" "Hybrid-DSC Promo Panel" }
            If ( $DSCRoot        ) { Write-Theme -Action "Loaded [+]" "Desired State Controller Root Install" }
            If ( $DCFound        ) { Write-Theme -Action "Loaded [+]" "Domain Controller Found" }
            If ( $ProvisionDSC   ) { Write-Theme -Action "Loaded [+]" "Provision Desired State Controller Server" }
            If ( $Service        ) { Write-Theme -Action "Loaded [+]" "ViperBomb Service Configuration Tool" }
        
            $Return 
        
        }                                                          
                                                                                      #____ -- ____    ____ -- ____    ____ -- ____    ____ -- ____      
}
