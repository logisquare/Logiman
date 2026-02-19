<%@ Page Language="C#" MasterPageFile="~/Sms.Master" AutoEventWireup="true" CodeBehind="PayStep02.aspx.cs" Inherits="SMS.Pay.PayStep02" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Pay/Proc/PayStep02.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>

    <!--감싸는 태그 Start-->
     <div id="wrap">

        <div class="fast_area">
            <h1 class="logo"><img src="/SMS/images/service_logo.png"></h1>
            <div class="top">
                
                <dl>
                    <dt>먼저 차감되는<br>
                        수수료를 확인하세요.</dt>
                    <dd>
                        차주님께서 거래한 운송사가 아닌,<br>카고페이에서 선지급합니다.
                    </dd>
                </dl>
            </div>
            <div class="middle" style="height: 110vw;">
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
                            <th>운송사 공제금액</th>
                            <td><span id="InputDeductAmt"></span> 원</td>
                        </tr>
                        <tr runat="server" id="TrDeductInfo2">
                            <th>공제 후 지급액</th>
                            <td><span id="SendAmt"></span> 원</td>
                        </tr>
                        <tr>
                            <th>수수료율</th>
                            <td><span id="RatePer"></span>%</td>
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
                <p>
                    차주님의 운송료 <span><span id="SendAmtView"></span>원</span>에서 <br> 
                    <span class="blue">수수료 <span id="RateAmtView"></span>(<span id="RatePerView"></span>%)원</span>이 차감됩니다.
                </p>
            </div>
            <div class="btn_type2">
                <ul>
                    <li><button type="button" class="blue" runat="server" id="BtnQuickPay">빠른입금 신청하기</button></li>
                    <li><button type="button" class="gray" onclick="fnGoReturn(); return false;">닫기</button></li>
                </ul>
            </div>
        </div>
     </div>
</asp:Content>