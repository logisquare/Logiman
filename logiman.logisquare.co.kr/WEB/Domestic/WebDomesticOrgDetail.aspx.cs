using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web.UI.WebControls;

namespace WEB.Domestic
{
    public partial class WebDomesticOrgDetail : PageBase
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
            string lo_strOrderNo = string.Empty;
            string lo_strReqSeqNo = string.Empty;

            lo_strOrderNo = Utils.IsNull(SiteGlobal.GetRequestForm("OrderNo"), "");
            lo_strReqSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("ReqSeqNo"), "");

            if (string.IsNullOrWhiteSpace(lo_strOrderNo))
            {
                DisplayMode.Value = "Y";
                ErrMsg.Value = "필요한 정보가 없습니다.";
                return;
            }
            else {
                GetOrderRequestDetail(lo_strReqSeqNo, lo_strOrderNo);
            }
        }

        protected void GetOrderRequestDetail(string lo_strReqSeqNo, string lo_strOrderNo) {

            lo_strReqSeqNo = Utils.IsNull(lo_strReqSeqNo, "0");
            lo_strOrderNo = Utils.IsNull(lo_strOrderNo, "0");
            
            WebReqOrderList lo_objWebReqOrderList = null;
            ServiceResult<WebResOrderList> lo_objWebResOrderList = null;
            WebOrderDasServices lo_objWebOrderDasServices = new WebOrderDasServices();

            try
            {
                lo_objWebReqOrderList = new WebReqOrderList
                {
                    ReqSeqNo = lo_strReqSeqNo.ToInt64(),
                    OrderNo = lo_strOrderNo.ToInt64(),
                    AccessCenterCode = objSes.AccessCenterCode
                };
                
                lo_objWebResOrderList = lo_objWebOrderDasServices.GetWebRequestOrderList(lo_objWebReqOrderList);

                if (lo_objWebResOrderList.result.ErrorCode.IsFail() || !lo_objWebResOrderList.data.RecordCnt.Equals(1))
                {
                    DisplayMode.Value = "Y";
                    ErrMsg.Value = "원본오더 정보를 조회하지 못했습니다.";
                    return;
                }

                CenterCode.Value = lo_objWebResOrderList.data.list[0].CenterCode.ToString();
                OrderNo.Value = lo_objWebResOrderList.data.list[0].OrderNo;

                ReqChargeName.Text = lo_objWebResOrderList.data.list[0].ReqChargeName;
                ReqChargeTeam.Text = lo_objWebResOrderList.data.list[0].ReqChargeTeam;
                ConsignorName.Text = lo_objWebResOrderList.data.list[0].ConsignorName;

                PickupYMD.Text = lo_objWebResOrderList.data.list[0].PickupYMD;
                PickupHM.Text = lo_objWebResOrderList.data.list[0].PickupHM;
                PickupPlace.Text = lo_objWebResOrderList.data.list[0].PickupPlace;
                PickupPlaceChargeName.Text = lo_objWebResOrderList.data.list[0].PickupPlaceChargeName;
                PickupPlaceChargeTelNo.Text = lo_objWebResOrderList.data.list[0].PickupPlaceChargeTelNo;
                PickupPlaceAddr.Text = lo_objWebResOrderList.data.list[0].PickupPlaceAddr;
                PickupPlaceAddrDtl.Text = lo_objWebResOrderList.data.list[0].PickupPlaceAddrDtl;
                PickupPlaceNote.Text = lo_objWebResOrderList.data.list[0].PickupPlaceNote;
                PickupPlaceChargePosition.Text = lo_objWebResOrderList.data.list[0].PickupPlaceChargePosition;
                PickupPlaceChargeTelExtNo.Text = lo_objWebResOrderList.data.list[0].PickupPlaceChargeTelExtNo;
                PickupPlaceChargeCell.Text = lo_objWebResOrderList.data.list[0].PickupPlaceChargeCell;

                GetYMD.Text = lo_objWebResOrderList.data.list[0].GetYMD;
                GetHM.Text = lo_objWebResOrderList.data.list[0].GetHM;
                GetPlace.Text = lo_objWebResOrderList.data.list[0].GetPlace;
                GetPlaceChargeName.Text = lo_objWebResOrderList.data.list[0].GetPlaceChargeName;
                GetPlaceChargeTelNo.Text = lo_objWebResOrderList.data.list[0].GetPlaceChargeTelNo;
                GetPlaceAddr.Text = lo_objWebResOrderList.data.list[0].GetPlaceAddr;
                GetPlaceAddrDtl.Text = lo_objWebResOrderList.data.list[0].GetPlaceAddrDtl;
                GetPlaceNote.Text = lo_objWebResOrderList.data.list[0].GetPlaceNote;
                GetPlaceChargePosition.Text = lo_objWebResOrderList.data.list[0].GetPlaceChargePosition;
                GetPlaceChargeTelExtNo.Text = lo_objWebResOrderList.data.list[0].GetPlaceChargeTelExtNo;
                GetPlaceChargeCell.Text = lo_objWebResOrderList.data.list[0].GetPlaceChargeCell;

                NoteClient.Text = lo_objWebResOrderList.data.list[0].NoteClient;
                GetPlaceNote.Text = lo_objWebResOrderList.data.list[0].GetPlaceNote;
                ReqRegDate.Text = lo_objWebResOrderList.data.list[0].RegDate;

                CarTonCodeM.Text    = lo_objWebResOrderList.data.list[0].CarTonCodeM;
                CarTypeCodeM.Text    = lo_objWebResOrderList.data.list[0].CarTypeCodeM;
                GoodsItemCodeM.Text    = lo_objWebResOrderList.data.list[0].GoodsItemCodeM;
                GoodsRunTypeM.Text    = lo_objWebResOrderList.data.list[0].GoodsRunTypeM;
                Weight.Text    = lo_objWebResOrderList.data.list[0].Weight.ToString();
                Volume.Text    = lo_objWebResOrderList.data.list[0].Volume.ToString();
                Length.Text    = lo_objWebResOrderList.data.list[0].Length.ToString();
                GoodsName.Text    = lo_objWebResOrderList.data.list[0].GoodsName;
                GoodsNote.Text    = lo_objWebResOrderList.data.list[0].GoodsNote;

                if (!lo_objWebResOrderList.data.list[0].OrderNo.Equals(0) || lo_objWebResOrderList.data.list[0].CenterCode.Equals(0))
                {
                    GetOrderFileList(lo_objWebResOrderList.data.list[0].OrderNo, lo_objWebResOrderList.data.list[0].CenterCode);
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("WebDomesticOrgDetail", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9100);
            }
        }

        protected void GetOrderFileList(string lo_intOrderNo, int lo_intCenterCode) {
            ReqOrderFileList lo_objReqOrderFileList = null;
            ServiceResult<ResOrderFileList> lo_objResOrderFileList = null;
            OrderDasServices lo_objOrderDasServices = new OrderDasServices();
            string lo_strText = "";
            try
            {
                lo_objReqOrderFileList = new ReqOrderFileList
                {
                    CenterCode = lo_intCenterCode,
                    OrderNo = lo_intOrderNo.ToInt64(),
                    FileRegType = 2, //등록구분(1: TMS, 2: 웹오더, 3: 앱, 4: 알림톡, 5: 기타)
                    DelFlag = "N",
                    AccessCenterCode = objSes.AccessCenterCode
                };

                lo_objResOrderFileList = lo_objOrderDasServices.GetOrderFileList(lo_objReqOrderFileList);

                if (lo_objResOrderFileList.result.ErrorCode.IsFail())
                {
                    DisplayMode.Value = "Y";
                    ErrMsg.Value = "원본오더 정보를 조회하지 못했습니다.";
                    return;
                }

                if (lo_objResOrderFileList.data.RecordCnt > 0) {
                    for (var i = 0; i < lo_objResOrderFileList.data.RecordCnt; i++)
                    {
                        lo_strText += "<li seq = '" + lo_objResOrderFileList.data.list[i].EncFileSeqNo + "' fname='" + lo_objResOrderFileList.data.list[i].EncFileNameNew + "' flag='" + lo_objResOrderFileList.data.list[i].TempFlag + "' >";
                        lo_strText += "<a href=\"#\" onclick=\"fnDetailDownloadFile(this); return false;\">" + lo_objResOrderFileList.data.list[i].FileName + "</a> ";
                        lo_strText += "</li>\n";
                    }
                    UlFileList.InnerHtml = lo_strText;
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("WebDomesticOrgDetail", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9101);
            }
        }
    }
}