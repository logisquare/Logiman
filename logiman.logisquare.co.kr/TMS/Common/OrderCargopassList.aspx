<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderCargopassList.aspx.cs" Inherits="TMS.Common.OrderCargopassList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/OrderCargopassList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#CargopassOrderNo").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#OrderNo").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 31);
                    return false;
                }
            });

            $("#ComCorpNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#CarNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#DriverName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#DriverCell").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#RegAdminName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });
            
            $("#BtnListSearch").on("click", function (event) {
                fnCheckPeriodAndSearch(event);
                return false;
            });

            $("#BtnGoCargopassExtList").on("click", function (event) {
                fnOpenCargopassExtList();
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewCargopassStatus").val("");
                $("#CargopassStatus input[type='checkbox']").prop("checked", false);
                $("#CargopassOrderNo").val("");
                $("#OrderNo").val("");
                $("#ComCorpNo").val("");
                $("#CarNo").val("");
                $("#DriverName").val("");
                $("#DriverCell").val("");
                return;
            });
        });

        function fnCheckPeriodAndSearch(event) {

            if ($("#CargopassOrderNo").val().length > 0 && $.isNumeric($("#CargopassOrderNo").val())) { //연동번호 입력 검색
                fnMoveToPage(1);
                return false;
            }

            fnMoveToPagePeriod(1, 31);
            return false;
        }
    </script>
    <style>
        form { height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="OrderType"/>
    <asp:HiddenField runat="server" ID="HidCenterCode"/>
    <asp:HiddenField runat="server" ID="HidCargopassOrderNo"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name">
                    카고패스 연동현황
                    <button type="button" runat="server" ID="BtnGoCargopassExtList" class="btn_01" style="float: right;">카고패스 현황</button>
                </h3>
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="접수일 From" width="110"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="접수일 To" width="110"/>
                            <asp:TextBox runat="server" id="ViewCargopassStatus" ToolTip="연동상태" CssClass="type_01 SearchConditions" placeholder="연동상태" readonly></asp:TextBox>
                            <div id="DivCargopassStatus" class="DivSearchConditions">
                                <asp:CheckBoxList runat="server" ID="CargopassStatus" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                            </div>
                            <asp:TextBox runat="server" ID="CargopassOrderNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="연동번호"/>
                            <asp:TextBox runat="server" ID="OrderNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="오더번호"/>

                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                        </div>
                        <div class="search_line">
                            <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="차량사업자번호"/>
                            <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                            <asp:TextBox runat="server" ID="DriverName" class="type_small" AutoPostBack="false" placeholder="기사명"/>
                            <asp:TextBox runat="server" ID="DriverCell" class="type_01" AutoPostBack="false" placeholder="기사휴대폰"/>
                            <ul class="drop_btn" style="float: right; margin-right: 20px;">
                                <li>
                                    <dl>
                                        <dt>항목 설정</dt>
                                        <dd>
                                            <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '카고패스연동현황', '카고패스연동현황');">엑셀다운로드</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderCargopassListGrid', this);">항목관리</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderCargopassListGrid');">항목순서 초기화</asp:LinkButton>
                                        </dd>
                                    </dl>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="grid_list">
                        <div id="OrderCargopassListGrid"></div>
			            <div id="page"></div>
                        <!-- 검색 다이얼로그 UI -->
                        <div id="gridDialog" title="Grid 검색">
                            <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                            <div>
                                <select id="GridSearchDataField" class="type_01">
                                    <option value="ALL">전체</option>
                                </select>
                                <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                                <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                                <br/>
                                <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderCargopassListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderCargopassListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderCargopassListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
