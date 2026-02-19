 <%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseCarList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseCarList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseCarList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ComName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#ComCorpNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#CarNo").on("keyup", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#DriverName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#DriverCell").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
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
                $("#CarDivType").val("");
                $("#CarNo").val("");
                $("#ComName").val("");
                $("#ComCorpNo").val("");
                $("#DriverName").val("");
                $("#DriverCell").val("");
                $("#ChkCooperatorFlag input[type='checkbox']").prop("checked", false);
                fnChkMyOrderFlag("Y");
                return;
            });

            $("#ChkMyOrder").click(function () {
                fnChkMyOrderFlag("N");
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
                    CallType: "PurchaseCarCompanyListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ClosingFlag: $("#ClosingFlag").val(),
                    CarDivType: $("#CarDivType").val(),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    CooperatorFlag: $("#ChkCooperatorFlag").is(":checked") ? "Y" : "",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N"
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseCarHandler.ashx", {
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
                    CallType: "PurchaseCarCompanyPayListExcel",
                    CenterCode: $("#HidCenterCode").val(),
                    ComCode: $("#HidComCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ClosingFlag: $("#ClosingFlag").val(),
                    CarDivType: $("#CarDivType").val(),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    CooperatorFlag: $("#ChkCooperatorFlag").is(":checked") ? "Y" : "",
                    MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N"
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseCarHandler.ashx", {
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

            
            //마감
            $("#BtnClosing").on("click", function (e) {
                fnClosing();
                return false;
            });

            //마감취소
            $("#BtnClosingCnl").on("click", function (e) {
                fnCnlClosing();
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

        function fnChkMyOrderFlag(resetflag) {
            if ($("#HidMyOrderFlag").val() == "Y") {
                $("#ChkMyOrder").prop("checked", true);
                if (resetflag != "Y") {
                    fnDefaultAlert("접속하신 아이디는 내오더만 조회하실 수 있습니다.");
                }
                return;
            }
            else {
                if (resetflag == "Y") {
                    $("#ChkMyOrder").prop("checked", false);
                }
                return;
            }
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidComCode" />
    <asp:HiddenField runat="server" ID="HidMyOrderFlag" />

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
                </div>
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CarDivType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="차량업체명"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" CssClass="type_01" AutoPostBack="false" placeholder="기사명"></asp:TextBox>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="기사휴대폰"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkCooperatorFlag" Text="<span></span>협력업체"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Checked="true" Text="<span></span>내오더"/>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnClosing" class="btn_01">마감</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnClosingCnl" class="btn_03">마감취소</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:40%;">
                    <h1>차량업체</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 12px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '매입마감_사업자내역', '매입마감_사업자내역');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PurchaseCarCompanyListGrid', this);">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseCarCompanyListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                    <asp:TextBox runat="server" ID="TaxWriteDateTo" class="type_01 date" AutoPostBack="false" placeholder="계산서작성일"/>
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
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridDetailID, 'xlsx', '매입마감_운송내역', '매입마감_운송내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('PurchaseCarCompanyPayListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseCarCompanyPayListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                    <button type="button" runat="server" ID="BtnDetailSaveExcel" class="btn_02 download" style="float: right; margin-right: 10px;">엑셀다운로드</button>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult2" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
            </ul>
            <div class="grid_type_03">
                <div class="left" style="width:40%;">
                    <div id="PurchaseCarCompanyListGrid"></div>
                </div>
                <div class="right" style="width:60%;">
                    <div id="PurchaseCarCompanyPayListGrid"></div>
                    <div id="GridSelectedInfo2" style="margin-top: 5px; font-weight: 700; color: #5674C8; text-align: right;"></div>
                </div>
            </div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="거래처 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ComName">차량업체명</option>
                        <option value="ComCorpNo">차량사업자번호</option>
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
                        <option value="CarNo">차량번호</option>
                        <option value="DriverName">기사명</option>
                        <option value="DriverCell">기사휴대폰</option>
                        <option value="OrderClientName">발주처명</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="ConsignorName">화주명</option>
                        <option value="OrderNo">오더번호</option>
                        <option value="PurchaseClosingSeqNo">전표번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PurchaseCarCompanyListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PurchaseCarCompanyListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('PurchaseCarCompanyListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('PurchaseCarCompanyPayListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('PurchaseCarCompanyPayListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('PurchaseCarCompanyPayListGrid');">취소</button>
            </div>
        </div>
    </div>
    
    <div id="DivAcctNo">
        <asp:HiddenField runat="server" ID="PopCenterCode"/>
        <asp:HiddenField runat="server" ID="PopComCode"/>
        <asp:HiddenField runat="server" ID="PopComCorpNo"/>
        <asp:HiddenField runat="server" ID="PopAcctValidFlag"/>
        <div>
            <h1>사업자 계좌 등록</h1>
            <a href="#" onclick="fnCloseAcctNo(); return false;" class="close_btn">x</a>
            <div class="tableWrap">
                <table style="width:100%">
                    <colgroup>
                        <col width="30%"/>
                        <col width="70%"/>
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td><span id="PopSpanCenterName"></span></td>
                    </tr>
                    <tr>
                        <th>사업자</th>
                        <td><span id="PopSpanComName"></span></td>
                    </tr>
                    <tr>
                        <th>사업자번호</th>
                        <td><span id="PopSpanComCorpNo"></span></td>
                    </tr>
                    <tr>
                        <th>대표자명</th>
                        <td><span id="PopSpanComCeoName"></span></td>
                    </tr>
                    <tr>
                        <th>은행명</th>
                        <td><asp:DropDownList runat="server" CssClass="type_01" ID="PopBankCode"/></td>
                    </tr>
                    <tr>
                        <th>계좌번호</th>
                        <td>
                            <asp:TextBox runat="server" ID="PopAcctNo" CssClass="OnlyNumber type_03" placeholder="계좌번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>예금주</th>
                        <td>
                            <asp:TextBox runat="server" ID="PopAcctName" CssClass="type_01" placeholder="예금주"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnCloseAcctNo(); return false;">닫기</button>
                <button type="button" class="btn_02" id="BtnChkAcctNo" onclick="fnChkAcctNo(); return false;">계좌확인</button>
                <button type="button" class="btn_02" id="BtnResetAcctNo" onclick="fnResetAcctNo(); return false;" style="display: none;">다시입력</button>
                <button type="button" class="btn_01" onclick="fnRegAcctNo(); return false;">등록</button>
            </div>
        </div>
    </div>

    <div id="DivPurchaseBill">
        <asp:HiddenField runat="server" ID="PopBillCenterCode"/>
        <asp:HiddenField runat="server" ID="PopBillComCode"/>
        <asp:HiddenField runat="server" ID="PopBillComCorpNo"/>
        <asp:HiddenField runat="server" ID="PopBillMinBillWrite"/>
        <asp:HiddenField runat="server" ID="PopBillOrgAmt"/>
        <asp:HiddenField runat="server" ID="PopBillInsureYMD" Value=""/>
        <asp:HiddenField runat="server" ID="PopBillInsureChkFlag" Value="N"/>
        <asp:HiddenField runat="server" ID="PopBillInsureTargetFlag" Value=""/>
        <div>
            <h1>마감 계산서 선택 / 작성일 지정</h1>
            <a href="#" onclick="fnClosePurchaseBill(); return false;" class="close_btn">x</a>
            <h2 style="padding-bottom: 5px;">▶ 마감 정보</h2>
            <div class="">
                <table style="width: 100%;">
                    <tr>
                        <td><span id="PopSpanBillCenterName"></span></td>
                        <td><span id="PopSpanBillComName"></span>(<span id="PopSpanBillComCorpNo"></span>)</td>
                        <td>비용수 : <span id="PopSpanBillPayCnt"></span></td>
                        <td>공급가액 : <span id="PopSpanBillSupplyAmt"></span></td>
                        <td>부가세 : <span id="PopSpanBillTaxAmt"></span></td>
                    </tr>
                </table>
            </div>
            <h2 style="padding-bottom: 5px;">
                ▶ 추천 계산서
                <button type="button" class="btn_01" onclick="fnResetColumnLayout('PurchaseCarBillListGrid'); return false;" style="float: right;">항목초기화</button>
                <button type="button" class="btn_02" onclick="fnUncheckBill(); return false;" style="float: right; margin-right: 10px;">선택취소</button>
            </h2>
            <div class="gridWrap">
                <div id="PurchaseCarBillListGrid"></div>
            </div>
            <h2 style="padding-bottom: 5px;">▶ 계산서 작성일</h2>
            <div class="">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="PopBillWrite" class="type_01 date" AutoPostBack="false" placeholder="작성일"/>
                        </td>
                        <td>
                            ※ 연결할 계산서가 없다면 계산서 작성일을 지정해주세요. 입력한 정보로 차주에게 계산서 발행을 요청합니다.
                        </td>
                    </tr>
                </table>
            </div>
            <h2>
                ▶ 산재보험료산정<button type="button" class="btn_help"  onclick="fnInsureHelp(); return false;"></button>
                <button type="button" class="btn_01" onclick="fnInsureCheck(); return false;" style="float: right;">대상확인</button>
                <span style="float: right; color: red; font-weight: bold; margin-right: 10px;" id="PopSpanBillInsureInfo"></span>
            </h2>
            <div class="insureWrap">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            1. 경비공제 후 금액(월 보수액)
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillTransAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            2. 예상 산재보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillInsureRateAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>   
                    </tr>
                    <tr>
                        <td>
                            3. 감경보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillInsureReduceAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            4. 실제 납부보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillInsurePayAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            5. 운송/주선사 부담금액
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillCenterInsureAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            6. 차주 부담금액
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopBillDriverInsureAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            ※ 표시된 금액과 운송사에 고지된 금액은 차이가 있을 수 있습니다.
                        </td>
                        <td class="tr">
                            <asp:CheckBox runat="server" id="PopBillInsureFlag" Checked="False" Text="<span></span>보험적용"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnClosePurchaseBill(); return false;">닫기</button>
                <button type="button" class="btn_01" onclick="fnInsClosing(); return false;">마감</button>
            </div>
        </div>
    </div>
</asp:Content>
