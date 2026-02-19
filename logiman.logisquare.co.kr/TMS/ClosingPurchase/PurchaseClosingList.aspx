<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseClosingList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseClosingList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseClosingList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 365);
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $(".search_line > input[type=text]").val("");
                $("#DateType").val("4");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#DeliveryLocationCode input[type='checkbox']").prop("checked", false);
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#SendStatus").val("");
                $("#SendType").val("");
                $("#ChkInsure").prop("checked", false);
                return false;
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
                    CallType: "PurchaseClosingListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    SendStatus: $("#SendStatus").val(),
                    SendType: $("#SendType").val(),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    ClosingAdminName: $("#ClosingAdminName").val(),
                    PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val(),
                    InsureFlag: $("#ChkInsure").is(":checked") ? "Y" : ""
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

            //송금예정일등록
            $("#BtnRegSendPlanYMD").on("click", function (e) {
                fnOpenSendPlan();
                return false;
            });

            //별도송금등록
            $("#BtnRegOtherPay").on("click", function (e) {
                fnOpenOtherPay();
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
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />

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
                    <asp:TextBox runat="server" id="ViewDeliveryLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="배송사업장" readonly></asp:TextBox>
                    <div id="DivDeliveryLocationCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="DeliveryLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkInsure" Text="<span></span>산재보험적용"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="SendStatus" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="SendType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="차량업체명"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" CssClass="type_01" AutoPostBack="false" placeholder="기사명"></asp:TextBox>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="기사휴대폰"/>
                    <asp:TextBox runat="server" ID="ClosingAdminName" class="type_01" AutoPostBack="false" placeholder="마감자명"/>
                    <asp:TextBox runat="server" ID="SearchPurchaseClosingSeqNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="전표번호"/>
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
                    <button type="button" runat="server" ID="BtnRegSendPlanYMD" class="btn_01">송금예정일등록</button>
                    <button type="button" runat="server" ID="BtnRegOtherPay" class="btn_01" Visible="False">별도송금등록</button>
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '매입마감현황', '매입마감현황');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PurchaseClosingListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseClosingListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="PurchaseClosingListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ComName">차량업체명</option>
                        <option value="PurchaseClosingSeqNo">전표번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PurchaseClosingListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PurchaseClosingListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('PurchaseClosingListGrid');">취소</button>
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
        <asp:HiddenField runat="server" ID="PopBillOrgAmt"/>
        <asp:HiddenField runat="server" ID="PopBillInsureFlag"/>
        <asp:HiddenField runat="server" ID="PopBillPurchaseClosingSeqNo"/>
        <div>
            <h1>마감 계산서 선택</h1>
            <a href="#" onclick="fnCloseBill(); return false;" class="close_btn">x</a>
            <h2>▶ 마감 정보</h2>
            <div class="" style="margin-top: 10px;">
                <table style="width: 100%;">
                    <tr>
                        <td><span id="PopSpanBillCenterName"></span></td>
                        <td><span id="PopSpanBillComName"></span>(<span id="PopSpanBillComCorpNo"></span>)</td>
                        <td>공급가액 : <span id="PopSpanBillSupplyAmt"></span></td>
                        <td>부가세 : <span id="PopSpanBillTaxAmt"></span></td>
                    </tr>
                </table>
            </div>
            <h2>▶ 추천계산서 
                <button type="button" class="btn_01" onclick="fnResetColumnLayout('PurchaseCarBillListGrid'); return false;" style="float: right;">항목초기화</button>
                <button type="button" class="btn_02" onclick="fnUncheckBill(); return false;" style="float: right; margin-right: 10px;">선택취소</button>
            </h2>
            <div class="gridWrap" style="margin-top: 10px; height: 350px;">
                <div id="PurchaseCarBillListGrid"></div>
            </div>
            <div class="btnWrap" style="margin-top: 20px;">
                <button type="button" class="btn_03" onclick="fnCloseBill(); return false;">닫기</button>
                <button type="button" class="btn_01" onclick="fnPreMatching(); return false;">연결하기</button>
            </div>
        </div>
    </div>

    <div id="DivOtherPay">
        <div>
            <h1>별도 송금 등록</h1>
            <a href="#" onclick="fnCloseOtherPay(); return false;" class="close_btn">x</a>
            <div class="commonWrap">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="PopOtherPaySendPlanYMD" class="type_01 date" AutoPostBack="false" placeholder="송금예정일"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="commonWrap">재신청 시 선택한 날짜로 반영됩니다.</div>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnCloseOtherPay(); return false;">닫기</button>
                <button type="button" class="btn_01" onclick="fnInsOtherPay(); return false;">등록</button>
            </div>
        </div>
    </div>

    <div id="DivSendPlan">
        <div>
            <h1>송금 예정일 등록</h1>
            <a href="#" onclick="fnCloseSendPlan(); return false;" class="close_btn">x</a>
            <div class="commonWrap">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="PopSendPlanYMD" class="type_01 date" AutoPostBack="false" placeholder="송금예정일"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="commonWrap">재신청 시 선택한 날짜로 반영됩니다.</div>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnCloseSendPlan(); return false;">닫기</button>
                <button type="button" class="btn_01" onclick="fnInsSendPlan(); return false;">등록</button>
            </div>
        </div>
    </div>
</asp:Content>
