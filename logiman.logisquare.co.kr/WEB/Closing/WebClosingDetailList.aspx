<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebClosingDetailList.aspx.cs" Inherits="WEB.Closing.WebClosingDetailList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/WEB/Closing/Proc/WebClosingDetailList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            if ($("#DisplayMode").val() === "Y") {
                fnDefaultAlert($("#ErrMsg").val(), "warning", "parent.fnCloseCpLayer();");
                return;
            }

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "OrderClosingExcelList",
                    CenterCode: $("#HidCenterCode").val(),
                    SaleClosingSeqNo: $("#HidSaleClosingSeqNo").val()
                };

                $.fileDownload("/WEB/Closing/Proc/WebClosingHandler.ashx", {
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
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="DisplayMode"/>
<asp:HiddenField runat="server" ID="ErrMsg"/>
<asp:HiddenField runat="server" ID="HidSaleClosingSeqNo"/>
<asp:HiddenField runat="server" ID="HidCenterCode"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search" style="text-align:right;">
                        <ul class="drop_btn" style="margin-left:10px;">
						    <li>
							    <dl>
								    <dt>항목 설정</dt>
								    <dd>
									    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('WebClosingDetailListGrid');">항목관리</asp:LinkButton>
									    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('WebClosingDetailListGrid');">항목순서 초기화</asp:LinkButton>
								    </dd>
							    </dl>
						    </li>
					    </ul>
                        &nbsp;&nbsp;
                        <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
                    </div>
                    <div class="grid_list">
                        <div id="WebClosingDetailListGrid"></div>
                    </div>
                </div>
            </div>    
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('WebClosingDetailListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('WebClosingDetailListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('WebClosingDetailListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
