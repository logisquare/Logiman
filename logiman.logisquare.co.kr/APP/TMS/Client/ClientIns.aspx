<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="ClientIns.aspx.cs" Inherits="APP.TMS.Client.ClientIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Client/Proc/ClientIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="HidCorpNoChk" Value="N"/>
    <asp:HiddenField runat="server" ID="HidAcctNoChk" Value="N"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <asp:HiddenField runat="server" ID="ClientStatus"/>
    <asp:HiddenField runat="server" ID="ClientCloseYMD"/>
    <asp:HiddenField runat="server" ID="ClientUpdYMD"/>
    <asp:HiddenField runat="server" ID="ChargeSeqNo"/>
    <asp:HiddenField runat="server" ID="ClientTaxMsg"/>
    <asp:HiddenField runat="server" ID="ClientFaxNo"/>
    <asp:HiddenField runat="server" ID="ClientEmail"/>
    <asp:HiddenField runat="server" ID="ChargeBillFlag"/>
    <asp:HiddenField runat="server" ID="ChargeArrivalFlag"/>
    <asp:HiddenField runat="server" ID="DouzoneCode"/>
    <asp:HiddenField runat="server" ID="TransCenterCode"/>
    <asp:HiddenField runat="server" ID="RevenueLimitPer"/>
    <asp:HiddenField runat="server" ID="SaleLimitAmt"/>
    <asp:HiddenField runat="server" ID="ClientNote4"/>
    <asp:HiddenField runat="server" ID="ClientNote3"/>
    <asp:HiddenField runat="server" ID="ClientNote2"/>
    <asp:HiddenField runat="server" ID="ClientNote1"/>
    <asp:HiddenField runat="server" ID="ClientBusinessStatus"/>
    <asp:HiddenField runat="server" ID="ClientPayDay"/>
    <asp:HiddenField runat="server" ID="ClientClosingType"/>
    <asp:HiddenField runat="server" ID="ClientDMAddrDtl"/>
    <asp:HiddenField runat="server" ID="ClientDMAddr"/>
    <asp:HiddenField runat="server" ID="ClientDMPost"/>
    <asp:HiddenField runat="server" ID="UseFlag" Value="Y"/>
    <asp:HiddenField runat="server" ID="HidParam"/>
    <div class="contents" style="padding-top:0px;">
        <div class="data_detail">
            <div class="ins_section">
                <h2>회원사</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section">
                <h2>업체정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_05">
                                    <li>
                                        <asp:DropDownList runat="server" ID="ClientTaxKind" CssClass="type_01 read"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientCorpNo" CssClass="type_01 essential" placeholder="사업자번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button type="button" class="type_02" id="BtnCorpNoChk" runat="server" onclick="fnChkCorpNo();">중복확인</button>
                                        <button type="button" class="type_03" id="BtnCorpNoReChk" runat="server" style="display:none;">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:DropDownList runat="server" ID="ClientType" CssClass="type_01 essential"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" id="ClientName" CssClass="type_01 essential" maxlength="50" placeholder="업체명"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" id="ClientCeoName" CssClass="type_01 essential" maxlength="50" placeholder="대표자명"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" id="ClientTelNo" CssClass="type_01 essential OnlyNumber" maxlength="10" placeholder="전화번호"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientBizType" CssClass="type_01" placeholder="업태" MaxLength="100"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientBizClass" CssClass="type_01" placeholder="종목" MaxLength="100"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="dispatch_search">
                                    <li style="width:65%;">
                                        <asp:TextBox runat="server" ID="ClientPost" placeholder="우편번호를 검색하세요" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li style="width:35%;">
                                        <button type="button" class="btn_100p" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                                    </li>
                                </ul>
                                <div id="DivClientAddrWrap"></div>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientAddr" CssClass="type_01" placeholder="주소" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientAddrDtl" CssClass="type_01" placeholder="상세주소"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>화물실적신고대상</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="checkbox_list">
                                    <li>
                                        <asp:RadioButton ID="ClientFPISFlagY" runat="server" GroupName="ClientFPISFlag" value="Y" Checked="true" />
                                        <label for="ClientFPISFlagY">대상</label>
                                    </li>
                                    <li>
                                        <asp:RadioButton ID="ClientFPISFlagN" runat="server" GroupName="ClientFPISFlag" value="N" />
                                        <label for="ClientFPISFlagN">대상아님</label>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>은행정보</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:DropDownList runat="server" ID="ClientBankCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ClientAcctNo" CssClass="type_01" placeholder="계좌번호"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" id="ClientAcctName" CssClass="type_01" ReadOnly="true" placeholder="예금주"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button type="button" id="BtnAcctNoChk" class="type_02">계좌확인</button>
                                        <button id="BtnAcctNoReChk" type="button" class="type_03" style="display:none;">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="reg_btn">
                <button type="button" id="InsBtn" onclick="fnInsClient();">등록하기</button>
            </div>
        </div>
    </div>
</asp:Content>