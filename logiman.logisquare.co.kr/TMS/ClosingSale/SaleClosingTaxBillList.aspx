 <%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SaleClosingTaxBillList.aspx.cs" Inherits="TMS.ClosingSale.SaleClosingTaxBillList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSale/Proc/SaleClosingTaxBillList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#CorpName").on("keyup", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#CorpNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#ChargeName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#ChargeEmail").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 60);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ReqStatCode").val("");
                $("#StatCode").val("");
                $("#CorpName").val("");
                $("#CorpNo").val("");
                $("#ChargeName").val("");
                $("#ChargeEmail").val("");
                return;
            });

            //발행취소
            /*
            $("#BtnCnlBill").on("click", function (e) {
                fnCnlTaxBill();
                return false;
            });
            */
        });
        
        function fnReloadPageNotice(strMsg) {
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="ClosingType" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="작성일 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="작성일 To"/>
                    <asp:DropDownList runat="server" ID="ReqStatCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="StatCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                       
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:TextBox runat="server" ID="CorpName" class="type_01" AutoPostBack="false" placeholder="거래처명"/>
                    <asp:TextBox runat="server" ID="CorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="사업자번호"/>
                    <asp:TextBox runat="server" ID="ChargeName" class="type_01" AutoPostBack="false" placeholder="담당자"/>
                    <asp:TextBox runat="server" ID="ChargeEmail" class="type_01" AutoPostBack="false" placeholder="이메일"/>
                </div>
            </div>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnCnlBill" class="btn_03" style="display: none;">발행취소</button>
                </li>
            </ul>

            <div id="SaleClosingTaxBillListGrid"></div>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('SaleClosingTaxBillListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('SaleClosingTaxBillListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('SaleClosingTaxBillListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
