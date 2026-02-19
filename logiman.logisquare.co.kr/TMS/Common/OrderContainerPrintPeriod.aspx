<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderContainerPrintPeriod.aspx.cs" Inherits="TMS.Common.OrderContainerPrintPeriod" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/OrderContainerPrintPeriodList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div.page_line {width: 100%; position: relative; margin: 0px; padding: 0px;}
        div.print_area ul.top_ul {overflow:hidden; width:100%;}
        div.print_area ul.top_ul {font-size:12px;}
        div.print_area ul.top_ul li:first-child {float:left;}
        div.print_area ul.top_ul li:last-child {float:right;}
        div.print_area h1 {font-size:20px; font-weight:700; color:#333333; padding-top:10px; text-align:center;}
        table.type_01 {width:100%; margin-top:15px;}
        table.type_01 thead th {border:1px solid #E1E6EA; height:30px; color:#707070; background:#F4F6F8;}
        table.type_01 tbody td {border:1px solid #E1E6EA; height:30px; text-align:center; padding:0 10px;}
        div.print_area h2 {padding-top:10px; font-size:16px; font-weight:700; color:#333;}
        table.type_02 {width:100%; margin-top:15px; border-top:2px solid #000; margin-left:0px;}
        table.type_02 thead.tleft td {text-align:left;}
        table.type_02 thead th {text-align:center; }
        table.type_02 th {font-size:14px; height:30px; border:1px solid #E1E6EA; background:#F4F6F8; text-align:left; padding:0 2px; color:#000; text-align:center; word-break: keep-all;}
        table.type_02 tbody.amt td {text-align:right;}
        table.type_02 td {height:30px; border:1px solid #E1E6EA; text-align:left; padding:0 3px; color:#000; text-align:center; font-size:12px; word-break:break-all;}
        table.type_02 td.money {text-align:right !important;}
        table.type_02 tfoot th {text-align:right; font-weight:500;}
        table.type_02 tfoot th strong {font-weight:700; font-size:16px; color:#5674C8; padding-left:10px;}
        div.print_area p.charge_info {padding-top:10px; font-size:12px; color:#333333;}
        div.print_area  ul.bottom_ul {overflow:hidden; width:100%; margin-top:60px;}
        div.print_area  ul.bottom_ul li {float:left; width:33.33333333333333%; padding:5px 10px; line-height:1.5; border:1px solid #E1E6EA; color:#333333; text-align:center; font-size:12px;}
        div.print_bottom {background:#F4F6F8; padding:10px 0; width:100%; margin-top:12px;}
        div.print_bottom dl dt {font-size:16px; font-weight:700; text-align:center; padding-bottom:15px;}
        div.print_bottom dl dd {color:#707070; text-align:center; padding-bottom:15px;}
        div.print_bottom ul {border-top:1px solid #D9DEE2; width:100%; padding:15px 20px 0; overflow:hidden;}
        div.print_bottom ul li {float:left; margin-right:10px;}
        div.print_bottom ul li:nth-child(5n) {margin-right:0px;}
        div.print_bottom ul li:nth-child(6n) {clear:both;}
        div.btnArea{width:100%; height:100px; margin:0px; margin-top:5px; padding:0px; text-align:right; border-bottom:2px dashed #aaa; }
        @media print {
            @page {
                size: A4;
                margin: 5mm;
            }
            body { overflow-y: initial !important; height: auto;}
            html { overflow-y: initial !important; height: auto;}
            div.print_area div {height: auto !important;}
            div.btnArea {display:none;}
            html, body { -webkit-print-color-adjust:exact;}
            table { page-break-inside:auto; }
            tr    { page-break-inside:avoid;}
            td    { page-break-inside:avoid;}
            thead { display:table-header-group; }
            tfoot { display:table-footer-group; }

        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="HidGridID" />
    <asp:HiddenField runat="server" ID="OrderNos1" />
    <asp:HiddenField runat="server" ID="OrderNos2" />
    <asp:HiddenField runat="server" ID="SaleClosingSeqNo" />
    <asp:HiddenField runat="server" ID="CenterCode" />
    <asp:HiddenField runat="server" ID="ClientCode" />
    <asp:HiddenField runat="server" ID="SupplyAmtTotal" />
    <asp:HiddenField runat="server" ID="TaxAmtTotal" />
    <asp:HiddenField runat="server" ID="OrgAmtTotal" />
    <asp:HiddenField runat="server" ID="AdminName" />
    <asp:HiddenField runat="server" ID="AdminID" />
    <asp:HiddenField runat="server" ID="ClientName" />
    <asp:HiddenField runat="server" ID="CenterName" />
    <asp:HiddenField runat="server" ID="AdminTel" />
    <asp:HiddenField runat="server" ID="AdminMobile" />
    <asp:HiddenField runat="server" ID="DeptName" />
    <asp:HiddenField runat="server" ID="AdminPosition" />
    <asp:HiddenField runat="server" ID="AdminMail" />
    <asp:HiddenField runat="server" ID="PdfFlag" />
    <asp:HiddenField runat="server" ID="hidPage" />
    <div class="btnArea" runat="server" id="BtnArea">
        <div class="btn">
            <div class="print_input">
                <asp:TextBox runat="server" ID="ChargeName" CssClass="type_01 find" Width="140px" placeholder="청구처담당자(검색)"></asp:TextBox>
                <asp:DropDownList runat="server" ID="ChargeNameList" CssClass="type_01"/>
                <asp:TextBox runat="server" ID="RecName" CssClass="type_01" Width="80px" ReadOnly="True"></asp:TextBox>
                <asp:TextBox runat="server" ID="RecMail" CssClass="type_01" ReadOnly="True" placeholder="수신자 메일주소"></asp:TextBox>
                <asp:TextBox runat="server" ID="SendMail" CssClass="type_01" placeholder="발신자 메일주소"></asp:TextBox>
                &nbsp;
                <asp:CheckBox runat="server" ID="CheckMail" Text="<span></span>기본 메일(shtax@logisquare.co.kr)로 변경"/>
            </div>
            <ul class="print_btn_type02">
                <li>
                    <asp:CheckBox runat="server" ID="SaleClosingChk" Text="<span></span>매출마감"/>
                    <button type="button" class="btn_01" onclick="fnMailSendConfirm();">메일발송</button>
                </li>
                <li>
                    <button type="button" class="btn_01" onclick="window.print(); return false;">인쇄</button>&nbsp;
                    <button type="button" class="btn_02" onclick="fnPdfSave(); return false;">PDF저장</button>
                </li>
            </ul>
        </div>
        <div class="help">* PDF파일로 저장하시려면 대상을 <b>"PDF로 저장"</b>으로 선택하여 저장해주세요.</div>
    </div>
    <div class="print_area" style="float:none;">
        <asp:Literal id="repDetailList" runat="server"></asp:Literal>
    </div>
</asp:Content>