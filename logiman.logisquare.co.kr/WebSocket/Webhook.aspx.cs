using System;
using System.IO;

namespace WebSocket
{
    public partial class Webhook : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string json;
            using (var reader = new StreamReader(Request.InputStream))
            {
                json = reader.ReadToEnd();
            }

            Response.Write(json);
        }
    }
}