<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdvanceList.aspx.cs" Inherits="TMS.ClosingAdvance.AdvanceList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingAdvance/Proc/AdvanceList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
                $("#PayType").val("");
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#SearchClientType").val("2");
                $("#SearchChargeType").val("2");
                return false;
            });

            $("#BtnDepositHelp").on("click", function (e) {
                var htmlMsg = "";
                htmlMsg += "[입금정보 등록 조건]<br/>";
                htmlMsg += " - 선택한 비용과 회원사 동일<br/>";
                htmlMsg += " - 선택한 비용과 입금구분(선급/예수) 동일<br/>";
                htmlMsg += " - 선택한 비용과 입금업체 동일<br/>";
                htmlMsg += " - 선택한 비용 총액과 입금액 동일<br/>";
                htmlMsg += "※ 입금정보 삭제는 \"입금내역관리\"에서 가능";
                fnDefaultAlert(htmlMsg, "info");
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
                    CallType: "AdvanceListExcel",
                    CenterCode: $("#CenterCode").val(),
                    PayType: $("#PayType").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    SearchClientType: $("#SearchClientType").val(),
                    SearchClientText: $("#SearchClientText").val(),
                    SearchChargeType: $("#SearchChargeType").val(),
                    SearchChargeText: $("#SearchChargeText").val(),
                    OrgAmt: $("#OrgAmt").val(),
                    ClientName: $("#ClientName").val(),
                    DepositClientName: $("#DepositClientName").val(),
                    DepositAmt: $("#DepositAmt").val(),
                    DepositNote: $("#DepositNote").val()
                };

                $.fileDownload("/TMS/ClosingAdvance/Proc/AdvanceHandler.ashx", {
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

            //입금등록
            $("#BtnRegDeposit").on("click", function (e) {
                fnRegDeposit();
                return false;
            });

            //다시입력
            $("#BtnResetDeposit").on("click", function (e) {
                $("#RClientCode").val("");
                $("#RPayType").val("3");
                $("#RDepositYMD").val("");
                $("#RClientName").val("");
                $("#RDepositAmt").val("");
                $("#RDepositNote").val("");
                return false;
            });

            //입금내역관리
            $("#BtnOpenDeposit").on("click", function (e) {
                window.open("/TMS/ClosingAdvance/AdvanceDepositList", "선급금/예수금입금내역관리", "width=1620, height=850px, scrollbars=Yes");
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
                    <asp:DropDownList runat="server" ID="PayType" class="type_01" width="100"></asp:DropDownList>
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
                    &nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="SearchClientType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    <asp:DropDownList runat="server" ID="SearchChargeType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchChargeText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    <asp:TextBox runat="server" ID="OrgAmt" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="선급/예수합계금액"/>
                    <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                    <asp:TextBox runat="server" ID="DepositClientName" class="type_01" AutoPostBack="false" placeholder="입금업체명"/>
                    <asp:TextBox runat="server" ID="DepositAmt" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="입금액"/>
                    <asp:TextBox runat="server" ID="DepositNote" class="type_01" AutoPostBack="false" placeholder="입금비고"/>
                </div>
            </div>  
            
            <div class="search" style="margin-top: 20px;">
                <asp:HiddenField runat="server" ID="RClientCode"/>
                <asp:DropDownList runat="server" ID="RPayType" class="type_01" width="100"></asp:DropDownList>
                <asp:TextBox runat="server" ID="RDepositYMD" class="type_01 date" AutoPostBack="false" placeholder="입금일"/>
                <asp:TextBox runat="server" ID="RClientName" class="type_01 find" AutoPostBack="false" placeholder="입금업체명"/>
                <asp:TextBox runat="server" ID="RDepositAmt" class="type_01 Money" AutoPostBack="false" placeholder="입금액"/>
                <asp:TextBox runat="server" ID="RDepositNote" class="type_01" AutoPostBack="false" placeholder="입금비고"/>
                &nbsp;<button type="button" class="btn_01" id="BtnRegDeposit">입금등록</button>
                &nbsp;&nbsp;<button type="button" class="btn_02" id="BtnResetDeposit">다시입력</button>
                <button type="button" class="btn_help" id="BtnDepositHelp"></button>
            </div>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnOpenDeposit" class="btn_02">입금내역관리</button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '선급예수관리내역', '선급예수관리내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('AdvanceListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('AdvanceListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="AdvanceListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="ClientName">업체명</option>
                        <option value="DepositClientName">입금업체명</option>
                        <option value="OrderNo">오더번호</option>
                        <option value="AdvanceClosingSeqNo">전표번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('AdvanceListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('AdvanceListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('AdvanceListGrid');">취소</button>
            </div>
        </div>
    </div>
        
</asp:Content>
