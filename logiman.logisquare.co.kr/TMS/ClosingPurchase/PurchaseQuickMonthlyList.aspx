 <%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PurchaseQuickMonthlyList.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseQuickMonthlyList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseQuickMonthlyList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            
            $("#LinkPrev").on("click", function (e) {
                fnGoPrev();
                return false;
            });

            $("#LinkCurrent").on("click", function (e) {
                fnGoCurrent();
                return false;
            });

            $("#LinkNext").on("click", function (e) {
                fnGoNext();
                return false;
            });
        });
            
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="HidYear" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line" style="text-align: center;">
                    <h1>미마감 내역 총 <span runat="server" id="SpanTotalCnt">0</span> 건 / <span runat="server" id="SpanTotalAmt">0</span> 원</h1><br/>
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>&nbsp;&nbsp;
                    <a href="#" runat="server" id="LinkPrev">◀</a>&nbsp;&nbsp;
                    <a href="#" runat="server" id="LinkCurrent"><span runat="server" id="SpanYear">2022</span></a>&nbsp;&nbsp;
                    <a href="#" runat="server" id="LinkNext">▶</a>
                </div>
            </div>  
        </div>
        <div class="day_remit_list_od">
            <%
                for (int i = 1; i <= 12; i++)
                {
            %>
            <div class="day_remit_pay_od">
                <table>
                    <colgroup><col style="width:50%;"><col style="width:50%;"></colgroup>
                    <thead>
                        <tr>
                            <th><%=i%>월</th>
                            <td style="text-align: right;"><button type="button" class="btn_02" onclick="fnSetSearchCondition(<%=i%>);">조회</button></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><th class="remit_05">건수</th><td><span id="SpanCnt<%=i%>">0</span>건</td></tr>
                        <tr><th class="remit_06">금액</th><td><span id="SpanAmt<%=i%>">0</span>원</td></tr>
                    </tbody>
                </table>
            </div>
            <%
                }
            %>
        </div>
	</div>
</asp:Content>
