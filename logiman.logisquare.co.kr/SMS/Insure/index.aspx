<%@ Page Language="C#" MasterPageFile="~/Sms.Master"  AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="SMS.Insure.Index" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Insure/Proc/Index.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div.page_title p {
            color: #2D8CE2;
            font-weight: 800;
            font-size: 5vw !important;
            padding: 0 !important;
        }

        div.page_title ul {
            width: 100%; margin-top: 4.67vw;
        }

        div.page_title li {
            width: 100%;
            margin-top: 10px;
            text-align: left;
            font-size: 3.9vw;
            line-height: 1.5;
        }
        div.page_title li:before {
            content: url('../images/square_icon.png');
            margin-right: 0.5em;
        }

        div#DivWrapCert { width:100%; height:100%; background:#fff; position:fixed; left: 0px; top: 0px; display: none;}
        div#DivWrapCert div.btn_type1 {width:100%; position:fixed; padding-top:9.17vw; bottom:0px; left:0px;}
        div#DivWrapCert div.btn_type1 button {width:100%; height:13.89vw; border:none; color:#fff; font-size:6.67vw;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>
    <asp:HiddenField runat="server" ID="MobileDevice"/>
    <!------ KCP 모바일인증 변수 START ------->
    <asp:HiddenField runat="server" ID="site_cd" />
    <asp:HiddenField runat="server" ID="ordr_idxx" />
    <asp:HiddenField runat="server" ID="req_tx" Value="cert" />
    <asp:HiddenField runat="server" ID="cert_method" Value="01" />
    <asp:HiddenField runat="server" ID="user_name" />
    <asp:HiddenField runat="server" ID="up_hash" />
    <asp:HiddenField runat="server" ID="cert_otp_use" Value="Y" />
    <asp:HiddenField runat="server" ID="cert_able_yn" Value="Y" />
    <asp:HiddenField runat="server" ID="web_siteid" />
    <asp:HiddenField runat="server" ID="param_opt_1"/>
    <asp:HiddenField runat="server" ID="param_opt_2"/>
    <asp:HiddenField runat="server" ID="param_opt_3"/>
    <asp:HiddenField runat="server" ID="action"/>
    <asp:HiddenField runat="server" ID="Ret_URL"/>
    <asp:HiddenField runat="server" ID="web_siteid_hashYN"/>
    <asp:HiddenField runat="server" ID="cert_enc_use_ext" Value="Y" />
    
    <asp:HiddenField runat="server" ID="veri_up_hash" />
    <asp:HiddenField runat="server" ID="res_cd" />
    <asp:HiddenField runat="server" ID="res_msg" />
    <asp:HiddenField runat="server" ID="cert_no" />
    <asp:HiddenField runat="server" ID="enc_cert_data2" />
    <asp:HiddenField runat="server" ID="dn_hash" />
    <!------ KCP 모바일인증 변수 END ------->
    
    <div id="wrap">
        <div class="fast_area">
            <div class="top">
                <h2 class="bill_title" style="color: #333;">화물 차주 산재보험 적용 안내</h2>
            </div>
            <div class="middle" style="height: 130vw;">
                <div class="page_wrap_01">
                    <div class="page_title">
                        <p>
                            2023년 7월 1일 부터<br/>
                            모든 화물 차주가 산재보험의<br/>
                            보호를 받을 수 있게 되었습니다.
                        </p>
                        <ul>
                            <li>
                                23년 7월 1일부터 전속성 요건과 무관하게 모든 화물 차주가 산재보험 혜택을 받을 수 있게 되었습니다.
                            </li>
                            <li>
                                산재보험료는 운송료를 지급할 때, 차주의 산재보험 가입여부와 관계없이 사업주(운송/주선사 OR 화주)가 원천공제 하도록 되어있습니다.
                            </li>
                            <li>
                                산재보험료는 사업주(운송/주선사 OR 화주)가 차주의 보험료 부담분을 원천공제하여, 사업주 부담분과 합산하여 매월 신고 & 납부합니다.
                            </li>
                            <li>
                                산재보험 신고를 위해 사업주(운송/주선사 OR 화주)는 차주의 개인정보를 수집, 이용하여 공단에 제공합니다.
                            </li>
                        </ul>
                    </div>
                </div>
                <p class="help" style="padding: 4.67vw 0 0 0;">※ 산재보험 관련 법령에 정한 항목 또는 신고에 필요한 항목 노무제공자(차주)의 성명, 주민번호, 노무제공일자, 월보수액 등</p>
            </div>
            <div class="btn_type2">
                <ul>
                    <li style="width: 100%;"><button type="button" class="blue" onclick="fnAuthCheck(); return false;">본인인증 후 개인정보 입력</button></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="DivWrapCert">
        <iframe runat="server" id="kcp_cert" name="kcp_cert" width="100%" height="700" frameborder="0" scrolling="no"></iframe>
    </div>
</asp:Content>