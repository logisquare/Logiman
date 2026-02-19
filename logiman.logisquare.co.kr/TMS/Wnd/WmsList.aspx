<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WmsList.aspx.cs" Inherits="TMS.Wnd.WmsList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Wnd/Proc/WmsList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function (event) {
                fnCheckPeriodAndSearch(event);
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ChkMyOrder").prop("checked", false);
                $("#ChkCnl").prop("checked", false);
                $("#CarNo").val("");
                $("#ComCorpNo").val("");
                $("#DriverName").val("");
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }

        function fnCheckPeriodAndSearch(event) {
            fnMoveToPagePeriod(1, 63);
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidOrderNo" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                    <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호" Width="120"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호" Width="120"/>
                    <asp:TextBox runat="server" ID="DriverName" class="type_small" AutoPostBack="false" placeholder="기사명"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더" Visible="False"/>
				    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkCnl" Text="<span></span>취소오더"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:60%;">
                    <h1 style="margin-left: 3px;">배차현황</h1>
                    <ul class="drop_btn" style="float: right; margin-right: 12px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '배차현황', '배차현황');">엑셀다운로드</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('WmsListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 저장" href="javascript:fnSaveColumnCustomLayout('WmsListGrid');">항목순서 저장</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('WmsListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download" style="float: right; margin-right: 10px;" Visible="False">엑셀다운로드</button>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
                <li class="right" style="width:40%; text-align: left;">
                    <h1 style="margin-left: 3px;">배송현황</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
                                    <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridDetailID, 'xlsx', '배송현황', '배송현황');">엑셀다운로드</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('WmsLayoverListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 저장" href="javascript:fnSaveColumnCustomLayout('WmsLayoverListGrid');">항목순서 저장</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('WmsLayoverListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                    <button type="button" runat="server" ID="BtnDetailSaveExcel" class="btn_02 download" style="float: right; margin-right: 10px;" Visible="False">엑셀다운로드</button>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult2" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
            </ul>
            
            <div class="grid_type_03">
                <div class="left" style="width:60%;">
                    <div id="WmsListGrid"></div>
                    <div id="page"></div>
                </div>
                <div class="right" style="width:40%;">
                    <div id="WmsLayoverListGrid"></div>
                </div>
            </div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="OrderClientName">발주처명</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="PickupPlace">상차지</option>
                        <option value="CarNo">차량번호</option>
                        <option value="DriverName">기사명</option>
                        <option value="DriverCell">기사휴대폰</option>
                        <option value="OrderNo">오더번호</option>
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
                        <option value="DeliveryName">거래처</option>
                        <option value="LayoverConsignorName">화주사</option>
                        <option value="DeliveryTelNo">전화번호</option>
                        <option value="DriverCell">휴대폰번호</option>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('WmsListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('WmsListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('WmsListGrid');">취소</button>
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
</asp:Content>
