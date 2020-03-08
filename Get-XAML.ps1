
    Begin
    {

        $SP                        = 0..25 | % { "    " * $_ }
                                     0..3 | % { IEX "`$M$_ = 0..120 | % { @( '¯' , '_' , ' ' , '-' )[$_] * `$_ }" }

        $Schema                    = "http://schemas.microsoft.com/winfx/2006/xaml"
        $Author                    = "Secure Digits Plus LLC"
        $Banner                    = "$Author | Hybrid @"
        $OS                        = GCIM Win32_OperatingSystem
        $CS                        = GCIM Win32_ComputerSystem
        $GFX                       = Resolve-HybridDSC -Graphics


        $Glossary                  = 
        
            # Window
            '  $WI = "Window"',
            '  $TI = "Title"',
            '  $VA = "Value"',
            ' $RES = "Resources"',
            '  $CP = "ContentPresenter"',

            # Grid
            '   $G = "Grid"',
            '  $GC = "Grid.Column"',
            ' $GCS = "Grid.ColumnSpan"',
            '  $GR = "Grid.Row"',
            ' $GRS = "Grid.Rowspan"',
            ' $GRD = "Grid.RowDefinitions"',
            '  $RD = "RowDefinition"',
            ' $GCD = "Grid.ColumnDefinitions"',
            '  $CD = "ColumnDefinition"',

            # Size/Position
            '   $W = "Width"',
            '   $H = "Height"',

            # Style
            '  $ST = "Style"',
            '  $XK = "x:Key"',
            '  $TT = "TargetType"',
            '  $CT = "ControlTemplate"',
            '  $BO = "Border"',
            '  $SE = "Setter"',
            '  $PR = "Property"',
            '  $BG = "Background"',
            '  $SI = "SelectIndex"',
            '  $EF = "Effect"',
            '  $TR = "Trigger"',
            '  $TN = "TargetName"',
            
            # Space
            '  $MA = "Margin"',
            '  $PA = "Padding"',
            '  $Hx = "HorizontalAlignment"',
            ' $HCx = "HorizontalContentAlignment"',
            '  $Vx = "VerticalAlignment"',
            ' $VCx = "VerticalContentAlignment"' ,

            # Text
            '  $CO = "Content"',
            '  $HD = "Header"',
            '   $N = "Name"',
            '  $TW = "TextWrapping"',

            # Control
            '  $BU = "Button"',
            ' $CHK = "CheckBox"',
            '  $CB = "ComboBox"',
            ' $CBI = "ComboBoxItem"',
            '  $GB = "GroupBox"',
            ' $GBI = "GroupBoxItem"',
            '  $LA = "Label"',
            '  $MN = "Menu"',
            ' $MNI = "MenuItem"',
            '  $RB = "RadioButton"',
            '  $TB = "TextBox"',
            ' $TBL = "TextBlock"' ,
            '  $TC = "TabControl"',

            # Password
            '  $PW = "Password"',
            ' $PWB = "PasswordBox"',
            ' $PWC = "PasswordChar"'

        $Glossary                  | % { IEX $_ }

        $Script                    = [ PSCustomObject ]@{

            Certificate            =                         "Certificate Info" , 350 , 200
            Login                  =                                 "AD Login" , 480 , 280
            NewAccount             =                      "Account Designation" , 480 , 280
            HybridDSCPromo         =       "Desired State Controller Promotion" , 800 , 800
            DCFound                =                  "Domain Controller Found" , 350 , 200
            DSCRoot                =                    "DSC Root Installation" , 640 , 450
            ProvisionDSC           =                     "DSC Deployment Share" , 640 , 960
            Service                =  "ViperBomb Service Configuration Utility" , 800 , 600
        }

        $Title                     = "$Banner {0}" -f $Script.Service[0]
        $Wx0                       = $Script.Service[1]
        $Hx0                       = $Script.Service[2]
        $XAML                      = [ PSCustomObject ]@{ XML = @{ } }
    }

    $Object                        = [ PSCustomObject ]@{
    
        Left                       = @(0;@(2)*15)|%{"    " * $_}
        Item                       = "<$WI xmlns,xmlns:x,Icon,$Ti,$W,Min$W,$H,Min$H,Topmost,BorderBrush,ResizeMode,$Hx,$HCx,$Vx,$VCx,$WI`StartupLocation".Split(',')
        Space                      = "32,30,33,32,32,29,31,28,30,26,27,18,11,20,13,16".Split(',') | % { "$( " " * $_ ) = " }
        Value                      = ("$Schema/presentation,$Schema,$($GFX.Icon),$Title,{0},{0},{1},{1},True,Black,CanResize,{2},{2},{2},{2},{2}Screen>" -f $Wx0,$Hx0,"Center").Split(',') | % { "'$_'" }
    }

    $XAML.Xml[0]                   = ForEach ( $I in 0..( $Object.Item.Count - 1 ) )
    {     
        $Object                    | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
    }

Process
{
    If ( $Services )
    {
        # Window Resources
        $Object                    = [ PSCustomObject ]@{

            Left                   = "0,4,5,5,7,5,7,5,6,7,8,10,10,10,10,10,7,6,5,4,4,5,7,4,3,3,4,3".Split(',') | % { "    " * $_ }
            Item                   = ("<$WI.$RES>,<$ST $XK,   $TT,<$SE $PR,$VA,<$SE $PR,$VA,<$SE $PR,<$SE.$VA>,<$CT $TT,<$BO $H,SnapsToDevicePixels,$BG,$BO`Brush,$BO`Thickness,"+
                                      "CornerRadius,</$CT>,</$SE.$VA>,</$SE>,</$ST>,<$ST $TT,<$SE $PR,$VA,</$ST>,</$WI.$RES>,<$WI.$EF>,<DropShadow$EF>,</$WI.$EF>").Split(',')
            Space                  = "0,9,4,1,4,1,4,1,0,5,14,1,10,9,5,8,0,0,0,0,4,1,4,0,0,0".Split(',') | % { If ( $_ -eq 0 ) { $Null } Else { "$( " " * $_ ) = " } }
            Value                  = @('',"'Separator$ST`1'","'{x:Type Separator}'>","'SnapsToDevicePixels'","'True'/>","'$MA'","'0,0,0,0'/>","'Template'>",'',"'{x:Type Separator}'>",
                                        "'24'","'True'","'#FF4D4D4D'", "'Azure'","'1,1,1,1'","'5,5,5,5'/>",'','','','',"'{x:Type ToolTip}'>","'$BG'","'#000000'/>",'','','','','')
        }

        $XAML.Xml[1]               = ForEach ( $I in 0..( $Object.Item.Count - 1 ) )
        {     
            $Object                | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
        }

        # Framing / Menu
        $Object                    = [ PSCustomObject ]@{

            Left                   = "0,0,1,1,1,0,0,1,1,2,3,5,3,5,2,2,3,5,3,5,2,2,3,5,3,5,3,5,3,5,2,2,3,5,3,5,2,1,1,2,4,2,4,2,4,2,4,2,3,5,3,5,2,2,4,2,4,1,0".Split(',')|%{ "    " * $_ }
            Item                   = ("<$G>,<$GRD>,<$RD $H,<$RD $H,<$RD $H,</$GRD>,<$MN $GR,  IsMainMenu,<$MNI $HD,<$MNI $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,</$MNI>,<$MNI $HD,"+
                                      "<$MNI $N,  $HD,<$MNI $N,  $HD,</$MNI>,<$MNI $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,</$MNI>,<$MNI $HD,<$MNI $N,  $HD,"+
                                      "<$MNI $N,  $HD,</$MNI>,</$MNI>,<$MNI $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,<$MNI $HD,<$MNI $N,  $HD,<$MNI $N,  $HD,"+
                                      "</$MNI>,<$MNI $N,  $HD,<$MNI $N,  $HD,</$MNI>,</$MN>").Split(',')
            Space                  = "0,0,8,8,8,0,19,17,13,9,7,5,7,5,0,9,7,5,7,5,0,9,7,5,7,5,7,5,7,5,0,9,7,5,7,5,0,0,13,11,9,11,9,11,9,11,9,9,7,5,7,5,0,11,9,11,9,0,0".Split(',') | % { 
                                        If ( $_ -eq 0 ) { $Null } Else { "$( " " * $_ ) = " } }
            Value                  = @("","","'20'/>","'*'/>","'60'/>","","'0'","'True'>","'Configuration'>","'Home'>","'MenuConfigHomeDefaultMax'","'Default Maximum'/>",
                                       "'MenuConfigHomeDefaultMin'","'Default Minimum'/>","","'Pro'>","'MenuConfigProDefaultMax'","'Default Maximum'/>","'MenuConfigProDefaultMin'",
                                       "'Default Minimum'/>","","'Desktop'>","'MenuConfigDesktopSafeMax'","'Safe Maximum'/>","'MenuConfigDesktopSafeMin'","'Safe Minimum'/>",
                                       "'MenuConfigDesktopTweakedMax'","'Tweaked Maximum'/>","'MenuConfigDesktopTweakedMin'","'Tweaked Minimum'/>","","'Laptop'>","'MenuConfigLaptopSafeMax'",
                                       "'Safe Maximum'/>","'MenuConfigLaptopSafeMin'","'Safe Minimum'/>","","","'Info'>","'MenuInfoFeedback'","'Feedback'/>","'MenuInfoFAQ'","'FAQ'/>",
                                       "'MenuInfoAbout'","'About'/>","'MenuInfoCopyright'","'Copyright'/>","'MadBomb122'>","'MenuInfoMadBombDonate'","'Donate to MadBomb122'/>",
                                       "'MenuInfoMadBombGitHub'","'Original GUI/Script Source -> GitHub'/>","","'MenuInfoBlackViper'","'BlackViper Service Configuration Website'/>",
                                       "'MenuInfoSecureDigitsPlus'","'Secure Digits Plus: Fighting Entropy'/>","","")
        }

        $XAML.Xml[2]               = ForEach ( $I in 0..( $Object.Item.Count - 1 ) )
        {     
            $Object                | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
        }

        # Tab Control
        $Object                    = [ PSCustomObject ]@{

            Left                   = "0,0,3,3,1,2,3,4,5,6,8,8,8,8,7,11,11,11,11,6,6,7,9,8,10,10,7,7,9,8,10,10,7,6,5,4,3,2,1".Split(',') | % { "    " * $_ }
            Item                   = ("<$G $GR,<$TC $BO`Brush,$GR,$N,<$TC.$RES>,<$ST $TT,<$SE $PR,<$SE.$VA>,<$CT $TT,<$BO $N,$BO`Thickness,$BO`Brush,CornerRadius,$MA,<$CP x:$N,  $Vx,"+
                                      "  $Hx,  ContentSource,  $MA,</$BO>,<$CT.$TR`s>,<$TR $PR, $VA,<$SE $TN,$PR,$VA,</$TR>,<$TR $PR, $VA,<$SE $TN,$PR,$VA,</$TR>,</$CT.$TR`s>,</$CT>,"+
                                      "</$SE.$VA>,</$SE>,</$ST>,</$TC.$RES>").Split(',')
            Space                  = "19,6,9,13,0,4,1,0,19,30,19,23,22,28,14,3,1,7,14,0,0,6,9,1,3,6,0,6,9,1,3,6,0,0,0,0,0,0,0".Split(',')|%{ If ( $_ -eq 0 ) { $Null } Else { "$( " " * $_ ) = " } }
            Value                  = @('"1">','"Gainsboro"','"1"','"TabControl">','','"TabItem">','"Template">','','"TabItem">','"Border"','"1,1,1,0"','"Gainsboro"','"4,4,0,0"','"2,0">',
                                      '"ContentSite"','"Center"','"Center"','"Header"','"10,2"/>','','','"IsSelected"','"True">','"Border"','"Background"','"LightSkyBlue"/>','','"IsSelected"',
                                      '"False">','"Border"','"Background"','"GhostWhite"/>','','','','','','','' )
        }
        
        $XAML.Xml[3]               = ForEach ( $I in 0..( $Object.Item.Count - 1 ) )
        {     
            $Object                | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
        }

        # Service Dialog
        $Object                    = [ PSCustomObject ]@{

            Left                   = ("0,0,1,2,2,2,1,1,2,3,3,3,2,2,4,4,3,5,5,2,2,4,4,3,5,5,2,2,4,4,3,5,5,2,1,1,2,3,3,3,3,2,2,5,5,5,6,5,2,5,5,5,5,2,5,5,5,5,3,7,3,3,3,2,2,4,4,4,3,4,3,4,3,4,2,1,1,"+
                                      "3,3,3,3,3,3,3,3,3,3,3,2,3,4,5,7,6,7,8,10,10,10,10,7,6,6,8,5,5,9,6,9,5,5,9,6,9,5,5,9,6,9,5,4,3,2,2,3,8,8,8,8,3,8,8,8,8,1,8,8,8,3,4,5,7,17,17,7,17,5,4,3,3,8,"+
                                      "8,8,8,1,8,8,8,2,3,4,7,17,17,7,17,3,2,1,1,8,8,8,2,3,4,7,17,17,7,17,3,2,1,1,8,8,8,8,3,8,8,8,8,3,8,8,8,8,2,1,1,4,4,4,4,4,1,0").Split(',') | % { "    " * $_ }
            Item                   = @( '<TabItem Header','<Grid>','<Grid.RowDefinitions>','<RowDefinition Height','<RowDefinition Height','<RowDefinition Height','</Grid.RowDefinitions>','<Grid Grid.Row',
                                        '<Grid.ColumnDefinitions>','<ColumnDefinition Width','<ColumnDefinition Width','<ColumnDefinition Width','</Grid.ColumnDefinitions>','<GroupBox Grid.Column',
                                        '  Header','  Margin','<TextBlock Name','   TextAlignment','   Margin','</GroupBox>','<GroupBox Grid.Column','  Header','  Margin','<TextBlock Name','   TextAlignment',
                                        '   Margin','</GroupBox>','<GroupBox Grid.Column','  Header','  Margin','<TextBlock Name','   TextAlignment','   Margin','</GroupBox>','</Grid>','<Grid Grid.Row',
                                        '<Grid.ColumnDefinitions>','<ColumnDefinition Width','<ColumnDefinition Width','<ColumnDefinition Width','<ColumnDefinition Width','</Grid.ColumnDefinitions>',
                                        '<TextBlock  Grid.Column','Margin','VerticalAlignment','FontSize','Search:','</TextBlock>','<TextBox    Grid.Column','Margin','Height','Name','TextWrapping',
                                        '<ComboBox   Grid.Column','Margin','Height','Name','VerticalAlignment','<ComboBoxItem   Content','IsSelected','<ComboBoxItem   Content','<ComboBoxItem   Content',
                                        '<ComboBoxItem   Content','</ComboBox>','<TextBlock Grid.Column','   Margin','   TextAlignment','   VerticalAlignment','<Run   Background','   Text','<Run   Background',
                                        '   Text','<Run   Background','   Text','</TextBlock>','</Grid>','<DataGrid Grid.Row','  Grid.Column','  Name','  FrozenColumnCount','  AutoGenerateColumns',
                                        '  AlternationCount','  HeadersVisibility','  CanUserResizeRows','  CanUserAddRows','  IsTabStop','  IsTextSearchEnabled','  SelectionMode','<DataGrid.RowStyle>',
                                        '<Style TargetType','<Style.Triggers>','<Trigger Property',' Value','<Setter Property','<Setter.Value>','<TextBlock Text','   TextWrapping','   Width','   Background',
                                        '   Foreground','</Setter.Value>','</Setter>','<Setter Property','Value','</Trigger>','<DataTrigger      Binding','  Value','<Setter       Property','  Value',
                                        '</DataTrigger>','<DataTrigger      Binding','  Value','<Setter       Property','  Value','</DataTrigger>','<DataTrigger      Binding','  Value','<Setter       Property',
                                        '  Value','</DataTrigger>','</Style.Triggers>','</Style>','</DataGrid.RowStyle>','<DataGrid.Columns>','<DataGridTextColumn Header','Width','Binding','CanUserSort',
                                        'IsReadOnly','<DataGridTextColumn Header','Width','Binding','CanUserSort','IsReadOnly','<DataGridTemplateColumn     Header','Width','SortMemberPath','CanUserSort',
                                        '<DataGridTemplateColumn.CellTemplate>','<DataTemplate>','<ComboBox ItemsSource','  Text',' Mode',' UpdateSourceTrigger','  IsEnabled',' Path','</DataTemplate>',
                                        '</DataGridTemplateColumn.CellTemplate>','</DataGridTemplateColumn>','<DataGridTextColumn Header','Width','Binding','CanUserSort','IsReadOnly',
                                        '<DataGridTemplateColumn     Header','Width','SortMemberPath','CanUserSort','<DataGridTemplateColumn.CellTemplate>','<DataTemplate>','<ComboBox     ItemsSource',
                                        '  Text',' Mode',' UpdateSourceTrigger','  IsEnabled',' Path','</DataTemplate>','</DataGridTemplateColumn.CellTemplate>','</DataGridTemplateColumn>',
                                        '<DataGridTemplateColumn     Header','Width','SortMemberPath','CanUserSort','<DataGridTemplateColumn.CellTemplate>','<DataTemplate>','<ComboBox     ItemsSource',
                                        '  Text',' Mode',' UpdateSourceTrigger','  IsEnabled',' Path','</DataTemplate>','</DataGridTemplateColumn.CellTemplate>','</DataGridTemplateColumn>',
                                        '<DataGridTextColumn         Header','Width','Binding','CanUserSort','IsReadOnly','<DataGridTextColumn Header','Width','Binding','CanUserSort','IsReadOnly',
                                        '<DataGridTextColumn Header','Width','Binding','CanUserSort','IsReadOnly','</DataGrid.Columns>','</DataGrid>','<TextBlock  Grid.Row','Name','Margin',
                                        'VerticalAlignment','HorizontalAlignment','FontSize','</Grid>','</TabItem>').Replace("'",'"')
            Space                  = ("1,0,0,15,15,15,0,26,0,9,9,9,0,15,20,20,16,8,15,0,15,20,20,17,8,15,0,15,20,20,17,8,15,0,0,26,0,9,9,9,9,0,13,17,7,16,0,0,13,18,18,20,12,13,18,18,20,7,9,6,9,9,9,0,14,"+
                                      "19,12,8,15,21,15,21,15,21,0,0,22,19,26,13,11,14,13,13,16,21,11,17,0,15,0,7,10,4,0,9,1,8,3,3,0,0,16,19,0,11,13,10,13,0,11,13,10,13,0,11,13,10,13,0,0,0,0,0,18,19,17,"+
                                      "13,14,18,19,17,13,14,18,19,10,13,0,0,15,22,16,1,17,16,0,0,0,18,19,17,13,14,18,19,10,13,0,0,15,22,16,1,17,16,0,0,0,18,19,10,13,0,0,15,22,16,1,17,16,0,0,0,18,19,17,13,"+
                                      "14,18,19,17,13,14,18,19,17,13,14,0,0,16,20,18,7,5,16,0,0").Split(',')|%{ If ( $_ -eq 0 ) { $Null } Else { "$( " " * $_ ) = " } }
            Value                  = @('"Service Dialog">','','','"60"/>','"35"/>','"*"/>','','"0" >','','"2.5*"/>','"1.25*" />','"1.25*"/>','','"0"','"Operating System"','"5" >',' "CurrentOS"','"Center"',
                                    '"5"/>','','"1"','"Current Build"','"5" >','"CurrentBuild"','"Center"','"5"/>','','"2"','"Chassis"','"5" >','"CurrentChassis"','"Center"','"5"/>','','','"1">','',
                                    '"50"/>','"*"/>','"150"/>','"200"/>','','"0"','"5"','"Center"','"12" >','','','"1"','"5"','"22"','"ServiceDialogSearch"','"Wrap" />','"2"','"5"','"22"',
                                    '"ServiceDialogSelect"','"Center">','"Name"','"True"/>','"DisplayName"/>','"PathName"/>','"Description"/>','','"3"','"5"','"Center"','"Center">','"#66FF66"','"Scoped"/>',
                                    '"#FFFF66"','"Unspecified"/>','"#FF6666"','"Non Scoped"/>','','','"2"','"0"','"ServiceDialogGrid"','"2"','"False"','"2"','"Column"','"False"','"False"','"True"','"True"',
                                    '"Extended">','','"{x:Type DataGridRow}">','','"IsMouseOver"','"True">','"ToolTip">','','"{Binding Description}"','"Wrap"','"400"','"#000000"','"#FFFFFF"/>','','',
                                    '"ToolTipService.ShowDuration"','"360000000"/>','','"{Binding Scoped}"','"@">','"Background"','"#66FF66"/>','','"{Binding Scoped}"','"+">','"Background"','"#FFFF66"/>','',
                                    '"{Binding Scoped}"','"-">','"Background"','"#FF6666"/>','','','','','','"#"','"25"','"{Binding Index}"','"True"','"True"/>','"@"','"20"','"{Binding Scoped}"','"True"',
                                    '"True"/>','"Profile"','"75"','"Profile"','"True">','','','"{ Binding Profile }"','"{ Binding Path                = Profile,','TwoWay,','PropertyChanged }"',
                                    '"{ Binding ElementName         = Profile,','SelectedIndex }"/>','','','','"Name"','"150"','"{Binding Name}"','"True"','"True"/>','"StartMode"','"75"','"StartMode"',
                                    '"True">','','','"{ Binding StartMode }"','"{ Binding Path                = StartMode,','TwoWay,','= PropertyChanged }"','"{ Binding ElementName    = StartMode,',
                                    'SelectedIndex }"/>','','','','"State"','"75"','"State"','"True">','','','"{ Binding State }"','"{ Binding Path                = State,','TwoWay,','PropertyChanged }"',
                                    '"{ Binding ElementName         = State,','SelectedIndex }"/>','','','','"DisplayName"','"150"','"{Binding DisplayName}"','"True"','"True"/>','"PathName"','"150"',
                                    '"{Binding PathName}"','"True"','"True"/>','"Description"','"150"','"{Binding Description}"','"True"','"True"/>','','','"2"','"ServiceDialogEmpty"','"20"','"Center"',
                                    '"Center"','"20"/>','','')
        }

        $XAML.Xml[4]               = ForEach ( $I in 0..( $Object.Item.Count - 1 ) )
        {     
            $Object                | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
        }
    }
}




$Example                                     = @"
<TabItem Header = 'Service Dialog'>
<Grid>
    <Grid.RowDefinitions>
        <RowDefinition Height               = '60'/>
        <RowDefinition Height               = '35'/>
        <RowDefinition Height               = '*'/>
    </Grid.RowDefinitions>
    <Grid Grid.Row                          = '0' >
        <Grid.ColumnDefinitions> 
            <ColumnDefinition Width         = '2.5*' />
            <ColumnDefinition Width         = '1.25*' />
            <ColumnDefinition Width         = '1.25*' />
        </Grid.ColumnDefinitions>
        <GroupBox Grid.Column               = '0' 
                  Header                    = 'Operating System' 
                  Margin                    = '5' >
            <TextBlock Name                 = 'CurrentOS'
                       TextAlignment        = 'Center'
                       Margin               = '5'/>
        </GroupBox>
        <GroupBox Grid.Column               = '1' 
                  Header                    = 'Current Build' 
                  Margin                    = '5' >
            <TextBlock Name                 = 'CurrentBuild'
                       TextAlignment        = 'Center'
                       Margin               = '5'/>
        </GroupBox>
        <GroupBox Grid.Column               = '2' 
                  Header                    = 'Chassis' 
                  Margin                    = '5' >
            <TextBlock Name                 = 'CurrentChassis'
                       TextAlignment        = 'Center'
                       Margin               = '5'/>
        </GroupBox>
    </Grid>
    <Grid Grid.Row                          = '1'>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width         = '50'/>
            <ColumnDefinition Width         = '*'/>
            <ColumnDefinition Width         = '150'/>
            <ColumnDefinition Width         = '200'/>
        </Grid.ColumnDefinitions>
        <TextBlock  Grid.Column             = '0' 
                    Margin                  = '5' 
                    VerticalAlignment       = 'Center' 
                    FontSize                = '12' >
                        Search:
                    </TextBlock>
        <TextBox    Grid.Column             = '1' 
                    Margin                  = '5' 
                    Height                  = '22' 
                    Name                    = 'ServiceDialogSearch' 
                    TextWrapping            = 'Wrap' />
        <ComboBox   Grid.Column             = '2' 
                    Margin                  = '5' 
                    Height                  = '22' 
                    Name                    = 'ServiceDialogSelect' 
                    VerticalAlignment       = 'Center'>
            <ComboBoxItem   Content         = 'Name' 
                            IsSelected      = 'True'/>
            <ComboBoxItem   Content         = 'DisplayName'/>
            <ComboBoxItem   Content         = 'PathName'/>
            <ComboBoxItem   Content         = 'Description'/>
        </ComboBox>
        <TextBlock Grid.Column              = '3' 
                   Margin                   = '5' 
                   TextAlignment            = 'Center'
                   VerticalAlignment        = 'Center'>
            <Run   Background               = '#66FF66'
                   Text                     = 'Scoped'/>
            <Run   Background               = '#FFFF66'
                   Text                     = 'Unspecified'/>
            <Run   Background               = '#FF6666'
                   Text                     = 'Non Scoped'/>
        </TextBlock>
    </Grid>
    <DataGrid Grid.Row                      = '2'
              Grid.Column                   = '0'
              Name                          = 'ServiceDialogGrid'
              FrozenColumnCount             = '2' 
              AutoGenerateColumns           = 'False' 
              AlternationCount              = '2' 
              HeadersVisibility             = 'Column' 
              CanUserResizeRows             = 'False' 
              CanUserAddRows                = 'False' 
              IsTabStop                     = 'True'
              IsTextSearchEnabled           = 'True'
              SelectionMode                 = 'Extended'>
        <DataGrid.RowStyle>
            <Style TargetType               = '{x:Type DataGridRow}'>
                <Style.Triggers>
                    <Trigger Property       = 'IsMouseOver'
                             Value          = 'True'>
                        <Setter Property    = 'ToolTip'>
                            <Setter.Value>
                                <TextBlock Text         = '{Binding Description}'
                                           TextWrapping = 'Wrap'
                                           Width        = '400'
                                           Background   = '#000000'
                                           Foreground   = '#FFFFFF'/>
                            </Setter.Value>
                        </Setter>
                        <Setter Property                = 'ToolTipService.ShowDuration'
                                Value                   = '360000000'/>
                    </Trigger>
                    <DataTrigger      Binding           = '{Binding Scoped}'
                                      Value             = '@'>
                        <Setter       Property          = 'Background'
                                      Value             = '#66FF66'/>
                    </DataTrigger>
                    <DataTrigger      Binding           = '{Binding Scoped}'
                                      Value             = '+'>
                        <Setter       Property          = 'Background'
                                      Value             = '#FFFF66'/>
                    </DataTrigger>
                    <DataTrigger      Binding           = '{Binding Scoped}'
                                      Value             = '-'>
                        <Setter       Property          = 'Background'
                                      Value             = '#FF6666'/>
                    </DataTrigger>
                </Style.Triggers>
            </Style>
        </DataGrid.RowStyle>
        <DataGrid.Columns>
            <DataGridTextColumn Header                  = '#'
                                Width                   = '25'
                                Binding                 = '{Binding Index}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
            <DataGridTextColumn Header                  = '@'
                                Width                   = '20'
                                Binding                 = '{Binding Scoped}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
    <DataGridTemplateColumn     Header                  = 'Profile' 
                                Width                   = '75' 
                                SortMemberPath          = 'Profile' 
                                CanUserSort             = 'True'>
            <DataGridTemplateColumn.CellTemplate>
                <DataTemplate>
                    <ComboBox ItemsSource               = '{ Binding Profile }' 
                              Text                      = '{ Binding Path                = Profile, 
                                                                     Mode                = TwoWay, 
                                                                     UpdateSourceTrigger = PropertyChanged }' 
                              IsEnabled                 = '{ Binding ElementName         = Profile, 
                                                                     Path                = SelectedIndex }'/>
                    </DataTemplate>
                </DataGridTemplateColumn.CellTemplate>
            </DataGridTemplateColumn>
            <DataGridTextColumn Header                  = 'Name'
                                Width                   = '150'
                                Binding                 = '{Binding Name}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
    <DataGridTemplateColumn     Header                  = 'StartMode' 
                                Width                   = '75' 
                                SortMemberPath          = 'StartMode' 
                                CanUserSort             = 'True'>
        <DataGridTemplateColumn.CellTemplate>
            <DataTemplate>
                <ComboBox     ItemsSource               = '{ Binding StartMode }' 
                              Text                      = '{ Binding Path                = StartMode, 
                                                                     Mode                = TwoWay, 
                                                                     UpdateSourceTrigger = PropertyChanged }' 
                              IsEnabled                 = '{ Binding ElementName         = StartMode, 
                                                                     Path                = SelectedIndex }'/>
            </DataTemplate>
        </DataGridTemplateColumn.CellTemplate>
    </DataGridTemplateColumn>
    <DataGridTemplateColumn     Header                  = 'State' 
                                Width                   = '75' 
                                SortMemberPath          = 'State' 
                                CanUserSort             = 'True'>
        <DataGridTemplateColumn.CellTemplate>
            <DataTemplate>
                <ComboBox     ItemsSource               = '{ Binding State }' 
                              Text                      = '{ Binding Path                = State, 
                                                                     Mode                = TwoWay, 
                                                                     UpdateSourceTrigger = PropertyChanged }' 
                              IsEnabled                 = '{ Binding ElementName         = State, 
                                                                     Path                = SelectedIndex }'/>
            </DataTemplate>
        </DataGridTemplateColumn.CellTemplate>
    </DataGridTemplateColumn>
    <DataGridTextColumn         Header                  = 'DisplayName'
                                Width                   = '150'
                                Binding                 = '{Binding DisplayName}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
            <DataGridTextColumn Header                  = 'PathName'
                                Width                   = '150'
                                Binding                 = '{Binding PathName}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
            <DataGridTextColumn Header                  = 'Description'
                                Width                   = '150'
                                Binding                 = '{Binding Description}'
                                CanUserSort             = 'True'
                                IsReadOnly              = 'True'/>
        </DataGrid.Columns>
    </DataGrid>
    <TextBlock  Grid.Row                = '2' 
                Name                    = 'ServiceDialogEmpty' 
                Margin                  = '20' 
                VerticalAlignment       = 'Center' 
                HorizontalAlignment     = 'Center' 
                FontSize                = '20'/>
    </Grid>
</TabItem>
"@

Get-LineDepth -Object $Example | % { $_.Y }
