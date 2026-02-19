 <%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PayClosingList.aspx.cs" Inherits="TMS.ClosingPurchasePay.PayClosingList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchasePay/Proc/PayClosingList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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

            $("#ClosingAdminName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#SearchPurchaseClosingSeqNo").on("keyup", function (event) {
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
                $("#DateType").val("5");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewDeliveryLocationCode").val("");
                $("#DeliveryLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderItemCode").val("");
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#ComName").val("");
                $("#ComCorpNo").val("");
                $("#ClosingAdminName").val("");
                $("#SearchPurchaseClosingSeqNo").val("");
                $("#DeductFlag").prop("checked", false);
                $("#ChkInsure").prop("checked", false);
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
                    CallType: "PayClosingSendListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    ClosingAdminName: $("#ClosingAdminName").val(),
                    DeductFlag: $("#DeductFlag").is(":checked") ? "Y" : "N",
                    InsureFlag: $("#ChkInsure").is(":checked") ? "Y" : "N",
                    PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val()
                };

                $.fileDownload("/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx", {
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
                if (!$("#HidCenterCode").val()) {
                    fnDefaultAlert("선택된 회원사 정보가 없습니다.");
                    return false;
                }

                if (!$("#HidSendPlanYMD").val()) {
                    fnDefaultAlert("선택된 송금일 정보가 없습니다.");
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
                    CallType: "PayClosingListExcel",
                    CenterCode: $("#HidCenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#HidSendPlanYMD").val(),
                    DateTo: $("#HidSendPlanYMD").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    ClosingAdminName: $("#ClosingAdminName").val(),
                    DeductFlag: $("#DeductFlag").is(":checked") ? "Y" : "N",
                    InsureFlag: $("#ChkInsure").is(":checked") ? "Y" : "",
                    PurchaseClosingSeqNo: $("#SearchPurchaseClosingSeqNo").val()
                };

                $.fileDownload("/TMS/ClosingPurchasePay/Proc/PayClosingHandler.ashx", {
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

            //카고페이송금신청
            $("#BtnSendPay").on("click", function (e) {
                fnSendPay();
                return false;
            });

            //공제금액등록
            $("#BtnRegDeduct").on("click", function (e) {
                fnOpenDeduct();
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
    <asp:HiddenField runat="server" ID="HidSendPlanYMD" />
<div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="120"></asp:DropDownList>
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
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="DeductFlag" Text="<span></span>공제내역"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkInsure" Text="<span></span>산재보험적용"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
                <div class="search_line">
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="차량업체명"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호"/>
                    <asp:TextBox runat="server" ID="ClosingAdminName" class="type_01" AutoPostBack="false" placeholder="마감자"/>
                    <asp:TextBox runat="server" ID="SearchPurchaseClosingSeqNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="전표번호"/>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnRegDeduct" class="btn_01">공제금액등록</button>
                    <button type="button" runat="server" ID="BtnSendPay" class="btn_01">카고페이송금신청</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:30%;">
                    <h1>송금예정일</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 12px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '카고페이송금신청_송금예정일내역', '카고페이송금신청_송금예정일내역');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PayClosingSendListGrid', this);">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PayClosingSendListGrid');">항목순서 초기화</asp:LinkButton>
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
                <li class="right" style="width:70%; text-align: left;">
                    <h1 style="margin-left: 3px;">송금신청내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridPurchaseID, 'xlsx', '카고페이송금신청_송금신청내역', '카고페이송금신청_송금신청내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('PayClosingListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PayClosingListGrid');">항목순서 초기화</asp:LinkButton>
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
                <div class="left" style="width:30%;">
                    <div id="PayClosingSendListGrid"></div>
                </div>
                <div class="right" style="width:70%;">
                    <div id="PayClosingListGrid"></div>
                </div>
            </div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="거래처 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="SendPlanYMD">송금예정일</option>
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
                        <option value="ComName">차량업체명</option>
                        <option value="ComCorpNo">차량사업자번호</option>
                        <option value="PurchaseClosingSeqNo">전표번호</option>
                        <option value="NtsConfirmNum">국세청승인번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PayClosingSendListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PayClosingSendListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('PayClosingSendListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('PayClosingListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('PayClosingListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('PayClosingListGrid');">취소</button>
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

    <div id="DivDeduct">
        <div>
            <h1>공제금액등록</h1>
            <a href="#" onclick="fnCloseDeduct(); return false;" class="close_btn">x</a>
            <div class="gridWrap">
                <div id="PurchaseClosingDeductListGrid"></div>
            </div>
            <div class="textWrap">
                * 공제금액은 매입합계금액을 초과할 수 없습니다.<br/>
                * 공제금액을 입력하시면 송금예정액이 변경됩니다. (송금예정액=매입합계-공제금액-산재보험료)
            </div>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnUpdDeduct(); return false;">적용</button>
                <button type="button" class="btn_03" onclick="fnCloseDeduct(); return false;">닫기</button>
            </div>
        </div>
    </div>
</asp:Content>
