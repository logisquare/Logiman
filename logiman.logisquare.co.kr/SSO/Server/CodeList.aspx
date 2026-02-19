<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CodeList.aspx.cs" Inherits="SSO.Server.CodeList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Server/Proc/CodeList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });
        });

        function fnSearchData() {
            $("#PageNo").val("1");
        }

        function fnInsCode(strTitle, strCodeName) {
            fnOpenRightSubLayer(strTitle, "/SSO/Server/CodeIns.aspx?CodeName=" + strCodeName, "1024px", "700px", "50%");
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            fnSearchData();
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
                <asp:TextBox runat="server" ID="CodeName" placeholder="코드명" class="type_02" />
                <asp:TextBox runat="server" ID="CodeVal" placeholder="코드값" class="type_02" />
                <asp:TextBox runat="server" ID="CodeDesc" placeholder="코드설명" class="type_02" />
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>

            <ul class="action">
                <li class="left">
                    <button type="button" class="btn_02" onclick="javascript:fnInsCode('코드 추가', '');">코드 추가</button>
                </li>
                <li class="right"></li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <ul class="drop_btn" style="float:right;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('CodeListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('CodeListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                </li>
            </ul>

            <div id="CodeListGrid"></div>

            <div id="page"></div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('CodeListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('CodeListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('CodeListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
