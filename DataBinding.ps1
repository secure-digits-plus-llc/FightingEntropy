# Shows inherent strengths in using Data Binding.


    Function Create-WPFWindow 
    {
        Param ( $Hash )
 
        $Window                            = New-Object System.Windows.Window

        $Window                            | % { 
    
            $_.SizeToContent               = [ System.Windows.SizeToContent ]::WidthAndHeight
            $_.Title                       = "Multiplication Tables"
            $_.WindowStartupLocation       = [ System.Windows.WindowStartupLocation ]::CenterScreen
            $_.ResizeMode                  = [ System.Windows.ResizeMode ]::NoResize
        }
 
        $TextBoxProperties                 = @{
    
            Height                         = 85
            Width                          = 60
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Center
            FontSize                       = 30
            BorderThickness                = 0
            IsReadOnly                     = $True
        }

        $TextBox1                          = New-Object System.Windows.Controls.TextBox
    
        $TextBoxProperties.GetEnumerator() | % { 

            $TextBox1.$( $_.Name )         = $_.Value
        }

        $Hash.TextBox1                     = $TextBox1
 
        $TextBoxProperties                 = @{
    
            Height                         = 85
            Width                          = 40
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Center
            FontSize                       = 30
            BorderThickness                = 0
            Text                           = "x"
            IsReadOnly                     = $True
        }

        $TextBox2                          = New-Object System.Windows.Controls.TextBox

        $TextBoxProperties.GetEnumerator() | % {

            $TextBox2.$( $_.Name )         = $_.Value
        }

        $Hash.TextBox2                     = $TextBox2
 
        $TextBoxProperties                 = @{
    
            Height                         = 85 
            Width                          = 60
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Center
            FontSize                       = 30
            BorderThickness                = 0
            IsReadOnly                     = $True 
        }

        $TextBox3                          = New-Object System.Windows.Controls.TextBox
        $TextBoxProperties.GetEnumerator() | % {

            $TextBox3.$( $_.Name )         = $_.Value
        }

        $Hash.TextBox3                     = $TextBox3
 
        $TextBoxProperties                 = @{

            Height                         = 85
            Width                          = 40
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Center
            FontSize                       = 30
            BorderThickness                = 0
            Text                           = "="
            IsReadOnly                     = $True 
        }

        $TextBox4                          = New-Object System.Windows.Controls.TextBox
        $TextBoxProperties.GetEnumerator() | % {

            $TextBox4.$( $_.Name )         = $_.Value
        }

        $Hash.TextBox4                     = $TextBox4
 
        $TextBoxProperties                 = @{

            Height                         = 85
            Width                          = 80
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Center
            FontSize                       = 30
            BorderThickness                = 0
            IsReadOnly                     = $True
        }

        $TextBox5                          = New-Object System.Windows.Controls.TextBox
        $TextBoxProperties.GetEnumerator() | % {

            $TextBox5.$( $_.Name )         = $_.Value
        }

        $Hash.TextBox5                     = $TextBox5
 
        $ButtonProperties                  = @{

            Height                         = 30
            Width                          = 30
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Top
            FontSize                       = 20
            Content                        = "+"
            Margin                         = "5,0,0,0"
        }

        $Button1                           = New-Object System.Windows.Controls.Button
        $ButtonProperties.GetEnumerator()  | % {

            $Button1.$( $_.Name )          = $_.Value
        }

        $Hash.Button1                      = $Button1
 
        $ButtonProperties                  = @{

            Height                         = 30
            Width                          = 30
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Top
            FontSize                       = 20
            Content                        = "-"
            Margin                         = "5,0,0,0"
        }

        $Button2                           = New-Object System.Windows.Controls.Button
        $ButtonProperties.GetEnumerator()  | % {

            $Button2.$( $_.Name )          = $_.Value
        }

        $Hash.Button2                      = $Button2
 
        $ButtonProperties                  = @{

            Height                         = 30
            Width                          = 30
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Top
            FontSize                       = 20
            Content                        = "+"
            Margin                         = "28,0,0,0"
        }

        $Button3                           = New-Object System.Windows.Controls.Button
        $ButtonProperties.GetEnumerator()  | % {

            $Button3.$( $_.Name )          = $_.Value

        }
        $Hash.Button3                      = $Button3
 
        $ButtonProperties                  = @{

            Height                         = 30
            Width                          = 30
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Top
            FontSize                       = 20
            Content                        = "-"
            Margin                         = "5,0,0,0"
        }

        $Button4                           = New-Object System.Windows.Controls.Button
        $ButtonProperties.GetEnumerator()  | % {

            $Button4.$( $_.Name )          = $_.Value

        }

        $Hash.Button4                      = $Button4
 
        $ButtonProperties                  = @{

            Height                         = 30
            Width                          = 60
            HorizontalContentAlignment     = [ System.Windows.HorizontalAlignment ]::Center
            VerticalContentAlignment       = [ System.Windows.VerticalAlignment ]::Top
            FontSize                       = 20
            Content                        = "Reset"
            Margin                         = "40,0,0,0"
        }

        $Button5                           = New-Object System.Windows.Controls.Button
        $ButtonProperties.GetEnumerator()  | % {
        
            $Button5.$( $_.Name )          = $_.Value
    
        }

        $Hash.Button5                      = $Button5
 
        $StackPanel                        = New-Object System.Windows.Controls.StackPanel
        $StackPanel.Orientation            = [ System.Windows.Controls.Orientation ]::Horizontal

        $TextBox1 , $TextBox2 , $TextBox3 , $TextBox4 , $TextBox5 | % {

            $StackPanel.AddChild( $_ )
        }
 
        $StackPanel2                       = New-Object System.Windows.Controls.StackPanel
        $StackPanel2.Orientation           = [ System.Windows.Controls.Orientation ]::Horizontal

        $Button1 , $Button2 , $Button3 , $Button4 , $Button5 | % {

            $StackPanel2.AddChild( $_ )
        }
 
        $MainStackPanel                    = New-Object System.Windows.Controls.StackPanel
        $MainStackPanel.Margin             = "5,5,5,5"

        $MainStackPanel.AddChild( $StackPanel )
        $MainStackPanel.AddChild( $StackPanel2 )

        $Window.AddChild( $MainStackPanel )
        $Hash.Window                       = $Window
    }
 
    Function Set-Binding 
    {
        Param ( $Target , $Property , $Path , $Source )
 
        $Binding                           = New-Object System.Windows.Data.Binding
        $Binding.Path                      = $Path
        $Binding.Mode                      = [ System.Windows.Data.BindingMode ]::OneWay
    
        If ( $Source )
        {
            $Binding.Source                = $Source
        }

        [ Void ][ System.Windows.Data.BindingOperations ]::SetBinding( $Target , $Property , $Binding )
 
        #[void]$Target.SetBinding($Property,$Binding)
    }
 
    $Hash                                  = @{}
    Create-WPFWindow $Hash

    $DataSource                            = New-Object System.Collections.ObjectModel.ObservableCollection[Object]
    
    $DataSource.Add( [ Int ] 1 )
    $DataSource.Add( [ Int ] 1 )
    $DataSource.Add( [ Int ] 1 )
    
    $Hash.Window.DataContext               = $DataSource
 

    
    $Splat                                 = @{ 
    
        Target                             = $Hash.TextBox1
        Property                           = [ System.Windows.Controls.TextBox ]::TextProperty
        Path                               = "[0]"
    }

    ( $Hash.TextBox1 , "[0]" ) , ( $Hash.TextBox3 , "[1]" ) , ( $Hash.TextBox5 , "[2]" ) | % { 

        Set-Binding -Target $_[0] -Property $( [ System.Windows.Controls.TextBox ]::TextProperty ) -Path $_[1] 
    }


#    Set-Binding -Target $Hash.TextBox3 -Property $( [ System.Windows.Controls.TextBox ]::TextProperty ) -Path "[1]"
#    Set-Binding -Target $Hash.TextBox5 -Property $( [ System.Windows.Controls.TextBox ]::TextProperty ) -Path "[2]"

    $Hash.Button1.Add_Click{ $DataSource[0] ++ }
    $Hash.Button2.Add_Click{ $DataSource[0] -- }
    $Hash.Button3.Add_Click{ $DataSource[1] ++ }
    $Hash.Button4.Add_Click{ $DataSource[1] -- }
    $Hash.Button5.Add_Click{ $DataSource[0] = [ Int ] 1 ; $DataSource[1] = [ Int ] 1 }
    
    $Hash.TextBox1 , $Hash.TextBox3 , $hash.TextBox5 | % {
    
        $_.Add_TextChanged{ $DataSource[2] = $DataSource[0] * $DataSource[1] }
    }
 
    [ Void ] $Hash.Window.Dispatcher.InvokeAsync{ $Hash.Window.ShowDialog() }.Wait()
