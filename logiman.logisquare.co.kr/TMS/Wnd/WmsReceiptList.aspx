<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WmsReceiptList.aspx.cs" Inherits="TMS.Wnd.WmsReceiptList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Wnd/Proc/WmsReceiptList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnWindowClose() {
            window.close();
        }
    </script>
    <style>
        ul.order_pg_area li span.ImageDownload {
            background: url("/images/icon/receipt_download_icon.png") no-repeat center;
            background-size: cover;
            display: inline-block;
            width: 30px;
            height: 30px;
            position: absolute;
            right: 50px;
            top: 15px;
            cursor: pointer;
        }
        
        ul.order_pg_area li span.ImageOpen {
            background: url("/images/icon/receipt_open_icon.png") no-repeat center;
            background-size: cover;
            display: inline-block;
            width: 30px;
            height: 30px;
            position: absolute;
            right: 15px;
            top: 15px;
            cursor: pointer;
        }

        #DispatchList { display:none;}
        #LayoverList { display:none;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderNo"/>
    <asp:HiddenField runat="server" ID="DeliveryNo"/>
    <asp:HiddenField runat="server" ID="ReceiptType"/>
    <asp:HiddenField runat="server" ID="PickupYMD"/>
    <asp:HiddenField runat="server" ID="ConsignorName"/>
    <asp:HiddenField runat="server" ID="HidFileUrl"/>
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="receipt_list">
                    <div id="DispatchList">
                        <h3 class="H3Name">온도기록계</h3>
                        <ul class="order_pg_area">
                        </ul>
                    </div>
                    <div id="LayoverList">
                        <h3 class="H3Name">배송증빙</h3>
                        <ul class="order_pg_area">
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
