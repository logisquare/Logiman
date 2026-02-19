<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientCsList.aspx.cs" Inherits="TMS.ClientCs.ClientCsList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClientCs/Proc/ClientCsList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "ClientCsExcelList",
                    CenterCode: $("#CenterCode").val(),
                    CsAdminType: $("#CsAdminType").val(),
                    CsAdminName: $("#CsAdminName").val(),
                    ClientName: $("#ClientName").val(),
                    DelFlag: "N"
                };

                $.fileDownload("/TMS/ClientCs/Proc/ClientCsHandler.ashx", {
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
                        console.log(url);
                        console.log(html);
                        $.unblockUI();
                        fnDefaultAlert("나중에 다시 시도해 주세요.");
                    }
                });
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

        function fnClientPlaceIns(n) {
            fnOpenRightSubLayer("고객사 담당자 등록", "/TMS/ClientCs/ClientCsins?HidMode=Insert", "1024px", "700px", "70%");
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
                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="CsAdminType" CssClass="type_01"></asp:DropDownList>
                <asp:TextBox runat="server" ID="CsAdminName" class="type_01" AutoPostBack="false" placeholder="담당자명"/>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="고객사명"/>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  

            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" class="btn_02" onclick="fnClientPlaceIns();">담당자등록</button>
                    <button type="button" runat="server" class="btn_03" onclick="fnClientCsDelConfirm();">담당자삭제</button>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
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
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('ClientCsListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('ClientCsListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="ClientCsListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('ClientCsListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('ClientCsListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('ClientCsListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
