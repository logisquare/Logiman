<%@ WebHandler Language="C#" Class="BoardHandler" %>
using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Web;
using Newtonsoft.Json;

///================================================================
/// <summary>
/// FileName        : BoardHandler.ashx
/// Description     : 담당 고객사 관리
/// Special Logic
///   - Use Session Variables : NONE
///   - Use Server Component  : NONE
///
/// Copyright ⓒ 2018 by LOGISLAB Inc. All rights reserved.
/// Author          : jylee88@logislab.com, 2022-08-02
/// Modify History  : Just Created.
/// </summary>
///================================================================
public class BoardHandler : AshxBaseHandler
{
    //상수 선언
    private const string CurrentMenuLink = "/SSO/Board/BoardUserList"; //필수

    // 메소드 리스트
    private const string MethodBoardList        = "BoardList";
    private const string MethodBoardInsert      = "BoardInsert";
    private const string MethodBoardUpdate      = "BoardUpdate";

    BoardDasServices      objBoardDasServices  = new BoardDasServices();

    private string      strCallType         = string.Empty;
    private int         intPageSize         = 0;
    private int         intPageNo           = 0;

    private string strSeqNo                = string.Empty;
    private string strBoardViewType        = string.Empty;
    private string strBoardKind            = string.Empty;
    private string strMainDisplayFlag      = string.Empty;
    private string strBoardTitle           = string.Empty;

    private string strBoardContent         = string.Empty;
    private string strNewArticleFlag       = string.Empty;
    private string strUseFlag              = string.Empty;
    private string strDateFrom             = string.Empty;
    private string strDateTo               = string.Empty;

    private string strToDayYMD             = string.Empty;
    private string strGradeCode            = string.Empty;
    private string strAccessCenterCode     = string.Empty;
    private string strAccessGradeCode      = string.Empty;
    private string strSearchType           = string.Empty;
    private string strSearchText           = string.Empty;


    ///-------------------------------------------------------
    /// <summary>
    /// 최초실행 메소드 - 해당 메소드의 내용은 변경되지 않음!!
    /// </summary>
    ///-------------------------------------------------------
    public override void ProcessRequest(HttpContext context)
    {
        //# 메소드 별 필요한 메뉴 접근권한 정의
        objMethodAuthList.Add(MethodBoardList,      MenuAuthType.ReadOnly);
        objMethodAuthList.Add(MethodBoardInsert,    MenuAuthType.ReadWrite);
        objMethodAuthList.Add(MethodBoardUpdate,    MenuAuthType.ReadWrite);

        //# 호출 페이지 링크 지정
        SetMenuLink(CurrentMenuLink);

        base.ProcessRequest(context);
        if(base.IsHandlerStop.Equals(true))
        {
            return;
        }

        try
        {
            strCallType  = SiteGlobal.GetRequestForm("CallType");
            intPageSize  = Utils.IsNull(SiteGlobal.GetRequestForm("PageSize"), "0").ToInt();
            intPageNo    = Utils.IsNull(SiteGlobal.GetRequestForm("PageNo"),   "0").ToInt();

            //1.Request
            GetData();
            if (!objResMap.RetCode.Equals(0))
            {
                return;
            }

            //2.처리
            Process();
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9401;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
        finally
        {
            //3. 결과 출력 - 종료
            WriteJsonResponse("BoardHandler");
        }
    }

    ///------------------------------
    /// <summary>
    /// 파라미터 데이터 설정
    /// </summary>
    ///------------------------------
    private void GetData()
    {
        try
        {

            strSeqNo                = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "0");
            strBoardViewType        = Utils.IsNull(SiteGlobal.GetRequestForm("BoardViewType"), "0");
            strBoardKind            = Utils.IsNull(SiteGlobal.GetRequestForm("BoardKind"), "0");
            strMainDisplayFlag      = Utils.IsNull(SiteGlobal.GetRequestForm("MainDisplayFlag"), "");
            strBoardTitle           = Utils.IsNull(SiteGlobal.GetRequestForm("BoardTitle"), "");

            strBoardContent         = Utils.IsNull(SiteGlobal.GetRequestForm("BoardContent", false), "");
            strNewArticleFlag       = Utils.IsNull(SiteGlobal.GetRequestForm("NewArticleFlag"), "");
            strUseFlag              = Utils.IsNull(SiteGlobal.GetRequestForm("UseFlag"), "");
            strDateFrom             = Utils.IsNull(SiteGlobal.GetRequestForm("DateFrom"), "");
            strDateTo               = Utils.IsNull(SiteGlobal.GetRequestForm("DateTo"), "");

            strToDayYMD             = Utils.IsNull(SiteGlobal.GetRequestForm("ToDayYMD"), "");
            strGradeCode            = Utils.IsNull(SiteGlobal.GetRequestForm("GradeCode"), "0");
            strAccessCenterCode     = Utils.IsNull(SiteGlobal.GetRequestForm("AccessCenterCode"), "");
            strAccessGradeCode      = Utils.IsNull(SiteGlobal.GetRequestForm("AccessGradeCode"), "");
            strSearchType           = Utils.IsNull(SiteGlobal.GetRequestForm("SearchType"), "");
            strSearchText           = Utils.IsNull(SiteGlobal.GetRequestForm("SearchText"), "");
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9402;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    ///------------------------------
    /// <summary>
    /// 실행 메소드 처리함수
    /// </summary>
    ///------------------------------
    private void Process()
    {
        try
        {
            switch (strCallType)
            {
                case MethodBoardList:
                    GetBoardList();
                    break;
                case MethodBoardInsert:
                    SetBoardInsert();
                    break;
                case MethodBoardUpdate:
                    SetBoardUpdate();
                    break;
                default:
                    objResMap.RetCode = 9500;
                    objResMap.ErrMsg  = "Wrong Method" + strCallType;
                    break;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9403;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    #region Handler Process

    /// <summary>
    /// 자동배차 롤관리 목록
    /// </summary>
    protected void GetBoardList()
    {
        ReqBoardList                        lo_objReqBoardList  = null;
        ServiceResult<ResBoardList>         lo_objResBoardList = null;

        switch (strSearchType)
        {
            case "Title":
                strBoardTitle = strSearchText;
                break;
        }

        try
        {
            lo_objReqBoardList = new ReqBoardList
            {
                SeqNo           = strSeqNo.ToInt(),
                BoardViewType   = strBoardViewType.ToInt(),
                BoardKind       = strBoardKind.ToInt(),
                MainDisplayFlag = strMainDisplayFlag,
                BoardTitle      = strBoardTitle,

                BoardContent    =  HttpUtility.HtmlEncode(strBoardContent),
                NewArticleFlag  = strNewArticleFlag,
                UseFlag         = strUseFlag,
                ToDayYMD        = strToDayYMD,
                GradeCode       = objSes.GradeCode,

                AccessCenterCode    = objSes.AccessCenterCode,
                AdminID         = objSes.AdminID,
                AdminName       = objSes.AdminName,
                PageSize        = intPageSize,
                PageNo          = intPageNo
            };

            lo_objResBoardList    = objBoardDasServices.GetBoardList(lo_objReqBoardList);
            objResMap.strResponse = "[" + JsonConvert.SerializeObject(lo_objResBoardList) + "]";
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9404;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 게시물 등록
    /// </summary>
    protected void SetBoardInsert()
    {
        BoardViewModel                lo_objBoardViewModel  = null;
        ServiceResult<BoardViewModel> lo_objResBoardViewModel = null;
        if (string.IsNullOrWhiteSpace(strBoardViewType) || strBoardViewType.Equals("0")) {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strMainDisplayFlag) || strMainDisplayFlag.Equals("")) {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strAccessCenterCode) || strAccessCenterCode.Equals("")) {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objBoardViewModel = new BoardViewModel
            {
                BoardViewType    = strBoardViewType.ToInt(),
                BoardKind        = strBoardKind.ToInt(),
                MainDisplayFlag  = strMainDisplayFlag,
                AccessCenterCode = strAccessCenterCode,
                AccessGradeCode  = strAccessGradeCode,
                BoardTitle       = strBoardTitle,
                BoardContent     = strBoardContent,
                UseFlag          = strUseFlag,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName
            };

            lo_objResBoardViewModel = objBoardDasServices.SetBoardIns(lo_objBoardViewModel);
            objResMap.RetCode       = lo_objResBoardViewModel.result.ErrorCode;
            objResMap.Add("SeqNo", lo_objResBoardViewModel.data.SeqNo);

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResBoardViewModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9405;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }

    /// <summary>
    /// 게시물 수정
    /// </summary>
    protected void SetBoardUpdate()
    {
        BoardViewModel                lo_objBoardViewModel  = null;
        ServiceResult<BoardViewModel> lo_objResBoardViewModel = null;
        if (string.IsNullOrWhiteSpace(strBoardViewType) || strBoardViewType.Equals("0")) {
            objResMap.RetCode = 9001;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strMainDisplayFlag) || strMainDisplayFlag.Equals("")) {
            objResMap.RetCode = 9003;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }
        if (string.IsNullOrWhiteSpace(strAccessCenterCode) || strAccessCenterCode.Equals("")) {
            objResMap.RetCode = 9004;
            objResMap.ErrMsg  = "필요한 값이 없습니다.";
            return;
        }

        try
        {
            lo_objBoardViewModel = new BoardViewModel
            {
                SeqNo            = strSeqNo.ToInt(),
                BoardViewType    = strBoardViewType.ToInt(),
                BoardKind        = strBoardKind.ToInt(),
                MainDisplayFlag  = strMainDisplayFlag,
                AccessCenterCode = strAccessCenterCode,
                AccessGradeCode  = strAccessGradeCode,
                BoardTitle       = strBoardTitle,
                BoardContent     = HttpUtility.HtmlEncode(strBoardContent),
                UseFlag          = strUseFlag,
                AdminID          = objSes.AdminID,
                AdminName        = objSes.AdminName
            };

            lo_objResBoardViewModel = objBoardDasServices.SetBoardUpd(lo_objBoardViewModel);
            objResMap.RetCode     = lo_objResBoardViewModel.result.ErrorCode;

            if (objResMap.RetCode.IsFail())
            {
                objResMap.ErrMsg = lo_objResBoardViewModel.result.ErrorMsg;
            }
        }
        catch (Exception lo_ex)
        {
            objResMap.RetCode = 9406;
            objResMap.ErrMsg  = CommonConstant.COMMON_EXCEPTION_MESSAGE;

            SiteGlobal.WriteLog("BoardHandler", "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                objResMap.RetCode);
        }
    }
    #endregion

    ///--------------------------------------------
    /// <summary>
    /// 페이지 기본 Json 응답 출력
    /// </summary>
    ///--------------------------------------------
        public override void WriteJsonResponse(string strLogFileName)
    {
        try
        {
            base.WriteJsonResponse(strLogFileName);
        }
        catch
        {
        }
    }
}