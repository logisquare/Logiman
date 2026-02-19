<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CarDispatchRefIns.aspx.cs" Inherits="TMS.Car.CarDispatchRefIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Car/Proc/CarDispatchRefIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
            parent.fnMoveToPage(1);
        }
    </script>
    <style>
        #SpanComStatusDtl {color:#ff0000; margin-left:10px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode" />
    <!--PK Hidden-->
    <asp:HiddenField runat="server" ID="RefSeqNo"/>
    <asp:HiddenField runat="server" ID="CarSeqNo"/>
    <asp:HiddenField runat="server" ID="ComCode"/>
    <asp:HiddenField runat="server" ID="DriverSeqNo"/>
    <asp:HiddenField runat="server" ID="DtlSeqNo"/>
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

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>차량정보</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CarDivType"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="CarNo" CssClass="type_01" placeholder="* 차량번호"></asp:TextBox>
                            <button type="button" runat="server" id="BtnChkCar" onclick="fnChkCar();" class="btn_02">중복확인</button>
                            <button type="button" runat="server" id="BtnChkCarReset" onclick="fnObjReset('CarNo');" class="btn_03" style="display:none;">다시입력</button>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CarTypeCode"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CarTonCode"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CarBrandCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>기사정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="DriverName" CssClass="type_01" placeholder="* 기사명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="DriverCell" CssClass="type_01 OnlyNumber" placeholder="* 휴대폰"></asp:TextBox>
                            <button type="button" runat="server" id="BtnChkDriver" class="btn_02" onclick="fnChkDriver();">중복확인</button>
                            <button type="button" runat="server" id="BtnChkDriverReset" class="btn_03" onclick="fnObjReset('DriverCell');" style="display:none;">다시입력</button>
                        </td>
                    </tr>
                    <tr runat="server" ID="TrAgreement" Visible="False">
                        <th>기사개인정보</th>
                        <td>
                            <div style="position: relative; width: 100%;">
                                <div style="width: 39%; float: left; text-align: center;">
                                    주민번호 수집여부&nbsp;&nbsp;:&nbsp;&nbsp;
                                    <asp:Literal runat="server" id="InformationFlagM"></asp:Literal>
                                </div>
                                <div style="width: 2%; float: left; text-align: center;"> | </div>
                                <div style="width: 39%; float: left; text-align: center;">
                                    약관 동의여부 &nbsp;&nbsp;:&nbsp;&nbsp;
                                    <asp:Literal runat="server" id="AgreementFlagM"></asp:Literal>
                                </div>
                                <div style="width: 20%; float: left; text-align: right;">
                                    <button type="button" class="btn_02" onclick="fnSendAgreement(); return false;" width="200">주민번호수집 알림톡발송</button>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3">업체정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="ComCorpNo" CssClass="type_01 OnlyNumber" MaxLength="10" placeholder="* 사업자등록번호"></asp:TextBox>
                            <button runat="server" type="button" id="BtnChkCorpNo" onclick="fnChkCorpNo();" class="btn_02">사업자확인</button>
                            <button runat="server" type="button" id="BtnChkCorpNoReset" class="btn_03" onclick="fnObjReset('ComCorpNo');" style="display:none;">다시입력</button>
                            <asp:DropDownList runat="server" ID="ComTaxKind" CssClass="type_01"></asp:DropDownList>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="CooperatorFlag" Text="<span></span> 협력업체"/>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="CargoManFlag" Text="<span></span> 카고맨"/>
                            <asp:Label runat="server" ID="SpanComStatusDtl"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ComName" CssClass="type_02" placeholder="* 업체명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComCeoName" CssClass="type_01" placeholder="* 대표자"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComBizType" CssClass="type_01" placeholder="업태"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComBizClass" CssClass="type_01" placeholder="종목"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComTelNo" CssClass="type_01 OnlyNumber" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComFaxNo" CssClass="type_01 OnlyNumber" placeholder="팩스"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ComEmail" CssClass="type_02 OnlyEmail" placeholder="이메일"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComPost" CssClass="type_01" placeholder="우편번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComAddr" CssClass="type_02" placeholder="주소"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ComAddrDtl" CssClass="type_03" placeholder="상세주소"></asp:TextBox>
                            <button type="button" class="btn_02" onclick="fnOpenAddress('Com')">우편번호검색</button>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>계좌정보</th>
                        <td>
                            <asp:DropDownList runat="server" ID="BankCode" CssClass="type_02"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="AcctName" CssClass="type_01" placeholder="예금주"></asp:TextBox>
                            <asp:TextBox runat="server" ID="EncAcctNo" CssClass="type_01 OnlyNumber" placeholder="계좌번호"></asp:TextBox>
                            <button type="button" id="BtnChkAcctNo" class="btn_02" onclick="fnChkAcctNo();">계좌확인</button>
                            <button type="button" id="BtnChkAcctNoReset" class="btn_03" style="display:none;" onclick="fnObjReset('Acct');">다시입력</button>
                        </td>
                        <th>결제일</th>
                        <td>
                            <asp:DropDownList runat="server" ID="PayDay" CssClass="type_01"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <div runat="server" ID="DivInsure">
                    <table class="popup_table" style="margin-top:20px;">
                        <colgroup>
                            <col style="width:180px"/> 
                            <col style="width:auto;"/> 
                        </colgroup>
                        <tr>
                            <th>산재보험 대상여부</th>
                            <td>
                                <asp:RadioButton ID="InsureTargetFlagY" runat="server" GroupName="InsureTargetFlag" value="Y" Checked="true" />
                                <label for="InsureTargetFlagY"><span></span>대상</label>&nbsp;&nbsp;
                                <asp:RadioButton ID="InsureTargetFlagN" runat="server" GroupName="InsureTargetFlag" value="N" />
                                <label for="InsureTargetFlagN"><span></span>대상아님</label>&nbsp;&nbsp;
                                <span>※ 사업자의 대표자와 운전기사가 고용관계일 경우 산재보험 대상이 아닙니다.</span>
                            </td>
                        </tr>
                    </table>
                </div>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>비고</th>
                        <td>
                            <asp:TextBox runat="server" ID="RefNote" CssClass="type_01" placeholder="비고" style="width:100%;" MaxLength="500"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div runat="server" id="UseFlagArea" visible="false" style="margin-top:20px;">
                    <table class="popup_table">
                        <colgroup>
                            <col style="width:180px"/> 
                            <col style="width:auto;"/> 
                        </colgroup>
                        <tr>
                            <th>사용여부</th>
                            <td>
                                <asp:DropDownList runat="server" ID="UseFlag" CssClass="type_01"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_01" id="InsBtn" onclick="fnCarDispatchInsConfirm();">등록</button>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button type="button" class="btn_02" id="CopyBtn" style="display:none;" onclick="fnCarDispatchCopy();">복사</button>
            </div>
        </div>
    </div>
</asp:Content>
