<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CenterHomeTaxDeptUserIns.aspx.cs" Inherits="CENTER.Center.CenterHomeTaxDeptUserIns" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript">
        function fnCenterHometaxDeptins() {
            if ($("#DeptUserID").val() === "") {
                fnDefaultAlert("부서사용자 아이디를 입력하세요.", "warning");
            }
            if ($("#EncDeptUserPwd").val() === "") {
                fnDefaultAlert("부서사용자 아이디를 입력하세요.", "warning");
            }

            fnDefaultConfirm("등록하시겠습니까?", "fnInsCenteHometaxDeptinsrProc", "CenterHomeTaxDeptInsert");
            return;
        }

        function fnInsCenteHometaxDeptinsrProc(ojbParam) {
            var strHandlerURL = "/SSO/Center/Proc/CenterHandler.ashx";
            var strCallBackFunc = "fnAjaxCenteHometax";

            let objParam = {
                CallType: ojbParam,
                CenterCode: $("#hidCenterCode").val(),
                DeptUserID: $("#DeptUserID").val(),
                EncDeptUserPwd: $("#EncDeptUserPwd").val(),
                RegType: $("#RegType").val()
            };

            UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
        }

        function fnAjaxCenteHometax(data) {
            if (data[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
            } else {
                fnDefaultAlert("등록되었습니다.", "success");
            }
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="hidMode" />
    <asp:HiddenField runat="server" ID="hidCenterCode" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="border-top:0px;">
                    <colgroup>
                        <col style="width:180px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th style="width:150px">부서사용자 아이디</th>
                        <td class="lft"><asp:TextBox runat="server" ID="DeptUserID" class="type_100p" MaxLength="50" placeholder="아이디" ></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th style="width:150px">부서사용자 비밀번호</th>
                        <td class="lft"><asp:TextBox runat="server" TextMode="Password" ID="EncDeptUserPwd" class="type_100p" MaxLength="50" placeholder="비밀번호"></asp:TextBox></td>
                    </tr>
                    <tr runat="server" id="GradeRegType" style="display:none;">
                        <th style="width:150px">등록 진행상태</th>
                        <td class="lft" colspan="3">
                            <asp:DropDownList runat="server" ID="RegType" CssClass="type_100p"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <p style="padding:15px 0; text-align:center;">등록이 완료되면 전자계산서 수집이 진행됩니다.</p>
            </div>
            <div style="text-align:center;margin-top:10px">
                <button type="button" class="btn_01" onclick="javascript:fnCenterHometaxDeptins();">등록</button>
            </div>
            <br />
            <br />
            <p style="text-align:center; line-height:1.5; word-break:keep-all">부서사용자 등록이란?<br />
회원사의 매입 전자계산서를 국세청으로부터 카고페이로 수신받기 위해서는 국세청 사이트 (<a href="http://www.hometax.go.kr" style="color: #1738c5;" target="_blank">http://www.hometax.go.kr</a>) 에서 카고페이 전용 부서사용자를 등록해 주셔야 합니다.</p>
            <div style="text-align:center;margin-top:20px">
                <asp:Button ID="btnDownLoad" runat="server" class="btn_02" OnClick="DownLoad_Click" Text="부서사용자등록 매뉴얼 다운로드" />
            </div>
        </div>
    </div>
</asp:Content>
