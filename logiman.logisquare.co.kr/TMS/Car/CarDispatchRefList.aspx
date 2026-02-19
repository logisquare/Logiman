<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarDispatchRefList.aspx.cs" Inherits="TMS.Car.CarDispatchRefList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Car/Proc/CarDispatchRefList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search input[type='text']").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function (event) {
                fnMoveToPage(1);
                return false;
            });


            $("#BtnResetListSearch").on("click", function () {
                $(".search input[type='text']").val("");
                $("#UseFlag").val("");
                $("#CarDivType").val("");
                $("#CooperatorFlag").prop("checked", false);
                $("#CargoManFlag").prop("checked", false);
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var objParam = {
                    CallType: "CarDispatchExcelList",
                    CenterCode: $("#CenterCode").val(),
                    UseFlag: $("#UseFlag").val(),
                    ComName: $("#ComName").val(),
                    ComCorpNo: $("#ComCorpNo").val(),
                    CarDivType: $("#CarDivType").val(),
                    DriverName: $("#DriverName").val(),
                    DriverCell: $("#DriverCell").val(),
                    CarNo: $("#CarNo").val(),
                    CooperatorFlag: $("#CooperatorFlag").is(":checked") ? "Y" : "",
                    CargoManFlag: $("#CargoManFlag").is(":checked") ? "Y" : ""
                };

                $.fileDownload("/TMS/Car/Proc/CarDispatchRefListHandler.ashx", {
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
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }

        function fnCarIns() {
            fnOpenRightSubLayer("차량업체 통합등록", "/TMS/Car/CarDispatchRefins?HidMode=Insert", "1024px", "700px", "80%");
        }

        function fnCarDispatchPartnerList() {
            fnOpenRightSubLayer("협력업체 등록현황", "/TMS/Car/CarDispatchCooperatorList", "1024px", "700px", "70%");
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
                <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                <asp:TextBox runat="server" ID="ComCorpNo" class="type_01 OnlyNumber" AutoPostBack="false" placeholder="사업자번호"/>
                <asp:DropDownList runat="server" ID="CarDivType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                <asp:TextBox runat="server" ID="DriverName" class="type_01" AutoPostBack="false" placeholder="기사명"/>
                <asp:TextBox runat="server" ID="DriverCell" class="type_01" AutoPostBack="false" placeholder="기사 휴대폰"/>
                <asp:CheckBox runat="server" ID="CooperatorFlag" Text="<span></span> 협력업체"/>
                &nbsp;&nbsp;
                <asp:CheckBox runat="server" ID="CargoManFlag" Text="<span></span> 카고맨"/>
                &nbsp;&nbsp;
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
            </div>  

            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" class="btn_01" onclick="fnCarIns();">통합등록</button>
                    <button type="button" runat="server" class="btn_03" onclick="fnCarDispatchPartnerList();">협력업체 등록현황</button>
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
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('CarDispatchListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('CarDispatchListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="CarDispatchListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('CarDispatchListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('CarDispatchListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('CarDispatchListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
