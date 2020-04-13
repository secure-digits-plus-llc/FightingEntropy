# Originally based on this... https://steemit.com/powershell/@esoso/fun-with-toast-notifications-in-powershell
# This allows all of the templates to be dynamically generated via cmdlet

Function Show-ToastNotification 
{
    [ CmdLetBinding () ] Param (

        [ Parameter ( ParameterSetName =   "Text" , Position = 0 ,                                                  Mandatory ) ][ Switch ] $Text  ,
        [ Parameter ( ParameterSetName =  "Image" , Position = 0 , HelpMessage = "http:// | https:// | file:///"  , Mandatory ) ][ String ] $Image ,
        [ ValidateSet ( 1,2,3,4 ) ]
        [ Parameter ( ParameterSetName =   "Text" , Position = 1 , Mandatory ) ]
        [ Parameter ( ParameterSetName =  "Image" , Position = 1 , Mandatory ) ][    Int ] $Template              ,
        [ Parameter ( ParameterSetName =   "Text" , Position = 2 , Mandatory ) ]
        [ Parameter ( ParameterSetName =  "Image" , Position = 2 , Mandatory ) ][ String ] $Header    = "Header"  ,
        [ Parameter ( ParameterSetName =   "Text" , Position = 3             ) ]
        [ Parameter ( ParameterSetName =  "Image" , Position = 3             ) ][ String ] $Message   = "Message" ,
        [ Parameter ( ParameterSetName =   "Text" , Position = 4             ) ]
        [ Parameter ( ParameterSetName =  "Image" , Position = 4             ) ][ String ] $Footer    = "Footer"  )
        
        $W    = ( "{0}.Data.Xml.Dom.XmlDocument;{0}.UI.{1}s;Toast{1}" -f "Windows","Notification" ).Split(';')

        IEX "Using Namespace $( $W[1] )"
        
        $X    = @( "{0},{0}" -f $W[0] ; @( "Manager" , "" | % { "{0}.{1}$_,{0}" -f $W[1..2] } ) ) | % { "[$_,ContentType=WindowsRuntime]" } 

        $Return                     = [ PSCustomObject ]@{

            Object                  = $Template | % { @{ $True = "ToastText0$_" ; $False = "ToastImageAndText0$_" }[ $Text -ne $Null ] }
            Dom                     = IEX $X[0]
            Manager                 = IEX $X[1]
            Receive                 = IEX $X[2]
            Obj                     = ("toast","visual","binding","")[0..3+2..0]
            Body                    = @( "<image id=`"1`" src=`"$Image`" alt=`"$Image`"/>" ; 1..3 | % { "<text id=`"$_`">" + @( "" , $Header , $Message, $Footer )[$_] + "</text>" } ) 
            Space                   = 0..3+2..0 | % { " " * ( 4 * $_ ) }
            Template                = ""
            XML                     = New-Object $W[0]
            Content                 = ""
            
        }

        $Return.Template                = ForEach ( $I in 0..6 )
        { 
            If ( $I -lt 3 ) { "{0}<{1}>" -f $Return.Space[$I] , $Return.Obj[$I] }
            If ( $I -eq 3 )
            {
                @{
                    ToastText01         =    1 ; 
                    ToastText02         = 1..2 ; 
                    ToastText03         = 1..2 ; 
                    ToastText04         = 1..3 ; 
                    ToastImageAndText01 = 0..1 ; 
                    ToastImageAndText02 = 0..2 ; 
                    ToastImageAndText03 = 0..2 ; 
                    ToastImageAndText04 = 0..3 }[ $Return.Object ] | % { "{0}{1}" -f $Return.Space[$I] , $Return.Body[$_] }
            }
            If ( $I -gt 3 ) { "{0}</{1}>" -f $Return.Space[$I] , $Return.Obj[$I] }
        }

        $Return.Template                = $Return.Template -join "`n" -Replace "<binding>" , ( "<binding template=`"{0}`">" -f $Return.Object ) 
                                      
        $Return.XML.LoadXml( $Return.Template )
            
        $Return.Content               = New-Object ( $W[1,2] -join '.' ) $Return.Xml

        [ Windows.UI.Notifications.ToastNotificationManager ]::CreateToastNotifier( ( New-GUID ) ).Show( $Return.Content )

    }
