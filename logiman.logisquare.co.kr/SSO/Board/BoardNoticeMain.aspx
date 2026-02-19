<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" validateRequest="false" CodeBehind="BoardNoticeMain.aspx.cs" Inherits="SSO.Board.BoardNoticeMain" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        $(document).ready(function () {
            if ($("#HidNewFlag").val() === "Y") {
                parent.$("header div.info ul li.info").addClass("new");
            }

            parent.$("#HidNoticeFlag").val($("#HidNoticeDataFlag").val());
            
            if ($.cookie("MainNoticeView") == 1 || $.cookie("MainNoticeView") == 7) {
                parent.$("#NoticeMainLayer").hide();
                if ($("#HidNoticeDataFlag").val() === "N") {
                    parent.$("#Notice_frame").attr("src", "");
                }
                return;
            }else {
                if ($("#HidNoticeDataFlag").val() === "Y") {
                    parent.NoticeMainViewSub();
                    return;
                }
            }
        });

        function NoticeClose() {
            parent.$("#NoticeMainLayer").hide();
            parent.$("#Notice_frame").attr("src", "");
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
    <style>
        .exception {margin:0px !important; width:100%; height:100%;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidDisplayMode" />
    <asp:HiddenField runat="server" ID="hidErrMsg" />
    <asp:HiddenField runat="server" ID="HidNewFlag" />
    <asp:HiddenField runat="server" ID="HidNoticeDataFlag" />

    <div class="notice_board_list">
        <ul class="notice_scroll" id="NOTICE_SCROLL" runat="server" Visible="False">
            <li><a href="javascript:void(0);" onclick="NoticeScroll(1);"><img src="/images/icon/top_arr_icon.png"/></a></li>
            <li><a href="javascript:void(0);" onclick="NoticeScroll(2);"><img src="/images/icon/down_arr_icon.png"/></a></li>
        </ul>
        <div id="NoticeBody" runat="server"></div>
        <div id="NOTICE_NO_DATA" style="height:100%;" runat="server" Visible="False">
            <div class="hc_notice_title">
                <h3>공지사항 정보가 없습니다.</h3>
            </div>
            <div class="hc_notice_cnts">
                공지사항 정보가 없습니다.
            </div>
            
        </div>
        <div class="notice_bottom" style="width: 100%; height: 0px;"></div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
