<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FranchiseList.aspx.cs" Inherits="SSO.Center.FranchiseList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Center/Proc/FranchiseList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            fnSetInitData();

            $("#SearchType").on("change", function () {
                fnSetInitData();
            });

            $("#ListSearch").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });
        });

        function fnSearchData() {
            $("#PageNo").val("1");
        }

        function fnSetInitData() {
            if ($("#SearchType option:selected").val() == "") {
                $("#ListSearch").val("");
                $("#ListSearch").attr("disabled", true);
            }
            else {
                $("#ListSearch").attr("disabled", false);
            }
        }

        function fnInsCenter(strTitle, strCenterCode) {
            fnOpenRightSubLayer(strTitle, "/SSO/Center/FranchiseIns.aspx?CenterCode=" + strCenterCode, "1024px", "700px", "80%");
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
                <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="ListSearch" class="type_01" />
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>

            <ul class="action">
                <li class="left">
                    <button type="button" class="btn_02" id="RegBtn" runat="server" onclick="javascript:fnInsCenter('가맹점 추가', '');">가맹점 등록</button>
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
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('CenterListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('CenterListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                </li>
            </ul>

            <div id="CenterListGrid"></div>

            <div id="page"></div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('CenterListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('CenterListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('CenterListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
