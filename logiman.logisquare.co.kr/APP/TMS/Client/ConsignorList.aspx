<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppSite.Master" AutoEventWireup="true" CodeBehind="ConsignorList.aspx.cs" Inherits="APP.TMS.Client.ConsignorList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Client/Proc/ConsignorList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                fnCallResultData(1);
                return;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="Header" ContentPlaceHolderID="HeaderContent" runat="server">
    <asp:HiddenField runat="server" ID="HidParam"/>
    <asp:HiddenField runat="server" ID="HidCallType"/>
    <div class="header">
        <h1>화주현황</h1>
        <button type="button" onclick="fnDataIns();">화주등록</button>
    </div>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidListparam" />
    <div id="DataList">
        <!--검색영역 시작-->
        <div class="search_body">
            <div class="search_area">
                <ul class="ul_type_04">
                    <li>
                        <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01"></asp:DropDownList>
                    </li>
                    <li>
                        <asp:DropDownList runat="server" ID="UseFlag" CssClass="type_01"></asp:DropDownList>
                    </li>
                    <li>
                        <asp:TextBox runat="server" ID="ConsignorName" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    </li>
                </ul>
                <ul class="ul_type_01">
                    <li>
                        <button type="button" class="search_btn" ID="BtnListSearch">검색하기</button>
                    </li>
                </ul>
            </div>
            <div class="search_up">
                <button type="button" class="search_up" onclick="fnSlideSearch();"></button>
            </div>
        </div>
        <!--검색영역 끝-->
        
        <!--리스트 영역 시작-->
        <div class="list_area">
            <p class="list_count">총 <asp:Label runat="server" ID="TotalCount">0</asp:Label> 건</p>
            <ul class="car_list" id="ConsignorData">
                
            </ul>
            <div class="more_list">
                <button type="button">더보기</button>
            </div>
        </div>
        <!--리스트 영역 끝-->
    </div>
</asp:Content>