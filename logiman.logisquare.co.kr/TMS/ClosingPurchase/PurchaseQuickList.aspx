 <%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseQuickList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseQuickList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseQuickList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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

            $("#CarNo").on("keyup", function (event) {
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

            $("#ConsignorName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#AcceptAdminName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#DispatchAdminName").on("keyup", function (event) {
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
                $("#QuickType").val("");
                $("#CarDivType").val("");
                $("#ComName").val("");
                $("#ComCorpNo").val("");
                $("#CarNo").val("");
                $("#DriverName").val("");
                $("#DriverCell").val("");
                $("#ConsignorName").val("");
                $("#AcceptAdminName").val("");
                $("#DispatchAdminName").val("");
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
                    CallType: "PurchaseQuickPayListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    DeliveryLocationCodes: DLocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ClosingFlag: $("#ClosingFlag").val(),
                    QuickType: $("#QuickType").val(),
                    CarDivType: $("#CarDivType").val(),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarNo: $("#CarNo").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    ConsignorName: $("#ConsignorName").val(),
                    AcceptAdminName: $("#AcceptAdminName").val(),
                    DispatchAdminName: $("#DispatchAdminName").val()
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx", {
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

                if (!$("#HidComCorpNo").val()) {
                    fnDefaultAlert("선택된 차량업체 정보가 없습니다.");
                    return false;
                }

                var objParam = {
                    CallType: "HometaxListExcel",
                    CenterCode: $("#HidCenterCode").val(),
                    ComCode: $("#HidComCode").val(),
                    ComCorpNo: $("#HidComCorpNo").val(),
                    NtsConfirmNum: $("#HidNtsConfirmNum").val(),
                    TaxWriteDateTo: $("#TaxWriteDateTo").val()
                };

                $.fileDownload("/TMS/ClosingPurchase/Proc/PurchaseQuickHandler.ashx", {
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

            //마감
            $("#BtnClosingInfo").on("click", function (e) {
                fnDefaultAlert("바로지급건은 송금신청 시 5분 이내에 운송료가 지급됩니다.", "info");
                return false;
            });

            //미마감 내역
            $("#BtnOpenNoClosing").on("click", function (e) {
                fnOpenRightSubLayer("미마감 내역", "/TMS/ClosingPurchase/PurchaseQuickMonthlyList", "500px", "700px", "80%");
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
    <asp:HiddenField runat="server" ID="HidComCode" />
    <asp:HiddenField runat="server" ID="HidComCorpNo" />
    <asp:HiddenField runat="server" ID="HidNtsConfirmNum" />

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
                    <asp:DropDownList runat="server" ID="QuickType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="CarDivType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="차량업체명"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DriverName" CssClass="type_01" AutoPostBack="false" placeholder="기사명"></asp:TextBox>
                    <asp:TextBox runat="server" ID="DriverCell" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="기사휴대폰"/>
                    <asp:TextBox runat="server" ID="ConsignorName" class="type_01" AutoPostBack="false" placeholder="화주명"/>
                    <asp:TextBox runat="server" ID="AcceptAdminName" class="type_01" AutoPostBack="false" placeholder="접수자명"/>
                    <asp:TextBox runat="server" ID="DispatchAdminName" class="type_01" AutoPostBack="false" placeholder="배차자명"/>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnClosing" class="btn_01">마감</button>
                    <button type="button" class="btn_help" id="BtnClosingInfo"></button>
                    &nbsp;
                    <button type="button" runat="server" ID="BtnOpenNoClosing" class="btn_02">미마감내역</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:60%;">
                    <h1>운송내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 6px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '빠른입금마감_운송내역', '빠른입금마감_운송내역');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('PurchaseQuickPayListGrid', this);">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseQuickPayListGrid');">항목순서 초기화</asp:LinkButton>
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
                <li class="right" style="width:40%; text-align: left;">
                    <h1 style="margin-left: 3px;">계산서내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridDetailID, 'xlsx', '빠른입금마감_계산서내역', '빠른입금마감_계산서내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('PurchaseQuickBillListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('PurchaseQuickBillListGrid');">항목순서 초기화</asp:LinkButton>
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
                <div class="left" style="width:60%;">
                    <div id="PurchaseQuickPayListGrid"></div>
                    <div id="GridSelectedInfo" style="margin-top: 5px; font-weight: 700; color: #5674C8; text-align: right;"></div>
                </div>
                <div class="right" style="width:40%;">
                    <div id="PurchaseQuickBillListGrid"></div>
                </div>
            </div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="거래처 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
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
                        <option value="NTS_CONFIRM_NUM">국세청승인번호</option>
                        <option value="INVOICER_CORP_NAME">공급자</option>
                        <option value="INVOICEE_CORP_NAME">공급받는자</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('PurchaseQuickPayListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('PurchaseQuickPayListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('PurchaseQuickPayListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('PurchaseQuickBillListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('PurchaseQuickBillListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('PurchaseQuickBillListGrid');">취소</button>
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

    <div id="DivPurchaseInsure">
        <asp:HiddenField runat="server" ID="PopInsureCenterCode"/>
        <asp:HiddenField runat="server" ID="PopInsureComCode"/>
        <asp:HiddenField runat="server" ID="PopInsureYMD"/>
        <asp:HiddenField runat="server" ID="PopInsureChkFlag" Value="N"/>
        <asp:HiddenField runat="server" ID="PopInsureTargetFlag" Value=""/>
        <div>
            <h1>빠른입금마감</h1>
            <a href="#" onclick="fnClosePurchaseInsure(); return false;" class="close_btn">x</a>
            <h2>
                ▶ 산재보험료산정<button type="button" class="btn_help"  onclick="fnInsureHelp(); return false;"></button>
                <button type="button" class="btn_01" onclick="fnInsureCheck(); return false;" style="float: right;">대상확인</button>
                <span style="float: right; color: red; font-weight: bold; margin-right: 10px;" id="PopSpanInsureInfo"></span>
            </h2>
            <div class="insureWrap">
                <table style="width: 100%;">
                    <tr>
                        <td>
                            1. 경비공제 후 금액(월 보수액)
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopTransAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            2. 예상 산재보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopInsureRateAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>   
                    </tr>
                    <tr>
                        <td>
                            3. 감경보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopInsureReduceAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            4. 실제 납부보험료
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopInsurePayAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            5. 운송/주선사 부담금액
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopCenterInsureAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                        <td>
                            6. 차주 부담금액
                        </td>
                        <td class="tr">
                            <asp:TextBox runat="server" ID="PopInsureAmt" class="type_01" AutoPostBack="false" Text="0" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                             ※ 표시된 금액과 운송사에 고지된 금액은 차이가 있을 수 있습니다.
                        </td>
                        <td class="tr">
                            <asp:CheckBox runat="server" id="PopInsureFlag" Checked="true" Text="<span></span>보험적용"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnClosePurchaseInsure(); return false;">닫기</button>
                <button type="button" class="btn_01" onclick="fnInsClosing(); return false;">마감</button>
            </div>
        </div>
    </div>
</asp:Content>
