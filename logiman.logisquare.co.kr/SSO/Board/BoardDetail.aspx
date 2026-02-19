<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" validateRequest="false" CodeBehind="BoardDetail.aspx.cs" Inherits="SSO.Board.BoardDetail" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script>
        function fnCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }

        //파일 다운로드
        function fnDownloadFile(obj) {
            var seq = "";
            var foname = "";
            var fnname = "";
            var flag = "";

            seq = $(obj).parent("li").attr("seq");
            foname = $(obj).text();
            fnname = $(obj).parent("li").attr("fname");
            flag = $(obj).parent("li").attr("flag");

            if (seq == "" || seq == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (foname == "" || foname == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (fnname == "" || fnname == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (flag == "" || flag == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            var $form = null;

            if ($("form[name=dlFrm]").length == 0) {
                $form = $('<form name="dlFrm"></form>');
                $form.appendTo('body');
            } else {
                $form = $("form[name=dlFrm]");
            }

            $form.attr('action', '/SSO/Board/Proc/BoardFileHandler.ashx');
            $form.attr('method', 'post');
            $form.attr('target', 'ifrmFiledown');
            var f1 = $('<input type="hidden" name="CallType" value="BoardFileDownload">');
            var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
            var f3 = $('<input type="hidden" name="FileName" value="' + foname + '">');
            var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
            var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');

            $form.append(f1).append(f2).append(f3).append(f4).append(f5);
            $form.submit();
            $form.remove();
        }
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
                            <asp:Label runat="server" ID="BoardViewTypeM"></asp:Label>
                        </td>
                        <th><span style="color:#f00">*</span> 메인 팝업 설정</th>
                        <td class="lft">
                            <asp:Label runat="server" ID="MainDisplayFlagM"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:#f00">*</span> 제목</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="BoardTitle"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th><span style="color:#f00">*</span> 내용</th>
                        <td style="height:300px" colspan="3">
                            <div id="BoardContent" runat="server"></div>
                        </td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td colspan="3">
                            <ul id="UlFileList" runat="server">
                            </ul>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="btn" style="text-align:center; margin-top:20px;">
                <button type="button" class="btn_03" onclick="fnCloseCpLayer();">닫기</button>
            </div>
        </div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
