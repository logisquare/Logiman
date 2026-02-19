<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientPlaceChargeIns.aspx.cs" Inherits="TMS.ClientPlace.ClientPlaceChargeIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClientPlace/Proc/ClientPlaceChargeIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
            parent.fnMoveToPage(1);
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="PlaceSeqNo" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidPlaceNameChk" />
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
                            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="2">상/하차</th>
                        <td>
                            <asp:TextBox runat="server" ID="PlaceName" CssClass="type_01 essential" placeholder="* 상하차지명"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnPlaceNameChk" onclick="fnPlaceNameChk();">중복확인</button>
                            <button type="button" class="btn_03" id="BtnPlaceNameReset" onclick="fnPlaceNameReset();" style="display:none;">다시입력</button>
                            <asp:TextBox runat="server" ID="PlacePost" CssClass="type_01 essential" ReadOnly="true" placeholder="* 우편번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PlaceAddr" CssClass="type_01 essential" ReadOnly="true" placeholder="* 주소"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PlaceAddrDtl" CssClass="type_01" placeholder="상세주소"></asp:TextBox>
                            <button type="button" runat="server" id="BtnPostSearch" onclick="fnOpenAddress('Place');" class="btn_02">우편번호 검색</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="PlaceSido" CssClass="type_01" ReadOnly="true" placeholder="광역시,도"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PlaceSigungu" CssClass="type_01" ReadOnly="true" placeholder="시,군,구"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PlaceDong" CssClass="type_01" ReadOnly="true" placeholder="읍,동,면"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3">고객사</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="* 고객사명"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="ClientCode" />
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3">담당자</th>
                        <td>
                            <asp:HiddenField runat="server" ID="SeqNo"/>
                            <asp:TextBox runat="server" ID="ChargeName" CssClass="type_01 essential" placeholder="* 담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargePosition" CssClass="type_small" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeTelExtNo" CssClass="type_01 OnlyNumber" MaxLength="20" placeholder="연락처(내선)"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeTelNo" CssClass="type_01 OnlyNumber" MaxLength="20" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeCell" CssClass="type_01 OnlyNumber" MaxLength="20" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ChargeNote" CssClass="type_100p" placeholder="비고"></asp:TextBox>
                            <button runat="server" type="button" id="AddChargeBtn" onclick="fnChargeInsConfirm();" visible="false" class="btn_01">담당자 추가</button>
                            <button runat="server" type="button" id="ResetChargeBtn" onclick="fnChargeReset('Charge');" visible="false" class="btn_02">다시입력</button>
                        </td>
                    </tr>
                    <tr runat="server" id="GridClientCharge" visible="false">
                        <td>
                            <ul class="action">
                                <li class="left">
                                    <asp:TextBox runat="server" ID="SearchChargeName" CssClass="type_01" placeholder="담당자명 검색"></asp:TextBox>
                                    <button type="button" id="SearchChargeBtn" class="btn_01">검색</button>
                                </li>
                                <li class="right">
                                    <button type="button" id="DelChargeBtn" onclick="fnChargeDelConfirm();" class="btn_03">삭제</button>
                                </li>
                            </ul>
                            <div id="ChargeListGrid" class="subGridWrap" style="margin-top:20px;"></div>
                        </td>
                    </tr>
                </table>
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3">지역</th>
                        <td>
                            <asp:TextBox runat="server" ID="LocalCode" CssClass="type_small" MaxLength="10" placeholder="지역코드"></asp:TextBox>
                            <asp:TextBox runat="server" ID="LocalName" CssClass="type_01" MaxLength="10" placeholder="지역명"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <h3 class="popup_title">특이사항</h3>
                <table class="popup_table">
                    <colgroup>
                        <col style="width:50%;"/> 
                        <col style="width:50%"/> 
                    </colgroup>
                    <tr>
                        <th>내수</th>
                        <th>수입</th>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox TextMode="MultiLine" runat="server" ID="PlaceRemark1" CssClass="special_note" MaxLength="500" style="height:70px;"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox TextMode="MultiLine" runat="server" ID="PlaceRemark2" CssClass="special_note" MaxLength="500" style="height:70px;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>수출</th>
                        <th>컨테이너</th>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox TextMode="MultiLine" runat="server" ID="PlaceRemark3" CssClass="special_note" MaxLength="500" style="height:70px;"></asp:TextBox>
                        </td>
                        <td>
                            <asp:TextBox TextMode="MultiLine" runat="server" ID="PlaceRemark4" CssClass="special_note" MaxLength="500" style="height:70px;"></asp:TextBox>
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
                                <asp:RadioButton ID="UseFlagY" runat="server" GroupName="UseFlag" value="Y" Checked="true" />
                                <label for="UseFlagY"><span></span>사용중</label>
                                <asp:RadioButton ID="UseFlagN" runat="server" GroupName="UseFlag" value="N" />
                                <label for="UseFlagN"><span></span>사용중지</label>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_01" id="InsBtn" onclick="fnClientPlaceChargeInsConfirm();">등록</button>
            </div>
        </div>
    </div>
</asp:Content>
