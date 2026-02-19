<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="PlaceIns.aspx.cs" Inherits="APP.TMS.Client.PlaceIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/APP/TMS/Client/Proc/PlaceIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            if ($("#Mode").val() === "Insert") {
                $("#PopMastertitle").text("상하차지 등록");
            } else {
                $("#PopMastertitle").text("상하차지 수정");
            }
        });
    </script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
    <asp:HiddenField runat="server" ID="Mode"/>
    <asp:HiddenField runat="server" ID="PlaceSeqNo"/>
    <asp:HiddenField runat="server" ID="HidPlaceNameChk"/>
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
                <h2>상/하차</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceName" CssClass="type_01" placeholder="상/하차지명"></asp:TextBox>
                                    </li>
                                    <li>
                                        <button type="button" id="BtnPlaceNameChk" class="type_02" onclick="fnPlaceNameChk();">중복확인</button>
                                        <button type="button" id="BtnPlaceNameReset" class="type_02" style="display:none;" onclick="fnPlaceNameReset();">다시입력</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="dispatch_search">
                                    <li style="width:65%;">
                                        <asp:TextBox runat="server" ID="PlacePost" placeholder="우편번호를 검색하세요" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li style="width:35%;">
                                        <button type="button" class="btn_100p" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                                    </li>
                                </ul>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceAddr" CssClass="type_01" placeholder="주소" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceAddrDtl" CssClass="type_01" placeholder="상세주소"></asp:TextBox>
                                    </li>
                                </ul>
                                <ul class="ul_type_04">
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceSido" CssClass="type_01" placeholder="광역시,도" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceSigungu" CssClass="type_01" placeholder="시,군,구" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="PlaceDong" CssClass="type_01" placeholder="읍,동,면" ReadOnly="true"></asp:TextBox>
                                    </li>
                                </ul>
                                <div id="DivPlaceAddrWrap"></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="reg_btn" id="BtnUpd" style="display:none;">
                    <button type="button" onclick="fnClientPlaceChargeInsConfirm();">수정하기</button>
                </div>
            </div>

            <div class="ins_section">
                <h2>담당자</h2> 
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_04">
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargeName" CssClass="type_01 essential" placeholder="담당자명"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargePosition" CssClass="type_01" placeholder="직급"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargeTelExtNo" CssClass="type_01" placeholder="내선"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargeTelNo" CssClass="type_01" placeholder="전화번호"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargeCell" CssClass="type_01" placeholder="휴대폰번호"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="ChargeNote" CssClass="type_01" placeholder="비고"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="reg_btn" id="BtnChargeReg" style="display:none;">
                    <button type="button" onclick="fnChargeInsConfirm();">추가하기</button>
                </div>
            </div>

            <div class="ins_section" runat="server" id="ChargeList" visible="false">
                <h2>담당자 목록</h2>
                <div>
                    <asp:DropDownList runat="server" ID="PlaceChargeList" CssClass="type_01"></asp:DropDownList>
                </div>
                <div class="reg_btn_02" id="BtnChargeDel" style="display:none;">
                    <button type="button" onclick="fnChargeDelConfirm();">삭제하기</button>
                </div>
            </div>

            <div class="reg_btn" id="BtnReg">
                <button type="button" onclick="fnClientPlaceChargeInsConfirm();">등록하기</button>
            </div>
        </div>
    </div>
</asp:Content>