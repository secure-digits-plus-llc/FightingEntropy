$BrowserResize = [ PSCustomObject ]@{

    Name    = ".\BrowserResize.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class BrowserResize
        {
            int InnerHeight;
            int InnerWidth;

            public readonly IJSRuntime JSR;

            public static event Func<Task> OnResize;

            [JSInvokable]
            public static async Task OnBrowserResize()
            {
                await OnResize?.Invoke();
            }

            public async Task<int> GetInnerHeight()
            {
                return InnerHeight = await JSR.InvokeAsync<int>( "browserResize.getInnerHeight" );
            }

            public async Task<int> GetInnerWidth()
            {
                return InnerWidth = await JSR.InvokeAsync<int>( "browserResize.getInnerWidth" );
            }

            public async Task OnInitAsync()
            {
                OnResize += BrowserHasResized;

                await JSR.InvokeAsync<object>( "browserResize.registerResizeCallback" );

                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();
            }

            public async Task BrowserHasResized()
            {
                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();

                var Block   = new Style();

                await Block.Variables();

            }
        }
    }
"@ }

$Layout     = [ PSCustomObject ]@{

    Name    = ".\Layout.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    namespace ShellBlaze
    {
        public class Layout
        {
            public string LToggle { get; set; }
            public string LLogo { get; set; }
            public string LId { get; set; }

            public object[] LCs = new string[7];

            public object[] LTag = new string[7];
        }
    }
"@ }

$Select     = [ PSCustomObject ]@{

    Name    = ".\Select.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;

    namespace ShellBlaze
    {
        public class Select
        {
            public Task<Layout> GetLayout(int Width)
            {
                if (Width > 720)
                {
                    return Task.FromResult(new Layout
                    {

                        LToggle = 'top',
                        LLogo   = 'toplogo',
                        LId     = 'ti',
                        LCs     = new string[] { 't0', 't1', 't2', 't3', 't4', 't5', 't6' },
                        LTag    = new string[] { 'Home', 'App<br/>Development', 'Network<br/>Security', 'Enterprise', 'OS<br/>Management', 'Hardware', 'Data<br/>Management' }
                    });
                }

                else
                {
                    return Task.FromResult(new Layout
                    {
                        LToggle = 'side',
                        LLogo   = 'sidelogo',
                        LId     = 'si',
                        LCs     = new string[] { 's0', 's1', 's2', 's3', 's4', 's5', 's6' },
                        LTag    = new string[] { 'Home', 'App Development', 'Network Security', 'Enterprise', 'OS Management', 'Hardware', 'Data Management' }
                    });
                }
            }
        }
    }
"@ }

$Sheet      = [ PSCustomObject ]@{

    Name    = ".\Sheet.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class Sheet
        {
            public readonly IJSRuntime JSR;
            public object ID       { get; set; } = "";
            public string Tag      { get; set; } = "";
            public string Property { get; set; } = "";
            public string Value    { get; set; } = "";

            public async Task<object> QuerySelect( string Tag )
            {
                return await JSR.InvokeAsync<object>( "querySel", Tag );
            }

            public async Task SetProperty( object ID , string Property , string Value )
            {
                await JSR.InvokeVoidAsync( "setProp" , ID , Property , Value );
            }
        }
    }
"@ }

$Style      = [ PSCustomObject ]@{

    Name    = ".\Style.cs"
    Content = @"
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.JSInterop;

    namespace ShellBlaze
    {
        public class Style
        {
            public readonly IJSRuntime JSR;

            int InnerHeight { get; set; }
            int InnerWidth  { get; set; }
            double Side     { get; set; }
            double Main     { get; set; }
            double Pixel    { get; set; }

            public async Task<int> GetInnerHeight()
            {
                return InnerHeight = await JSR.InvokeAsync<int>( "browserResize.getInnerHeight" );
            }

            public async Task<int> GetInnerWidth()
            {
                return InnerWidth  = await JSR.InvokeAsync<int>( "browserResize.getInnerWidth" );
            }

            public async Task Variables()
            {
                InnerHeight = await GetInnerHeight();
                InnerWidth  = await GetInnerWidth();
                Side        = InnerWidth * 0.15f;
                Main        = InnerWidth * 0.85f;
                Pixel       = InnerWidth / 1920;

                var CSS     = new Sheet();

                var root    = CSS.QuerySelect( ":root" );

                await CSS.SetProperty( root , "--root"  , InnerWidth + "px" );
                await CSS.SetProperty( root , "--side"  ,       Side + "px" );
                await CSS.SetProperty( root , "--main"  ,       Main + "px" );
                await CSS.SetProperty( root , "--pixel" ,      Pixel + "px" );

                var top  = CSS.QuerySelect( "#top"  );
                var side = CSS.QuerySelect( "#side" );
                var body = CSS.QuerySelect( "body"  );
                var main = CSS.QuerySelect( "#main" );

                if ( InnerWidth <  720 )
                {
                    await CSS.SetProperty( side , "display"        , "none"            );
                    await CSS.SetProperty(  top , "display"        , "flex"            );
                    await CSS.SetProperty( body , "flex-direction" , "column"          );
                    await CSS.SetProperty( root , "--content"      , InnerWidth + "px" );
                }

                if ( InnerWidth >= 720 )
                {
                    await CSS.SetProperty( side , "display"        , "flex"      );
                    await CSS.SetProperty( top  , "display"        , "none"      );
                    await CSS.SetProperty( body , "flex-direction" , "row"       );
                    await CSS.SetProperty( root , "--content"      , main + "px" );
                }
            }
        }
    }
"@ }
