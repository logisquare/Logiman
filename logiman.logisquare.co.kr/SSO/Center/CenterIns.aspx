<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CenterIns.aspx.cs" Inherits="CENTER.Center.CenterIns" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="./Proc/CenterIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidCenterCode" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    <asp:HiddenField runat="server" ID="CorpNoCheck" />
    <asp:HiddenField runat="server" ID="AcctValidFlag" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="display:none; border-top:0px;">
                    <colgroup>
                        <col style="width:180px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th style="width:150px">회원사ID</th>
                        <td class="lft"><asp:TextBox runat="server" ID="CenterID" Width="233px" class="type_01" MaxLength="50" ToolTip="별도 입력없이 자동으로 설정됩니다."></asp:TextBox></td>
                        <th style="width:150px">회원사KEY</th>
                        <td class="lft"><asp:TextBox runat="server" ID="CenterKey" Width="233px" class="type_01" MaxLength="50" style="width:100%" ToolTip="별도 입력없이 자동으로 설정됩니다."></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">가맹점명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="CenterName" Width="233px" class="type_01 essential" MaxLength="50"></asp:TextBox></td>
                        <th style="width:150px">사업자번호</th>
                        <td class="lft">
                            <asp:TextBox runat="server" ID="CorpNo" CssClass="type_01 OnlyNumber essential" MaxLength="10" placeholder="사업자번호('-'제거)"></asp:TextBox>
                            <button runat="server" type="button" id="BtnChkCorpNo" onclick="fnChkCorpNo();" class="btn_02">사업자확인</button>
                            <button runat="server" type="button" id="BtnChkCorpNoReset" class="btn_03" onclick="fnCorpNoReset();" style="display:none;">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:150px"> 대표자명</th>
                        <td class="lft"><asp:TextBox runat="server" ID="CeoName" Width="233px" class="type_01 essential" MaxLength="30"></asp:TextBox></td>
                        <th style="width:150px">업태</th>
                        <td class="lft"><asp:TextBox runat="server" ID="BizType" Width="233px" class="type_01 essential" MaxLength="40"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">종목</th>
                        <td class="lft"><asp:TextBox runat="server" ID="BizClass" Width="233px" class="type_01 essential" MaxLength="40"></asp:TextBox></td>
                        <th style="width:150px">전화번호</th>
                        <td class="lft"><asp:TextBox runat="server" ID="TelNo" Width="233px" class="type_01 txt_number essential" MaxLength="20"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">팩스번호</th>
                        <td class="lft"><asp:TextBox runat="server" ID="FaxNo" Width="233px" class="type_01 txt_number essential" MaxLength="20"></asp:TextBox></td>
                        <th style="width:150px">이메일</th>
                        <td class="lft"><asp:TextBox runat="server" ID="Email" Width="233px" class="type_01 essential" MaxLength="100"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">주소</th>
                        <td class="lft">
                            <asp:TextBox runat="server" ID="AddrPost" class="type_small essential" MaxLength="6" placeholder="우편번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="Addr" class="type_06 essential" MaxLength="256" placeholder="가맹점 주소"></asp:TextBox>
                        </td>
                        <th style="width:150px">비고</th>
                        <td class="lft">
                            <asp:TextBox runat="server" ID="CenterNote" class="type_100p" MaxLength="500"></asp:TextBox>
                        </td>                        
                    </tr>
                    <tr>
                        <th style="width:150px"> 회원사 종류</th>
                        <td class="lft">
                            <asp:DropDownList runat="server" ID="CenterType" onchange="fnChangeCenterType();" CssClass="type_01 essential"></asp:DropDownList></td>
                        <th style="width:150px"> 회원사 사용여부</th>
                        <td class="lft"><asp:DropDownList runat="server" ID="UseFlag" CssClass="type_01 UseFlag essential"></asp:DropDownList></td>
                    </tr>
                    <tr runat="server" id="TrContract" style="display: none;">
                        <th style="width:150px">정보위탁계약여부</th>
                        <td class="lft" colspan="3">
                            <asp:DropDownList runat="server" ID="ContractFlag" CssClass="type_01 essential"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr id="divTransSaleRate" style="display:none;">
                        <th style="width:150px"> 이관매출비율(%)</th>
                        <td class="lft" colspan="3">
                            <asp:TextBox runat="server" ID="TransSaleRate" CssClass="type_01 OnlyNumberPoint" placeholder="이관매출비율(%)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:150px"> 계좌정보</th>
                        <td class="lft" colspan="3">
                            <asp:DropDownList runat="server" ID="BankCode" CssClass="type_02"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="AcctName" CssClass="type_01" placeholder="예금주"></asp:TextBox>
                            <asp:TextBox runat="server" ID="EncAcctNo" CssClass="type_01 OnlyNumber" placeholder="계좌번호"></asp:TextBox>
                            <button type="button" id="BtnChkAcctNo" class="btn_02" onclick="fnChkAcctNo();">계좌확인</button>
                            <button type="button" id="BtnChkAcctNoReset" class="btn_03" style="display:none;" onclick="fnObjReset('Acct');">다시입력</button>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnInsCenter();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
</asp:Content>
