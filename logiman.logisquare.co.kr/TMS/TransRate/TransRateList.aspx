<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TransRateList.aspx.cs" Inherits="TMS.TransRate.TransRateList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#SearchText").on("keydown", function(event) {
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
                var checkItems = AUIGrid.getCheckedRowItems(GridID);
                if (checkItems.length === 0) {
                    fnDefaultAlert("리스트를 선택해주세요.");
                    return;
                }

                var TransSeqNo = checkItems[0].item.TransSeqNo;
                var CenterCode = checkItems[0].item.CenterCode;
                var RateRegKind = checkItems[0].item.RateRegKind;
                var RateType = checkItems[0].item.RateType;

                if (checkItems.length > 1) {
                    fnDefaultAlert("내역은 1개씩만 다운로드 가능합니다.");
                    return;
                }
                
                var objParam = {
                    CallType: "TransRateDtlListExcel",
                    TransSeqNo: TransSeqNo,
                    CenterCode: CenterCode,
                    RateRegKind: RateRegKind,
                    RateType: RateType,
                    GoodsRunType: "0",
                    DelFlag: "N"
                };

                $.fileDownload("/TMS/TransRate/Proc/TransRateHandler.ashx", {
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
            return;
        }

        function fnReloadPageNotice(strMsg) {
            fnCloseCpLayer();
            fnCallGridData(GridID);
            fnDefaultAlert(strMsg, "success");
        }

        function fnTransRatePopup() {
            fnOpenRightSubLayer("요율표 등록", "/TMS/TransRate/TransRateIns?HidMode=Insert&RateRegKind=" + $("#RateRegKind").val(), "1024px", "700px", "90%");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="RateRegKind" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="RateType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="FTLFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="TransRateName" class="type_01" AutoPostBack="false" placeholder="요율표명"/>
                <asp:DropDownList runat="server" ID="DelFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  

            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" id="BtnTransRateIns" class="btn_01" onclick="fnTransRatePopup();">요율표 등록</button>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">요율표 다운로드</button>
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
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('TransRateListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('TransRateListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="TransRateListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('TransRateListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('TransRateListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('TransRateListGrid');">취소</button>
            </div>
        </div>
    </div>
    
    <!--적용 고객사 현황 레이어-->
    <div id="TranseRateClientLayer">
        <div>
            <h1>적용 고객사 현황</h1>
            <a href="#" onclick="fnCloseClientLayer(); return false;" class="close_btn">x</a>
            <div class="btnWrap">
                <button type="button" class="btn_03" onclick="fnCloseClientLayer(); return false;">닫기</button>
            </div>
            <div class="gridLayerWrap" style="margin-top: 30px;">
                <asp:HiddenField runat="server" ID="TransSeqNo"/>
                <div id="TransRateApplyClientListGrid"></div>
            </div>
        </div>
    </div>
    
</asp:Content>
