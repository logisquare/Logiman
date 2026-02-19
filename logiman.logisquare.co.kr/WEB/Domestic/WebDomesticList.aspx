<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebDomesticList.aspx.cs" Inherits="WEB.Domestic.WebDomesticList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/WEB/Domestic/Proc/WebDomesticList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#SearchText").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#SearchType").on("change", function (event) {
                if ($(this).val() === "") {
                    $("#SearchText").val("");
                    $("#SearchText").attr("readonly", true);
                } else {
                    $("#SearchText").attr("readonly", false);
                }
            });

            if ($("#SearchType").val() === "") {
                $("#SearchText").val("");
                $("#SearchText").attr("readonly", true);
            }
            
            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 186);
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

                if (dateTerm > 31) {
                    fnDefaultAlert("최대 31일까지 조회하실 수 있습니다.", "info");
                    return false;
                }

                var objParam = {
                    CallType: "WebOrderExcelList",
                    CenterCode: $("#CenterCode").val(),
                    ListType: "1",
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderStatuses: $("#OrderStatus").val(),
                    SearchText: $("#SearchText").val(),
                    OrderRegType: "5",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
                    CnlFlag: $("#ChkCnl").is(":checked") ? "Y" : "N"
                };

                $.fileDownload("/WEB/Domestic/Proc/WebDomesticHandler.ashx", {
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
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidOrderNo" />
    <asp:HiddenField runat="server" ID="HidGoodsSeqNo" />
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" ></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span>오더상태</span>
                <asp:DropDownList runat="server" ID="OrderStatus" class="type_01" width="100"></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span>검색어</span>
                <asp:DropDownList runat="server" ID="SearchType" class="type_01" width="100"></asp:DropDownList>
                <asp:TextBox runat="server" id="SearchText" ToolTip="검색어 입력" CssClass="type_01" placeholder="검색어 입력"></asp:TextBox>
                &nbsp;&nbsp;
                <asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더"/>
				&nbsp;&nbsp;
                <asp:CheckBox runat="server" id="ChkCnl" Text="<span></span>취소오더"/>
                &nbsp;&nbsp;
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  

            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" class="btn_01" onclick="fnWebDomesticIns();">오더등록</button>
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
                    <button type="button" class="btn_02" onclick="fnPrintList();">운송내역서</button>
                    
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('WebDomesticListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('WebDomesticListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="WebDomesticListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('WebDomesticListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('WebDomesticListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('WebDomesticListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="DivDispatchCar">
        <div>
            <h1>오더 배차 목록</h1>
            <a href="#" onclick="fnCloseDispatchCar(); return false;" class="close_btn">x</a>
            <div class="gridWrap" style="margin-top:10px;">
                <div id="OrderDispatchCarListGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
