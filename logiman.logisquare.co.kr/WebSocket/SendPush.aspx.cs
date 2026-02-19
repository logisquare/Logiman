//using Microsoft.AspNet.SignalR;
using System;
using System.Linq;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace WebSocket
{
    public partial class SendPush : System.Web.UI.Page
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

                string strAdminID     = Request["AdminID"];
                string strCenterCode  = Request["CenterCode"];
                string strSndTelNo    = Request["SndTelNo"];
                string strRcvTelNo    = Request["RcvTelNo"];
                string strSeqNo       = Request["SeqNo"];
                string strCMJsonParam = "";

                /* DB에서 조회해서 세팅*/
                strCenterCode = "2";
                strSndTelNo   = "01011112222";
                strRcvTelNo   = "01033334444";
                strSeqNo      = "1";

                //차량업체
                /*
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 1,
                    CallerDetailType = 32,
                    CallerDetailText = "협력업체",
                    Name             = "김기사",
                    ComName          = "로지스랩",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "서울33가3333",
                    CarTon           = "1톤",
                    CarType          = "카고",
                    PlaceName        = "",
                    PlaceAddr        = "",
                    CenterName       = "로지스랩(주)",
                    Position         = "",
                    DeptName         = "",
                    ClassType        = 2,
                    RefSeqNo         = "10072",
                    ComCode          = "1",
                    ClientCode       = "",
                    ClientAdminID    = ""
                };
                */

                //차량
                /*
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 1,
                    CallerDetailType = 31,
                    CallerDetailText = "직영",
                    Name             = "김기사",
                    ComName          = "로지스랩",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "서울33가3333",
                    CarTon           = "1톤",
                    CarType          = "카고",
                    PlaceName        = "",
                    PlaceAddr        = "",
                    CenterName       = "로지스랩(주)",
                    Position         = "",
                    DeptName         = "",
                    ClassType        = 2,
                    RefSeqNo         = "10072",
                    ComCode          = "1",
                    ClientCode       = "",
                    ClientAdminID    = ""
                };
                */
                //고객사
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 2,
                    CallerDetailType = 51,
                    CallerDetailText = "포워더",
                    Name             = "고객담당",
                    ComName          = "로지스퀘어",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "",
                    CarTon           = "",
                    CarType          = "",
                    PlaceName        = "",
                    PlaceAddr        = "",
                    CenterName       = "로지스퀘어",
                    Position         = "직급",
                    DeptName         = "부서",
                    ClassType        = 2,
                    RefSeqNo         = "",
                    ComCode          = "",
                    ClientCode       = "3",
                    ClientAdminID    = ""
                };


                //상하차지
                /*
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 2,
                    CallerDetailType = 71,
                    CallerDetailText = "상하차지",
                    Name             = "고객담당",
                    ComName          = "로지스퀘어",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "",
                    CarTon           = "",
                    CarType          = "",
                    PlaceName        = "상차지명",
                    PlaceAddr        = "서울 강남구",
                    CenterName       = "로지스퀘어",
                    Position         = "직급",
                    DeptName         = "부서",
                    ClassType        = 2,
                    RefSeqNo         = "",
                    ComCode          = "",
                    ClientCode       = "",
                    ClientAdminID    = ""
                };
                */

                //로지맨
                /*
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 3,
                    CallerDetailType = 21,
                    CallerDetailText = "로지맨",
                    Name             = "로지맨",
                    ComName          = "",
                    CorpNo           = "",
                    CeoName          = "",
                    CarNo            = "",
                    CarTon           = "",
                    CarType          = "",
                    PlaceName        = "",
                    PlaceAddr        = "",
                    CenterName       = "로지스퀘어",
                    Position         = "직급",
                    DeptName         = "부서",
                    ClassType        = 2,
                    RefSeqNo         = "",
                    ComCode          = "",
                    ClientCode       = "",
                    ClientAdminID    = "sybyun96"
                };
                */
                //미등록
                /*
                CMJsonParamModel objCMJsonParam = new CMJsonParamModel
                {
                    SeqNo            = strSeqNo,
                    CenterCode       = strCenterCode.ToInt(),
                    SndTelNo         = strSndTelNo,
                    RcvTelNo         = strRcvTelNo,
                    CallerType       = 4,
                    CallerDetailType = 99,
                    CallerDetailText = "미등록",
                    Name             = "고객담당",
                    ComName          = "로지스퀘어",
                    CorpNo           = "1908700380",
                    CeoName          = "대표자명",
                    CarNo            = "",
                    CarTon           = "",
                    CarType          = "",
                    PlaceName        = "상차지명",
                    PlaceAddr        = "서울 강남구",
                    CenterName       = "로지스퀘어",
                    Position         = "직급",
                    DeptName         = "부서",
                    ClassType        = 2,
                    RefSeqNo         = "",
                    ComCode          = "",
                    ClientCode       = "",
                    ClientAdminID    = ""
                };
                */

                strCMJsonParam = JsonConvert.SerializeObject(objCMJsonParam);

                var hub = GlobalHost.ConnectionManager.GetHubContext("NotiHub");

                var snapshot = SignalRUsers._joinedUsers;
                var json = Newtonsoft.Json.JsonConvert.SerializeObject(snapshot, Newtonsoft.Json.Formatting.Indented);
                Response.Write(json);
                Response.Write("<BR>");

                if (hub != null)
                {
                    string lo_strConnectionId = SignalRUsers._joinedUsers.FirstOrDefault(u => u.AdminID == strAdminID) ?.ConnectionId;

                    Response.Write("lo_strConnectionId : " + lo_strConnectionId + "<BR>");

                    if (lo_strConnectionId != null)
                    {
                        hub.Clients.Client(lo_strConnectionId).cidReceived(strCMJsonParam, "Y", "Y", "N");
                    }
                }
            }
        }
    }
}