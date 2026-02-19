<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientDetailList.aspx.cs" Inherits="TMS.Common.ClientDetailList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/ClientDetailList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#SearchText").on("keydown",
                function(event) {
                    if (event.keyCode === 13) {
                        fnCallGridData(GridID);
                        return;
                    }
                });

            $("#BtnListSearch").on("click",
                function() {
                    fnCallGridData(GridID);
                    return;
                });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="Type"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </div>
                    </div>
                    <div class="grid_list">
                        <div id="ClientDetailListGrid"></div>
			            <div id="page"></div>
                        <!-- 검색 다이얼로그 UI -->
                        <div id="gridDialog" title="Grid 검색">
                            <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                            <div>
                                <select id="GridSearchDataField" class="type_01">
                                    <option value="ALL">전체</option>
                                    <option value="ClientName">고객사명</option>
                                    <option value="ClientChargeName">담당자명</option>
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
