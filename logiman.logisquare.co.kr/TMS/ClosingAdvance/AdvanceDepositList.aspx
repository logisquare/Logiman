<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdvanceDepositList.aspx.cs" Inherits="TMS.ClosingAdvance.AdvanceDepositList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingAdvance/Proc/AdvanceDepositList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#DepositClientName").on("keyup", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 365);
                    return;
                }
            });

            $("#DepositNote").on("keyup", function (event) {
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
                $("#PayType").val("");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#DepositClientName").val("");
                $("#DepositAmt").val("");
                $("#DepositNote").val("");
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                if (!$("#CenterCode").val()) {
                    fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
                    return false;
                }

                var objParam = {
                    CallType: "PayDepositListExcel",
                    CenterCode: $("#CenterCode").val(),
                    PayType: $("#PayType").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
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


            $("#BtnDetailSaveExcel").on("click", function () {
                if (!$("#HidCenterCode").val() || !$("#HidDepositSeqNo").val() || !$("#HidDepositClosingSeqNo").val()) {
                    fnDefaultAlert("선택된 입금 정보가 없습니다.");
                    return false;
                }

                var objParam = {
                    CallType: "AdvanceListExcel",
                    CenterCode: $("#HidCenterCode").val(),
                    DepositSeqNo: $("#HidDepositSeqNo").val(),
                    DepositClosingSeqNo: $("#HidDepositClosingSeqNo").val()
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

            //입금삭제
            $("#BtnDelDeposit").on("click", function (e) {
                fnDelDeposit();
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
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidDepositSeqNo" />
    <asp:HiddenField runat="server" ID="HidDepositClosingSeqNo" />

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
                    <asp:TextBox runat="server" ID="DepositClientName" class="type_01" AutoPostBack="false" placeholder="입금업체명"/>
                    <asp:TextBox runat="server" ID="DepositAmt" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="입금액"/>
                    <asp:TextBox runat="server" ID="DepositNote" class="type_01" AutoPostBack="false" placeholder="입금비고"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>  
            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnDelDeposit" class="btn_03">입금삭제</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:40%;">
                    <h1>입금내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 12px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '선급예수입금내역_입금내역', '선급예수입금내역_입금내역');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('AdvanceDepositListGrid', this);">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('AdvanceDepositListGrid');">항목순서 초기화</asp:LinkButton>
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
                    <h1 style="margin-left: 3px;">비용내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridDetailID, 'xlsx', '선급예수입금내역_비용내역', '선급예수입금내역_비용내역');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('AdvancePayListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('AdvancePayListGrid');">항목순서 초기화</asp:LinkButton>
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
                    <div id="AdvanceDepositListGrid"></div>
                </div>
                <div class="right" style="width:60%;">
                    <div id="AdvancePayListGrid"></div>
                </div>
            </div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="DepositClientName">입금업체명</option>
                        <option value="AdvanceClosingSeqNo">전표번호</option>
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
                        <option value="Hawb">H/AWB</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('AdvanceDepositListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('AdvanceDepositListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('AdvanceDepositListGrid');">취소</button>
            </div>
        </div>
    </div>
    
    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('AdvancePayListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('AdvancePayListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('AdvancePayListGrid');">취소</button>
            </div>
        </div>
    </div>

</asp:Content>
