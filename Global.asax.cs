using System;
using System.Web;
using System.Web.UI;

namespace IOSMSystem
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
        }

        void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex == null) return;

            // Unwrap inner exceptions
            Exception inner = ex;
            while (inner.InnerException != null) inner = inner.InnerException;

            if (ex is ViewStateException || inner is ViewStateException
                || ex.Message.Contains("state information is invalid"))
            {
                Server.ClearError();
                string path = Request.Url.AbsolutePath;
                Response.Redirect(path, true);
            }
        }
    }
}
