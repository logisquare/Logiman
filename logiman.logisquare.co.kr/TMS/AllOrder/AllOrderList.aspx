<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AllOrderList.aspx.cs" Inherits="TMS.AllOrder.AllOrderList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/AllOrder/Proc/AllOrderList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //검색조건 enter
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13 && !$(this).hasClass("ui-autocomplete-input") && !$(this).attr("readonly")) {
                    $("#BtnListSearch").click();
                    return;
                }
            });

            $("#BtnListSearch").on("click", function (event) {
                fnCheckPeriodAndSearch(event);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderItemCode").val("");
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderStatus").val("");
                $("#OrderStatus input[type='checkbox']").prop("checked", false);
                $("#ChkMyCharge").prop("checked", false);
                $("#ChkMyOrder").prop("checked", false);
                $("#ChkCnl").prop("checked", false);
                $("#SearchClientType").val("1");
                $("#SearchClientText").val("");
                $("#SearchPlaceType").val("1");
                $("#SearchPlaceText").val("");
                $("#SearchChargeType").val("1");
                $("#SearchChargeText").val("");
                $("#ComCorpNo").val("");
                $("#CarNo").val("");
                $("#DriverName").val("");
                $("#CsAdminID").val("");
                $("#CsAdminName").val("");
                $("#OrderNo").val("");
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                if ($("#OrderNo").val().length === 0 && !$.isNumeric($("#OrderNo").val())) {
                    var dateTerm = fnGetDateTerm($("#DateFrom").val(), $("#DateTo").val());

                    if (dateTerm > 30) {
                        fnDefaultAlert("최대 31일까지 조회하실 수 있습니다.", "info");
                        return false;
                    }
                }

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
                    CallType: "AllOrderListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    OrderStatuses: OrderStatus.join(","),
                    SearchClientType: $("#SearchClientType").val(),
                    SearchClientText: $("#SearchClientText").val(),
                    SearchPlaceType: $("#SearchPlaceType").val(),
                    SearchPlaceText: $("#SearchPlaceText").val(),
                    SearchChargeType: $("#SearchChargeType").val(),
                    SearchChargeText: $("#SearchChargeText").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    CsAdminID: $("#CsAdminID").val(),
                    OrderNo: $("#OrderNo").val(),
                    MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
                    CnlFlag: $("#ChkCnl").is(":checked") ? "Y" : "N",
                    SortType: $("#SortType").val()
                };

                $.fileDownload("/TMS/AllOrder/Proc/AllOrderHandler.ashx", {
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

            //사업장변경
            $("#BtnChgOrderLocation").on("click", function (e) {
                fnChgOrderLocation();
                return false;
            });

            //오더취소
            $("#BtnCancelOrder").on("click", function (e) {
                fnCnlOrder();
                return false;
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

        function fnCheckPeriodAndSearch(event) {

            if ($("#OrderNo").val().length > 0 && $.isNumeric($("#OrderNo").val())) { //오더번호 입력 검색
                fnMoveToPage(1);
                return false;
            }

            fnMoveToPagePeriod(1, 63);
            return false;
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
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderStatus" ToolTip="오더 상태" CssClass="type_01 SearchConditions" placeholder="오더 상태" readonly></asp:TextBox>
                    <div id="DivOrderStatus" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderStatus" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyCharge" Text="<span></span>내담당"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더"/>
				    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkCnl" Text="<span></span>취소오더"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="SearchClientType" class="type_01" AutoPostBack="false" Width="95"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchClientText" class="type_small" AutoPostBack="false" placeholder="검색어"/>
                    <asp:DropDownList runat="server" ID="SearchPlaceType" class="type_01" AutoPostBack="false" Width="120"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchPlaceText" class="type_small" AutoPostBack="false" placeholder="검색어"/>
                    <asp:DropDownList runat="server" ID="SearchChargeType" class="type_01" AutoPostBack="false" Width="125"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchChargeText" class="type_small" AutoPostBack="false" placeholder="검색어"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01" AutoPostBack="false" placeholder="차량사업자번호"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" class="type_small" AutoPostBack="false" placeholder="기사명"/>
                    <asp:HiddenField runat="server" ID="CsAdminID" />
                    <asp:TextBox runat="server" ID="CsAdminName" class="type_small find" AutoPostBack="false" placeholder="업무담당"/>
                    <asp:TextBox runat="server" ID="OrderNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="오더번호"/>
                    <asp:DropDownList runat="server" ID="SortType" class="type_01" AutoPostBack="false" Width="140" title="1. 상차일 최신순 (기본) : 상차일 최근 일자순 정렬&#10;2. 오더상태순 : 상차일 최신순 정렬 후 오더상태(등록-접수-배차)순 정렬&#10;3. 오더등록 과거순 : 상차일 최신순 정렬 후 오더등록 과거순 정렬&#10;4. 오더등록 최신순 : 상차일 최신순 정렬 후 오더등록 최신순 정렬"></asp:DropDownList>
                    &nbsp;
                    <asp:CheckBox runat="server" id="ChkFilter" Text="<span></span>필터유지" Checked="False"/>
                    <asp:CheckBox runat="server" id="ChkSort" Text="<span></span>정렬유지" Checked="False"/>
                </div>
            </div>  

            <ul class="action" style="display: none;">
                <li class="left">
                    <asp:DropDownList runat="server" ID="ChgOrderLocationCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <button type="button" class="btn_01" id="BtnChgOrderLocation">변경</button>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnCancelOrder" class="btn_03">오더취소</button>
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
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;&nbsp;
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
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '통합오더내역', '통합오더내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('AllOrderListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 저장" href="javascript:fnSaveColumnCustomLayout('AllOrderListGrid');">항목순서 저장</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('AllOrderListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="AllOrderListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="OrderClientName">발주처명</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="ConsignorName">화주명</option>
                        <option value="OrderNo">오더번호</option>
                        <option value="Hawb">H/AWB</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('AllOrderListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('AllOrderListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('AllOrderListGrid');">취소</button>
            </div>
        </div>
    </div>
        
    <div id="DivCancel">
        <div>
            <h1>오더 취소 사유</h1>
            <a href="#" onclick="fnCloseCnlOrder(); return;" class="close_btn">x</a>
            <textarea id="CnlReason" rows="3" cols="50"></textarea>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnCnlOrderReg(); return;">등록</button>
                <button type="button" class="btn_03" onclick="fnCloseCnlOrder(); return;">닫기</button>
            </div>
        </div>
    </div>

    <div id="DivDispatchCar">
        <div>
            <h1>오더 배차 목록</h1>
            <a href="#" onclick="fnCloseDispatchCar(); return false;" class="close_btn">x</a>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnResetDispatchCar(); return false;">새로고침</button>
                <button type="button" class="btn_01" onclick="fnResetColumnLayout('OrderDispatchCarListGrid'); return false;">항목초기화</button>
                <button type="button" class="btn_03" onclick="fnCloseDispatchCar(); return false;">닫기</button>
            </div>
            <div class="gridWrap">
                <div id="OrderDispatchCarListGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
