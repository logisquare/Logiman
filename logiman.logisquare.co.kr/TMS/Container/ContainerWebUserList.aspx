<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ContainerWebUserList.aspx.cs" Inherits="TMS.Container.ContainerWebUserList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Container/Proc/ContainerWebUserList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:TextBox runat="server" ID="TextBox2" class="type_01 date" AutoPostBack="false" placeholder="달력"/>
                            <asp:TextBox runat="server" ID="TextBox3" class="type_01 date" AutoPostBack="false" placeholder="달력"/>
                            <asp:DropDownList runat="server" ID="DropDownList1" class="type_small" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DropDownList2" class="type_small" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DropDownList3" class="type_small" AutoPostBack="false"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="TextBox1" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </div>
                    </div>
                    <div class="grid_list">
                        <div id="ContainerWebUserListGrid"></div>
			            <div id="page"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
