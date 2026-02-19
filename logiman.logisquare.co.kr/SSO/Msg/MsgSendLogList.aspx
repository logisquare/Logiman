<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" Codebehind="MsgSendLogList.aspx.cs" Inherits="SSO.Msg.MsgSendLogList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Msg/Proc/MsgSendLogList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#FromYMD").datepicker({
                changeMonth: true,
                changeYear: true,
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
                monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dateFormat: "yy-mm-dd"
            });

            $("#ToYMD").datepicker({
                changeMonth: true,
                changeYear: true,
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
                monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dateFormat: "yy-mm-dd"
            });

            SetInitData();

            $("#SearchType").change(function () {
                SetInitData();
            });

            $("#ListSearch").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function (event) {
                event.preventDefault();
                fnMoveToPage(1);
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "MsgSendLogListExcel",
                    CenterCode: $("#CenterCode").val(),
                    MsgType: $("#MsgType").val(),
                    RetCodeType: $("#RetCodeType").val(),
                    FromYMD: $("#FromYMD").val(),
                    ToYMD: $("#ToYMD").val(),
                    SearchType: $("#SearchType").val(),
                    ListSearch: $("#ListSearch").val()
                };

                $.fileDownload("/SSO/Msg/Proc/MsgSendLogHandler.ashx", {
                    httpMethod: "POST",
                    data: objParam,
                    prepareCallback: function () {
                        UTILJS.Ajax.fnAjaxBlock();
                    },
                    successCallback: function (url) {
                        $.unblockUI();
                        fnDefaultAlert("엑셀을 다운로드 하였습니다.", "success");
                    },
                    failCallback: function (html, url) {
                        $.unblockUI();
                        fnDefaultAlert("나중에 다시 시도해 주세요.");
                    }
                });
            });
        });

        function SetInitData() {
            if ($("#SearchType option:selected").val() === "") {
                $("#ListSearch").val("");
                $("#ListSearch").attr("disabled", true);
            }
            else {
                $("#ListSearch").attr("disabled", false);
                $("#ListSearch").focus();
            }
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" style="width:220px" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="MsgType" class="type_01" style="width:220px" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="RetCodeType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="FromYMD" class="date type_01" title="등록일" placeholder="등록일" AutoPostBack="false" />
                <asp:TextBox runat="server" ID="ToYMD" class="date type_01" title="등록일" placeholder="등록일" AutoPostBack="false" />
                <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="ListSearch" class="type_01" />
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                
            </div>
            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                </li>
            </ul>
            <div id="MsgSendLogListGrid"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="SendNum">발신번호</option>
                        <option value="RcvNum">수신번호</option>
                        <option value="Title">제목</option>
                        <option value="Contents">본문</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>

            <div id="page"></div>
        </div>

    </div>
</asp:Content>
