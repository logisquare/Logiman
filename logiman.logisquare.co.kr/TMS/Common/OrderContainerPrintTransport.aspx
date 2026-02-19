<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderContainerPrintTransport.aspx.cs" Inherits="TMS.Common.OrderContainerPrintTransport" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/OrderContainerPrintTansList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div.page_line {width: 720px; position: relative; margin: 0px; padding: 0px;}
        div.transport_print ul.top_ul {overflow:hidden; width:100%;}
        div.transport_print ul.top_ul {font-size:12px;}
        div.transport_print ul.top_ul li:first-child {float:left;}
        div.transport_print ul.top_ul li:last-child {float:right;}
        div.transport_print h1 {font-size:20px; font-weight:400; color:#333333; padding-top:10px; text-align:center;}
        table.type_01 {width:100%; margin-top:15px;}
        table.type_01 thead th {border:1px solid #E1E6EA; height:30px; color:#707070; background:#F4F6F8;}
        table.type_01 tbody td {border:1px solid #E1E6EA; height:30px; text-align:center; padding:0 10px;}
        div.transport_print h2 {padding-top:35px; font-size:16px; font-weight:400; color:#333;}
        table.type_02 {width:100%; margin-top:15px; border-top:2px solid #000;}
        table.type_02 thead.amt th {text-align:center;}
        table.type_02 th {height:30px; border:1px solid #E1E6EA; background:#F4F6F8; text-align:left; padding:0 10px; color:#333333}
        table.type_02 tbody.amt td {text-align:center;}
        table.type_02 td {height:30px; border:1px solid #E1E6EA; text-align:left; padding:0 10px; color:#707070;}
        table.type_02 td.money {text-align:right !important;}
        table.type_02 tfoot th {text-align:right; font-weight:500;}
        table.type_02 tfoot th strong {font-weight:700; font-size:16px; color:#5674C8; padding-left:10px;}
        div.transport_print p.charge_info {padding-top:10px; font-size:12px; color:#333333;}
        div.transport_print  ul.bottom_ul {overflow:hidden; width:100%; margin-top:60px;}
        div.transport_print  ul.bottom_ul li {float:left; width:33.33333333333333%; padding:5px 10px; line-height:1.5; border:1px solid #E1E6EA; color:#333333; text-align:center; font-size:12px;}
        div.print_bottom {background:#F4F6F8; padding:10px 0; width:100%; margin-top:12px;}
        div.print_bottom dl dt {font-size:16px; font-weight:700; text-align:center; padding-bottom:15px;}
        div.print_bottom dl dd {color:#707070; text-align:center; padding-bottom:15px;}
        div.print_bottom ul {border-top:1px solid #D9DEE2; width:100%; padding:15px 20px 0; overflow:hidden;}
        div.print_bottom ul li {float:left; margin-right:10px;}
        div.print_bottom ul li:nth-child(5n) {margin-right:0px;}
        div.print_bottom ul li:nth-child(6n) {clear:both;}
        div.btnArea{width:720px; height:70px; margin:0px; margin-top:5px; padding:0px; text-align:right; border-bottom:2px dashed #aaa; }
        @media print {
            @page {
                size: A4;
                margin: 5mm;
            }
            body { overflow-y: initial !important; height: auto;}
            html { overflow-y: initial !important; height: auto;}
            div.btnArea {display:none;}
            html, body { -webkit-print-color-adjust:exact;}
            table { page-break-inside:auto; }
            tr    { page-break-inside:avoid; page-break-after:auto; }
            thead { display:table-header-group; }
            tfoot { display:table-footer-group; }
        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidGridID" />
    <asp:HiddenField runat="server" ID="OrderNos" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <div class="btnArea">
	    <div class="btn">
		    <button class="btn_01" onclick="window.print(); return false;">인쇄</button>
	    </div>
	    <div class="help">* 인쇄시 <b>"배경색 및 이미지 인쇄"</b>가 체크되어 있는지 확인해 주십시오.</div>
    </div>
    <div class="transport_print" style="float:none;">
                        
    </div>
</asp:Content>