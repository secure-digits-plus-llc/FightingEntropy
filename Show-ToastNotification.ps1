# Originally based on this... https://steemit.com/powershell/@esoso/fun-with-toast-notifications-in-powershell
# This allows all of the templates to be dynamically generated via cmdlet
Function Resolve-Namespace
        {
            [ CmdLetBinding () ][ OutputType ("String") ] Param (
            
                [ Parameter ( Mandatory , Position = 0 , ValueFromPipeline = $True , HelpMessage = "Name of namespace" ) ][ String [] ] $Namespace )
               
            "`nUsing Namespace`n"

            $Namespace               | % {               # :Loop

                $Tee                 = 0..2
                $Tee[0]              = "    $_ ..."      #  Echo

                IEX ( "Using Namespace $_" )
                    
                $Tee[2]              = @{  
                        
                    $True            = " [+] Successful"  #  Success Flag
                    $False           = " [!] Exception"   #  Failure Flag
                    
                }[ $? ]
                    
                $Tee[1]              =  120 - ( $Tee[0] + $Tee[2] ).Length | % { "." * $_ }

                $Tee[0..2] -join ''
            }
        }

        Function Show-ToastNotification 
        {
            [ CmdLetBinding () ] Param (

                [ Parameter ( ParameterSetName =   "Text" , Position = 0 , Mandatory ) ][ Switch ] $Text  ,
                [ Parameter ( ParameterSetName =  "Image" , Position = 0 , HelpMessage = "http:// | https:// | file:///"  , Mandatory ) ][ String ] $Image ,
                [ ValidateScript ( { $_ -match ( 8 , 4 , 4 , 4 , 12 | % { "[0-9a-f]{$_}" } ) -join '-' } ) ]
                [ Parameter ( Position = 1 , Mandatory ) ][ String ] $GUID    ,
                [ ValidateSet ( 1,2,3,4 ) ]
                [ Parameter ( Position = 2 , Mandatory ) ][    Int ] $Type    = 4            ,
                [ Parameter ( Position = 3 , Mandatory ) ][ String ] $Header  = "Header"     ,
                [ Parameter ( Position = 4             ) ][ String ] $Message = "Message"    ,
                [ Parameter ( Position = 5             ) ][ String ] $Footer  = "Footer"     )

                $R = $Image.Count

                If ( $R -eq 0 )
                {
                    $Image = "&#33;"
                }

                If ( $R -eq 1 )
                {
                    If ( $Image -Match "http[s]*://" )
                    {
                        [ Net.ServicePointManager ]::SecurityProtocol = 3072

                        $Cache = $Env:AppData , $Image.Split('/')[-1] -join '\'

                        IWR -URI $Image -OutFile $Cache | % {
                
                            If ( $_.StatusDescription -ne "OK" )
                            {
                                Throw "Hyperlink Inaccessible"
                            }
                        }

                        $Image = "file:///{0}" -f $Cache.Replace("\","/")
                    }

                    ElseIf ( $Image -match "(\w+:\\\w+)" )
                    {
                        If ( Test-Path $Image )
                        {
                            $Image = "file:///{0}" -f $Image.Replace("\","/")
                        }

                        Else
                        {
                            Throw "Path to image not detected"
                        }
                    }

                    ElseIf ( $Image -match "(ms-app)+([x|data])+(:///)" )
                    {
                        Throw "ms-app* Not yet implemented"
                    }
                }

                $Stack           = @( 3 ) * $Type
                $Track           = 0..2 + $Stack + 2..0
                $Static          = @{

                    Type         = "Toast{0}Text0$Type" -f ( @{ 0 = "" ; 1 = "ImageAnd" }[ $Image.Count ] )
                    Body         = 0..3 | % { 
            
                        If ( $_ -eq 0 ) 
                        { 
                            "<image id='1' src='$Image' alt='$Image'/>" 
                        } 
                
                        Else 
                        { 
                            "<text id='$_'>{0}</text>" -f ( "" , $Header , $Message , $Footer )[$_] 
                        }
                    }
                    Space        = $Track | % { " " * ( 4 * $_ ) }
                    Items        = 0..( $Track.Length - 1 ) | % { ( ",,," + @(",")*$Stack.Length + "/,/,/" ).Split(',')[$_] , ("toast","visual","binding","")[$Track][$_] -join '' } | % { "<$_>" }
                }

                $Template        = 0..7 | % { 
        
                    [ PSCustomObject ]@{ 
            
                        Name     = ("Toast{0}Text0$( $_ % 4 + 1 )" -f ",ImageAnd".Split(',')[0,0,0,0,1,1,1,1][$_] )
                        Type     = @{ 0 = 1 ; 1 = 1..2 ; 2 = 1..2 ; 3 = 1..3 ; 4 = 0..1 ; 5 = 0..2 ; 6 = 0..2 ; 7 = 0..3 }[$_]
                    }
                }

                $I               = 0
                $Z               = 0

                $Root            = [ PSCustomObject ]@{ 
            
                    Name         = $Static.Type
                    Image        = ("-","$Image")[$R]
                    GUID         = $GUID
                    Runtime      = ""
                    Items        = ( "{0}.Data.Xml.Dom.XmlDocument;{0}.UI.{1}s;Toast{1}" -f "Windows","Notification" ).Split(';')
                    Object       = ""
                    Template     = $( While ( $I -lt $Track.Length )
                    {
                        $X       = $Track[$I]

                        If ( $X -ne 3 )
                        {
                            "{0}{1}" -f $Static.Space[$X] , $Static.Items[$I]
                        }

                        If ( $X -eq 3 )
                        {
                            "{0}{1}" -f $Static.Space[$X] , ( $Static.Body[ $Template[ ( 0..7 | ? { $Template.Name[$_] -eq $Static.Type } ) ].Type ] )[$Z]
                        
                            $Z ++
                        }
                
                        $I ++

                    }).Replace( "<binding>" , ( "<binding template='{0}'>" -f $Static.Type ) ).Replace("'",'"') -join "`n"

                    Header       = $Header
                    Message      = $Message
                    Footer       = $Footer
                }

                Resolve-Namespace $Root.Items[1]

                $Root.Runtime   = @( "{0},{0}" -f $Root.Items[0] ; "Manager","" | % { "{0}.{1}$_,{0}" -f $Root.Items[1,2] } ) | % { "[$_,ContentType=WindowsRuntime]" }

                $Root.Object    = New-Object $Root.Items[0] 
        
                $Root.Object.LoadXml( $Root.Template )

                $Root.Object    = New-Object ( $Root.Items[1,2] -join '.' ) $Root.Object

                $Root

                [ Windows.UI.Notifications.ToastNotificationManager ]::CreateToastNotifier( $Root.GUID ).Show( $Root.Object )
        }
