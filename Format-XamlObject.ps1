$Xaml_Input = @"
<Window 
                                               xmlns = 'http://schemas.microsoft.com/winfx/2006/xaml/presentation'
                                             xmlns:x = 'http://schemas.microsoft.com/winfx/2006/xaml'
                                               Title = 'Secure Digits Plus LLC | Hybrid @ ViperBomb Service Configuration Utility'
                                              Height = '600'
                                           MinHeight = '600'
                                               Width = '800'
                                            MinWidth = '800'
                                                Icon = 'C:\Users\Administrator\Documents\WindowsPowerShell\Modules\Hybrid-DSC\Graphics\icon.ico'
                                         BorderBrush = 'Black'
                                          ResizeMode = 'CanResize'
                                 HorizontalAlignment = 'Center'
                               WindowStartupLocation = 'CenterScreen'>
            <Window.Resources>
                <Style x:Key                                = 'SeparatorStyle1' 
                       TargetType                           = '{x:Type Separator}'>
                    <Setter Property                        = 'SnapsToDevicePixels'
                            Value                           = 'True'/>
                    <Setter Property                        = 'Margin'
                            Value                           = '0,0,0,0'/>
                    <Setter Property                        = 'Template'>
                        <Setter.Value>
                            <ControlTemplate TargetType     = '{x:Type Separator}'>
                                <Border Height              = '24'
                                        SnapsToDevicePixels = 'True' 
                                        Background          = '#FF4D4D4D'
                                        BorderBrush         = 'Azure'
                                        BorderThickness     = '1,1,1,1'
                                        CornerRadius        = '5,5,5,5'/>
                            </ControlTemplate> 
                        </Setter.Value>
                    </Setter>
                </Style>
                <Style TargetType                           = '{x:Type ToolTip}'>
                    <Setter Property                        = 'Background'
                            Value                           = '#000000'/>
                </Style>
            </Window.Resources>
            <Window.Effect>
                <DropShadowEffect/>
            </Window.Effect>
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height        = '20'/>
                    <RowDefinition Height        = '*'/>
                    <RowDefinition Height        = '60'/>
                </Grid.RowDefinitions>
                <Menu Grid.Row                   = '0'
                              IsMainMenu         = 'True'>
                    <MenuItem     Header         = 'Configuration'>
                        <MenuItem Header         = 'Home'>
                            <MenuItem Name       = 'MenuConfigHomeDefaultMax'
                                      Header     = 'Default Maximum'/>
                            <MenuItem Name       = 'MenuConfigHomeDefaultMin'
                                      Header     = 'Default Minimum'/>
                        </MenuItem>
                        <MenuItem Header         = 'Pro'>
                            <MenuItem Name       = 'MenuConfigProDefaultMax'
                                      Header     = 'Default Maximum'/>
                            <MenuItem Name       = 'MenuConfigProDefaultMin'
                                      Header     = 'Default Minimum'/>
                        </MenuItem>
                        <MenuItem Header         = 'Desktop'>
                            <MenuItem Name       = 'MenuConfigDesktopSafeMax'
                                      Header     = 'Safe Maximum'/>
                            <MenuItem Name       = 'MenuConfigDesktopSafeMin'
                                      Header     = 'Safe Minimum'/>
                            <MenuItem Name       = 'MenuConfigDesktopTweakedMax'
                                      Header     = 'Tweaked Maximum'/>
                            <MenuItem Name       = 'MenuConfigDesktopTweakedMin'
                                      Header     = 'Tweaked Minimum'/>
                        </MenuItem>
                        <MenuItem Header         = 'Laptop'>
                            <MenuItem Name       = 'MenuConfigLaptopSafeMax'
                                      Header     = 'Safe Maximum'/>
                            <MenuItem Name       = 'MenuConfigLaptopSafeMin'
                                      Header     = 'Safe Minimum'/>
                        </MenuItem>
                    </MenuItem>
                    <MenuItem     Header         = 'Info'>
                        <MenuItem Name           = 'MenuInfoFeedback'
                                  Header         = 'Feedback'/>
                        <MenuItem Name           = 'MenuInfoFAQ'
                                  Header         = 'FAQ'/>
                        <MenuItem Name           = 'MenuInfoAbout'
                                  Header         = 'About'/>
                        <MenuItem Name           = 'MenuInfoCopyright'
                                  Header         = 'Copyright'/>
                        <MenuItem Header         = 'MadBomb122'>
                            <MenuItem Name       = 'MenuInfoMadBombDonate'
                                      Header     = 'Donate to MadBomb122'/>
                            <MenuItem Name       = 'MenuInfoMadBombGitHub'
                                      Header     = 'Original GUI/Script Source - GitHub'/>
                        </MenuItem>
                        <MenuItem     Name       = 'MenuInfoBlackViper'
                                      Header     = 'BlackViper Service Configuration Website'/>
                        <MenuItem     Name       = 'MenuInfoSecureDigitsPlus'
                                      Header     = 'Secure Digits Plus: Fighting Entropy'/>
                    </MenuItem>
                </Menu>
                <Grid Grid.Row                   = '1'>
                    <TabControl BorderBrush      = 'Gainsboro' 
                                Grid.Row         = '1'
                                Name             = 'TabControl'>
                        <TabControl.Resources>
                            <Style TargetType    = 'TabItem'>
                                <Setter Property = 'Template'>
                                    <Setter.Value>
                                        <ControlTemplate TargetType                   = 'TabItem'>
                                            <Border Name                              = 'Border'
                                                    BorderThickness                   = '1,1,1,0'
                                                    BorderBrush                       = 'Gainsboro'
                                                    CornerRadius                      = '4,4,0,0'
                                                    Margin                            = '2,0'>
                                                <ContentPresenter x:Name              = 'ContentSite'
                                                                  VerticalAlignment   = 'Center'
                                                                  HorizontalAlignment = 'Center'
                                                                  ContentSource       = 'Header'
                                                                  Margin              = '10,2'/>
                                            </Border>
                                            <ControlTemplate.Triggers>
                                                <Trigger Property      = 'IsSelected'
                                                         Value         = 'True'>
                                                    <Setter TargetName = 'Border'
                                                            Property   = 'Background'
                                                            Value      = 'LightSkyBlue'/>
                                                </Trigger>
                                                <Trigger Property      = 'IsSelected'
                                                         Value         = 'False'>
                                                    <Setter TargetName = 'Border'
                                                            Property   = 'Background'
                                                            Value      = 'GhostWhite'/>
                                                </Trigger>
                                            </ControlTemplate.Triggers>
                                        </ControlTemplate>
                                    </Setter.Value>
                                </Setter>
                            </Style>
                        </TabControl.Resources>
                        <TabItem Header = 'Service Dialog'>
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '60'/>
                                    <RowDefinition Height = '35'/>
                                    <RowDefinition Height = '*'/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row = '0' >
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '2.5*' />
                                        <ColumnDefinition Width = '1.25*' />
                                        <ColumnDefinition Width = '1.25*' />
                                    </Grid.ColumnDefinitions>
                                    <GroupBox Grid.Column         = '0' 
                                              Header              = 'Operating System' 
                                              Margin              = '5' >
                                        <TextBlock Name           = 'CurrentOS'
                                                   TextAlignment  = 'Center'
                                                   Margin         = '5'/>
                                    </GroupBox>
                                    <GroupBox Grid.Column         = '1' 
                                              Header              = 'Current Build' 
                                              Margin              = '5' >
                                        <TextBlock Name           = 'CurrentBuild'
                                                   TextAlignment  = 'Center'
                                                   Margin         = '5'/>
                                    </GroupBox>
                                    <GroupBox Grid.Column         = '2' 
                                              Header              = 'Chassis' 
                                              Margin              = '5' >
                                        <TextBlock Name           = 'CurrentChassis'
                                                   TextAlignment  = 'Center'
                                                   Margin         = '5'/>
                                    </GroupBox>
                                </Grid>
                                <Grid Grid.Row                  = '1'>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '50'/>
                                        <ColumnDefinition Width = '*'/>
                                        <ColumnDefinition Width = '150'/>
                                        <ColumnDefinition Width = '200'/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column = '0' Margin = '5' VerticalAlignment = 'Center' FontSize = '12' Text = "Search:"/>
                                    <TextBox   Grid.Column = '1' Margin = '5' Height = '22' Name = 'ServiceDialogSearch' TextWrapping = 'Wrap' />
                                    <ComboBox  Grid.Column = '2' Margin = '5' Height = '22' Name = 'ServiceDialogSelect' VerticalAlignment = 'Center'>
                                        <ComboBoxItem Content = 'Name' IsSelected = 'True'/>
                                        <ComboBoxItem Content = 'DisplayName'/>
                                        <ComboBoxItem Content = 'PathName'/>
                                        <ComboBoxItem Content = 'Description'/>
                                    </ComboBox>
                                    <TextBlock Grid.Column       = '3' 
                                               Margin            = '5' 
                                               TextAlignment     = 'Center'
                                               VerticalAlignment = 'Center'>
                                        <Run   Background        = '#66FF66'
                                               Text              = 'Scoped'/>
                                        <Run   Background        = '#FFFF66'
                                               Text              = 'Unspecified'/>
                                        <Run   Background        = '#FF6666'
                                               Text              = 'Non Scoped'/>
                                    </TextBlock>
                                </Grid>
                                <DataGrid Grid.Row                   = '2'
                                          Grid.Column                = '0'
                                          Name                       = 'ServiceDialogGrid'
                                          FrozenColumnCount          = '2' 
                                          AutoGenerateColumns        = 'False' 
                                          AlternationCount           = '2' 
                                          HeadersVisibility          = 'Column' 
                                          CanUserResizeRows          = 'False' 
                                          CanUserAddRows             = 'False' 
                                          IsTabStop                  = 'True'
                                          IsTextSearchEnabled        = 'True'
                                          SelectionMode              = 'Extended'>
                                    <DataGrid.RowStyle>
                                        <Style TargetType            = '{x:Type DataGridRow}'>
                                            <Style.Triggers>
                                                <Trigger Property    = 'IsMouseOver'
                                                         Value       = 'True'>
                                                    <Setter Property = 'ToolTip'>
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
                                <TextBlock Grid.Row = '2' Name = 'ServiceDialogEmpty' Margin = '20' VerticalAlignment = 'Center' HorizontalAlignment = 'Center' FontSize = '20'/>
                            </Grid>
                        </TabItem>
                        <TabItem Header = 'Preferences'>
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height = '1.25*'/>
                                    <RowDefinition Height = '*'/>
                                </Grid.RowDefinitions>
                                <Grid Grid.Row = '0'>
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width = '*'/>
                                        <ColumnDefinition Width = '*'/>
                                        <ColumnDefinition Width = '*'/>
                                    </Grid.ColumnDefinitions>
                                    <Grid Grid.Column = '2'>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*'/>
                                            <RowDefinition Height = '*'/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row = '0' Header = 'Bypass / Checks [ Risky Options ]' Margin = '5'>
                                            <Grid>
                                                <Grid.RowDefinitions>
                                                    <RowDefinition Height = '*'/>
                                                    <RowDefinition Height = '*'/>
                                                    <RowDefinition Height = '*'/>
                                                </Grid.RowDefinitions>
                                                <ComboBox   Grid.Row = '0' VerticalAlignment = 'Center' Height = '24' Name = 'BypassEdition'>
                                                    <ComboBoxItem Content = 'Override Edition Check' IsSelected = 'True'/>
                                                    <ComboBoxItem Content = 'Windows 10 Home'/>
                                                    <ComboBoxItem Content = 'Windows 10 Pro'/>
                                                </ComboBox>
                                                <CheckBox   Grid.Row = '1' Margin = '5' Name = 'BypassBuild' Content = 'Skip Build/Version Check'/>
                                                <CheckBox   Grid.Row = '2' Margin = '5' Name = 'BypassLaptop' Content = 'Enable Laptop Tweaks'/>
                                            </Grid>
                                        </GroupBox>
                                        <GroupBox Grid.Row = '1' Header = 'Display' Margin = '5' >
                                            <Grid>
                                                <Grid.RowDefinitions>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                </Grid.RowDefinitions>
                                                <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DisplayActive' Content = 'Show Active Services' />
                                                <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DisplayInactive' Content = 'Show Inactive Services' />
                                                <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DisplaySkipped' Content = 'Show Skipped Services' />
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                    <Grid Grid.Column = '0'>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*'/>
                                            <RowDefinition Height = '*'/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row = '0' Header = 'Service Configuration' Margin = '5'>
                                            <ComboBox  Grid.Row = '1' Name = 'ServiceProfile' Height ='24'>
                                                <ComboBoxItem Content = 'Black Viper (Sparks v1.0)' IsSelected = 'True'/>
                                                <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsEnabled = 'False'/>
                                            </ComboBox>
                                        </GroupBox>
                                        <GroupBox Grid.Row = '1' Header = 'Miscellaneous' Margin = '5'>
                                            <Grid>
                                                <Grid.RowDefinitions>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                </Grid.RowDefinitions>
                                                <CheckBox  Grid.Row = '0' Margin = '5' Name = 'MiscSimulate'     Content = 'Simulate Changes [ Dry Run ]'   />
                                                <CheckBox  Grid.Row = '1' Margin = '5' Name = 'MiscXbox'     Content = 'Skip All Xbox Services'   />
                                                <CheckBox  Grid.Row = '2' Margin = '5' Name = 'MiscChange'     Content = 'Allow Change of Service State'   />
                                                <CheckBox  Grid.Row = '3' Margin = '5' Name = 'MiscStopDisabled'     Content = 'Stop Disabled Services'   />
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                    <Grid Grid.Column = '1'>
                                        <Grid.RowDefinitions>
                                            <RowDefinition Height = '*'/>
                                            <RowDefinition Height = '*'/>
                                        </Grid.RowDefinitions>
                                        <GroupBox Grid.Row = '0' Header = 'User Interface' Margin = '5'>
                                            <ComboBox  Grid.Row = '1' Name = 'ScriptProfile' Height = '24' >
                                                <ComboBoxItem Content = 'DevOPS (MC/SDP v1.0)' IsSelected =  'True'/>
                                                <ComboBoxItem Content = 'MadBomb (MadBomb122 v1.0)' IsEnabled  = 'False'/>
                                            </ComboBox>
                                        </GroupBox>
                                        <GroupBox Grid.Row = '1' Header = 'Development' Margin = '5'>
                                            <Grid>
                                                <Grid.RowDefinitions>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                    <RowDefinition Height = '30'/>
                                                </Grid.RowDefinitions>
                                                <CheckBox  Grid.Row = '0' Margin = '5' Name = 'DevelDiagErrors'  Content = 'Diagnostic Output [ On Error ]' />
                                                <CheckBox  Grid.Row = '1' Margin = '5' Name = 'DevelLog'  Content = 'Enable Development Logging' />
                                                <CheckBox  Grid.Row = '2' Margin = '5' Name = 'DevelConsole'  Content = 'Enable Console' />
                                                <CheckBox  Grid.Row = '3' Margin = '5' Name = 'DevelDiagReport'  Content = 'Enable Diagnostic' />
                                            </Grid>
                                        </GroupBox>
                                    </Grid>
                                </Grid>
                                <Grid Grid.Row = '1'>
                                    <Grid.RowDefinitions>
                                        <RowDefinition Height = '*'/>
                                        <RowDefinition Height = '*'/>
                                    </Grid.RowDefinitions>
                                    <GroupBox Grid.Row = '0' Header = 'Logging: Create logs for all changes made via this utility' Margin = '5'>
                                        <Grid>
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width = '75'/>
                                                <ColumnDefinition Width = '*'/>
                                                <ColumnDefinition Width = '6*'/>
                                            </Grid.ColumnDefinitions>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '*' />
                                                <RowDefinition Height = '*' />
                                            </Grid.RowDefinitions>
                                            <Label    Grid.Row = '0' Grid.Column = '0' Content = 'Service:' VerticalAlignment = 'Center' HorizontalAlignment = 'Right'/>
                                            <Button   Grid.Row = '0' Grid.Column = '1' Margin  = '5' Name = 'LoggingServiceBrowse' Content = 'Browse'  />
                                            <TextBox  Grid.Row = '0' Grid.Column = '2' Margin  = '5' Name = 'LoggingServiceFile' IsEnabled = 'False' />
                                            <Label    Grid.Row = '1' Grid.Column = '0' Content = 'Script:' VerticalAlignment = 'Center' HorizontalAlignment = 'Right'/>
                                            <Button   Grid.Row = '1' Grid.Column = '1' Margin  = '5' Name = 'LoggingScriptBrowse' Content = 'Browse'  />
                                            <TextBox  Grid.Row = '1' Grid.Column = '2' Margin  = '5' Name = 'LoggingScriptFile' IsEnabled = 'False' />
                                        </Grid>
                                    </GroupBox>
                                    <GroupBox Grid.Row = '1' Header = 'Backup: Save your current Service Configuration' Margin = '5'>
                                        <Grid>
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width = '75'/>
                                                <ColumnDefinition Width = '*'/>
                                                <ColumnDefinition Width = '6*'/>
                                            </Grid.ColumnDefinitions>
                                            <Grid.RowDefinitions>
                                                <RowDefinition Height = '*' />
                                                <RowDefinition Height = '*' />
                                            </Grid.RowDefinitions>
                                            <Label    Grid.Row = '0' Grid.Column = '0' Content = 'Registry:' VerticalAlignment = 'Center' HorizontalAlignment = 'Right'/>
                                            <Button   Grid.Row = '0' Grid.Column = '1' Margin  = '5' Name = 'BackupRegistryBrowse' Content   = 'Browse'  />
                                            <TextBox  Grid.Row = '0' Grid.Column = '2' Margin  = '5' Name = 'BackupRegistryFile'   IsEnabled = 'False'   />
                                            <Label    Grid.Row = '1' Grid.Column = '0' Content = 'Template:' VerticalAlignment = 'Center' HorizontalAlignment = 'Right'/>
                                            <Button   Grid.Row = '1' Grid.Column = '1' Margin  = '5' Name = 'BackupTemplateBrowse' Content   = 'Browse'  />
                                            <TextBox  Grid.Row = '1' Grid.Column = '2' Margin  = '5' Name = 'BackupTemplateFile'   IsEnabled = 'False'   />
                                        </Grid>
                                    </GroupBox>
                                </Grid>
                            </Grid>
                        </TabItem>
                        <TabItem Header = 'Console'>
                            <Grid Margin = '5'>
                                <GroupBox Header = 'Embedded Console'>
                                <ScrollViewer VerticalScrollBarVisibility = 'Visible' Margin = '5'>
                                    <TextBlock Name = 'ConsoleOutput' TextTrimming = 'CharacterEllipsis' Foreground = 'White' Background = 'DarkBlue' FontFamily = 'Lucida Console'/>
                                </ScrollViewer>
                                </GroupBox>
                            </Grid>
                        </TabItem>
                        <TabItem Header = 'Diagnostics'>
                            <Grid Background = '#FFE5E5E5'>
                                <ScrollViewer VerticalScrollBarVisibility = 'Visible'>
                                    <TextBlock Name = 'DiagnosticOutput' TextTrimming = 'CharacterEllipsis' Background = 'White' FontFamily = 'Lucida Console'/>
                                </ScrollViewer>
                            </Grid>
                        </TabItem>
                    </TabControl>
                </Grid>
                <Grid Grid.Row = '2'>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width = '*'/>
                        <ColumnDefinition Width = '0.5*'/>
                        <ColumnDefinition Width = '0.5*'/>
                        <ColumnDefinition Width = '*'/>
                    </Grid.ColumnDefinitions>
                    <GroupBox Header = 'Service Config' Margin = '5' Grid.Column = '0'>
                        <TextBlock Name = 'ServiceLabel' TextAlignment = 'Center' Margin = '5'/>
                    </GroupBox>
                    <Button    Grid.Column = '1' Name =  'Start' Content  = 'Start'  Height = '20' Margin = '5'/>
                    <Button    Grid.Column = '2' Name =  'Cancel' Content  = 'Cancel'  Height = '20' Margin = '5'/>
                    <GroupBox Header = 'Script/Module' Margin = '5' Grid.Column = '3'>
                        <TextBlock Name = 'ScriptLabel' TextAlignment = 'Center' Margin = '5' />
                    </GroupBox>
                </Grid>
            </Grid>
        </Window>
"@

Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script                                 = [ PSCustomObject ]@{

            Object                              = {

                Param ( $Xaml )                   

                [ PSCustomObject ]@{ 

                    Array                       = $Xaml.Split("`n")
                    Items                       = $Xaml.Split("`n").Split(' ') | ? { $_.Length -gt 0 }
                    Track                       = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) )
                    {
                        [ PSCustomObject ]@{ 

                            Index               = $I
                            Line                = $Xaml.Split("`n")[$I]
                        }
                    }
                    Xaml                        = $Xaml 
                }
            }
        
            Template                            = { 

                Param ( $Index , $Drive )

                [ PSCustomObject ]@{
                        
                    Index                       = $Index
                    Drive                       = $Drive
                    Track                       = ""
                    Type                        = ""
                    Path                        = ""
                    Parent                      = ""
                    Name                        = ""
                    Depth                       = ""
                    Indent                      = ""
                    Tag                         = ""
                    Property                    = $Null
                    Value                       = $Null
                }
            }
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯   Begin Parameter [~] : Pull Objects and loads initial process                                 ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Begin
        {
            $Drive                              = "DSC:"
            $Name                               = $Null
            $Path                               = $Null
            $Root                               = & $Script.Object $Xaml  #= $Xaml_Input
            $Depth                              = 0
            $Type                               = "@"
            $Indent                             = 0
            $Return                             = $Root.Items -match "<"
            $Count                              = $Return.Count - 1
            $Index                              = 0
            $X                                  = 0
            $I                                  = 0
            $T                                  = @( )
        }
    #    ____    ____________________________________________________________________________________________________      #
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  #
    #   \\__//¯¯¯           Process [~] : Re-track and Re-calculate positioning of Objects                       ___//¯¯\\ #
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// #
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  #
        Process
        {
            ForEach ( $X in 0..$Count )
            {
                Write-Progress -Activity "Collecting [~] Track Information" -PercentComplete ( ( $X / $Count ) * 100 )

                $T                             += & $Script.Template $X $Drive
                $T[$X].Track                    = $Return[$X]

                If ( $T[$X].Track -notmatch ">" )
                {
                    While( $T[$X].Track -notmatch ">" )
                    {
                        $Index ++
                        $T[$X].Track            = $T[$X].Track , $Root.Items[ $Index ] -join ' '
                    }
                }
                $Index ++

                $T[$X].Tag                      = $Return[$X] -Replace "(\s*)" , ""
                $T[$X].Type                     = $Type
                $T[$X].Track                    = $T[$X].Track -Replace  "(\s+)" , " " -Replace "(\'\s\/>)" , "'/>" -Replace "(\'\s[>])" , "'>"

                If ( $T[$X].Track -match "=" )
                {
                    $S                          = $T[$X].Track -Replace ( $T[$X].Tag + " " ) , "" -Replace "' " , "';"  -Split ";"

                    If ( $S.Count -eq 1 )
                    {
                        $T[$X].Property         = $S.Split(' ')[0]
                        $T[$X].Value            = $S -Replace ( $S.Split(' ')[0] + " = " ) , ''
                    }

                    Else
                    {
                        $T[$X].Property         = 0..( $S.Count - 1 ) | % { $S[$_].Split(' ')[0] }
                        $T[$X].Value            = 0..( $S.Count - 1 ) | % { $S[$_] -Replace ( $S[$_].Split(' ')[0] + " = " ) , '' }
                    }
                }

                $Type                           = $T[$X].Track | % {

                    If     ( $_ -Match "(<[^/].+[^/]>)" ) { "+" }
                    ElseIf ( $_ -Match ".+(\/>)"        ) { "/" }
                    ElseIf ( $_ -Match "(<\/).+"        ) { "-" }
                    Else                                  { "?" }
                }

                $T[$X].Name                     = $Return[$X] -Replace "(<*/*\>*)" , ""

                If ( $Path -ne $Null )
                {
                    $T[$X].Path                 = @{ 
                        
                        "+"                     = $Path , $T[$X].Name -join '\'
                        "/"                     = $Path 
                        "-"                     = Split-Path $Path -Parent
                    
                    }[ $T[$X].Type ]

                    $Path                       = $T[$X].Path

                    $T[$X].Parent               = Split-Path $Path -Parent | % {
                        
                        If ( $_.Length -eq "" -or $_ -eq $Drive )
                        {
                            "-"
                        }

                        Else
                        {
                            $_
                        }
                    }
                }

                If ( $Path -eq $Null )
                {
                    $Name                       = $T[$X].Name
                    $Path                       = $Drive , $Name -join '\'
                    $T[$X].Parent               = $Drive
                    $T[$X].Path                 = $Path
                }

                $Depth                          = $Path.Split('\').Count - 2
                $T[$X].Depth                    = $Depth

                If ( $Sw0 -ne $True  -and $T[$X].Tag    -match "(<\/)" -and $T[$X].Type -eq "/" )
                { 
                    $Sw0 = $True
                }

                If ( $Sw0 -ne $False -and $T[$X].Tag -notmatch "(<\/)" -and $T[$X].Type -eq "+" )
                {
                    $Sw0 = $False
                }

                $T[$X].Indent                   = @{
                    
                    "@"                         = 0
                    "/"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "-"                         = If ( ! $Sw0 ) { $Depth } Else { $Depth - 1 }
                    "+"                         = $Depth

                }[ $Type ]
            }
        }

    #    ____    ____________________________________________________________________________________________________      # 
    #   //¯¯\\__//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\\___  # 
    #   \\__//¯¯¯     End Parameter [~] : Finalize the object arrangement for output                             ___//¯¯\\ # 
    #    ¯¯¯\\__________________________________________________________________________________________________//¯¯\\__// # 
    #        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯  # 
        End
        {
            $Max                                = [ PSCustomObject ]@{

                Indent                          = ( $T.Indent                                             | Sort )[ -1 ] * 4
                Tag                             = ( $T.Tag      | % { $_.Length }                         | Sort )[ -1 ]
                Buffer                          = ( $T          | % { $_.Tag.Length + ( $_.Indent * 4 ) } | Sort )[ -1 ]
                Property                        = ( $T.Property | % { $_.Length }                         | Sort )[ -1 ]
            }

            $X                                  = 0

            ForEach ( $X in 0..$Count )
            {
                $OP                             = $T[$X] | % { 
                    
                    [ PSCustomObject ]@{

                        Indent                  = " " * ( $_.Indent * 4 )
                        Tag                     = $_.Tag
                        Remain                  = $Max.Buffer - ( ( $_.Indent * 4 ) + $_.Tag.Length )
                        Buffer                  = $Max.Buffer
                    }
                }

                $Slot                           = $OP.Remain | % { $OP.Indent + $OP.Tag + $( If ( $_ -gt 0 ) { " " * $_ } Else { "" } ) }

                If ( $T[$X].Property -ne $Null )
                {
                    If ( $T[$X].Property.Count -eq 1 )
                    {
                        [ PSCustomObject ]@{

                            Object   = $Slot
                            Property = $T[$X].Property + ( " " * ( $Max.Property - $T[$X].Property.Length ) )
                            Value    = $T[$X].Value
                        }

                        "{0} {1} = {2}" -f $_.Object  , $_.Property  , $_.Value
                    }
        
                    If ( $T[$X].Property.Count -gt 1 )
                    {
                        0..( $T[$X].Property.Count - 1 ) | % {
                            
                            [ PSCustomObject ]@{

                                Object   = If ( $_ -eq 0 ) { $Slot } Else { " " * $OP.Buffer }
                                Property = $T[$X].Property[$_] + ( " " * ( $Max.Property - $T[$X].Property[$_].Length ) )
                                Value    = $T[$X].Value[$_]
                            }

                            "{0} {1} = {2}" -f $_.Object  , $_.Property  , $_.Value
                        }
                    }
                }

                Else
                {
                    $Slot
                }
            }
        }


$Output = Format-XamlObject -Xaml $Xaml_Input
