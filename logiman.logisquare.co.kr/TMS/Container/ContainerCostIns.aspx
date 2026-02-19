<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ContainerCostIns.aspx.cs" Inherits="TMS.Container.ContainerCostIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Container/Proc/ContainerCostIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#SearchClientText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return;
                }
            });

            $("#SearchChargeText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return;
                }
            });

            $("#SearchText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return;
                }
            });

            $("#OrderNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function (event) {
                fnCheckPeriodAndSearch(event);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ViewOrderItemCode").val("");
                $("#OrderItemCode input[type='checkbox']").prop("checked", false);
                $("#ChkMyCharge").prop("checked", false);
                $("#ChkMyOrder").prop("checked", false);
                $("#ChkCnl").prop("checked", false);
                $("#SearchClientType").val("1");
                $("#SearchClientText").val("");
                $("#SearchChargeType").val("1");
                $("#SearchChargeText").val("");
                $("#GoodsItemCode").val("");
                $("#SearchType").val("1");
                $("#SearchText").val("");
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
        .popup_table tr td { padding: 0px !important; height: 32px; min-width: 160px;}
        .popup_table tr td span { margin-left: 5px;}
        .popup_table tr th { padding: 0px !important; height: 32px;}
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
    <asp:HiddenField runat="server" ID="PayClientCode"/>
    <asp:HiddenField runat="server" ID="PayClientInfo"/>
    <asp:HiddenField runat="server" ID="PayClientName"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="상차일 From"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="상차일 To"/>
                            <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                            <div id="DivOrderLocationCode" class="DivSearchConditions">
                                <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnorderedList"></asp:CheckBoxList>
                            </div>
                            <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                            <div id="DivOrderItemCode" class="DivSearchConditions">
                                <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnorderedList"></asp:CheckBoxList>
                            </div>
                            &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyCharge" Text="<span></span>내담당"/>
                            &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더"/>
                            &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkCnl" Text="<span></span>취소오더"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                        </div>
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="SearchClientType" class="type_01" AutoPostBack="false" Width="110"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            <asp:DropDownList runat="server" ID="SearchChargeType" class="type_01" AutoPostBack="false" Width="130"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchChargeText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            <asp:DropDownList runat="server" ID="GoodsItemCode" class="type_01" AutoPostBack="false" Width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false" Width="130"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
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
                                            <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('ContainerCostInsOrderListGrid');">항목관리</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('ContainerCostInsOrderListGrid');">항목순서 초기화</asp:LinkButton>
                                        </dd>
                                    </dl>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="grid_list" style="margin-top: 5px;">
                        <div id="ContainerCostInsOrderListGrid"></div>
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
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                            <col style="width:120px"/> 
                            <col style="width:auto;"/> 
                        </colgroup>
                        <tr>
                            <th>접수번호</th>
                            <td><span id="SpanOrderNo"></span></td>
                            <th>발주처</th>
                            <td><span id="SpanOrderClientName"></span></td>
                            <th>청구처</th>
                            <td><span id="SpanPayClientName"></span></td>
                            <th>화주</th>
                            <td><span id="SpanConsignorName"></span></td>
                            <th>작업일</th>
                            <td><span id="SpanPickupInfo"></span></td>
                            <th>화물</th>
                            <td><span id="SpanGoodsInfo"></span></td>
                        </tr>
                        <tr>
                            <th>업무특이사항<br/>(청구처)</th>
                            <td colspan="11" style="padding: 3px !important;">
                                <textarea id="OrderClientNote" class="type_100p" style="height: 100px;" readonly="readonly"></textarea>
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
                        <tr class="TrPayClient">
                            <td>
                                <asp:HiddenField runat="server" ID="ClientCode"/>
                                <asp:HiddenField runat="server" ID="ClientInfo"/>
                                <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="업체명 (고객사)"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="TrPayCar">
                            <td>
                                <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
                                <asp:HiddenField runat="server" ID="RefSeqNo"/>
                                <asp:HiddenField runat="server" ID="DispatchInfo"/>
                                <asp:HiddenField runat="server" ID="ComCode"/>
                                <asp:HiddenField runat="server" ID="ComInfo"/>
                                <asp:HiddenField runat="server" ID="CarSeqNo"/>
                                <asp:HiddenField runat="server" ID="CarInfo"/>
                                <asp:HiddenField runat="server" ID="DriverSeqNo"/>
                                <asp:HiddenField runat="server" ID="DriverInfo"/>
                                <asp:TextBox runat="server" ID="RefCarNo" CssClass="type_01 find" placeholder="차량번호 (배차)"></asp:TextBox>
                                <asp:DropDownList runat="server" CssClass="type_01" ID="CarDivType" Width="100"></asp:DropDownList>
                                <asp:TextBox runat="server" ID="ComName" CssClass="type_01 find" placeholder="차량업체명"></asp:TextBox>
                                <asp:TextBox runat="server" ID="CarNo" CssClass="type_01 find" placeholder="차량번호"></asp:TextBox>
                                <asp:TextBox runat="server" ID="DriverName" CssClass="type_small find" placeholder="기사명"></asp:TextBox>
                                <asp:TextBox runat="server" ID="DriverCell" CssClass="type_01 find" placeholder="기사휴대폰"></asp:TextBox>
                                <asp:DropDownList runat="server" CssClass="type_01" ID="InsureExceptKind" Width="128"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                    
                    <div class="grid_list" style="margin-top: 5px;">
                        <div id="ContainerCostInsPayListGrid" class="subGridWrap"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('ContainerCostInsOrderListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('ContainerCostInsOrderListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('ContainerCostInsOrderListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
