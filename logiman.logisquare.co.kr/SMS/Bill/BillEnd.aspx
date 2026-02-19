<%@ Page Language="C#" MasterPageFile="~/Sms.Master"  AutoEventWireup="true" CodeBehind="BillEnd.aspx.cs" Inherits="SMS.Bill.BillEnd" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Bill/Proc/BillEnd.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
        });

    </script>
    <style>
        .BillStatusInfo { display: none;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>
    <div id="wrap">
    
        <div class="fast_area">
            <div class="top">
                <h2></h2>
            </div>
            <div class="billend">
                <div class="BillStatusInfo BillStatus2">
                    <h1><img src="/SMS/images/icon_processing.png"></h1>
                    <dl>
                        <dt>계산서 발행<br/>진행중입니다.</dt>
                        <dd>신청하신 전자계산서가 발행중입니다.<br/>(발행 완료까지 최대 3시간 소요될 수 있습니다.)</dd>
                    </dl>
                </div>
                <div class="BillStatusInfo BillStatus3">
                    <h1><img src="/SMS/images/icon_complete.png"></h1>
                    <dl>
                        <dt>계산서 발행<br />완료되었습니다.</dt>
                        <dd>신청하신 전자계산서가 발행 완료되었습니다.<br />발행된 계산서는 국세청 홈택스에서 간편하게 확인하실 수 있습니다.</dd>
                    </dl>
                </div>
                <div class="BillStatusInfo BillStatus4">
                    <h1><img src="/SMS/images/icon_fail.png"></h1>
                    <dl>
                        <dt>계산서 발행<br />실패하였습니다.</dt>
                        <dd>신청하신 전자계산서가 발행 실패하였습니다.<br/>운송사로 문의해주세요.<br/><span id="CenterTelNo"></span></dd>
                    </dl>
                </div>
            </div>
            <div class="btn_type2">
                <ul>
                    <li style="width: 100%;"><button type="button" class="gray" onclick="fnPopupClose(); return false;">닫기</button></li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>