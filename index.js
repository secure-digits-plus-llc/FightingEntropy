    
    var windowWidth = window.innerWidth;

    function getWindowWidth()
    {
        if ( windowWidth != window.innerWidth )
        {
            var windowWidth = window.innerWidth;
        }

        setTimeout(() => 
        {
            console.log( windowWidth );

        }, 500 );
    }

    getWindowWidth();
     
    window.addEventListener( "resize" , getWindowWidth );


    function mobileStyleSheet()
    {
        console.log("so maybe this guy can program javascript too...");
    }
