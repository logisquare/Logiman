<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TransRateApplyList.aspx.cs" Inherits="TMS.TransRate.TransRateApplyList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateApplyList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search input[type='text']").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return false;
                }
            });

            $("#BtnTransRateReg").on("click", function () {
                fnTransRatePopup();
                return false;
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $(".search input[type='text']").val("");
                $("#OrderItemCode").val("");
                $("#OrderLocationCode").val("");
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "TransRateApplyListExcel",
                    CenterCode: $("#CenterCode").val(),
                    ClientName: $("#ClientName").val(),
                    ConsignorName: $("#ConsignorName").val(),
                    OrderItemCode: $("#OrderItemCode").val(),
                    OrderLocationCode: $("#OrderLocationCode").val(),
                    DelFlag: "N"
                };

                $.fileDownload("/TMS/TransRate/Proc/TransRateApplyHandler.ashx", {
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
                        console.log(url);
                        console.log(html);
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
            return false;
        }

        function fnReloadPageNotice(strMsg, strMode) {
            fnCloseCpLayer();

            strMsg = typeof strMsg !== "string" ? "" : strMsg;
            strMode = typeof strMode !== "string" ? "" : strMode;

            if (strMsg !== "") {
                strMode = strMode === "" ?  "success" : strMode;
                fnDefaultAlert(strMsg, strMode);
            }

            return false;
        }

        function fnTransRatePopup() {
            fnOpenRightSubLayer("요율표 적용관리 등록", "/TMS/TransRate/TransRateApplyIns?HidMode=Insert", "1024px", "700px", "90%");
            return false;
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="GradeCode" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="고객사명"/>
                <asp:TextBox runat="server" ID="ConsignorName" class="type_01" AutoPostBack="false" placeholder="화주명"/>
                <asp:DropDownList runat="server" ID="OrderItemCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="OrderLocationCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                &nbsp;&nbsp;
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                <button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
            </div>  

            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" ID="BtnTransRateReg" class="btn_01">적용 등록</button>
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
                    <ul class="drop_btn" style="float:right;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('TransRateApplyListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('TransRateApplyListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="TransRateApplyListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('TransRateApplyListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('TransRateApplyListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('TransRateApplyListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
