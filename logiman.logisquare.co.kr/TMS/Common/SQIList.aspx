<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SQIList.aspx.cs" Inherits="TMS.Common.SQIList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/SQIList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#SearchClientText").on("keydown",
                function(event) {
                    if (event.keyCode === 13) {
                        fnMoveToPage(1);
                        return;
                    }
                });

            $("#BtnListSearch").on("click",
                function () {
                    fnMoveToPage(1);
                    return;
                });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="OrderType"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name">서비스이슈 현황</h3>
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="발생일 From"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="발생일 To"/>
                            <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                            <div id="DivOrderLocationCode" class="DivSearchConditions">
                                <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                            </div>
                            <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                            <div id="DivOrderItemCode" class="DivSearchConditions">
                                <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                            </div>
                            <asp:DropDownList runat="server" ID="SearchClientType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </div>
                    </div>
                    <div class="grid_list">
                        <div id="SQIListGrid"></div>
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
                                    <option value="PayClientName">오더번호</option>
                                </select>
                                <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                                <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                                <br/>
                                <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span> 대/소문자 구분</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
