 <%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleList.aspx.cs" Inherits="TMS.ClosingSale.SaleList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSale/Proc/SaleList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //검색조건 enter
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13 && !$(this).hasClass("ui-autocomplete-input") && !$(this).attr("readonly")) {
                    $("#BtnListSearch").click();
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 365);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewDeliveryLocationCode").val("");
                $("#DeliveryLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderItemCode").val("");
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#ChkCarryOver").prop("checked", true);
                $("#OrderClientName").val("");
                $("#PayClientName").val("");
                $("#PayClientChargeName").val("");
                $("#CsAdminID").val("");
                $("#CsAdminName").val("");
                $("#ConsignorName").val("");
                $("#Hawb").val("");
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                if (!$("#CenterCode").val()) {
                    fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                    return false;
                }

                var LocationCode = [];
                var DLocationCode = [];
                var ItemCode = [];

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        DLocationCode.push($(el).val());
                    }
                });

                $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        ItemCode.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: "SaleClientListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    CarryOverFlag: $("#ChkCarryOver").is(":checked") ? "Y" : "",
                    ClosingFlag: $("#ClosingFlag").val(),
                    OrderClientName: $("#OrderClientName").val(),
                    PayClientName: $("#PayClientName").val(),
                    PayClientChargeName: $("#PayClientChargeName").val(),
                    CsAdminID: $("#CsAdminID").val(),
                    ConsignorName: $("#ConsignorName").val(),
                    Hawb: $("#Hawb").val()
                };

                $.fileDownload("/TMS/ClosingSale/Proc/SaleHandler.ashx", {
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

            $("#BtnDetailSaveExcel").on("click", function () {
                if (!$("#HidCenterCode").val() || !$("#HidCenterCode").val()) {
                    fnDefaultAlert("선택된 고객사 정보가 없습니다.");
                    return false;
                }

                var LocationCode = [];
                var DLocationCode = [];
                var ItemCode = [];

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                $.each($("#DeliveryLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        DLocationCode.push($(el).val());
                    }
                });

                $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        ItemCode.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: "SaleClientOrderListExcel",
                    CenterCode: $("#HidCenterCode").val(),
                    PayClientCode: $("#HidPayClientCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    CarryOverFlag: $("#ChkCarryOver").is(":checked") ? "Y" : "",
                    ClosingFlag: $("#ClosingFlag").val(),
                    OrderClientName: $("#OrderClientName").val(),
                    PayClientName: $("#PayClientName").val(),
                    PayClientChargeName: $("#PayClientChargeName").val(),
                    CsAdminID: $("#CsAdminID").val(),
                    ConsignorName: $("#ConsignorName").val(),
                    Hawb: $("#Hawb").val()
                };

                $.fileDownload("/TMS/ClosingSale/Proc/SaleHandler.ashx", {
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

            
            //개별마감
            $("#BtnClosingEach").on("click", function (e) {
                fnClosingEach();
                return false;
            });

            //일괄마감
            $("#BtnClosingAll").on("click", function (e) {
                fnClosingAll();
                return false;
            });

            //마감취소
            $("#BtnClosingCnl").on("click", function (e) {
                fnCnlClosing();
                return false;
            });

            //이월처리
            $("#BtnSetCarryover").on("click", function (e) {
                fnSetCarryover();
                return false;
            });

            //이월취소처리
            $("#BtnSetCarryoverDel").on("click", function (e) {
                fnSetCarryoverDel();
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
    <asp:HiddenField runat="server" ID="HidPayClientCode" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="ClosingFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewDeliveryLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="배송사업장" readonly></asp:TextBox>
                    <div id="DivDeliveryLocationCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="DeliveryLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkCarryOver" Text="<span></span>이월포함" Checked="True"/>
                </div>
                <div class="search_line">
                    <asp:TextBox runat="server" ID="OrderClientName" class="type_01" AutoPostBack="false" placeholder="발주처명"/>
                    <asp:TextBox runat="server" ID="PayClientName" class="type_01" AutoPostBack="false" placeholder="청구처명"/>
                    <asp:TextBox runat="server" ID="ConsignorName" class="type_01" AutoPostBack="false" placeholder="화주명"/>
                    <asp:TextBox runat="server" ID="PayClientChargeName" class="type_01" AutoPostBack="false" placeholder="청구처담당자"/>
                    <asp:HiddenField runat="server" ID="CsAdminID" />
                    <asp:TextBox runat="server" ID="CsAdminName" class="type_01 find" AutoPostBack="false" placeholder="업무담당"/>
                    <asp:TextBox runat="server" ID="Hawb" class="type_01" AutoPostBack="false" placeholder="H/AWB"/>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnClosingEach" class="btn_01">개별마감</button>
                    <button type="button" runat="server" ID="BtnClosingAll" class="btn_01">일괄마감</button>
                    <button type="button" runat="server" ID="BtnClosingCnl" class="btn_01">마감취소</button>
                    &nbsp;&nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnSetCarryover" class="btn_01">이월</button>
                    <button type="button" runat="server" ID="BtnSetCarryoverDel" class="btn_03">이월취소</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:40%;">
                    <h1>거래처</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 12px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '매출마감_거래처내역', '매출마감_거래처내역');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('SaleListGrid', this);">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('SaleListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download" style="float: right; margin-right: 10px;">엑셀다운로드</button>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
                <li class="right" style="width:60%; text-align: left;">
                    <h1 style="margin-left: 3px;">운송내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridDetailID, 'xlsx', '매출마감_운송내역', '매출마감_운송내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('SaleOrderListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('SaleOrderListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                    <ul class="drop_down_btn" style="float: right; margin-right: 10px;">
						<li>
							<dl>
								<dt>출력</dt>
								<dd>
									<asp:LinkButton runat="server" title="운송내역서_내수" href="javascript:fnDomesticPrint();">운송내역서_내수</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="운송내역서_수출입" href="javascript:fnInoutPrint();">운송내역서_수출입</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="운송내역서_컨테이너" href="javascript:fnContainerPrint();">운송내역서_컨테이너</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                    <button type="button" runat="server" ID="BtnDetailSaveExcel" class="btn_02 download" style="float: right; margin-right: 10px;">엑셀다운로드</button>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult2" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 600; color: #5674c8; "></strong>
                    </div>
                </li>
            </ul>
            <div class="grid_type_03">
                <div class="left" style="width:40%;">
                    <div id="SaleListGrid"></div>
                </div>
                <div class="right" style="width:60%;">
                    <div id="SaleOrderListGrid"></div>
                </div>
            </div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="거래처 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="PayClientName">거래처</option>
                        <option value="PayClientCorpNo">사업자번호</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
            
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog2" title="오더 검색">
                <a href="#" id="LinkGridSearchClose2" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField2" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="OrderClientName">발주처명</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="ConsignorName">화주명</option>
                        <option value="OrderNo">오더번호</option>
                        <option value="ClosingSeqNo">전표번호</option>
                    </select>
                    <input type="text" id="GridSearchText2"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch2" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive2" type="checkbox" /><label for="ChkCaseSensitive2"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('SaleListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('SaleListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('SaleListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('SaleOrderListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('SaleOrderListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('SaleOrderListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
