<%@ Page Language="C#" MasterPageFile="~/Sms.Master"  AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="SMS.SafetyCheck.Index" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/SafetyCheck/Proc/Index.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div.page_title p {
            color: #2D8CE2;
            font-weight: 800;
            font-size: 4vw !important;
            padding: 0 !important;
        }

        div.page_title ul {
            width: 100%; margin-top: 4.67vw;
        }

        div.page_title li {
            width: 100%;
            margin-top: 10px;
            text-align: left;
            font-size: 3.8vw;
            line-height: 1.5;
        }

        div.page_title li p{
            margin: 10px 0 30px 0;
        }
        
        input[type="checkbox"] {display:none;}
        input[type="checkbox"] + label {font-size:3.8vw; color:#555; font-weight:300;}
        input[type="checkbox"] + label span {display:inline-block; width:5vw; height:5vw; vertical-align:middle; background:url("/SMS/images/check_off.png") left top no-repeat; background-size: 100%; cursor:pointer;}
        input[type="checkbox"]:checked + label span {background:url("/SMS/images/check_on.png") left top no-repeat; background-size: 100%;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>
    
    <div id="wrap">
        <div class="fast_area">
            <div class="top">
                <h2 class="bill_title" style="color: #333;">차량운행 전 안전 점검표</h2>
            </div>
            <div class="middle" style="height: auto;">
                <div class="page_wrap_01">
                    <div class="page_title">
                        <p>
                            안녕하세요. <span id="SpanDriverName"></span>기사님<br/>
                            아래 항목은 차량운행 전 안전 점검표입니다.<br/>
                            체크리스트 확인 진행하시고,<br/>
                            하단의 완료하기 버튼을 눌러주세요.<br/>
                            오늘 하루도 안전운행 부탁드립니다.<br/>
                            감사합니다.<br/>
                        </p>
                        <ul>
                            <li>
                                1. 적재함 잠금장치 확인하셨나요?
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk1_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk1_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                            <li>
                                2. 선적서류와 물품의 이상여부 확인하셨나요?
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk2_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk2_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                            <li>
                                3. 운송수단 등에 폭발물 부착 테러징후 검사 확인하셨나요?
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk3_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk3_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                            <li>
                                4. 봉인 또는 잠금장치 이상여부 확인하셨나요?
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk4_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk4_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                            <li>
                                5. 운송수단 내,외부 오염도 이상여부 확인하셨나요?
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk5_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk5_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                            <li>
                                6. 트럭 구조 검증 – 7가지 지점을 확인하셨나요?<br/>
                                (①범퍼/타이어/외륜 ②문/공구함 ③배터리함 ④공기흡입엔진 ⑤연료탱크 ⑥내부운전실/수면공간 ⑦fairing/지붕)
                                <p>
                                    <asp:CheckBox runat="server" ID="Chk6_Y" CssClass="chkAgree" Text="<span></span> 예" Checked="True"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="Chk6_N" CssClass="chkAgree" Text="<span></span> 아니오"/>
                                </p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="btn_type2">
                <ul>
                    <li style="width: 100%;"><button type="button" class="blue" onclick="fnPopupClose(); return false;">점검 항목 작성 완료하기</button></li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>