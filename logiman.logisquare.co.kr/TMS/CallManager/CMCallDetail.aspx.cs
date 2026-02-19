using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using Newtonsoft.Json;
using System;

namespace TMS.CallManager
{
    public partial class CMCallDetail : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadOnly;
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
            SiteGlobal.WriteInformation("CMCallDetail", "PageView", $"{objSes.AdminID} | {Request.UrlReferrer.PathAndQuery}");

            CMJsonParamModel lo_objCMJsonParamModel = null;
            string           lo_strCMJsonParam      = string.Empty;

            lo_strCMJsonParam = Utils.IsNull(SiteGlobal.GetRequestForm("CMJsonParam", false), "");
            CMJsonParam.Value = lo_strCMJsonParam;

            try
            {
                lo_objCMJsonParamModel = JsonConvert.DeserializeObject<CMJsonParamModel>(lo_strCMJsonParam);

                DivAreaType01.Visible = lo_objCMJsonParamModel.CallerType.Equals(1);
                DivAreaType02.Visible = lo_objCMJsonParamModel.CallerType.Equals(2);
                DivAreaType03.Visible = lo_objCMJsonParamModel.CallerType.Equals(3);
                DivAreaType04.Visible = lo_objCMJsonParamModel.CallerType.Equals(4);

                DivCardRefresh.Visible = lo_objCMJsonParamModel.CallerType.Equals(4);
                DivCardList.Visible    = !lo_objCMJsonParamModel.CallerType.Equals(4);
            }
            catch (Exception)
            {
                // ignored
            }
        }
    }
}