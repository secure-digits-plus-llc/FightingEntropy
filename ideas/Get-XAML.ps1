$SP                        = 0..25 | % { "    " * $_ }
                             0..3  | % { IEX "`$M$_ = 0..120 | % { @( '¯' , '_' , ' ' , '-' )[$_] * `$_ }" }

$Schema                    = "http://schemas.microsoft.com/winfx/2006/xaml"
$Author                    = "Secure Digits Plus LLC"
$OS                        = GCIM Win32_OperatingSystem
$CS                        = GCIM Win32_ComputerSystem
$GFX                       = Resolve-HybridDSC -Graphics

$Script                    = [ PSCustomObject ]@{

    Certificate            =                        "Certificate Info" , 350 , 200
    Login                  =                                "AD Login" , 480 , 280
    NewAccount             =                     "Account Designation" , 480 , 280
    HybridDSCPromo         =      "Desired State Controller Promotion" , 800 , 800
    DCFound                =                 "Domain Controller Found" , 350 , 200
    DSCRoot                =                   "DSC Root Installation" , 640 , 450
    ProvisionDSC           =                    "DSC Deployment Share" , 640 , 960
    Service                = "ViperBomb Service Configuration Utility" , 800 , 600
}

$XAML                          = [ PSCustomObject ]@{

    XML                        = @{ }

    Glossary                   = 
                    
    # Window
    '  $WI = "Window"',
    '  $TI = "Title"',

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

    # Size
    '   $W = "Width"',
    '   $H = "Height"',

    # Style
    '  $BO = "Border"',
    '  $SE = "Setter"',
    '  $PR = "Property"',
    '  $BG = "Background"',
    '  $SI = "SelectIndex"',
    
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
    '   $Q = "Name"',
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

    # Password
    '  $PW = "Password"',
    ' $PWB = "PasswordBox"',
    ' $PWC = "PasswordChar"'
}

$Xaml.Glossary | % { IEX $_ }

$Title     = $Script.Service[0]
$Width     = $Script.Service[1]
$Height    = $Script.Service[2]
$Object    = [ PSCustomObject ]@{
    
    Left   = @( 0 ; @( 2 ) * 15 ) | % { $SP[$_] }
    Item   = @( "<Window xmlns","xmlns:x","Icon","Title","Width","MinWidth","Height","MinHeight","Topmost","BorderBrush","ResizeMode","HorizontalAlignment",
                 "HorizontalContentAlignment","VerticalAlignment","VerticalContentAlignment","WindowStartupLocation" )
    Space  = @( 32,30,33,32,32,29,31,28,30,26,27,18,11,20,13,16 | % { "$( " " * $_ ) = " } )
    Value  = @( "$Schema/presentation","$Schema","$( $GFX.Icon )","$Author | Hybrid @ $Title","$Height","$Height","$Width","$Width","True","Black","CanResize";
                @("Center")*4;"CenterScreen>") | % { "'$_'" }
}

$XAML.Xml[0]  = ForEach ( $I in 0..15 )
{     
    $Object | % { $_.Left[$I] , $_.Item[$I] , $_.Space[$I] , $_.Value[$I] -join '' }
}

$Example                                     = @"
<Window xmlns                                = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
        xmlns:x                              = 'http://schemas.microsoft.com/winfx/2006/xaml'
        Icon                                 = 'C:\Users\Administrator\Documents\WindowsPowerShell\Modules\Hybrid-DSC\Graphics\icon.ico'
        Title                                = 'Secure Digits Plus LLC | Hybrid @ ViperBomb Service Configuration Utility'
        Height                               = '600'
        MinHeight                            = '600'
        Width                                = '800'
        MinWidth                             = '800'
        Topmost                              = 'True'
        BorderBrush                          = 'Black'
        ResizeMode                           = 'CanResize'
        HorizontalAlignment                  = 'Center'
        HorizontalContentAlignment           = 'Center'
        VerticalAlignment                    = 'Center'
        VerticalContentAlignment             = 'Center'
        WindowStartupLocation                = 'CenterScreen'>
"@
