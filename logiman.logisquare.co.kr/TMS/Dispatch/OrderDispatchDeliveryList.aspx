<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDispatchDeliveryList.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchDeliveryList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchDeliveryList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var LocationCode = [];
                var ItemCode = [];
                var OrderStatus = [];

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

                $.each($("#OrderStatus input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        OrderStatus.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: "OrderDispatchListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    OrderStatuses: OrderStatus.join(","),
                    SearchClientType: $("#SearchClientType").val(),
                    SearchClientText: $("#SearchClientText").val(),
                    CarNo: $("#CarNo").val(),
                    DispatchAdminName: $("#DispatchAdminName").val(),
                    GoodsDispatchType: $("#GoodsDispatchType").val(),
                    ComName: $("#ComName").val(),
                    OrderNo: $("#OrderNo").val(),
                    MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
                    PageNo: $("#PageNo").val(),
                    PageSize: $("#PageSize").val()
                };

                $.fileDownload("/TMS/Dispatch/Proc/OrderDispatchDeliveryHandler.ashx", {
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

        function fnClosePopUpLayer() {
            fnCloseCpLayer();
            fnCallGridData(GridID);
        }

        function fnDispatchCostIns() {
            window.open("/TMS/Dispatch/OrderDispatchCostIns?GoodsDispatchType=4", "차량 비용등록", "width=1620, height=850px, scrollbars=Yes");
            return;
        }

        function fnCarIns(n) {
            fnOpenRightSubLayer("차량업체 통합등록", "/TMS/Car/CarDispatchRefins?HidMode=Insert", "1024px", "700px", "80%");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="RefSeqNo" />
    <asp:HiddenField runat="server" ID="CarSeqNo" />

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
                    <asp:TextBox runat="server" id="ViewDeliveryLocationCode" ToolTip="배송사업장" CssClass="type_01 SearchConditions" placeholder="배송사업장" readonly></asp:TextBox>
                    <div id="DivDeliveryLocationCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="DeliveryLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:DropDownList runat="server" ID="SearchClientType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    
                </div>
                <div>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    &nbsp;&nbsp;
                    <asp:TextBox runat="server" ID="DispatchAdminName" class="type_01" AutoPostBack="false" placeholder="배차자"/>
                    &nbsp;&nbsp;
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                    <asp:TextBox runat="server" ID="SearchCarNo" CssClass="type_01 ml_0 find" placeholder="차량번호 검색"></asp:TextBox>
                    <button type="button" class="btn_03" id="BtnCarNoReset" style="display:none;">다시입력</button>
                    <asp:DropDownList runat="server" ID="QuickType" CssClass="type_01"></asp:DropDownList>
                    <button type="button" runat="server" class="btn_01" onclick="fnOrderDispatchInsConfirm();">배차 등록</button>
                    <button type="button" runat="server" class="btn_03" onclick="fnOrderDispatchCnlConfirm();">배차 취소</button>
                </li>
                <li class="right">
                    <button type="button" runat="server" class="btn_01" onclick="fnCarIns();">차량업체등록</button>
                    &nbsp;
                    <button type="button" runat="server" class="btn_01" onclick="fnDispatchCostIns();">비용등록</button>
                    &nbsp;
                    <button type="button" runat="server" class="btn_01" onclick="fnContractUpd();">위탁</button>
                    <button type="button" runat="server" class="btn_03" onclick="fnContractCnlConfirm();">위탁취소</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
                </li>
            </ul>
            <p class="car_info" style="margin-top:10px;"></p>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    
                    <ul class="drop_btn">
                        <li>
                            <dl>
                                <dt>정보망</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="정보망 등록" href="javascript:fnOrderNetworkIns();">정보망 등록</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="정보망 현황" href="javascript:fnOpenNetworkList();">정보망 현황</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                    &nbsp;
                    <ul class="drop_btn" style="float:right; margin-left:10px">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchDeliveryListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchDeliveryListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="OrderDispatchDeliveryListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchDeliveryListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchDeliveryListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchDeliveryListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
