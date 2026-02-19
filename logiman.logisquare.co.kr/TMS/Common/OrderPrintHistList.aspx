<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderPrintHistList.aspx.cs" Inherits="TMS.Common.OrderPrintHistList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Common/Proc/OrderPrintHistList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            $("#SearchText").attr("readonly", true);

            $("#SearchText").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#OrderNo").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#SaleClosingSeqNo").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPagePeriod(1, 60);
                    return;
                }
            });

            $("#SearchType").on("change", function (event) {
                if ($(this).val() === "") {
                    $("#SearchText").attr("readonly", true);
                    $("#SearchText").val("");
                    return;
                } else {
                    $("#SearchText").attr("readonly", false);
                    $("#SearchText").focus();
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 60);
                return;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name">내역서 발송내역</h3>
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            발송기간 : 
                            <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="접수일 From" width="110"/>
                            <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="접수일 To" width="110"/>
                            <asp:TextBox runat="server" ID="OrderNo" class="type_01" AutoPostBack="false" placeholder="오더번호"/>
                            <asp:TextBox runat="server" ID="SaleClosingSeqNo" class="type_01" AutoPostBack="false" placeholder="전표번호"/>
                            <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false" width="110"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SearchText" class="type_01" placeholder="검색어"/>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </div>
                    </div>
                    <div class="grid_list">
                        <div id="OrderPrintHistListGrid"></div>
                        <div id="page"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
