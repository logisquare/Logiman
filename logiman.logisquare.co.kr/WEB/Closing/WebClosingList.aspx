<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebClosingList.aspx.cs" Inherits="WEB.Closing.WebClosingList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/WEB/Closing/Proc/WebClosingList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ListSearch").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });
        });

        function fnAjaxSaveExcel(objData) {

            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }

            return;
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_02"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                &nbsp;&nbsp;<span>계산서 발행상태</span>
                <asp:DropDownList runat="server" ID="BillStatus" class="type_01" width="100"></asp:DropDownList>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('WebClosingListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('WebClosingListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="WebClosingListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('WebClosingListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('WebClosingListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('WebClosingListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
