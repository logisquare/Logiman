//using Microsoft.AspNet.SignalR;
using System;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace WebSocket
{
    public partial class SendPush2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                /*
                 //CallerType
                 31:기사	단기, 고정, 지입, 직영, 협력	차주
                 32:차량업체	차량업체, 협력업체	사업자
                 51:고객사담당자	포워더, 화주, 창고, 운송, 기타	담당자
                 52:고객사	포워더, 화주, 창고, 운송, 기타	사업자
                 11:화주관리자	웹오더	담당자
                 21:운송사	로지맨	담당자
                 71:오더정보	포워더, 화주, 창고, 운송, 기타, 상하차지	담당자, 상하차지
                 99:없음
                 *
                 */
                string strCenterCode  = Request["CenterCode"];
                string strSndTelNo    = Request["SndTelNo"];
                string strRcvTelNo    = Request["RcvTelNo"];
                string strSeqNo       = Request["SeqNo"];
                string strCMJsonParam = "";

                /* DB에서 조회해서 세팅*/
                strCenterCode = "1";
                strSndTelNo   = "01011112222";
                strRcvTelNo   = "01033334444";
                strSeqNo      = "1";

                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    SeqNo            = strSeqNo,
                    CallerType       = 1,
                    CallerDetailType = 1,
                    CallerDetailText = "직영",
                    Name             = "홍길동",
                    ComName          = "로지스랩",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "서울33가3333",
                    CarTon           = "1톤",
                    CarType          = "카고",
                    PlaceName        = "",
                    PlaceAddr        = "",
                    CenterName       = "",
                    Position         = "",
                    DeptName         = "",
                    ClassType        = 2
                };

                strCMJsonParam = JsonConvert.SerializeObject(objCMJsonParam);

                var hub = GlobalHost.ConnectionManager.GetHubContext("NotiHub");
                if (hub != null)
                {
                    hub.Clients.All.cidReceived(strCMJsonParam, "Y", "Y", "Y");
                }
            }
        }
    }
}