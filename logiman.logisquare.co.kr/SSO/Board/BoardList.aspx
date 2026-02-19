<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BoardList.aspx.cs" Inherits="SSO.Board.BoardList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Board/Proc/BoardList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#SearchText").on("keydown", function(event) {
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

        function fnClosePopUpLayer() {
            fnCloseCpLayer();
            fnCallGridData(GridID);
        }

        function fnBoardIns(n) {
            fnOpenRightSubLayer("게시물 등록", "/SSO/Board/BoardIns?HidMode=Insert", "1024px", "700px", "70%");
            return;
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
                <asp:DropDownList runat="server" ID="UseFlag" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="BoardViewType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="MainDisplayFlag" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="SearchType" CssClass="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="SearchText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  

            <ul class="action">
                <li>
                    <button type="button" runat="server" class="btn_02" onclick="fnBoardIns();">게시글 등록</button>
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
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('BoardManagerListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('BoardManagerListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="BoardManagerListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('BoardManagerListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('BoardManagerListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('BoardManagerListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
