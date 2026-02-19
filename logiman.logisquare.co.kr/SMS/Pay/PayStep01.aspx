<%@ Page Language="C#" MasterPageFile="~/Sms.Master" AutoEventWireup="true" CodeBehind="PayStep01.aspx.cs" Inherits="SMS.Pay.PayStep01" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Pay/Proc/PayStep01.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>

    <!--감싸는 태그 Start-->
    <div id="wrap">
        <div class="service_area">
            <div class="top">
                <h1 class="logo"><img src="/SMS/images/service_logo.png"></h1>
                <dl>
                    <dt>약간의 수수료를 지불하고,<br>
                        운송료를 지금 바로 받아보세요!</dt>
                    <dd>
                        차주님들의 운송료를 운송사 대신,<br>
                        카고페이가 선지급하는 서비스입니다.
                    </dd>
                </dl>
                <button type="button" runat="server" id="BtnQuickPay">빠른입금<br>신청하기</button>
            </div>
            <div class="middle">
                <dl>
                    <dt>서비스 1.</dt>
                    <dd>
                        <strong>5분 내 바로 운송료 입금!</strong>
                        빠른입금 서비스 신청 후, 5분 내로 운송료가 입금됩니다.
                    </dd>
                </dl>
                <dl>
                    <dt>서비스 2.</dt>
                    <dd>
                        <strong>3.3% 수수료가 발생합니다.!</strong>
                        부가세가 포함된 운송료의 3.3% 수수료가 발생합니다.
                    </dd>
                </dl>
                <dl>
                    <dt>서비스 3.</dt>
                    <dd>
                        <strong>카고페이에서 제공합니다.</strong>
                        거래한 운송사가 아닌 카고페이에서 선지급 해드립니다.
                    </dd>
                </dl>
            </div>
        </div>
        <div class="btn_type1">
            <button type="button" class="gray" onclick="fnGoReturn(); return false;">닫기</button>
        </div>
    </div>
</asp:Content>