    Class Map
    {
        [ Int32  ] $ID
        [ String ] $File
        [ String ] $Tag

        Map(){}
    }

    Class Archive
    {
        [ String ] $Path
        [ String ] $Name
        [ String ] $Filter
    
        Archive(){}
    }

    $Maps    =  [ Map ]@{ ID = 1850 ; File = "20kdm3"      ; Tag  = "Insane Products"          } ,
                [ Map ]@{ ID = 1491 ; File = "map-20kdm2"  ; Tag  = "Return to Castle: Quake"  } , 
                [ Map ]@{ ID = 1115 ; File = "map-20kdm1"  ; Tag  = "Tempered Graveyard"       } ,
                [ Map ]@{ ID =  980 ; File = "bfgdm4"      ; Tag  = "Suspended Animation"      } ,
                [ Map ]@{ ID =  943 ; File = "bfgdm3a"     ; Tag  = "Space Station 1138"       } ,
                [ Map ]@{ ID = 1500 ; File = "map-20kctf1" ; Tag  = "Out of My Head"           } , 
                [ Map ]@{ ID = 1260 ; File = "hellra3map1" ; Tag  = "Dude, You Can Go To Hell" }

    $Maps       | % {
    
        @{  # Uri       = "https://lvlworld.com/download/id:{0}#" -f $_.ID
            Source      = "https://lvlworld.com/download/id:{0}#" -f $_.ID
            # Outfile   = "C:\Program Files (x86)\Quake III Arena\baseq3\{0}.zip" -f $_.File
            Destination = "C:\Program Files (x86)\Quake III Arena\baseq3\{0}.zip" -f $_.File
            Description = "Downloading Map: {0}" -f $_.Tag
        
        } | % { Start-BitsTransfer @_ }
    }
            
        Start-BitsTransfer -Source "X" -Destination "C:\Program Files (x86)\Quake III Arena\baseq3"
                
    $Archive =  [ Archive ]@{ Path = "C:\Program Files (x86)\Quake III Arena\baseq3" ; Filter = "zip" } 

    $Archive | % { 

        $_.Name += GCI $_.Path *$( $_.Filter )* 
        
        ForEach ( $I in 0..( $_.Name.Count- 1 ) )
        {
            Expand-Archive -Path "$($_.Path)/$($_.Name[$I])" -DestinationPath $_.Path
        }
    }
