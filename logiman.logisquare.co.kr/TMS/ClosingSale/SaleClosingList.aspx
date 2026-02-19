<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleClosingList.aspx.cs" Inherits="TMS.ClosingSale.SaleClosingList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSale/Proc/SaleClosingList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
                $("#ClosingKind").val("");
                $("#DateType").val("4");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewDeliveryLocationCode").val("");
                $("#DeliveryLocationCode input[type='checkbox']").prop("checked", false);
                $("#CsAdminID").val("");
                $("#CsAdminName").val("");
                $("#PayClientName").val("");
                $("#ClosingAdminName").val("");
                $("#SearchSaleClosingSeqNo").val("");
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

                var objParam = {
                    CallType: "SaleClosingListExcel",
                    CenterCode: $("#CenterCode").val(),
                    ClosingKind: $("#ClosingKind").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    CsAdminID: $("#CsAdminID").val(),
                    PayClientName: $("#PayClientName").val(),
                    ClosingAdminName: $("#ClosingAdminName").val(),
                    SaleClosingSeqNo: $("#SearchSaleClosingSeqNo").val()
                };

                $.fileDownload("/TMS/ClosingSale/Proc/SaleClosingHandler.ashx", {
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

            //계산서 발행 취소
            $("#BtnCnlBillSU").on("click", function (e) {
                fnCnlBillSU();
                return false;
            });

            //별도발행완료
            $("#BtnRegBillEtc").on("click", function (e) {
                fnRegBillEtc();
                return false;
            });

            //별도발행취소
            $("#BtnCnlBillEtc").on("click", function (e) {
                fnCnlBillEtc();
                return false;
            });

            //계산서발행내역
            $("#BtnOpenTaxList").on("click", function (e) {
                fnOpenTaxList();
                return false;
            });

            //내역서 발송내역
            $("#BtnOpenPrintList").on("click", function (e) {
                window.open("/TMS/Common/OrderPrintHistList", "내역서 발송내역", "width=1500, height=760, scrollbars=Yes");
                return false;
            });
        });

        function fnAjaxSaveExcel(objData) {
            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }
            return false;
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
            return false;
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
                    <asp:DropDownList runat="server" ID="ClosingKind" class="type_01" AutoPostBack="false"></asp:DropDownList>
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
                    <asp:HiddenField runat="server" ID="CsAdminID" />
                    <asp:TextBox runat="server" ID="CsAdminName" class="type_01 find" AutoPostBack="false" placeholder="업무담당"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:TextBox runat="server" ID="PayClientName" class="type_01" AutoPostBack="false" placeholder="청구처명"/>
                    <asp:TextBox runat="server" ID="ClosingAdminName" class="type_01" AutoPostBack="false" placeholder="마감자"/>
                    <asp:TextBox runat="server" ID="SearchSaleClosingSeqNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="전표번호"/>
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
                    <span runat="server" id="SpanCnlBillSU" Visible="False">
                        <asp:TextBox runat="server" ID="CnlBillSUSaleClosingSeqNos" class="type_01 Money" AutoPostBack="false" placeholder="전표번호 (,로 구분)"/>
                        <button type="button" runat="server" ID="BtnCnlBillSU" class="btn_03">발행취소</button>
                    </span>
                    &nbsp;&nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnRegBillEtc" class="btn_01">별도발행</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnCnlBillEtc" class="btn_03">별도발행취소</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnOpenTaxList" class="btn_02">계산서발행내역</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnOpenPrintList" class="btn_02">내역서 발송내역</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '매출마감현황', '매출마감현황');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('SaleClosingListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('SaleClosingListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="SaleClosingListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="PayClientName">거래처명</option>
                        <option value="SaleClosingSeqNo">전표번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('SaleClosingListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('SaleClosingListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('SaleClosingListGrid');">취소</button>
            </div>
        </div>
    </div>
        
    <div id="DivBillEtc">
        <div>
            <h1>별도 발행</h1>
            <a href="#" onclick="fnCloseBillEtc(); return false;" class="close_btn">x</a>
            <div class="infoWrap">
                별도 발행한 계산서의<br/>
                작성일과 발행일을 선택해 주세요.
            </div>
            <div class="tableWrap">
                <table>
                    <colgroup>
                        <col style="width:40%"/> 
                        <col style="width:60%;"/> 
                    </colgroup>
                    <tr>
                        <th>계산서종류*</th>
                        <td>
                            <asp:DropDownList runat="server" ID="BillKind" class="type_01" AutoPostBack="false"></asp:DropDownList>

                        </td>
                    </tr>
                    <tr>
                        <th>작성일 *</th>
                        <td>
                            <asp:TextBox runat="server" ID="BillWrite" class="type_01 date" AutoPostBack="false" placeholder=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>발행일</th>
                        <td>
                            <asp:TextBox runat="server" ID="BillYMD" class="type_01 date" AutoPostBack="false" placeholder=""/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnUpdBillEtc(); return false;">등록</button>
                <button type="button" class="btn_03" onclick="fnCloseBillEtc(); return false;">닫기</button>
            </div>
        </div>
    </div>
</asp:Content>