<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SQIDetailList.aspx.cs" Inherits="TMS.Common.SQIDetailList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/SQIDetailList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function() {

            $("#BtnRegSQI").on("click",
                function () {
                    fnGoInsSQI();
                    return;
                });
        });

        function fnWindowClose() {
            window.close();
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="OrderType"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderNo"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name"> 오더 서비스 이슈 목록</h3>
                <table class="popup_table" style="margin-bottom:0px;">
                    <colgroup>
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                    </colgroup>
                    <tbody>
                            <tr>
                                <th>오더번호</th>
                                <td><span runat="server" id="OrderNoView"></span></td>
                                <th>상차일(작업일)</th>
                                <td><span id="PickupYMD"></span></td>
                            </tr>
                            <tr>
                                <th>고객사</th>
                                <td><span id="PayClientName"></span></td>
                                <th>화주</th>
                                <td><span id="ConsignorName"></span></td>
                            </tr>
                            <tr>
                                <th>상품</th>
                                <td><span id="OrderItemCodeM"></span></td>
                                <th>고객담당 / 접수자</th>
                                <td><span id="CsAdminName"></span> / <span id="AcceptAdminName"></span></td>
                            </tr>
                    </tbody>
                </table>
                <div style="text-align:right;margin-top:20px">
                    <button type="button" class="btn_01" id="BtnRegSQI">등록</button>
                </div>
                <table class="popup_table" style="margin:10px 0;">
                    <colgroup>
                        <col/> 
                        <col style="width:80px;"/> 
                        <col style="width:80px;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:80px;"/> 
                    </colgroup>
                    <thead>
                    <tr>
                        <th>이슈유형</th>
                        <th>발생일</th>
                        <th>등록자</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="SQIList"></tbody>
                </table>
                <div style="text-align:center;margin-top:20px">
                    <button type="button" class="btn_03" onclick="fnWindowClose();">닫기</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
