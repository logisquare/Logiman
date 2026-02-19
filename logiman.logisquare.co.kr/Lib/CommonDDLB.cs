using CommonLibrary.CommonModel;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Data;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

//===============================================================
// FileName       : CommonDDLB의.cs
// Description    : 공통 DDLB 정의  Class
// Copyright      : 2018 by LogislabInc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonModule
{
    /// <summary>
    /// CommonDDLB의 요약 설명입니다.
    /// </summary>
    public class CommonDDLB
    {

        public static void PAGE_SIZE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("리스트수", CommonConstant.PAGENAVIGATION_LIST));
            DDLB.Items.Add(new ListItem("5",   "5"));
            DDLB.Items.Add(new ListItem("10",  "10"));
            DDLB.Items.Add(new ListItem("20",  "20"));
            DDLB.Items.Add(new ListItem("30",  "30"));
            DDLB.Items.Add(new ListItem("40",  "40"));
            DDLB.Items.Add(new ListItem("50",  "50"));
            DDLB.Items.Add(new ListItem("60",  "60"));
            DDLB.Items.Add(new ListItem("70",  "70"));
            DDLB.Items.Add(new ListItem("80",  "80"));
            DDLB.Items.Add(new ListItem("90",  "90"));
            DDLB.Items.Add(new ListItem("100", "100"));
        }

        public static void USE_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("사용 여부", ""));
            DDLB.Items.Add(new ListItem("사용중",    "Y"));
            DDLB.Items.Add(new ListItem("사용중지",  "N"));
        }

        public static void CONTRACT_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("계약 여부", ""));
            DDLB.Items.Add(new ListItem("계약",   "Y"));
            DDLB.Items.Add(new ListItem("미계약",  "N"));
        }

        public static void ADMIN_GRADE_DDLB(DropDownList DDLB, int GradeCode)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("사용자 등급", ""));
            switch (GradeCode)
            {
                case 1:
                    DDLB.Items.Add(new ListItem("슈퍼관리자",   "1"));
                    DDLB.Items.Add(new ListItem("내부관리자",   "2"));
                    DDLB.Items.Add(new ListItem("최고관리자", "3"));
                    DDLB.Items.Add(new ListItem("관리자", "4"));
                    DDLB.Items.Add(new ListItem("담당자",   "5"));
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
                case 2:
                    DDLB.Items.Add(new ListItem("내부관리자", "2"));
                    DDLB.Items.Add(new ListItem("최고관리자", "3"));
                    DDLB.Items.Add(new ListItem("관리자", "4"));
                    DDLB.Items.Add(new ListItem("담당자", "5"));
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
                case 3:
                    DDLB.Items.Add(new ListItem("최고 관리자", "3"));
                    DDLB.Items.Add(new ListItem("관리자", "4"));
                    DDLB.Items.Add(new ListItem("담당자", "5"));
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
                case 4:
                    DDLB.Items.Add(new ListItem("관리자", "4"));
                    DDLB.Items.Add(new ListItem("담당자", "5"));
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
                case 5:
                    DDLB.Items.Add(new ListItem("담당자", "5"));
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
                case 6:
                    DDLB.Items.Add(new ListItem("고객웹사용자", "6"));
                    break;
            }
        }

        public static void USE_ADMIN_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("사용 여부", ""));
            DDLB.Items.Add(new ListItem("사용중",    "Y"));
            DDLB.Items.Add(new ListItem("사용중지",  "N"));
            DDLB.Items.Add(new ListItem("대기",      "P"));
        }

        public static void CENTER_CODE_DDLB(string strAdminID, DropDownList DDLB, int intDropDownListType = 0)
        {
            DDLB.Items.Clear();
            if (string.IsNullOrWhiteSpace(strAdminID))
            {
                return;
            }

            CenterDasServices            lo_objCenterDasServices = new CenterDasServices();

            ReqCenterList                lo_objReqCenterList  = null;
            ServiceResult<ResCenterList> lo_objResCenterList  = null;

            try
            {
                lo_objReqCenterList = new ReqCenterList{
                    AdminID = strAdminID,
                    PageNo = 0,
                    PageSize = 0
                };

                lo_objResCenterList = lo_objCenterDasServices.GetCenterList(lo_objReqCenterList);

                if (lo_objResCenterList.data.RecordCnt > 1)
                {
                    DDLB.Items.Add(new ListItem("회원사선택", ""));
                }

                foreach (var item in lo_objResCenterList.data.list)
                {
                    if (intDropDownListType.Equals(1))
                    {
                        DDLB.Items.Add(new ListItem(item.CenterName,
                            $"{item.CenterCode}^{item.CenterID}^{item.CenterKey}^{item.CenterName}^{item.CorpNo}"));
                    }
                    else if (intDropDownListType.Equals(2))
                    {
                        DDLB.Items.Add(new ListItem(item.CenterName,
                            $"{item.CenterCode}^{item.CorpNo}"));
                    }
                    else
                    {
                        DDLB.Items.Add(new ListItem(item.CenterName, item.CenterCode.ToString()));
                    }
                }

            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("CommonDDLB", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9988);
            }
        }

        public static void CENTER_CODE_CHKLB(CheckBoxList CHKLB, string strAdminID)
        {
            if (string.IsNullOrWhiteSpace(strAdminID))
            {
                return;
            }

            CenterDasServices lo_objCenterDasServices = new CenterDasServices();

            ReqCenterList lo_objReqCenterList = null;
            ServiceResult<ResCenterList> lo_objResCenterList = null;

            lo_objReqCenterList = new ReqCenterList
            {
                AdminID = strAdminID,
                PageNo = 0,
                PageSize = 0
            };

            lo_objResCenterList = lo_objCenterDasServices.GetCenterList(lo_objReqCenterList);

            CHKLB.Items.Clear();
            foreach (var item in lo_objResCenterList.data.list)
            {
                CHKLB.Items.Add(new ListItem("<span></span>" + item.CenterName, item.CenterCode.ToString()));
            }
        }

        public static void DATE_CHOICE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("날짜", ""));
            DDLB.Items.Add(new ListItem("금일", "1"));
            DDLB.Items.Add(new ListItem("익일", "2"));
            DDLB.Items.Add(new ListItem("전일", "3"));
            DDLB.Items.Add(new ListItem("금주", "6"));
            DDLB.Items.Add(new ListItem("금월", "4"));
            DDLB.Items.Add(new ListItem("전월", "5"));
        }

        //비용구분
        public static void PAY_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("비용구분", ""));
            DDLB.Items.Add(new ListItem("매출", "1"));
            DDLB.Items.Add(new ListItem("매입", "2"));
            DDLB.Items.Add(new ListItem("선급", "3"));
            DDLB.Items.Add(new ListItem("예수", "4"));
        }

        //비용구분(내수)
        public static void PAY_TYPE_DOMESTIC_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("비용구분", ""));
            DDLB.Items.Add(new ListItem("매출",   "1"));
            DDLB.Items.Add(new ListItem("매입",   "2"));
        }

        //오더 상품 구분
        public static void ORDER_ITEM_CHKLB(CheckBoxList CHKLB, bool DomesticFlag, bool InoutFlag, bool ContainerFlag, bool WmsFlag)
        {
            CHKLB.Items.Clear();
            CHKLB.Items.Add(new ListItem("<span class=\"ChkAll\"></span>전체",   ""));
            if (InoutFlag)
            {
                CHKLB.Items.Add(new ListItem("<span></span>항공수출", "OA001"));
                CHKLB.Items.Add(new ListItem("<span></span>항공수입", "OA002"));
                CHKLB.Items.Add(new ListItem("<span></span>해상수출", "OA003"));
                CHKLB.Items.Add(new ListItem("<span></span>해상수입", "OA004"));
            }

            if (ContainerFlag)
            {
                CHKLB.Items.Add(new ListItem("<span></span>컨테이너수출", "OA005"));
                CHKLB.Items.Add(new ListItem("<span></span>컨테이너수입", "OA006"));
            }

            if (DomesticFlag)
            {
                CHKLB.Items.Add(new ListItem("<span></span>내수", "OA007"));
            }

            if (InoutFlag)
            {
                CHKLB.Items.Add(new ListItem("<span></span>내수수출", "OA008"));
                CHKLB.Items.Add(new ListItem("<span></span>내수수입", "OA009"));
            }

            if (WmsFlag)
            {
                CHKLB.Items.Add(new ListItem("<span></span>WMS", "OA010"));
            }
        }

        public static void ORDER_ITEM_DDLB(DropDownList DDLB, bool DomesticFlag, bool InoutFlag, bool ContainerFlag, bool WmsFlag)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("상품구분",   ""));
            if (InoutFlag)
            {
                DDLB.Items.Add(new ListItem("항공수출", "OA001"));
                DDLB.Items.Add(new ListItem("항공수입", "OA002"));
                DDLB.Items.Add(new ListItem("해상수출", "OA003"));
                DDLB.Items.Add(new ListItem("해상수입", "OA004"));
            }

            if (ContainerFlag)
            {
                DDLB.Items.Add(new ListItem("컨테이너수출", "OA005"));
                DDLB.Items.Add(new ListItem("컨테이너수입", "OA006"));
            }

            if (DomesticFlag)
            {
                DDLB.Items.Add(new ListItem("내수", "OA007"));
            }

            if (InoutFlag)
            {
                DDLB.Items.Add(new ListItem("내수수출", "OA008"));
                DDLB.Items.Add(new ListItem("내수수입", "OA009"));
            }

            if (WmsFlag)
            {
                DDLB.Items.Add(new ListItem("WMS", "OA010"));
            }
        }

        public static void KAKAO_USE_STATE_DDLB(bool bAddBlank, DropDownList DDLB)
        {
            DDLB.Items.Clear();
            if (bAddBlank)
            {
                DDLB.Items.Add(new ListItem("등록상태", ""));
            }
            DDLB.Items.Add(new ListItem("요청", "1"));
            DDLB.Items.Add(new ListItem("승인", "2"));
            DDLB.Items.Add(new ListItem("반려", "3"));
        }

        public static void KAKAO_BUTTON_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("웹링크", "WL"));
        }

        public static void SERVER_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("DASD", "DASD"));
            DDLB.Items.Add(new ListItem("PGTXD", "PGTXD"));
            DDLB.Items.Add(new ListItem("CPAPI", "CPAPI"));
        }

        public static void MSG_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("알림서비스유형 선택", ""));
            DDLB.Items.Add(new ListItem("문자메시지",      "1"));
            DDLB.Items.Add(new ListItem("알림톡",        "3"));
            DDLB.Items.Add(new ListItem("SMS인증",      "4"));
        }

        public static void MSG_TYPE_DDLB(int GRADE_CODE, DropDownList DDLB)
        {
            DDLB.Items.Clear();

            if (GRADE_CODE >= 3)
            {
                DDLB.Items.Add(new ListItem("알림서비스유형 선택", ""));
                DDLB.Items.Add(new ListItem("문자메시지",      "1"));
                DDLB.Items.Add(new ListItem("알림톡",        "3"));
            }
            else
            {
                DDLB.Items.Add(new ListItem("알림서비스유형 선택", ""));
                DDLB.Items.Add(new ListItem("문자메시지",      "1"));
                DDLB.Items.Add(new ListItem("알림톡",        "3"));
                DDLB.Items.Add(new ListItem("SMS인증",      "4"));
            }
        }

        public static void RET_CODE_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("전송결과유형 선택", ""));
            DDLB.Items.Add(new ListItem("정상",        "1"));
            DDLB.Items.Add(new ListItem("오류",        "2"));
        }

        public static void HOMETAX_DEPT_USER_REG_TYPE(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("등록 진행상태 선택", ""));
            DDLB.Items.Add(new ListItem("등록요청", "1"));
            DDLB.Items.Add(new ListItem("등록완료", "2"));
            DDLB.Items.Add(new ListItem("등록취소", "3"));
        }

        public static void TMS_USE_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("사용여부", ""));
            DDLB.Items.Add(new ListItem("사용함",  "Y"));
            DDLB.Items.Add(new ListItem("사용안함", "N"));
        }

        public static void TRUST_STATE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("신뢰도", ""));
            DDLB.Items.Add(new ListItem("정상", "1"));
            DDLB.Items.Add(new ListItem("주의", "2"));
            DDLB.Items.Add(new ListItem("악성", "99"));
        }

        public static void CLIENT_CLOSING_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("마감구분", ""));
            DDLB.Items.Add(new ListItem("월별",  "1"));
            DDLB.Items.Add(new ListItem("일별",  "2"));
            DDLB.Items.Add(new ListItem("기타",  "3"));
        }

        public static void CLIENT_BUSINESS_STATUS_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("거래상태", ""));
            DDLB.Items.Add(new ListItem("정상",  "1"));
            DDLB.Items.Add(new ListItem("연장신청",  "2"));
            DDLB.Items.Add(new ListItem("정지대상",  "3"));
            DDLB.Items.Add(new ListItem("정지",  "4"));
        }

        public static void CLIENT_PAY_DAY_OLD_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("결제일", ""));
            DDLB.Items.Add(new ListItem("25", "25"));
            DDLB.Items.Add(new ListItem("30",  "30"));
            DDLB.Items.Add(new ListItem("35",  "35"));
            DDLB.Items.Add(new ListItem("40",  "40"));
            DDLB.Items.Add(new ListItem("45",  "45"));
            DDLB.Items.Add(new ListItem("50",  "50"));
            DDLB.Items.Add(new ListItem("60",  "60"));
            DDLB.Items.Add(new ListItem("기타",  "기타"));
            DDLB.Items.Add(new ListItem("즉시결제",  "즉시결제"));
        }

        public static void CLIENT_PAY_DAY_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("매출여신일", ""));
            DDLB.Items.Add(new ListItem("15일",    "15"));
            DDLB.Items.Add(new ListItem("25일",    "25"));
            DDLB.Items.Add(new ListItem("30일",    "30"));
            DDLB.Items.Add(new ListItem("35일",    "35"));
            DDLB.Items.Add(new ListItem("40일",    "40"));
            DDLB.Items.Add(new ListItem("45일",    "45"));
            DDLB.Items.Add(new ListItem("50일",    "50"));
            DDLB.Items.Add(new ListItem("60일",    "60"));
            DDLB.Items.Add(new ListItem("90일",    "90"));
            DDLB.Items.Add(new ListItem("120일",    "120"));
            DDLB.Items.Add(new ListItem("즉시결제",  "1"));
        }

        public static void BILL_KIND_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("계산서종류",   ""));
            DDLB.Items.Add(new ListItem("일반전자",    "1"));
            DDLB.Items.Add(new ListItem("카고페이위수탁", "2"));
            DDLB.Items.Add(new ListItem("타사위수탁",   "3"));
            DDLB.Items.Add(new ListItem("수기",      "4"));
        }

        //도어 지역명(컨테이너)
        public static void DOOR_PLACE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("DOOR 지역",     ""));
            DDLB.Items.Add(new ListItem("경인",  "001"));
            DDLB.Items.Add(new ListItem("경동", "002"));;

        }

        //상차방법
        public static void PICKUP_WAY_DDLB(DropDownList DDLB, string strNetworkKind = "1")
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("상차방법", ""));

            if (strNetworkKind.Equals("4"))
            {
                DDLB.Items.Add(new ListItem("지게차",  "MoveType06"));
                DDLB.Items.Add(new ListItem("수작업",  "MoveType01"));
                DDLB.Items.Add(new ListItem("호이스트", "MoveType05"));
                DDLB.Items.Add(new ListItem("크레인",  "MoveType03"));
                DDLB.Items.Add(new ListItem("컨베이어", "MoveType04"));
                DDLB.Items.Add(new ListItem("일반",   "MoveType02"));
            }
            else if (strNetworkKind.Equals("6"))
            {
                DDLB.Items.Add(new ListItem("지게차",  "지게차"));
                DDLB.Items.Add(new ListItem("수해줌",  "수해줌"));
                DDLB.Items.Add(new ListItem("수작업",  "수작업"));
                DDLB.Items.Add(new ListItem("호이스트", "호이스트"));
            }
            else
            {
                DDLB.Items.Add(new ListItem("지게차",  "지게차"));
                DDLB.Items.Add(new ListItem("수작업",  "수작업"));
                DDLB.Items.Add(new ListItem("호이스트", "호이스트"));
                DDLB.Items.Add(new ListItem("크레인",  "크레인"));
                DDLB.Items.Add(new ListItem("컨베이어", "컨베이어"));
                DDLB.Items.Add(new ListItem("기타",   "기타"));
            }
        }

        //하차방법
        public static void GET_WAY_DDLB(DropDownList DDLB, string strNetworkKind = "1")
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("하차방법", ""));

            if (strNetworkKind.Equals("4"))
            {
                DDLB.Items.Add(new ListItem("지게차",  "MoveType06"));
                DDLB.Items.Add(new ListItem("수작업",  "MoveType01"));
                DDLB.Items.Add(new ListItem("호이스트", "MoveType05"));
                DDLB.Items.Add(new ListItem("크레인",  "MoveType03"));
                DDLB.Items.Add(new ListItem("컨베이어", "MoveType04"));
                DDLB.Items.Add(new ListItem("일반",   "MoveType02"));
            }
            else if (strNetworkKind.Equals("6"))
            {
                DDLB.Items.Add(new ListItem("지게차",  "지게차"));
                DDLB.Items.Add(new ListItem("수해줌",  "수해줌"));
                DDLB.Items.Add(new ListItem("수작업",  "수작업"));
                DDLB.Items.Add(new ListItem("호이스트", "호이스트"));
            }
            else
            {
                DDLB.Items.Add(new ListItem("지게차",  "지게차"));
                DDLB.Items.Add(new ListItem("수작업",  "수작업"));
                DDLB.Items.Add(new ListItem("호이스트", "호이스트"));
                DDLB.Items.Add(new ListItem("크레인",  "크레인"));
                DDLB.Items.Add(new ListItem("컨베이어", "컨베이어"));
                DDLB.Items.Add(new ListItem("기타",   "기타"));
            }
        }

        public static void CAR_TON_DDLB(Page page, DropDownList DDLB, int nType = 1, string strNetworkKind = "1")
        {
            //nNetworkKind (1:24시콜, 2:화물맨, 3:원콜)

            DataTable list = null;
            DataRow[] row  = null;

            DDLB.Items.Clear();

            DDLB.Items.Add(new ListItem("톤수", ""));

            list = SiteGlobal.ReadCarTon_DataTable(page);

            if (null == list)
            {
                return;
            }

            if (strNetworkKind.Equals("2"))
            {
                row = list.Select("UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND NetworkKind = 2 AND CarTruckName = '전체'");
                list.DefaultView.Sort = "SeqNo ASC";
            }
            else if (strNetworkKind.Equals("3"))
            {
                row = list.Select("UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND NetworkKind = 3");
                list.DefaultView.Sort = "SeqNo ASC";
            }
            else
            {
                row = list.Select("UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND NetworkKind = 1 AND (CarTruckName = '전체' OR (CarTruckName = '다마스' AND CarTon = '0.1'))");
                list.DefaultView.Sort = "SeqNo ASC";
            }

            for (int nLoop = 0; nLoop < row.Length; nLoop++)
            {
                if (nType.Equals(1))
                {
                    DDLB.Items.Add(new ListItem(row[nLoop]["CarTon"].ToString(), row[nLoop]["CarTonCode"].ToString()));
                }
                else if (nType.Equals(2))
                {
                    DDLB.Items.Add(new ListItem(row[nLoop]["CarTon"].ToString(), row[nLoop]["CarTon"].ToString()));
                }
            }

            // 24시콜에 없는 21t 추가
            if (nType.Equals(1))
            {
                DDLB.Items.Add(new ListItem("21", "9999"));
            }
            else if (nType.Equals(2))
            {
                DDLB.Items.Add(new ListItem("21", "21"));
            }
        }

        //실정신고 주민번호 수집 여부
        public static void FPIS_INFORMATION_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("주민번호수집여부", ""));
            DDLB.Items.Add(new ListItem("수집",       "Y"));
            DDLB.Items.Add(new ListItem("미수집",      "N"));
        }

        public static void CAR_TRUCK_DDLB(Page page, string strCarTonCode, DropDownList DDLB, int nType = 1, string strNetworkKind = "1")
        {
            //nNetworkKind (1:24시콜, 2:화물맨, 3:원콜)

            DataTable list = null;
            DataRow[] row  = null;
            DDLB.Items.Clear();

            DDLB.Items.Add(new ListItem("차종", ""));

            list = SiteGlobal.ReadCarTon_DataTable(page);

            if (null == list)
            {
                return;
            }

            if (nType.Equals(1))
            {
                if (strNetworkKind.Equals("2"))
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND CarTruckName <> '전체' AND NetworkKind = 2");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
                else if (strNetworkKind.Equals("3"))
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND NetworkKind = 3");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
                else
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND NetworkKind = 1");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
            }
            else if (nType.Equals(2))
            {
                if (strNetworkKind.Equals("2"))
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND CarTruckName <> '전체' AND NetworkKind = 2");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
                else if (strNetworkKind.Equals("3"))
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND NetworkKind = 3");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
                else
                {
                    row                   = list.Select($"UseFlagTon = 'Y' AND UseFlagTruck = 'Y' AND CarTonCode='{strCarTonCode}' AND NetworkKind = 1");
                    list.DefaultView.Sort = "SeqNo ASC";
                }
            }

            for (int nLoop = 0; nLoop < row.Length; nLoop++)
            {
                if (nType.Equals(1))
                {
                    DDLB.Items.Add(new ListItem(row[nLoop]["CarTruckName"].ToString(), row[nLoop]["CarTruckCode"].ToString()));
                }
                else if (nType.Equals(2))
                {
                    DDLB.Items.Add(new ListItem(row[nLoop]["CarTruckName"].ToString(), row[nLoop]["CarTruckName"].ToString()));
                }
            }

            if (strCarTonCode.Equals("9999") && nType.Equals(0))
            {
                DDLB.Items.Add(new ListItem("카고", "9990"));
                DDLB.Items.Add(new ListItem("카고축", "9991"));
                DDLB.Items.Add(new ListItem("윙바디", "9992"));
            }
            else if (strCarTonCode.Equals("21") && nType.Equals(1))
            {
                DDLB.Items.Add(new ListItem("카고", "카고"));
                DDLB.Items.Add(new ListItem("카고축", "카고축"));
                DDLB.Items.Add(new ListItem("윙바디", "윙바디"));
            }
            else if (strCarTonCode.Equals("13") && nType.Equals(0))
            {
                DDLB.Items.Add(new ListItem("트레일러", "9993"));
            }
            else if (strCarTonCode.Equals("25") && nType.Equals(1))
            {
                DDLB.Items.Add(new ListItem("트레일러", "트레일러"));
            }
        }

        /*차량구분*/
        public static void CAR_DIV_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("차량구분", ""));
            DDLB.Items.Add(new ListItem("직영", "1"));
            //DDLB.Items.Add(new ListItem("", "2"));
            DDLB.Items.Add(new ListItem("단기", "3"));
            DDLB.Items.Add(new ListItem("지입", "4"));
            DDLB.Items.Add(new ListItem("협력", "5"));
            DDLB.Items.Add(new ListItem("고정", "6"));
        }

        /*업체과세구분*/
        public static void COM_TAX_KIND_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("과세구분",   ""));
            DDLB.Items.Add(new ListItem("과세",     "1"));
            DDLB.Items.Add(new ListItem("면세",     "2"));
            DDLB.Items.Add(new ListItem("간이",     "3"));
            DDLB.Items.Add(new ListItem("간이-계산서발행", "4"));
        }

        /*비용과세구분*/
        public static void PAY_TAX_KIND_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("과세구분",   ""));
            DDLB.Items.Add(new ListItem("과세",     "1"));
            DDLB.Items.Add(new ListItem("면세",     "2"));
            DDLB.Items.Add(new ListItem("간이",     "3"));
            DDLB.Items.Add(new ListItem("간이-계산서발행", "4"));
            DDLB.Items.Add(new ListItem("영세",     "5"));
        }

        /*오더업체구분 - 컨테이너*/
        public static void ORDER_CLIENT_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("업체구분",  ""));
            DDLB.Items.Add(new ListItem("발주처",   "1"));
            DDLB.Items.Add(new ListItem("청구처",   "2"));
            DDLB.Items.Add(new ListItem("화주",    "3"));
            DDLB.Items.Add(new ListItem("차량업체명", "4"));
            DDLB.Items.Add(new ListItem("차량번호",  "5"));
            DDLB.Items.Add(new ListItem("작업지",   "6"));
        }

        /*오더업체구분 - 오더*/
        public static void ORDER_CLIENT_COMMON_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("업체구분",  ""));
            DDLB.Items.Add(new ListItem("발주처",   "1"));
            DDLB.Items.Add(new ListItem("청구처",   "2"));
            DDLB.Items.Add(new ListItem("화주",    "3"));
        }

        /*오더담당구분*/
        public static void ORDER_CHARGE_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("담당구분",   ""));
            DDLB.Items.Add(new ListItem("발주처담당",  "1"));
            DDLB.Items.Add(new ListItem("청구처담당",  "2"));
            DDLB.Items.Add(new ListItem("청구처사업장", "3"));
            DDLB.Items.Add(new ListItem("오더접수자",  "4"));
        }

        /*오더상하차지구분*/
        public static void ORDER_PLACE_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("상하차지구분",   ""));
            DDLB.Items.Add(new ListItem("상차지",  "1"));
            DDLB.Items.Add(new ListItem("하차지",  "2"));
        }

        /// <summary>
        /// 오더 상태
        /// </summary>
        /// <param name="CHKLB"></param>
        public static void ORDER_STATUS_CHKLB(CheckBoxList CHKLB)
        {
            CHKLB.Items.Clear();
            CHKLB.Items.Add(new ListItem("<span class=\"ChkAll\"></span>전체", ""));
            CHKLB.Items.Add(new ListItem("<span></span>등록",                  "1"));
            CHKLB.Items.Add(new ListItem("<span></span>접수",                  "2"));
            CHKLB.Items.Add(new ListItem("<span></span>배차",                  "3"));
            CHKLB.Items.Add(new ListItem("<span></span>직송상차",                "4"));
            CHKLB.Items.Add(new ListItem("<span></span>직송하차",                "5"));
            CHKLB.Items.Add(new ListItem("<span></span>집하상차",                "6"));
            CHKLB.Items.Add(new ListItem("<span></span>집하하차",                "7"));
            CHKLB.Items.Add(new ListItem("<span></span>간선상차",                "8"));
            CHKLB.Items.Add(new ListItem("<span></span>간선하차",                "9"));
            CHKLB.Items.Add(new ListItem("<span></span>배송상차",                "10"));
            CHKLB.Items.Add(new ListItem("<span></span>배송하차",                "11"));
        }

        /// <summary>
        /// 은행코드
        /// </summary>
        /// <param name="DDLB"></param>
        public static void BANK_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("은행",  ""));

            ReqBankList                lo_objReqBankList    = null;
            ServiceResult<ResBankList> lo_objResBankList    = null;
            CommonDasServices          objCommonDasServices = new CommonDasServices();

            try
            {
                lo_objReqBankList = new ReqBankList
                {
                    BankCode = string.Empty,
                    BankName = string.Empty,
                    PageSize = 0,
                    PageNo   = 0
                };

                lo_objResBankList     = objCommonDasServices.GetBankList(lo_objReqBankList);
                if (lo_objResBankList.result.ErrorCode.IsSuccess())
                {
                    foreach (BankModel objBankModel in lo_objResBankList.data.list)
                    {
                        DDLB.Items.Add(new ListItem(objBankModel.BankName, objBankModel.BankCode));
                    }
                }
            }
            catch (Exception)
            {
            }
        }

        /// <summary>
        /// 관리 항목(일반)
        /// </summary>
        public static void ITEM_DDLB(Page page, DropDownList DDLB, string strGroupCode, string strAccessCenterCode, string strAdminID, string strTitle = "")
        {
            string    lo_strGroupName = string.Empty;
            DataTable lo_objCodeTable = null;

            lo_objCodeTable = CommonUtils.Utils.GetItemList(page, strGroupCode, strAccessCenterCode, strAdminID, out lo_strGroupName);

            if (lo_objCodeTable == null)
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(strTitle))
            {
                strTitle = lo_strGroupName;
            }

            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem(strTitle, ""));

            foreach (DataRow row in lo_objCodeTable.Rows)
            {
                DDLB.Items.Add(new ListItem(row["ItemName"].ToString(), row["ItemFullCode"].ToString()));
            }
        }

        /// <summary>
        /// 관리 항목(일반)
        /// </summary>
        public static void ITEM_NAME_DDLB(Page page, DropDownList DDLB, string strGroupCode, string strAccessCenterCode, string strAdminID, string strTitle = "")
        {
            string    lo_strGroupName = string.Empty;
            DataTable lo_objCodeTable = null;

            lo_objCodeTable = CommonUtils.Utils.GetItemList(page, strGroupCode, strAccessCenterCode, strAdminID, out lo_strGroupName);

            if (lo_objCodeTable == null)
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(strTitle))
            {
                strTitle = lo_strGroupName;
            }

            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem(strTitle, ""));

            foreach (DataRow row in lo_objCodeTable.Rows)
            {
                DDLB.Items.Add(new ListItem(row["ItemName"].ToString(), row["ItemName"].ToString()));
            }
        }

        /// <summary>
        /// 관리 항목(일반)
        /// </summary>
        public static void ITEM_CHKLB(Page page, CheckBoxList CHKLB, string strGroupCode, string strAccessCenterCode, string strAdminID)
        {
            string    lo_strGroupName  = string.Empty;
            DataTable lo_objCodeTable  = null;
            ListItem  lo_objChkAllItem = new ListItem("<span class=\"ChkAll\"></span>전체", "");

            lo_objCodeTable = CommonUtils.Utils.GetItemList(page, strGroupCode, strAccessCenterCode, strAdminID, out lo_strGroupName);

            if (lo_objCodeTable == null)
            {
                return;
            }

            CHKLB.Items.Clear();
            CHKLB.Items.Add(lo_objChkAllItem);

            foreach (DataRow row in lo_objCodeTable.Rows)
            {
                CHKLB.Items.Add(new ListItem("<span></span>" + row["ItemName"].ToString(), row["ItemFullCode"].ToString()));
            }
        }

        public static void CENTER_TYPE_DDLB(DropDownList DDLB, int GradeCode) {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("선택", ""));
            if (GradeCode.Equals(2) || GradeCode.Equals(1)) {
                DDLB.Items.Add(new ListItem("본부", "1"));
            }
            DDLB.Items.Add(new ListItem("가맹 계열사", "2"));
            DDLB.Items.Add(new ListItem("일반", "3"));
        }

        /*배차구분*/
        public static void DISPATCH_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("배차구분", ""));
            DDLB.Items.Add(new ListItem("직송", "1"));
            DDLB.Items.Add(new ListItem("집하", "2"));
            DDLB.Items.Add(new ListItem("간선", "3"));
            DDLB.Items.Add(new ListItem("배송", "4"));
        }

        /*화물정보 배차구분*/
        public static void GOODS_DISPATCH_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("배차구분", ""));
            DDLB.Items.Add(new ListItem("직송", "2"));
            DDLB.Items.Add(new ListItem("집하", "3"));
        }

        public static void RUN_TYPE_DDLB_OLD(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("운행구분", ""));
            DDLB.Items.Add(new ListItem("편도",   "6"));
            //DDLB.Items.Add(new ListItem("운행",   "2"));
            DDLB.Items.Add(new ListItem("경유", "7"));
            DDLB.Items.Add(new ListItem("혼적", "4"));
            DDLB.Items.Add(new ListItem("왕복", "5"));
            DDLB.Items.Add(new ListItem("기타", "3"));
        }

        public static void RUN_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("편도/왕복", ""));
            DDLB.Items.Add(new ListItem("편도",    "1"));
            DDLB.Items.Add(new ListItem("왕복",    "2"));
            DDLB.Items.Add(new ListItem("기타",    "3"));
        }

        public static void CAR_FIXED_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("고정/용차", ""));
            DDLB.Items.Add(new ListItem("고정",    "Y"));
            DDLB.Items.Add(new ListItem("용차",    "N"));
        }

        /*운송사 빠른입금 구분*/
        public static void QUICK_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("일반지급", "1"));
            DDLB.Items.Add(new ListItem("바로지급", "2"));
            DDLB.Items.Add(new ListItem("14일지급", "3"));
        }

        public static void CAR_PAY_DAY_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("한달 후 금요일", "0"));
            DDLB.Items.Add(new ListItem("5일",            "5"));
            DDLB.Items.Add(new ListItem("10일",           "10"));
            DDLB.Items.Add(new ListItem("15일",           "15"));
            DDLB.Items.Add(new ListItem("20일",           "20"));
            DDLB.Items.Add(new ListItem("25일",           "25"));
            //DDLB.Items.Add(new ListItem("마감 후 28일", "28"));
            DDLB.Items.Add(new ListItem("말일",           "30"));
            DDLB.Items.Add(new ListItem("40일",           "40"));
            DDLB.Items.Add(new ListItem("45일",           "45"));
            DDLB.Items.Add(new ListItem("60일",           "60"));
        }

        public static void SORT_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("오더정렬기준",     ""));
            DDLB.Items.Add(new ListItem("상차일 최신순",   "1"));
            DDLB.Items.Add(new ListItem("오더상태순", "2"));
            DDLB.Items.Add(new ListItem("오더등록 과거순", "3"));
            DDLB.Items.Add(new ListItem("오더등록 최신순", "4"));
        }

        //요율표 구분(1:차량톤급, 2:시간(PickupHM/GetHM차이), 3:수량(EA,Volume), 4:부피(CBM), 5:중량(KG,Weight), 6:길이(CM,Length), 7:경유지)
        public static void RATE_TYPE_DDLB(DropDownList DDLB, int lo_intRateType = 0)
        {
            DDLB.Items.Clear();
            if (lo_intRateType.Equals(0))
            {
                DDLB.Items.Add(new ListItem("요율표 구분", ""));
                DDLB.Items.Add(new ListItem("차량톤급요율", "1"));
                DDLB.Items.Add(new ListItem("시간요율", "2"));
                DDLB.Items.Add(new ListItem("수량요율", "3"));
                DDLB.Items.Add(new ListItem("부피요율", "4"));
                DDLB.Items.Add(new ListItem("중량요율", "5"));
                DDLB.Items.Add(new ListItem("길이요율", "6"));
            }
            else if(lo_intRateType.Equals(4))
            {
                DDLB.Items.Add(new ListItem("경유지", "7"));
            }
            else if (lo_intRateType.Equals(5))
            {
                DDLB.Items.Add(new ListItem("유가연동", "8"));
            }

        }

        //운송구분(FTL(독차) 여부) : N:혼적, Y:독차
        public static void FTL_FLAG_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("운송구분", ""));
            DDLB.Items.Add(new ListItem("혼적", "N"));
            DDLB.Items.Add(new ListItem("독차", "Y"));
        }

        public static void OIL_AREA_DDLB(DropDownList DDLB, string lo_strPlaceHolderText = "")
        {
            if (!lo_strPlaceHolderText.Equals(""))
            {
                DDLB.Items.Add(new ListItem(lo_strPlaceHolderText, ""));
            }
            else
            {
                DDLB.Items.Add(new ListItem("지역(전국)", ""));
            }
            DDLB.Items.Add(new ListItem("서울", "서울"));
            DDLB.Items.Add(new ListItem("경기", "경기"));
            DDLB.Items.Add(new ListItem("강원", "강원"));
            DDLB.Items.Add(new ListItem("충북", "충북"));
            DDLB.Items.Add(new ListItem("충남", "충남"));
            DDLB.Items.Add(new ListItem("전북", "전북"));
            DDLB.Items.Add(new ListItem("전남", "전남"));
            DDLB.Items.Add(new ListItem("경북", "경북"));
            DDLB.Items.Add(new ListItem("경남", "경남"));
            DDLB.Items.Add(new ListItem("부산", "부산"));
            DDLB.Items.Add(new ListItem("제주", "제주"));
            DDLB.Items.Add(new ListItem("대구", "대구"));
            DDLB.Items.Add(new ListItem("인천", "인천"));
            DDLB.Items.Add(new ListItem("광주", "광주"));
            DDLB.Items.Add(new ListItem("대전", "대전"));
            DDLB.Items.Add(new ListItem("울산", "울산"));
            DDLB.Items.Add(new ListItem("세종", "세종"));
        }

        public static void ROUND_AMT_KIND_DDLB(DropDownList DDLB, string lo_strPlaceHolderText = "")
        {
            if (!lo_strPlaceHolderText.Equals(""))
            {
                DDLB.Items.Add(new ListItem(lo_strPlaceHolderText, ""));
            }
            else
            {
                DDLB.Items.Add(new ListItem("단위 선택", ""));
            }
            DDLB.Items.Add(new ListItem("원", "1"));
            DDLB.Items.Add(new ListItem("십원", "10"));
            DDLB.Items.Add(new ListItem("백원", "100"));
            DDLB.Items.Add(new ListItem("천원", "1000"));
        }

        public static void ROUND_TYPE_DDLB(DropDownList DDLB, string lo_strPlaceHolderText = "")
        {
            if (!lo_strPlaceHolderText.Equals(""))
            {
                DDLB.Items.Add(new ListItem(lo_strPlaceHolderText, ""));
            }
            else
            {
                DDLB.Items.Add(new ListItem("단위 조건 선택", ""));
            }
            DDLB.Items.Add(new ListItem("절삭", "F"));
            DDLB.Items.Add(new ListItem("반올림", "R"));
            DDLB.Items.Add(new ListItem("올림", "C"));
        }

        //산재보험신고(1: 포함, 2: 제외-24시콜, 3: 제외-화물맨, 4: 제외-원콜, 9: 제외-기타)
        public static void INSURE_EXCEPT_KIND_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Add(new ListItem("산재보험신고",  ""));
            DDLB.Items.Add(new ListItem("포함",      "1"));
            DDLB.Items.Add(new ListItem("제외-24시콜", "2"));
            DDLB.Items.Add(new ListItem("제외-화물맨",  "3"));
            DDLB.Items.Add(new ListItem("제외-원콜",   "4"));
            DDLB.Items.Add(new ListItem("제외-화물마당",   "5"));
            DDLB.Items.Add(new ListItem("제외-기타",   "9"));
        }

        //카고패스 톤수
        public static void CARGOPASS_CARTON_DDLB(DropDownList DDLB)
        {
            string    lo_strFileName = CommonConstant.M_CARGOPASS_CARTON_JSON;
            string    lo_strJson     = string.Empty;
            DataTable list           = null;

            DDLB.Items.Add(new ListItem("톤수",  ""));

            try
            {
                if (!File.Exists(lo_strFileName))
                {
                    return;
                }

                lo_strJson = File.ReadAllText(lo_strFileName);
                list       = JsonConvert.DeserializeObject<DataTable>(lo_strJson);

                if (list == null)
                {
                    return;
                }

                foreach (DataRow objRow in list.Rows)
                {
                    DDLB.Items.Add(new ListItem(objRow["CarTon"].ToString(), objRow["CarTon"].ToString()));
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("CommonDDLB", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9988);
            }
        }

        //카고패스 차종
        public static void CARGOPASS_CARTRUCK_DDLB(DropDownList DDLB)
        {
            string    lo_strFileName = CommonConstant.M_CARGOPASS_CARTRUCK_JSON;
            string    lo_strJson     = string.Empty;
            DataTable list           = null;

            DDLB.Items.Add(new ListItem("차종", ""));

            try
            {
                if (!File.Exists(lo_strFileName))
                {
                    return;
                }

                lo_strJson = File.ReadAllText(lo_strFileName);
                list       = JsonConvert.DeserializeObject<DataTable>(lo_strJson);

                if (list == null)
                {
                    return;
                }

                foreach (DataRow objRow in list.Rows)
                {
                    DDLB.Items.Add(new ListItem(objRow["CarTruckName"].ToString(), objRow["CarTruckName"].ToString()));
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("CommonDDLB", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    9988);
            }
        }

        public static void CS_ADMIN_TYPE_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("담당구분", ""));
            DDLB.Items.Add(new ListItem("업무",   "1"));
            DDLB.Items.Add(new ListItem("마감",    "2"));
        }

        public static void CHANNEL_TYPE_DDLB(DropDownList DDLB, bool withOSFlag = false)
        {
            DDLB.Items.Clear();
            DDLB.Items.Add(new ListItem("통신사",          ""));
            DDLB.Items.Add(new ListItem("KT",           "kt"));
            DDLB.Items.Add(new ListItem("LG U+",        "lguplus"));
            DDLB.Items.Add(new ListItem("SK Broadband", "skbroadband"));
            DDLB.Items.Add(new ListItem("LG IMS",       "lgims"));
            if (withOSFlag)
            {
                DDLB.Items.Add(new ListItem("Android", "android"));
                DDLB.Items.Add(new ListItem("iOS", "ios"));
            }
        }
    }
}