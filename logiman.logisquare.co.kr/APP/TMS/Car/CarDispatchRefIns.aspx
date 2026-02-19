<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="CarDispatchRefIns.aspx.cs" Inherits="APP.TMS.Car.CarDispatchRefIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Car/Proc/CarDispatchRefIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
    <asp:HiddenField runat="server" ID="HidMode" />
    <!--PK Hidden-->
    <asp:HiddenField runat="server" ID="RefSeqNo"/>
    <asp:HiddenField runat="server" ID="CarSeqNo"/>
    <asp:HiddenField runat="server" ID="ComCode"/>
    <asp:HiddenField runat="server" ID="DriverSeqNo"/>
    <asp:HiddenField runat="server" ID="DtlSeqNo"/>
    <asp:HiddenField runat="server" ID="UseFlag"/>
    <!--Overlap Check-->
    <asp:HiddenField runat="server" ID="ChkCar" />
    <asp:HiddenField runat="server" ID="ChkCom" />
    <asp:HiddenField runat="server" ID="ChkDriver" />
    <!--업체-->
    <asp:HiddenField runat="server" ID="ComStatus" />
    <asp:HiddenField runat="server" ID="ComCloseYMD" />
    <asp:HiddenField runat="server" ID="ComUpdYMD" />
    <asp:HiddenField runat="server" ID="ComTaxMsg" />
    <asp:HiddenField runat="server" ID="ComKindM"/>
    <!--차량-->
    <asp:HiddenField runat="server" ID="CarNote" />
    <!--계좌 Setting value-->
    <asp:HiddenField runat="server" ID="AcctValidFlag"/>
    <asp:HiddenField runat="server" ID="ChargeName"/>
    <asp:HiddenField runat="server" ID="ChargeTelNo"/>
    <asp:HiddenField runat="server" ID="ChargeEmail"/>
    <!--BackButton-->
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
                <h2>차량정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_05">
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarDivType" CssClass="type_01 essential"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="CarNo" CssClass="type_01 essential" placeholder="차량번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button type="button" class="type_02" runat="server" id="BtnChkCar" onclick="fnChkCar()">중복확인</button>
                                        <button runat="server" id="BtnChkCarReset" type="button" onclick="fnObjReset('CarNo');" class="type_03" style="display:none;">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_04">
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarTypeCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarTonCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarBrandCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section">
                <h2>기사정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_05">
                                    <li>
                                        <asp:TextBox runat="server" ID="DriverName" CssClass="type_01 essential" placeholder="기사명"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="DriverCell" CssClass="type_01 essential" placeholder="휴대폰번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button type="button" runat="server" id="BtnChkDriver" class="type_02" onclick="fnChkDriver();">중복확인</button>
                                        <button type="button" runat="server" id="BtnChkDriverReset" class="type_03" onclick="fnObjReset('DriverCell');" style="display:none;">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" runat="server" ID="DivAgreement" Visible="False">
                <h2>개인정보수집</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <td>
                            <ul class="ul_type_02">
                                <li>
                                    주민번호 수집여부
                                </li>
                                <li>
                                    <asp:Literal runat="server" id="InformationFlagM"></asp:Literal>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <ul class="ul_type_02">
                                <li>
                                    약관 동의여부
                                </li>
                                <li>
                                    <asp:Literal runat="server" id="AgreementFlagM"></asp:Literal>
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
                                        <asp:DropDownList runat="server" ID="ComTaxKind" CssClass="type_01 read"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComCorpNo" CssClass="type_01 OnlyNumber" placeholder="사업자번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button runat="server" type="button" id="BtnChkCorpNo" onclick="fnChkCorpNo();" class="type_02">확인</button>
                                        <button runat="server" type="button" id="BtnChkCorpNoReset" class="type_03" onclick="fnObjReset('ComCorpNo');" style="display:none;">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="ComName" CssClass="type_01" placeholder="업체명"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComCeoName" CssClass="type_01" placeholder="대표자"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="ComBizType" CssClass="type_01" placeholder="업태"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComBizClass" CssClass="type_01" placeholder="종목"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="ComTelNo" CssClass="type_01" placeholder="전화번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComFaxNo" CssClass="type_01" placeholder="팩스"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="checkbox_list">
                                    <li>
                                        <input type="checkbox" name="CustomFlag" runat="server" id="CooperatorFlag" value="" />
                                        <label for="CooperatorFlag">협력업체</label>
                                    </li>
                                    <li>
                                        <input type="checkbox" runat="server" name="CargoManFlag" id="CargoManFlag" value="" />
                                        <label for="CargoManFlag">카고맨</label>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComEmail" CssClass="type_01 OnlyEmail" placeholder="이메일"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="dispatch_search">
                                    <li style="width:65%;">
                                        <asp:TextBox runat="server" ID="ComPost" placeholder="우편번호를 검색하세요" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li style="width:35%;">
                                        <button type="button" class="btn_100p">우편번호 검색</button>
                                    </li>
                                </ul>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="ComAddr" CssClass="type_01" placeholder="주소" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ComAddrDtl" CssClass="type_01" placeholder="상세주소"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section">
                <h2>계좌정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:DropDownList runat="server" ID="BankCode" CssClass="type_01"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="AcctName" CssClass="type_01" placeholder="예금주"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li style="width:65%;">
                                        <asp:TextBox runat="server" ID="EncAcctNo" CssClass="type_01 OnlyNumber" placeholder="계좌번호"></asp:TextBox>
                                    </li>
                                    <li style="width:35%; padding-left:2%">
                                        <button type="button" id="BtnChkAcctNo" class="type_02" onclick="fnChkAcctNo();">계좌확인</button>
                                        <button type="button" id="BtnChkAcctNoReset" class="type_03" style="display:none;" onclick="fnObjReset('Acct');">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li style="width:20%; line-height:2;">
                                        결제일
                                    </li>
                                    <li style="width:80%; padding-left:2%">
                                        <asp:DropDownList runat="server" ID="PayDay"></asp:DropDownList>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" runat="server" ID="DivInsure">
                <h2>산재보험 대상여부</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <td>
                            <ul class="ul_type_02">
                                <li>
                                    <asp:RadioButton ID="InsureTargetFlagY" runat="server" GroupName="InsureTargetFlag" value="Y" Checked="true" />
                                    <label for="InsureTargetFlagY"><span></span>대상</label>&nbsp;&nbsp;
                                </li>
                                <li>
                                    <asp:RadioButton ID="InsureTargetFlagN" runat="server" GroupName="InsureTargetFlag" value="N" />
                                    <label for="InsureTargetFlagN"><span></span>대상아님</label>&nbsp;&nbsp;
                                </li>
                            </ul>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <span>※ 사업자의 대표자와 운전기사가 고용관계일 경우 산재보험 대상이 아닙니다.</span>
            </div>


            <div class="ins_section">
                <h2>비고</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="RefNote" CssClass="type_01" MaxLength="500"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="reg_btn">
                <button type="button" id="InsBtn" onclick="fnCarDispatchInsConfirm();">등록하기</button>
            </div>
        </div>
    </div>
</asp:Content>