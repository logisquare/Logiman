<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="AdminIns.aspx.cs" Inherits="SSO.Admin.AdminIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Admin/Proc/AdminIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        #CenterCodes label {margin-right:15px; font-size:14px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidAdminID" />
    <asp:HiddenField runat="server" ID="hidAdminIDFlag" />
    <asp:HiddenField runat="server" ID="AdminCorpNo" />
    <asp:HiddenField runat="server" ID="AdminCorpName" />
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th><span style="color:#f00">*</span>사용자 등급</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="GradeCode" Width="150px" CssClass="type_01"></asp:DropDownList></td>
                    </tr>
                </table>
                <div id="GradeTable" style="display:none; margin-top:10px;">
                    <h3 class="popup_title">사용자 정보</h3>
                    <table class="popup_table">
                        <colgroup>
                            <col style="width:180px"/> 
                            <col style="width:auto;"/> 
                        </colgroup>
                        <tr id="CenterCodeTr">
                            <th><span style="color:#f00">*</span> 회원사</th>
                            <td>
                                <asp:CheckBoxList runat="server" ID="CenterCodes" RepeatDirection="Horizontal" RepeatLayout="Flow"></asp:CheckBoxList>
                                <asp:DropDownList runat="server" ID="CenterCode" CssClass="type_01" style="display:none;"></asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <th style="width:150px"><span style="color:#f00">*</span> 아이디</th>
                            <td class="lft">
                                <asp:TextBox runat="server" ID="AdminID" Width="233px" class="type_01 onlyAlphabetNum" MaxLength="20" PlaceHolder="아이디(영문/숫자)" Title="아이디(영문/숫자)"></asp:TextBox>
                                <button type="button" class="btn_02" runat="server" id="AdminIDBtn" onclick="fnChkAdminID(1);">중복확인</button>
                                <button type="button" class="btn_03" runat="server" id="AdminIDBtnReturn" onclick="fnChkAdminID(2);" style="display:none;">다시 입력</button>
                                <br />
                                <span class="id_pass" style="color:#006cb7; display:none;">사용가능한 아이디입니다.</span>
                                <span class="id_fail" style="color:#f15929; display:none;">이미 등록된 아이디입니다.</span>
                            </td>
                        </tr>
                        <tr id="ClientTb" style="display:none;">
                            <th><span style="color:#f00">*</span> 고객사</th>
                            <td>
                                <asp:HiddenField runat="server" ID="ClientCorpNo"/>
                                <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="고객사 검색"></asp:TextBox>
                                <button type="button" id="ClientResetBtn" class="btn_03" onclick="fnClientReset();" style="display:none;">다시입력</button>
                            </td>
                        </tr>
                        <tr>
                            <th><span style="color:#f00">*</span> 이름</th>
                            <td class="lft"><asp:TextBox runat="server" ID="AdminName" class="type_01" MaxLength="30" placeholder="필수입력" title="필수입력"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th><span style="color:#f00">*</span> 휴대폰 번호</th>
                            <td class="lft"><asp:TextBox runat="server" ID="MobileNo" class="type_01 OnlyNumber" MaxLength="20" placeholder="필수입력 ('-'제외)" title="필수입력 ('-'제외)"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>직급</th>
                            <td class="lft"><asp:TextBox runat="server" ID="AdminPosition" class="type_01" MaxLength="50"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>소속팀</th>
                            <td class="lft"><asp:TextBox runat="server" ID="DeptName" class="type_01" MaxLength="100"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>전화번호</th>
                            <td class="lft"><asp:TextBox runat="server" ID="TelNo" class="type_01 txt_number" MaxLength="20"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td class="lft"><asp:TextBox runat="server" ID="Email" class="type_02" MaxLength="80"></asp:TextBox></td>
                        </tr>
                    
                        <tr>
                            <th>계정 만료일</th>
                            <td class="lft"><asp:TextBox runat="server" ID="ExpireYMD" class="type_01 date" title="만료일" placeholder="만료일" /></td>
                        </tr>
                        <tr>
                            <th>접속 IP 사용여부</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="AccessIPChkFlag" Width="120px"  CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <th rowspan="3">접속 IP 주소</th>
                            <td class="lft">
                                1 : <asp:TextBox runat="server" ID="AccessIP1_1" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP1_2" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP1_3" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP1_4" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="lft">
                                2 : <asp:TextBox runat="server" ID="AccessIP2_1" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP2_2" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP2_3" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP2_4" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="lft">
                                3 : <asp:TextBox runat="server" ID="AccessIP3_1" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP3_2" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP3_3" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>.
                                    <asp:TextBox runat="server" ID="AccessIP3_4" Width="50px" MaxLength="3" class="type_01 clsAccessIP"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="network_tr">
                            <th>전국24시콜 아이디</th>
                            <td class="lft"><asp:TextBox runat="server" ID="Network24DDID" Width="233px" class="type_01" MaxLength="50"></asp:TextBox></td>
                        </tr>
                        <tr class="network_tr">
                            <th>화물맨 아이디</th>
                            <td class="lft"><asp:TextBox runat="server" ID="NetworkHMMID" Width="233px" class="type_01" MaxLength="50"></asp:TextBox></td>
                        </tr>
                        <tr class="network_tr">
                            <th>원콜 아이디</th>
                            <td class="lft"><asp:TextBox runat="server" ID="NetworkOneCallID" Width="233px" class="type_01" MaxLength="50"></asp:TextBox></td>
                        </tr>
                        <tr class="network_tr">
                            <th>화물마당 아이디</th>
                            <td class="lft"><asp:TextBox runat="server" ID="NetworkHmadangID" Width="233px" class="type_01" MaxLength="50"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>중복로그인 허용 여부</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="DupLoginFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <th>내 오더만 조회 여부</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="MyOrderFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                        <tr>
                            <th>계정 사용 여부</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="UseFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                        <tr runat="server" ID="TrPrivate" style="display: none;">
                            <th>개인정보접근가능여부</th>
                            <td class="lft"><asp:DropDownList runat="server" ID="PrivateAvailFlag" Width="120px" CssClass="type_01"></asp:DropDownList></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsAdmin();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
