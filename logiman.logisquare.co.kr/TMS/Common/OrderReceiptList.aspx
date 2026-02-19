<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderReceiptList.aspx.cs" Inherits="TMS.Common.OrderReceiptList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Common/Proc/OrderReceiptList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
        });

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

    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderNo"/>
    <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
    <asp:HiddenField runat="server" ID="PickupYMD"/>
    <asp:HiddenField runat="server" ID="ConsignorName"/>
    <asp:HiddenField runat="server" ID="HidFileUrl"/>
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="receipt_list">
                    <h3 class="H3Name">상차화물 사진</h3>
                    <ul class="order_pg_area" id="PickupList">

                    </ul>

                    <h3 class="H3Name">하차화물 사진</h3>
                    <ul class="order_pg_area" id="GetList">
                    
                    </ul>

                    <h3 class="H3Name">인수증 사진</h3>
                    <ul class="order_pg_area" id="ReceiptList">
                    
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
