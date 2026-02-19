<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="DailySafetyCheckView.aspx.cs" Inherits="TMS.Dispatch.DailySafetyCheckView" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/DailySafetyCheckView.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div.page_line {width: 720px; position: relative; margin: 0px; padding: 0px;}
        div.checklist_print h1 {font-size:24px; font-weight:600; color:#999; padding-top:50px; text-align:center;}
        div.checklist_print h2 {font-size:20px; font-weight:400; color:#333; padding-top:10px; text-align:right;}
        
        table.type_01 {width:100%; margin-top:15px;}
        table.type_01 thead th {border:0; height:35px; color:#666; background:#F4F6F8; font-weight: 400; font-size: 16px;}
        
        table.type_02 {width:100%; margin-top:15px; border-top:2px solid #000;}
        table.type_02 th {height:35px; line-height: 30px; border:1px solid #E1E6EA; background:#F4F6F8; text-align:center;  padding:0 10px; color:#000}
        table.type_02 td {height:35px; line-height: 30px; border:1px solid #E1E6EA; text-align:left; padding:0 10px; color:#000;}
        table.type_02 td.center { text-align: center;}

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
    <asp:HiddenField runat="server" ID="CheckData"/>
    <div class="btnArea">
        <div class="btn">
            <button class="btn_01" type="button" onclick="window.print(); return false;">인쇄 및 PDF저장</button>
        </div>
        <div class="help">* PDF파일로 저장하시려면 대상을 <b>"PDF로 저장"</b>으로 선택하여 저장해주세요.</div>
    </div>
    <div class="checklist_print" style="float:none;">
        
    </div>
</asp:Content>
