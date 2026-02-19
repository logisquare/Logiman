<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDispatchList.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ListSearch").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 63);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 63);
                return false;
            });

            $("#BtnListSearchReset").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#SearchClientType").val(""),
                $("#SearchClientText").val(""),
                $("#CarNo").val(""),
                $("#DispatchAdminName").val(""),
                $("#GoodsDispatchType").val(""),
                $("#ComName").val(""),
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderItemCode").val("");
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#ChkMyCharge").prop("checked", false);
                $("#ChkMyOrder").prop("checked", false);
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

                if (dateTerm > 30) {
                    fnDefaultAlert("최대 31일까지 조회하실 수 있습니다.", "info");
                    return false;
                }

                var LocationCode = [];
                var ItemCode = [];

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        ItemCode.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: "OrderDispatchListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    ListType: 3,
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    SearchClientType: $("#SearchClientType").val(),
                    SearchClientText: $("#SearchClientText").val(),
                    CarNo: $("#CarNo").val(),
                    DispatchAdminName: $("#DispatchAdminName").val(),
                    GoodsDispatchType: $("#GoodsDispatchType").val(),
                    ComName: $("#ComName").val(),
                    OrderNo: $("#OrderNo").val(),
                    MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N"
                };

                $.fileDownload("/TMS/Dispatch/Proc/OrderDispatchHandler.ashx", {
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
    <style>
        .my-cell-style-color { text-decoration: underline; cursor: pointer; color: #0000ff;}
    </style>
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
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:DropDownList runat="server" ID="SearchClientType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DispatchAdminName" class="type_01" AutoPostBack="false" placeholder="배차자"/>
                </div>
                <div>
                    <asp:DropDownList runat="server" ID="GoodsDispatchType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" ID="ChkMyOrder" Text="<span></span> 내오더"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" ID="ChkMyCharge" Text="<span></span> 내담당"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearchReset" class="btn_02">다시입력</button>
                    &nbsp;
                    <asp:CheckBox runat="server" id="ChkFilter" Text="<span></span>필터유지" Checked="False"/>
                    <asp:CheckBox runat="server" id="ChkSort" Text="<span></span>정렬유지" Checked="False"/>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                    <asp:DropDownList runat="server" ID="DispatchType" CssClass="type_small"></asp:DropDownList>
                    <button type="button" runat="server" class="btn_01" onclick="fnDispatchTypeUpdConfirm();">변경</button>
                    &nbsp;
                    <asp:DropDownList runat="server" ID="LocationCode" CssClass="type_01"></asp:DropDownList>
                    <button type="button" runat="server" class="btn_01" onclick="fnLocationCodeUpdConfirm()">변경</button>
                </li>
                <li class="right">
                    <button type="button" class="btn_02" onclick="fnUnipassPopup();">유니패스</button>
                    &nbsp;
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
                    <ul class="drop_down_btn">
						<li>
							<dl>
								<dt>출력</dt>
								<dd>
									<asp:LinkButton runat="server" title="운송내역서_내수" href="javascript:fnDomesticTransPortPrint();">운송내역서_내수</asp:LinkButton>
                                    <p style="margin:5px 0; border-bottom:1px solid #000; width:100%;"></p>
                                    <asp:LinkButton runat="server" title="운송장_수출입" href="javascript:fnTransPortPrint();">운송장_수출입</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="운송내역서(건)_수출입" href="javascript:fnClientPrint();">운송내역서(건)_수출입</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="운송내역서(기간)_수출입" href="javascript:fnPeriodPrint();">운송내역서(기간)_수출입</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('#OrderDispatchListGrid');">항목순서 초기화</asp:LinkButton>
									<!--<asp:LinkButton runat="server" title="행높이 크게" href="javascript:fnCreateGridSizeLayout('#OrderDispatchListGrid', '38');">행높이 크게</asp:LinkButton>
									<asp:LinkButton runat="server" title="행높이 작게" href="javascript:fnCreateGridSizeLayout('#OrderDispatchListGrid', '25');">행높이 작게</asp:LinkButton>
                                    -->
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="OrderDispatchListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchListGrid');">취소</button>
            </div>
        </div>
    </div>
    <div id="DivDispatchCar">
        <div>
            <h1>오더 배차 목록</h1>
            <a href="#" onclick="fnCloseDispatchCar(); return false;" class="close_btn">x</a>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnResetDispatchCar(); return false;">원래대로</button>
                <button type="button" class="btn_03" onclick="fnCloseDispatchCar(); return false;">닫기</button>
            </div>
            <div class="gridWrap">
                <div id="OrderDispatchCarListGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
