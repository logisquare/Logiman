using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(Startup))]

public class Startup
{
    public Startup()
    {
    }

    public void Configuration(IAppBuilder app)
    {
        app.MapSignalR();

        //아래와 같이 옵션을 지정하여 생성도 가능
        /**
        var hubConfiguration = new HubConfiguration();
        hubConfiguration.EnableDetailedErrors = true;
        hubConfiguration.EnableJavaScriptProxies = false;
        app.MapSignalR("/signalr", hubConfiguration);
        */
    }
}