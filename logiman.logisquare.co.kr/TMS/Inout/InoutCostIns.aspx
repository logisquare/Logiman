<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="InoutCostIns.aspx.cs" Inherits="TMS.Inout.InoutCostIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Inout/Proc/InoutCostIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
                $("#CsAdminID").val("");
                $("#CsAdminName").val("");
                $("#OrderNo").val("");
                return;
            });
        });

        function fnCheckPeriodAndSearch(event) {

            if ($("#OrderNo").val().length > 0 && $.isNumeric($("#OrderNo").val())) { //오더번호 입력 검색
                fnMoveToPage(1);
                return false;
            }

            //사업장을 선택했거나 업체명 검색시 6개월까지 조회 가능
            var intOrderLocationCodeCnt = $("#OrderLocationCode input[type='checkbox']").length - 1;
            var intOrderLocationCodeCheckedCnt = 0;
            var arrOrderLocationCode = [];

            $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                if ($(el).val() !== "") {
                    arrOrderLocationCode.push($(el).val());
                }
            });

            intOrderLocationCodeCheckedCnt = arrOrderLocationCode.length;
            intOrderLocationCodeCnt = intOrderLocationCodeCnt < 0 ? 0 : intOrderLocationCodeCnt;

            if ((intOrderLocationCodeCheckedCnt > 0 && intOrderLocationCodeCnt !== intOrderLocationCodeCheckedCnt)) {
                fnMoveToPagePeriod(1, 186);
                return false;
            } else if ($("#SearchClientType").val() !== "" && $("#SearchClientText").val().replace(/ /gi, "").replace(/\t/gi, "").length >= 2) {
                fnMoveToPagePeriod(1, 186);
                return false;
            } else {
                fnMoveToPagePeriod(1, 63);
                return false;
            }

        }
    </script>
    <style>
        form { height: auto;}
        .popup_table tr td { padding: 0px !important; height: 32px; min-width: 160px;}
        .popup_table tr td span { margin-left: 5px;}
        .popup_table tr th { padding: 0px !important; height: 32px;}
        .TrTransRate {display:none;}
        .TrTransRate td:nth-child(8) {border-right: 0px !important; padding-left:5px !important;}
        .TrTransRate td:nth-child(9) {border-left: 0px !important; text-align:right;}
        #BtnUpdRequestAmt {display:none;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidOrderNo" />
    <asp:HiddenField runat="server" ID="HidCnlFlag" />
    <asp:HiddenField runat="server" ID="HidGoodsSeqNo" />
    <asp:HiddenField runat="server" ID="HidPayClientCode" />
    <asp:HiddenField runat="server" ID="HidPickupYMD" />
    <asp:HiddenField runat="server" ID="HidContractType"/>
    <asp:HiddenField runat="server" ID="HidContractStatus"/>
    <asp:HiddenField runat="server" ID="HidCarDivType1"/>
    <asp:HiddenField runat="server" ID="PayClientInfo" />
    <asp:HiddenField runat="server" ID="PayClientCode" />
    <asp:HiddenField runat="server" ID="PayClientName" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" width="120" AutoPostBack="false" placeholder="날짜 From"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" width="120" AutoPostBack="false" placeholder="날짜 To"/>
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
                            <asp:DropDownList runat="server" ID="SearchClientType" class="type_01" AutoPostBack="false" Width="100"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            <asp:DropDownList runat="server" ID="SearchPlaceType" class="type_01" AutoPostBack="false" Width="130"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchPlaceText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            <asp:DropDownList runat="server" ID="SearchChargeType" class="type_01" AutoPostBack="false" Width="130"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchChargeText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            <asp:HiddenField runat="server" ID="CsAdminID" />
                            <asp:TextBox runat="server" ID="CsAdminName" class="type_01 find" AutoPostBack="false" placeholder="업무담당"/>
                            <asp:TextBox runat="server" ID="OrderNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="오더번호"/>
                            <asp:DropDownList runat="server" ID="SortType" class="type_01" AutoPostBack="false" Width="160" title="1. 상차일 최신순 (기본) : 상차일 최근 일자순 정렬&#10;2. 오더상태순 : 상차일 최신순 정렬 후 오더상태(등록-접수-배차)순 정렬&#10;3. 오더등록 과거순 : 상차일 최신순 정렬 후 오더등록 과거순 정렬&#10;4. 오더등록 최신순 : 상차일 최신순 정렬 후 오더등록 최신순 정렬"></asp:DropDownList>
                            &nbsp;
                            <asp:CheckBox runat="server" id="ChkFilter" Text="<span></span>필터유지" Checked="False"/>
                            <asp:CheckBox runat="server" id="ChkSort" Text="<span></span>정렬유지" Checked="False"/>
                            
                            <ul class="drop_btn" style="float:right;">
                                <li>
                                    <dl>
                                        <dt>항목 설정</dt>
                                        <dd>
                                            <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('InoutCostInsOrderListGrid');">항목관리</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('InoutCostInsOrderListGrid');">항목순서 초기화</asp:LinkButton>
                                        </dd>
                                    </dl>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="grid_list" style="margin-top: 5px;">

                        <div id="InoutCostInsOrderListGrid"></div>
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
                    <table class="popup_table" style="margin-top: 10px;">
                        <colgroup>
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:480px"/> 
                        </colgroup>
                        <tr>
                            <th>접수번호</th>
                            <td><span id="SpanOrderNo"></span></td>
                            <th>목적국</th>
                            <td><span id="SpanNation"></span></td>
                            <th>H/AWB</th>
                            <td><span id="SpanHawb"></span></td>
                            <th>M/AWB</th>
                            <td><span id="SpanMawb"></span></td>
                            <th>업무특이사항 (청구처)</th>
                        </tr>
                        <tr>
                            <th>Invoice No.</th>
                            <td><span id="SpanInvoiceNo"></span></td>
                            <th>Booking No.</th>
                            <td><span id="SpanBookingNo"></span></td>
                            <th>입고 No.</th>
                            <td><span id="SpanStockNo"></span></td>
                            <th>수량</th>
                            <td><span id="SpanVolume"></span></td>
                            <td rowspan="3" style="padding: 3px !important;">
                                <textarea id="OrderClientNote" class="type_100p" style="height: 100px;" readonly="readonly"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th>CBM</th>
                            <td><span id="SpanCBM"></span></td>
                            <th>중량</th>
                            <td><span id="SpanWeight"></span></td>
                            <th>길이</th>
                            <td colspan="3"><span id="SpanLength"></span></td>
                        </tr>
                        <tr>
                            <th>화물정보</th>
                            <td colspan="7"><span id="SpanQuantity"></span></td>
                        </tr>
                        <tr class="TrContract" style="display: none;">
                            <th>위탁정보</th>
                            <td colspan="8">
                                <span id="SpanContract"></span>
                            </td>
                        </tr>
                    </table>
                    <table class="popup_table TrTransRate" style="margin-top: 5px;">
                        <asp:HiddenField runat="server" ID="TransRateChk"/>
                        <asp:HiddenField runat="server" ID="ApplySeqNo"/>
                        <colgroup>
                            <col style="width:120px"/> 
                            <col style="width:100px"/> 
                            <col style="width:120px"/> 
                            <col style="width:100px"/> 
                            <col style="width:120px"/> 
                            <col style="width:100px"/> 
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:180px"/> 
                        </colgroup>
                        <tr>
                            <th>자동운임</th>
                            <th>매출</th>
                            <td><asp:TextBox runat="server" ID="SaleUnitAmt" CssClass="type_01 ali_r" readonly></asp:TextBox></td>
                            <th>매입 (고정)</th>
                            <td><asp:TextBox runat="server" ID="FixedPurchaseUnitAmt" CssClass="type_01 ali_r" readonly></asp:TextBox></td>
                            <th>매입 (용차)</th>
                            <td><asp:TextBox runat="server" ID="PurchaseUnitAmt" CssClass="type_01 ali_r" readonly></asp:TextBox></td>
                            <td>적용 : <span id="SpanTransRateInfo"></span></td>
                            <td>
                                <button type="button" class="btn_01" id="BtnCallTransRate">확인</button>
                                <button type="button" class="btn_02" id="BtnUpdRequestAmt">수정요청</button>
                            </td>
                        </tr>
                    </table>
                    <table class="popup_table" style="margin-top: 5px;">
                        <colgroup>
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                        </colgroup>
                        <tr class="TrPay">
                            <th rowspan="3">비용정보</th>
                            <td>
                                <asp:HiddenField runat="server" ID="SeqNo"/>
                                <asp:HiddenField runat="server" ID="PaySeqNo"/>
                                <asp:DropDownList runat="server" CssClass="type_01" ID="PayType" Width="80"></asp:DropDownList>
                                <asp:DropDownList runat="server" CssClass="type_01" ID="TaxKind" Width="80"></asp:DropDownList>
                                <asp:DropDownList runat="server" CssClass="type_01" ID="ItemCode" Width="80"></asp:DropDownList>
                                <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_small Money" placeholder="* 공급가액" MaxLength="11"></asp:TextBox>
                                <asp:TextBox runat="server" ID="TaxAmt" CssClass="type_small Money" placeholder="부가세" MaxLength="10"></asp:TextBox>
                                <asp:TextBox runat="server" ID="Rate" CssClass="type_small Money" placeholder="할증율(%)" MaxLength="3"></asp:TextBox>
                                
                                <asp:HiddenField runat="server" ID="ClientCode"/>
                                <asp:HiddenField runat="server" ID="ClientInfo"/>
                                <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find TrPayClient" placeholder="업체명 (고객사)"></asp:TextBox>

                                <span style="float: right;">
                                    <button type="button" class="btn_01" id="BtnAddPay">추가</button>
                                    <button type="button" class="btn_02" id="BtnUpdPay" style="display: none;">수정</button>
                                    <button type="button" class="btn_03" id="BtnDelPay" style="display: none;">삭제</button>
                                    <button type="button" class="btn_02" id="BtnResetPay">다시입력</button>
                                    &nbsp;&nbsp;
                                    <button type="button" class="btn_01" id="BtnInsPay">등록 (F2)</button>
                                    <button type="button" class="btn_03" id="BtnResetAllPay">새로고침</button>
                                </span>
                            </td>
                        </tr>
                    </table>

                    <div class="grid_list" style="margin-top: 5px;">
                        <div id="InoutCostInsPayListGrid"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div id="DivTransRateAmtRequest">
        <div>
            <h1>자동운임 수정요청</h1>
            <a href="#" onclick="fnCloseTransRateAmtRequest(); return false;" class="close_btn">x</a>
            <div class="req_grid_list" style="margin-top:30px;">
                <div id="OrderTransRateAmtRequestGrid"></div>
            </div>
        </div>
    </div>

    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('InoutCostInsOrderListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('InoutCostInsOrderListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('InoutCostInsOrderListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
