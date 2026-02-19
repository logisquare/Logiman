<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemGroupList.aspx.cs" Inherits="SSO.Item.ItemGroupList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Item/Proc/ItemGroupList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#GroupCode").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#GroupName").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }

        function fnClosePopUpLayer() {
            fnCloseCpLayer();
            fnCallGridData(GridID);
        }

    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:TextBox runat="server" ID="GroupCode" class="type_01" AutoPostBack="false" placeholder="그룹코드"/>
                    <asp:TextBox runat="server" ID="GroupName" class="type_01" AutoPostBack="false" placeholder="그룹명"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    <button type="button" class="btn_01" onclick="fnGroupIns('그룹 등록');">그룹등록</button>
                </div>
            </div>  
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <h1>항목 그룹</h1>&nbsp;
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                </li>
            </ul>

            <div id="ItemGroupListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
</asp:Content>
