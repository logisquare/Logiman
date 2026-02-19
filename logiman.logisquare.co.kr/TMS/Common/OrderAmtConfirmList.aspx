<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderAmtConfirmList.aspx.cs" Inherits="TMS.Common.OrderAmtConfirmList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/OrderAmtConfirmList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return false;
            });
        });
    </script>
    <style>
        form {height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="ListType" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name">자동운임 수정승인</h3>
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="시작일 From"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="종료일 To"/>
                            <asp:DropDownList runat="server" ID="ReqStatus" class="type_01" width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="PayType" class="type_01" width="100"></asp:DropDownList>
                            &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyCharge" Text="<span></span>내담당"/>
                            &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </div>
                        <div class="search_line">
                            <asp:TextBox runat="server" ID="ConsignorName" class="type_01" AutoPostBack="false" placeholder="화주명"/>
                            <asp:TextBox runat="server" ID="PayClientName" class="type_01" AutoPostBack="false" placeholder="청구처명"/>
                            <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                            <asp:TextBox runat="server" ID="OrderNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="오더번호"/>
                        </div>
                    </div>
                    <div class="grid_list">
                        <ul class="grid_option">
                            <li class="left">&nbsp;</li>
                            <li class="right">
                                <ul class="drop_btn">
                                    <li>
                                        <dl>
                                            <dt>항목 설정</dt>
                                            <dd>
                                                <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '자동운임수정승인내역', '자동운임수정승인내역');">엑셀다운로드</asp:LinkButton>
                                            </dd>
                                        </dl>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                        <div id="OrderAmtConfirmGrid"></div>
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
                </div>
            </div>
        </div>
    </div>
</asp:Content>
