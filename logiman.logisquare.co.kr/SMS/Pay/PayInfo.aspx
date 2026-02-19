<%@ Page Language="C#" MasterPageFile="~/Sms.Master" AutoEventWireup="true" CodeBehind="PayInfo.aspx.cs" Inherits="SMS.Pay.PayInfo" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Pay/Proc/PayInfo.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>

    <div id="wrap">
        <div class="card_bill_area">
            <div class="top">
                <h1><img src="/SMS/images/card7_logo.png"></h1>
                <ul>
                    <li>
                        #빠른입금 #카고페이
                    </li>
                </ul>
                <h2>
                    <span id="SendPlanYMD"></span>,​<br>차주님의 운송료가​<br>입금될 예정입니다.​
                </h2>
                <div class="date_view">
                     <table>
                         <colgroup>
                            <col style="width:65%">
                            <col style="width:35%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="com_name"><span id="CenterNameView"></span></th>
                                <td rowspan="3" runat="server" id="TdPay">
                                    <img src="/SMS/images/step2.png" class="step2">
                                </td>
                                <td rowspan="3" runat="server" id="TdPayEnd" style="display: none;">
                                    <img src="/SMS/images/step3.png" class="step3">
                                </td>
                            </tr>
                            <tr>
                                <th class="amount">
                                    <dl>
                                        <dt><span id="BillWriteView"></span></dt>
                                        <dt runat="server" id="DtDeduct">(공제 <span id="DeductAmtView"></span>원)</dt>
                                        <dd><span id="SendAmtView"></span>원</dd>
                                    </dl>
                                </th>
                            </tr>
                            <tr>
                                <th class="bank">
                                    <dl>
                                        <dt><span id="BankNameView"></span> <span id="SearchAcctNoView"></span></dt>
                                        <dd><span id="AcctNameView"></span></dd>
                                    </dl>
                                </th>
                            </tr>
                        </tbody>
                     </table>   
                </div>
            </div>
            
            <div class="middle" runat="server" id="DivQuickPayInfo" style="display: none;">
                <dl>
                    <dt>카고페이 빠른입금</dt>
                    <dd>빠른입금 서비스 신청 시<br>5분 이내 바로 입금!</dd>
                </dl>
                <button type="button" class="blue" runat="server" id="BtnQuickPayView">자세히 보기</button>
                <div class="middle_logo">
                    <img src="/SMS/images/middle_logo.png">
                </div>
            </div>

            <div class="middle" runat="server" id="DivQuickPayEnd" style="display: none;">
                <dl>
                    <dt>카고페이 빠른입금</dt>
                    <dd class="middle_text">
                        <img src="/SMS/images/check_icon.png">
                        <br>
                        카고페이 빠른입금 완료!<br>(<span id="RateAmt"></span> 원을 제외한 <span id="ResultAmt"></span>원 입금 완료)
                    </dd>
                </dl>
                <div class="middle_tel">
                    <a href="tel:1522-9766">고객센터 문의 <img src="/SMS/images/tel_icon.png"></a>
                </div>
            </div>

            <div class="bottom">
                <dl class="bill_info">
                    <dt>입금예정액 상세보기</dt>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:35%;">
                                <col style="width:65%;">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>운송료<br/>(부가세포함)</th>
                                <td><span id="DtlOrgAmt"></span> 원</td>
                            </tr>
                            <tr>
                                <th>산재보험료</th>
                                <td><span id="DtlDriverInsureAmt"></span> 원</td>
                            </tr>
                            <tr>
                                <th>운송사공제금액</th>
                                <td><span id="DtlInputDeductAmt"></span> 원</td>
                            </tr>
                            <tr>
                                <th>최종입금예정액</th>
                                <td><span id="DtlSendAmt"></span> 원</td>
                            </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
                <dl class="bill_info">
                    <dt>세금계산서 발행정보</dt>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:35%;">
                                <col style="width:65%;">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>계산서 작성일</th>
                                <td><span id="BillWrite"></span></td>
                            </tr>
                            <tr>
                                <th>공급받는자</th>
                                <td><span id="CenterName"></span></td>
                            </tr>
                            <tr>
                                <th>공급가액</th>
                                <td><span id="SupplyAmt"></span> 원</td>
                            </tr>
                            <tr>
                                <th>부가세</th>
                                <td><span id="TaxAmt"></span> 원</td>
                            </tr>
                            <tr>
                                <th>합계</th>
                                <td><span id="OrgAmt"></span> 원</td>
                            </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
                <dl class="bill_info" runat="server" id="DlAcctInfo">
                    <dt>계좌정보</dt>
                    <dd>
                        <table>
                            <colgroup>
                                <col style="width:35%;">
                                <col style="width:65%;">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>은행명</th>
                                <td><span id="BankName"></span></td>
                            </tr>
                            <tr>
                                <th>계좌번호</th>
                                <td><span id="SearchAcctNo"></span></td>
                            </tr>
                            <tr>
                                <th>예금주</th>
                                <td><span id="AcctName"></span></td>
                            </tr>
                            </tbody>
                        </table>
                    </dd>
                </dl>
            </div>

            <div class="btn_type2" runat="server" id="DivButton1" style="display: none;">
                <ul>
                    <li><button type="button" class="blue" runat="server" id="BtnQuickPay">빠른입금 신청하기</button></li>
                    <li><button type="button" class="gray" onclick="fnPopupClose(); return false;">확인</button></li>
                </ul>
            </div>

            <div class="btn_type2" runat="server" id="DivButton2">
                <button type="button" class="blue" onclick="fnPopupClose(); return false;">확인</button>
            </div>
        </div>
    </div>
</asp:Content>