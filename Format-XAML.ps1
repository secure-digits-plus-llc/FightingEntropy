Function Format-XamlObject # Formats a Xaml Object to have a clean structure ________//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯\\__//¯¯¯  
{#/¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯ -- ¯¯¯¯    ¯¯¯¯      
    [ CmdLetBinding () ] Param ( 
        
        [ Parameter ( Mandatory , Position = 0 ) ] [ String ] $Xaml )

        $Script             = [ PSCustomObject ]@{

            Tab             = {

                Param ( $Line )

                $X , $Y = 0 , 0

                Do 
                {
                    If ( $Line[$X] -match "\s" ) { $X ++ } Else { $Y = 1 }
                }
                Until ( $Y -eq 1 )

                $X
            }
            
            Template        = {

                Param ( $Index )

                [ PSCustomObject ]@{ 
                    
                    Index         = $Index
                    Track         = ""
                    Name          = ""
                    Property      = @( )
                    Value         = @( )
                    Children      = @( )
                }
            }

            Reg             = "(?<=\<).+?(?=\>)"

            Status          = {
                
                Param ( $Item , $Total )
                Write-Progress -Activity "Collecting [~] Objects" ( ( $X / $Items.Count - 1 ) * 100 )

            }

            Obj             = {

                Param ( $Xaml )

                [ PSCustomObject ]@{

                    Track             = ForEach ( $I in 0..( $Xaml.Split( "`n" ).Count - 1 ) ) 
                    {
                        [ PSCustomObject ]@{
                
                            Index     = $I
                            Line      = $Xaml.Split("`n")[$I]
                            Level     = ""
                            Type      = ""
                            Prop      = @( )
                            Value     = @( )
                        }
                    }
                    Xaml              = $Xaml
                    Array             = $Xaml.Split( "`n" )
                    Items             = $Xaml.Split( "`n" ).Split(' ') | ? { $_.Length -gt 0 }
                }
            }
        }

        $Root                       = & $Script.Obj $Xaml

        $Array                      = $Root.Array
        $Return                     = $Root.Items -match "<"
        $Track                      = 0..( $Return.Count - 1 ) 
        $Items                      = $Root.Items
        $Path                       = "."
        $X                          = 0
        $Index                      = 0
        $Y                          = $Return.Count - 1
        $Depth                      = 0

        ForEach ( $I in $Track )
        {
            $Track[$I]              = & $Script.Template $I

            $Track[$I]              | % { 

                $_.Track            = $Return[$I]
                $_.Name             = $Return[$I].Replace("<",'').Replace(">",'').Replace("/",'')
                
                If ( $_.Track -match ">" )
                {
                    $X ++
                }

                If ( $_.Track -notmatch ">" )
                {
                    $X ++
                    Do
                    {
                        $_.Track    = $_.Track , $Items[$X] -join ' '
                        $X ++
                    }
                    Until ( $_.Track -match ">" )
                }

                $_.Track = $_.Track -Replace "\'\s\/>" , "'/>" -Replace "\'\s>" , "'/>"

                If ( $_.Track -match "(?<=\<).+?(?=\>)" )
                {
                    If ( ( $_.Track.Split(' ')[0] ).Count -eq 1 )
                    {

                    }

                    Else
                    {
                        $Split = $_.Track.Replace("<$($_.Name) ",'').Replace("' ","';").Split(';')

                        If ( $Split.Count -eq 1 )
                        {
                            $_.Property = $Split.Split(" = ")[0]
                            $_.Value    = $Split.Split(" = ")[1]
                        }

                        If ( $Split.Count -gt 1 )
                        {
                            ForEach ( $J in 0..( $Split.Count - 1 ) )
                            {
                                $_.Property += $Split[$J].Split(" = ")[0]
                                $_.Value    += $Split[$J].Split(" = ")[1]
                            }
                        }

                        $Split = $Null
                    }
                }
            }
        }

        [ PSCustomObject ]@{

            Xaml               = $Root
            Object             = $Track
        }
}
        

           

$Output = Format-XamlObject -Xaml $Xaml_Input
# # -------------------------------------------------------
# $Output.Xaml
# 
# Name        MemberType   Definition
# ----        ----------   ----------
# Equals      Method       bool Equals(System.Object obj)
# GetHashCode Method       int GetHashCode()
# GetType     Method       type GetType()
# ToString    Method       string ToString()
# Array       NoteProperty string[] Array=System.String[]
# Items       NoteProperty Object[] Items=System.Object[]
# Track       NoteProperty Object[] Track=System.Object[]
# Xaml        NoteProperty string Xaml=<Window …
# ----------- ------------ ------------------------------
# $Output.Object
#
# Name        MemberType   Definition
# ----        ----------   ----------
# Equals      Method       bool Equals(System.Object obj)
# GetHashCode Method       int GetHashCode()
# GetType     Method       type GetType()
# ToString    Method       string ToString()
# Children    NoteProperty Object[] Children=System.Object[]
# Index       NoteProperty int Index=0
# Name        NoteProperty string Name=Window
# Property    NoteProperty Object[] Property=System.Object[]
# Track       NoteProperty string Track=<Window xmlns = …
# Value       NoteProperty Object[] Value=System.Object[]


$Xaml_Process = Format-XamlObject -Xaml $Xaml_Input
