<%@ Page Language="C#" MasterPageFile="~/Sms.Master" AutoEventWireup="true" CodeBehind="PayStepEnd.aspx.cs" Inherits="SMS.Pay.PayStepEnd" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Pay/Proc/PayStepEnd.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>

    <!--감싸는 태그 Start-->
    <div id="wrap">
        <div class="fast_success_area">
            <h1 class="logo"><img src="/SMS/images/service_logo.png"></h1>
            <div class="top">
                <dl>
                    <dt>빠른입금 신청완료</dt>
                    <dd>
                        * 빠른입금 서비스 신청 후 5분 내로 <br>차주님의 계좌로 운송료가 입금됩니다.
                    </dd>
                </dl>
            </div>
            <div class="middle">
                <table>
                    <colgroup>
                        <col style="width:50%">
                        <col style="width:50%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>입금예정금액</th>
                        <td><span id="ResultAmtView"></span> 원</td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th>운송료</th>
                        <td><span id="OrgAmt"></span> 원</td>
                    </tr>
                    <tr>
                        <th>산재보험료</th>
                        <td><span id="DriverInsureAmt"></span> 원</td>
                    </tr>
                    <tr runat="server" id="TrDeductInfo1">
                        <th style="text-align: left;">운송사 공제금액</th>
                        <td><span id="InputDeductAmt"></span> 원</td>
                    </tr>
                    <tr runat="server" id="TrDeductInfo2">
                        <th style="text-align: left;">공제 후 지급액</th>
                        <td><span id="SendAmt"></span> 원</td>
                    </tr>
                    <tr>
                        <th>수수료율</th>
                        <td><span id="RatePer"></span> %</td>
                    </tr>
                    <tr>
                        <th>수수료</th>
                        <td><span id="RateAmt"></span> 원</td>
                    </tr>
                    <tr>
                        <th>입금예정금액</th>
                        <td><span id="ResultAmt"></span> 원</td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="bottom">
                <h1>
                    <span class="icon_left"></span>
                    카고페이 멤버십 출시
                    <span class="icon_right"></span>
                </h1>
                <p><strong>카고페이 멤버십</strong> 어플 다운받고,<br/>포인트를 받아가세요!</p>
            </div>
            
            <div class="btn_type2" style="padding-top:27vw;">
                <ul>
                    <li style="width:30%;"><button type="button" class="gray" onclick="fnGoReturn(); return false;">확인</button></li>
                    <li style="width:70%;"><button type="button" class="blue" onclick="fnGoMembershipApp(); return false;">포인트 받기</button></li>
                </ul>
            </div>

        </div>
    </div>
</asp:Content>