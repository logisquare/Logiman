<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="PurchaseClosingDetailList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseClosingDetailList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseClosingDetailList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                if (!$("#CenterCode").val() || !$("#PurchaseClosingSeqNo").val()) {
                    return false;
                }

                var objParam = {
                    CallType: "PurchaseClosingPayListExcel",
                    CenterCode: $("#CenterCode").val(),
                    PurchaseClosingSeqNo: $("#PurchaseClosingSeqNo").val()
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseClosingHandler.ashx", {
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
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="PurchaseClosingSeqNo"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search" style="text-align: right;">
                        &nbsp;
                        <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download" style=" margin-right: 10px;">엑셀다운로드</button>
                        <ul class="drop_btn" style="float: right; margin-right: 20px;">
                            <li>
                                <dl>
                                    <dt>항목 설정</dt>
                                    <dd>
                                        <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '매입마감상세내역', '매입마감상세내역');">엑셀다운로드</asp:LinkButton>
                                        <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PurchaseClosingOrderListGrid', this);">항목관리</asp:LinkButton>
                                        <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseClosingOrderListGrid');">항목순서 초기화</asp:LinkButton>
                                    </dd>
                                </dl>
                            </li>
                        </ul>
                    </div>
                    <div class="grid_list">
                        <div id="PurchaseClosingOrderListGrid"></div>
                        <div id="page"></div>
                        <!-- 검색 다이얼로그 UI -->
                        <div id="gridDialog" title="Grid 검색">
                            <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                            <div>
                                <select id="GridSearchDataField" class="type_01">
                                    <option value="ALL">전체</option>
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
                        <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PurchaseClosingOrderListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
                        <div id="GridColumn"></div>
                        <div class="gird_button">
                            <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PurchaseClosingOrderListGrid');">저장</button>
                            &nbsp;&nbsp;
                            <button type="button" class="cancel" onclick="fnCloseColumnLayout('PurchaseClosingOrderListGrid');">취소</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
