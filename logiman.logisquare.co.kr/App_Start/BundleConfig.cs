using System.Web.Optimization;

namespace logiman.logisquare.co.kr
{
    public class BundleConfig
    {
        // For more information on Bundling, visit https://go.microsoft.com/fwlink/?LinkID=303951
        public static void RegisterBundles(BundleCollection bundles)
        {
/*
            bundles.Add(new ScriptBundle("~/bundles/CommonJS").Include(
                                                                       "~/js/common.js",
                                                                       "~/js/utils.js"));
*/
            // Order is very important for these files to work, they have explicit dependencies
            bundles.Add(new ScriptBundle("~/bundles/LibJS").Include(
                                                                    "~/js/lib/jquery/jquery.js",
                                                                    //"~/js/lib/jquery-ui/jquery-ui.js",
                                                                    "~/js/lib/datatables/jquery.dataTables.js",
                                                                    "~/js/lib/bootstrap/bootstrap.js",
                                                                    "~/js/lib/jquery.blockUI.js",
                                                                    "~/js/lib/jquery.datetimepicker.full.js",
                                                                    "~/js/lib/jquery.fileDownload.js",
                                                                    "~/js/lib/jquery.cookie.js",
                                                                    "~/js/lib/AUIGrid/pdfkit/AUIGrid.pdfkit.js",
                                                                    "~/js/lib/AUIGrid/pdfkit/FileSaver.min.js"));
        }
    }
}