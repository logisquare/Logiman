<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseInsureList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseInsureList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseInsureList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ComCorpNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#CarNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#DriverName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#DriverCell").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ComCorpNo").val("");
                $("#CarNo").val("");
                $("#DriverName").val("");
                $("#DriverCell").val("");
                $("#InformationFlag").val("");
                $("#InsureExceptKind").val("1");
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                if (!$("#CenterCode").val()) {
                    fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                    return false;
                }

                var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

                if (dateTerm > 30) {
                    fnDefaultAlert("최대 31일까지 조회하실 수 있습니다.", "info");
                    return false;
                }

                var objParam = {
                    CallType: "PurchaseInsureListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    InformationFlag: $("#InformationFlag").val(),
                    InsureExceptKind: $("#InsureExceptKind").val()
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseInsureHandler.ashx", {
                    httpMethod: "POST",
                    data: objParam,
                    prepareCallback: function () {
                        UTILJS.Ajax.fnAjaxBlock();
                    },
                    successCallback: function (url) {
                        $.unblockUI();
                        fnDefaultAlert("엑셀을 다운로드 하였습니다.", "success");
                    },
                    failCallback: function (html, url) {
                        $.unblockUI();
                        fnDefaultAlert("나중에 다시 시도해 주세요.");
                    }
                });
            });

            //알림톡발송
            $("#BtnSendAgreement").on("click", function (e) {
                fnSendAgreement();
                return false;
            });
        });

        function fnAjaxSaveExcel(objData) {
            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }
            return;
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                    <asp:DropDownList runat="server" ID="InformationFlag" class="type_01"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="InsureExceptKind" CssClass="type_01" Width="128"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호" Width="115"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" CssClass="type_01" AutoPostBack="false" placeholder="기사명" Width="115"></asp:TextBox>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="기사휴대폰"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>  
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    <strong>※ 산재보험 월보수액(예상) 신고를 위한 기초 자료이며, 정확한 신고자료 작성은 별도로 진행하셔야 합니다.</strong>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSendAgreement" class="btn_02" width="200">주민번호수집 알림톡발송</button>
                    &nbsp;<button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '산재보험현황', '산재보험현황');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PurchaseInsureListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseInsureListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="PurchaseInsureListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>기사명
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="DriverName">기사명</option>
                        <option value="DriverCell">기사휴대폰</option>
                        <option value="OrderNo">접수번호</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PurchaseInsureListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PurchaseInsureListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('PurchaseInsureListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
