<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ClientList.aspx.cs" Inherits="TMS.Client.ClientList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Client/Proc/ClientList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ClientCorpNo").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#ClientName").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "ClientListExcel",
                    CenterCode: $("#CenterCode").val(),
                    UseFlag: $("#UseFlag").val(),
                    ClientType: $("#ClientType").val(),
                    ClientCorpNo: $("#ClientCorpNo").val(),
                    ClientName: $("#ClientName").val()
                };

                $.fileDownload("/TMS/Client/Proc/ClientHandler.ashx", {
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

        function fnAjaxSaveExcel(objData) {

            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }

            return;
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }

        function fnClosePopUpLayer() {
            fnCloseCpLayer();
            fnCallGridData(GridID);
        }

        function fnClientIns() {
            fnOpenRightSubLayer("고객사 등록", "/TMS/Client/Clientins", "1024px", "700px", "80%");
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
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="UseFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="ClientType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="ClientCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="사업자번호"/>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                <asp:DropDownList runat="server" ID="SaleLimitAmtFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="RevenueLimitPerFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <button type="button" runat="server" id="BtnListSearch" class="btn_01">조회</button>
            </div>  
            
            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" class="btn_01" onclick="fnClientIns();">고객사 등록</button>
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
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;&nbsp;
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('ClientListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('ClientListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="ClientListGrid"></div>
			<div id="page"></div>

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ClientName">고객사명</option>
                        <option value="ClientCeoName">대표자명</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('ClientListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('ClientListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('ClientListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
