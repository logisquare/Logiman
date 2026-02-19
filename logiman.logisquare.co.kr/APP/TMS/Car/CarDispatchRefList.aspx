<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppSite.Master" AutoEventWireup="true" CodeBehind="CarDispatchRefList.aspx.cs" Inherits="APP.TMS.Car.CarDispatchRefList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Car/Proc/CarDispatchRefList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
    <div class="header">
        <h1>차량관리</h1>
        <button type="button" onclick="fnDataIns();">통합등록</button>
    </div>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidParam"/>
    <asp:HiddenField runat="server" ID="HidCallType"/>
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
                        <asp:DropDownList runat="server" ID="CarDivType" CssClass="type_01"></asp:DropDownList>
                    </li>
                </ul>
                <ul class="ul_type_04">
                    <li>
                        <asp:TextBox runat="server" ID="ComName" CssClass="type_01" placeholder="업체명"></asp:TextBox>
                    </li>
                    <li>
                        <asp:TextBox runat="server" ID="ComCorpNo" CssClass="type_01" placeholder="사업자번호"></asp:TextBox>
                    </li>
                    <li>
                        <asp:TextBox runat="server" ID="CarNo" CssClass="type_01" placeholder="차량번호"></asp:TextBox>
                    </li>
                </ul>
                <ul class="ul_type_chk_multi">
                    <li style="width:50%;">
                        <input type="checkbox" runat="server" name="CooperatorFlag" id="CooperatorFlag"/>
                        <label for="CooperatorFlag">
                            협력업체
                            <span></span>
                        </label>
                    </li>
                    <li style="width:50%;">
                        <input type="checkbox" runat="server" name="CargoManFlag" id="CargoManFlag"/>
                        <label for="CargoManFlag">
                            카고맨
                            <span></span>
                        </label>
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
            <ul class="car_list" id="CarData">
            </ul>
            <div class="more_list">
                <button type="button">더보기</button>
            </div>
        </div>
        <!--리스트 영역 끝-->
    </div>
</asp:Content>