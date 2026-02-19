using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.IO;
using System.Web.UI.WebControls;

namespace CENTER.Center
{
    public partial class CenterHomeTaxDeptUserIns : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            try
            {
                CommonDDLB.HOMETAX_DEPT_USER_REG_TYPE(RegType);

                hidCenterCode.Value = SiteGlobal.GetRequestForm("CenterCode");
                if (objSes.GradeCode.Equals(1) || objSes.GradeCode.Equals(2))
                {
                    GradeRegType.Attributes.Add("style", "display:table-row");
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Center",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9240);
            }
        }

        protected void DownLoad_Click(object sender, EventArgs e)
        {
            Response.Clear();

            try
            {
                string strFileName = Request.PhysicalApplicationPath + "SSO\\Center\\CenterHomeTaxDeptUser_Manual.pdf";
                byte[] Content = File.ReadAllBytes(strFileName);

                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("content-disposition", "attachment; filename=HomeTaxManual.pdf");
                Response.BufferOutput = true;
                Response.OutputStream.Write(Content, 0, Content.Length);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog(
                    "Center",
                    "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9245);
            }
            finally
            {
                Response.End();
            }
        }
    }
}