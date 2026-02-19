<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMyInfo.aspx.cs" Inherits="SSO.Admin.AdminMyInfo" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" runat="server">
    <script src="/SSO/Admin/Proc/AdminMyInfo.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" id="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidDisplayMode"/>
    <asp:HiddenField runat="server" ID="Mode" />
    <asp:HiddenField runat="server" ID="HidAuthCode" />
    <asp:HiddenField runat="server" ID="HidEncCode" />
    <asp:HiddenField runat="server" ID="MobileNoAuthFlag" />
    <asp:HiddenField runat="server" ID="SecurityFlag" />
    <asp:HiddenField runat="server" ID="ClientCode" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    
    <div id="contents">
		<table id="maintable" class="popup_table" style="width:1000px; margin:0 auto;">
            <colgroup>
                <col width="150"/>
                <col width="350"/>
                <col width="150"/>
                <col width="350"/>
            </colgroup>
            <tr style="height:60px">
                <td colspan="4" style="text-align:left;"><span style="font-size:20px;font-weight:400">내정보 관리</span></td>
            </tr>
            <tr class="WebOrderRegTypeM" style="display:none;">
                <th>운송구분</th>
				<td colspan="3" class="lft">
					<asp:Label runat="server" ID="RegReqTypeM"></asp:Label>
				</td>
			</tr>
			<tr>
                <th style="width: 200px">아이디</th>
				<td colspan="3" class="lft">
					<asp:TextBox runat="server" ID="AdminID" class="type_01" style="background-color:#e7e7e7;" ReadOnly="true"></asp:TextBox>
				</td>
			</tr>
            <tr>
                <th style="width: 200px">이름</th>
				<td colspan="3" class="lft">
					<asp:TextBox runat="server" ID="AdminName" class="type_01"  ReadOnly="true"></asp:TextBox>
				</td>
			</tr>
            <tr>
                <th rowspan="3">비밀번호</th>
                <td colspan="3">
                    <asp:TextBox TextMode="password" runat="server" ID="OrgAdminPwd" CssClass="type_01" placeholder="현재 비밀번호"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="lft">
                    <asp:TextBox TextMode="Password" runat="server" ID="AdminResetPwd" class="type_01" MaxLength="32" style="width:250px" PlaceHolder="비밀번호 변경" Title="새 비밀번호" onKeyDown="return (event.keyCode!=13);"></asp:TextBox><br/>
                    <br />
                    <p class="info_text">비밀번호는 영문,숫자,특수문자(!@$%^*만 허용)를 혼합 사용하여 8~16자까지</p>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:TextBox TextMode="Password" runat="server" ID="AdminResetPwdChk" class="type_01" MaxLength="32" style="width:250px" PlaceHolder="비밀번호 변경확인" title="새 비밀번호 확인" onKeyDown="return (event.keyCode!=13);"></asp:TextBox>
                    <button type="button" onclick="javascript:fnResetPassword();" class="btn_02">비밀번호 변경</button>
                </td>
            </tr>
            <tr>
				<th>휴대폰번호</th>
				<td colspan="3" class="lft">
                    <asp:TextBox runat="server" ID="MobileNo" class="type_01 OnlyNumber" MaxLength="20" ReadOnly="true"  AutoPostBack="False"></asp:TextBox>
                    <button type="button" class="btn_02" onclick="fnMobileNoUpd();">수정</button>
                    <div style="margin-top:10px; display:none" id="ConfirmArea">
                        <asp:TextBox runat="server" ID="NewMobileNo" class="type_01 OnlyNumber" placeholder="변경할 휴대폰 번호" MaxLength="11" AutoPostBack="False"></asp:TextBox>
                        <button type="button" class="btn_01" id="btnMobile" onclick="fnAuthNumberGet();">인증번호</button>
                        <button type="button" class="btn_03" id="btnMobileReset" style="display:none;" onclick="fnAuthNumberReset();">다시입력</button>
                        <asp:TextBox runat="server" ID="SmsAuthNo" class="type_small OnlyNumber" MaxLength="4" style="display:none;" placeholder="인증번호" AutoPostBack="False"></asp:TextBox>
                        <button type="button" class="btn_01" id="ConfirmBtn" onclick="fnAuthMobileUpd();" style="display:none">확인</button>
                    </div>
                </td>
			</tr>
            <tr>
				<th>직급</th>
				<td class="lft">
					<asp:TextBox runat="server" ID="AdminPosition" class="type_01" Width="100%"></asp:TextBox>
				</td>
				<th>소속팀</th>
				<td class="lft">
					<asp:TextBox runat="server" ID="DeptName" class="type_01" Width="100%"></asp:TextBox>
				</td>
			</tr>
            <tr>
				<th>전화번호</th>
				<td colspan="3" class="lft">
					<asp:TextBox runat="server" ID="TelNo" class="type_01 OnlyNumber"  Width="100%"></asp:TextBox>
				</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td colspan="3" class="lft">
					<asp:TextBox runat="server" ID="Email" class="type_01 OnlyEmail" Width="100%"></asp:TextBox>
				</td>
			</tr>
            <tr runat="server" id="TrOp2" Visible="False" class="WebOrderNone">
				<th>전국24시콜 아이디</th>
				<td class="lft">
					<asp:TextBox runat="server" ID="Network24DDID" class="type_01"  Width="100%"></asp:TextBox>
				</td>
		        <th>화물맨 아이디</th>
		        <td class="lft">
		            <asp:TextBox runat="server" ID="NetworkHMMID" class="type_01"  Width="100%"></asp:TextBox>
		        </td>
		    </tr>
            <tr runat="server" id="TrOp3" Visible="False" class="WebOrderNone">
                <th>원콜 아이디</th>
                <td class="lft">
                    <asp:TextBox runat="server" ID="NetworkOneCallID" class="type_01"  Width="100%"></asp:TextBox>
                </td>
                <th>화물마당 아이디</th>
                <td class="lft">
                    <asp:TextBox runat="server" ID="NetworkHmadangID" class="type_01"  Width="100%"></asp:TextBox>
                </td>
            </tr>
            <tr runat="server" id="TrEtc1" Visible="False">
                <th>사업자명</th>
                <td colspan="3" class="lft">
                    <asp:Literal runat="server" ID="AdminCorpName"></asp:Literal>
                </td>
            </tr>
            <tr runat="server" id="TrEtc2" Visible="False">
                <th>사업자번호</th>
                <td colspan="3" class="lft">
                    <asp:Literal runat="server" ID="AdminCorpNo"></asp:Literal>
                </td>
            </tr>
            <tr class="WebOrderNone">
                <th>웹오더 알림<br />수신업체</th>
                <td colspan="3" class="lft">
                    <asp:DropDownList runat="server" CssClass="type_01" ID="CenterCode"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="고객사 검색"></asp:TextBox>
                    <button type="button" class="btn_02" onclick="fnAdminClientConfirm('Ins');">등록</button>
                    <asp:DropDownList runat="server" CssClass="type_03" ID="ClientInfo"></asp:DropDownList>
                    <button type="button" class="btn_03" onclick="fnAdminClientConfirm('Del')">선택삭제</button>
                </td>
            </tr>
		</table>
        <div style="text-align:center;margin-top:10px">
            <button type="button" class="btn_01" onclick="javascript:fnUpdAdminMyInfo();"  id="btnRegister">정보수정</button>
        </div>
    </div>
</asp:Content>
