<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebClosingPrint.aspx.cs" Inherits="WEB.Closing.WebClosingPrint" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        $(document).ready(function () {
            if ($("#DisplayMode").val() === "Y") {
                fnDefaultAlert($("#ErrMsg").val(), "warning", "parent.fnCloseCpLayer();");
                return;
            }
        });
    </script>
    <style>
        div.btnArea{width:100%; margin:0px; margin-top:5px; padding:0px 0px 10px; text-align:right; border-bottom:2px dashed #aaa; }
        div.print_bottom {background:#F4F6F8; padding:10px 0; width:100%; margin-top:12px;}
        div.print_bottom dl dt {font-size:16px; font-weight:700; text-align:center; padding-bottom:15px;}
        div.print_bottom dl dd {color:#707070; text-align:center; padding-bottom:15px;}
        div.print_bottom ul {border-top:1px solid #D9DEE2; width:100%; padding:15px 20px 0; overflow:hidden;}
        div.print_bottom ul li {float:left; margin-right:10px;}
        div.print_bottom ul li:nth-child(5n) {margin-right:0px;}
        div.print_bottom ul li:nth-child(6n) {clear:both;}
        table.popup_table tr td {text-align:right;}
        h1 {font-size:24px; font-weight:bold; text-align:center; display:none;}
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
            tr    { page-break-inside:avoid;}
            td    { page-break-inside:avoid;}
            thead { display:table-header-group; }
            tfoot { display:table-footer-group; }
            div.page_line {height:900px;}
            div.print_area ul.top_ul {padding-top: 0px; margin-top: 0px; border-top: none;}
            h1 {display:block;}
            div.print_table {width:100%; height:680px; margin-top:10px;}
        }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="DisplayMode"/>
<asp:HiddenField runat="server" ID="ErrMsg"/>
<asp:HiddenField runat="server" ID="HidSaleClosingSeqNo"/>
    <div class="btnArea">
	    <div class="btn">
		    <button class="btn_01" onclick="window.print(); return false;">인쇄</button>
	    </div>
    </div>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h1>청구내역서</h1>
                <h3 class="popup_title">[고객사정보]</h3>
                <p>
                    고객사명 : <asp:Label runat="server" ID="ClientName"></asp:Label>
                    |
                    <asp:Label runat="server" ID="ClientCeoName"></asp:Label>
                    |
                    <asp:Label runat="server" ID="ClientCorpNo"></asp:Label>
                </p>
                <h3 class="popup_title">[청구 상세]</h3>
                <p>
                    운송기간 : 
                    <asp:Label runat="server" ID="StartYMD"></asp:Label>
                    ~
                    <asp:Label runat="server" ID="EndYMD"></asp:Label>
                </p>
                <div class="print_table" style="width:100%; height:680px; margin-top:10px;">
                    <table class="popup_table" style="margin-bottom:30px;">
                        <colgroup>
                            <col style="width:33.33333333333333%"/> 
                            <col style="width:33.33333333333333%;"/> 
                            <col style="width:33.33333333333333%;"/> 
                        </colgroup>
                        <thead>
                            <tr>
                                <th>운임구분</th>
                                <th>공급가액</th>
                                <th>부가세</th>
                            </tr>
                        </thead>
                        <tbody id="AmtList" runat="server">
                        
                        </tbody>
                        <tbody>
                            <tr>
                                <th style="font-weight:700">소계</th>
                                <td id="TotalSupplyAmt" runat="server" style="font-weight:700;"></td>
                                <td id="TotalTaxAmt" runat="server" style="font-weight:700;"></td>
                            </tr>
                        </tbody>
                        <tbody>
                            <tr>
                                <th>대납금</th>
                                <td colspan="2" style="text-align:right;" id="AdvanceOrgAmt" runat="server"></td>
                            </tr>
                            <tr>
                                <th style="font-weight:700">총 청구금액</th>
                                <td colspan="2" style="font-weight:700" id="TotalAmt" runat="server"></td>
                            </tr>
                        </tbody>
                    </table>
                    <h3 class="popup_title">[결제 정보]</h3>
                    <p style="line-height:2; font-weight:700;">
                        예금주 : <asp:Label runat="server" ID="AcctName"></asp:Label>
                        <br />
                        은행명 : <asp:Label runat="server" ID="BankName"></asp:Label>
                        <br />
                        계좌번호 : <asp:Label runat="server" ID="EncAcctNo"></asp:Label>
                    </p>
                </div>
                
                <div class="print_bottom">
                    <dl>
                        <dt><asp:Label runat="server" ID="CenterName"></asp:Label></dt>
                        <dd>
                            <asp:Label runat="server" ID="Addr"></asp:Label> 
                            <br />
                            대표번호 : <asp:Label runat="server" ID="TelNo"></asp:Label>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            팩스 : <asp:Label runat="server" ID="FaxNo"></asp:Label>
                        </dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
