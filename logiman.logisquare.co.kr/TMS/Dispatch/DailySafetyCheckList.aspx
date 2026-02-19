<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DailySafetyCheckList.aspx.cs" Inherits="TMS.Dispatch.DailySafetyCheckList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/DailySafetyCheckList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ComName").on("keyup", function(event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return false;
                }
            });

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
                return false;
            });

            $("#BtnListSearchReset").on("click", function () {
                $("#DateType").val("1");
                $("#DateYMD").datepicker("setDate", GetDateToday("-"));
                $("#ComName").val("");
                $("#ComCorpNo").val("");
                $("#CarNo").val("");
                $("#DriverName").val("");
                $("#DriverCell").val("");
                return false;
            });

            //안전점검표발송
            $("#BtnSafetyCheckSend").on("click", function (e) {
                fnSafetyCheckSend();
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
            return false;
        }
    </script>
    <style>
        .my-cell-style-color { text-decoration: underline; cursor: pointer; color: #0000ff;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_small" AutoPostBack="false" Width="130"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateYMD" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="차량업체명"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01" AutoPostBack="false" placeholder="사업자번호"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" class="type_01" AutoPostBack="false" placeholder="기사명"/>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01" AutoPostBack="false" placeholder="휴대폰번호"/>
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    <button type="button" runat="server" ID="BtnListSearchReset" class="btn_03">다시입력</button>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                    &nbsp;
                </li>
                <li class="right">
                    &nbsp;
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSafetyCheckSend" class="btn_02">안전점검표발송</button>
                    &nbsp;&nbsp;
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '일일안전점검', '일일안전점검');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('DailySafetyCheckListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 저장" href="javascript:fnSaveColumnCustomLayout('DailySafetyCheckListGrid');">항목순서 저장</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('DailySafetyCheckListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="DailySafetyCheckListGrid"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('DailySafetyCheckListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('DailySafetyCheckListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('DailySafetyCheckListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
