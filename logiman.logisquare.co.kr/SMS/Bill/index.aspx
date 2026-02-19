<%@ Page Language="C#" MasterPageFile="~/Sms.Master"  AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="SMS.Bill.Index" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Bill/Proc/Index.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>
    
    <div id="wrap">
        <div class="fast_area">
            <div class="top">
                <h1></h1>
            </div>
            <div class="middle" style="height: 110vw;">
                <div class="page_wrap_01">
                    <div class="page_title">
                        <img src="/SMS/images/user_icon.png" alt="" />
                        <h2>개인정보 확인</h2>
                        <table>
                            <colgroup>
                                <col style="width: 60%;" />
                                <col style="width: 40%;" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th class="last" colspan="2">사업자번호</th>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span id="ComCorpNo"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="last" colspan="2">계좌정보</th>
                            </tr>
                            <tr>
                                <td>
                                    은행명 : <br/>
                                    예금주 : <br/>
                                    계좌번호(끝 4자리) : 
                                </td>
                                <td>
                                    <span id="BankName"></span><br/>
                                    <span id="AcctName"></span><br/>
                                    <span id="SearchAcctNo"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="last" colspan="2">계산서 받을 이메일</th>
                            </tr>
                            <tr>
                                <td class="last" colspan="2">
                                    <span id="ChargeEmail"></span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <p class="help">* 개인 정보 수정은 운송사로 문의해주세요.</p>
            </div>
            <div class="btn_type2">
                <ul>
                    <li style="width: 100%;"><button type="button" class="blue" onclick="fnGoNext(); return false;">무료 계산서 발행</button></li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>