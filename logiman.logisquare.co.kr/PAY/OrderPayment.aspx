<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderPayment.aspx.cs" Inherits="PAY.OrderPayment" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        $(document).ready(function () {
        });

        function fnWindowClose() {
            window.close();
        }

        function ShowPaper(type) {
            if (type == 1) {
                window.open("/PAY/CreditCardPay");
            }
            else if (type == 2) {
                window.open("/PAY/CreditCardUserInfo");
            }
        }
    </script>
    <style>
        .card {width:20%;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <asp:HiddenField runat="server" ID="OrderNos"/>
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div id="popup_wrap">
                <header class="header">
		            <h1>사용료 신용카드 결제</h1>
	            </header>
                <div>
                    <div class="top">
                        <div id="credit_card_on" class="credit_card_on" style="display: block">
                            <p>
                                <span>카드번호</span>
                            </p>
                            <asp:TextBox runat="server" ID="CARD_NUM1" size="4" maxLength="4" value="" CssClass="type_01 OnlyNumber card" ></asp:TextBox>
                            <asp:TextBox runat="server" ID="CARD_NUM2" size="4" maxLength="4" value="" CssClass="type_01 OnlyNumber card" ></asp:TextBox>
                            <asp:TextBox runat="server" ID="CARD_NUM3" size="4" maxLength="4" value="" CssClass="type_01 OnlyNumber card" ></asp:TextBox>
                            <asp:TextBox runat="server" ID="CARD_NUM4" type="password" size="4" maxLength="4" value="" CssClass="type_01 OnlyNumber"></asp:TextBox><br />
                            <p class="validity">
                                <span>유효기간(MM/YY)</span>
                                <asp:TextBox runat="server" ID="EXP_MM" type="number" maxLength="2" value="" placeholder="월(MM)" title="월(MM)" class="type_01" oninput="maxLengthCheck(this)"></asp:TextBox>
                                <span>&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;</span>
                                <asp:TextBox runat="server" ID="EXP_YY" type="number" maxLength="2" value="" placeholder="년(YY)" title="년(YY)" class="type_01" oninput="maxLengthCheck(this)"></asp:TextBox>
                            </p>
                        </div>
                    </div>
                    <div class="bottom">
                        <ul>
                            <li><a href="javascript:void(0)" onclick="ShowPaper(1);">전자금융거래 기본약관<!--전자 금융 거래 이용약관--></a>
                                <input type="checkbox" id="AGREEMENT1"/><label for="AGREEMENT1"><span></span> 동의</label>
                            </li>
                            <li><a href="javascript:void(0)" onclick="ShowPaper(2);">개인정보 수집 및 이용동의<!--개인정보 수집 및 이용안내--></a>
                                <input type="checkbox" id="AGREEMENT2"/><label for="AGREEMENT2"><span></span> 동의</label>
                            </li>
                        </ul>
                    </div>
                    <div class="total_price">
                        <p>
                            <span>총 결제금액&nbsp;&nbsp;&nbsp;</span>
                            <span><asp:Literal id="PAY_AMT" runat="server"></asp:Literal>원</span>
                        </p>
                
                    </div>
                    <div class="ok_cancle">
                        <button runat="server" id="btnCardPayCnl" type="button" class="btn_03" onclick="javascript:closeThisPopup();">취&nbsp;&nbsp;&nbsp;소</button>
                        <button runat="server" id="btnCardPay" type="button" class="btn_01" onclick="javascript:cardPay();">확&nbsp;&nbsp;&nbsp;인</button>
                    </div>
	            </div>
            </div>
        </div>
    </div>
</asp:Content>
