<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" validateRequest="false" CodeBehind="BoardIns.aspx.cs" Inherits="SSO.Board.BoardIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Board/Proc/BoardIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/lib/SmartEditor2/js/HuskyEZCreator.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" charset="utf-8"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script>
        $(document).ready(function () {
            if ($("#hidDisplayMode").val() === "Y") {
                parent.fnReloadPageNotice("데이터를 불러올 수 없습니다.");
                return;
            }
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="Mode" />
    <asp:HiddenField runat="server" ID="SeqNo" />

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table id="maintable" class="popup_table" style="border-top:0px;">
                    <colgroup>
                        <col style="width:150px"/>
                        <col style="width:auto;"/>
                        <col style="width:150px"/>
                        <col style="width:auto;"/>
                    </colgroup>
                    <tr>
                        <th><span style="color:#f00">*</span> 게사판 유형</th>
                        <td class="lft">
                            <asp:DropDownList runat="server" ID="BoardViewType"  CssClass="type_01"></asp:DropDownList>
                        </td>
                        <th><span style="color:#f00">*</span> 메인 팝업 설정</th>
                        <td class="lft">
                            <asp:DropDownList runat="server" ID="MainDisplayFlag"  CssClass="type_01"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>게시회원</th>
                        <td class="lft" colspan="3">
                            <div style="padding-bottom:10px;">
                                <asp:CheckBox runat="server" ID="AllCenterCodeChk" Text="<span></span> 전체"/>
                            </div>
                            <asp:CheckBoxList runat="server" ID="AccessCenterCode" RepeatDirection="Horizontal" RepeatLayout="Table"></asp:CheckBoxList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width:140px;">게시등급</th>
                        <td class="lft" colspan="3">
                            <asp:DropDownList runat="server" ID="BoardGradeCode" CssClass="type_01"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:#f00">*</span> 제목</th>
                        <td colspan="3">
                            <asp:TextBox runat="server" ID="BoardTitle" MaxLength="100" CssClass="type_100p" placeholder="제목을 입력하세요."></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:#f00">*</span> 내용</th>
                        <td style="height:300px" colspan="3">
                            <asp:TextBox TextMode="MultiLine" CssClass="special_note" runat="server" ID="BoardContent" name="BoardContent" placeholder="내용을 입력하세요."></asp:TextBox>
                            <script>
                                var oEditors = [];
                                nhn.husky.EZCreator.createInIFrame({
                                    oAppRef: oEditors,
                                    elPlaceHolder: "BoardContent",
                                    sSkinURI: "/js/lib/SmartEditor2/SmartEditor2Skin.html",
                                    fCreator: "createSEditor2"
                                });
                            </script>
                        </td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td colspan="3">
                            <asp:FileUpload runat="server" id="BoardFileUpload"/>
                            <ul id="UlFileList" runat="server">
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:#f00">*</span> 사용여부</th>
                        <td colspan="3">
                            <asp:DropDownList runat="server" ID="UseFlag" CssClass="type_small"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:10px">
                <ul><li><button type="button" class="btn_01" onclick="javascript:fnBoardConfirm();"><asp:Label runat="server" ID="lblMode" style="color:#fff;font-weight:200;font-size:15px">저장</asp:Label></button></li></ul>
            </div>
        </div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
