<%@ Page Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDispatchArrivalList.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchArrivalList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Dispatch/Proc/OrderDispatchArrivalList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ListSearch").on("keydown", function(event) {
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
                var LocationCode = [];

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                var objParam = {
                    CallType: "OrderDispatchListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: $("#OrderItemCodes").val(),
                    SearchClientType: $("#SearchClientType").val(),
                    SearchClientText: $("#SearchClientText").val(),
                    CarNo: $("#CarNo").val(),
                    DispatchAdminName: $("#DispatchAdminName").val(),
                    ArrivalReportClientName: $("#ComName").val(),
                    GetStandardType: $("#GetStandardType").val(),
                    OrderByPageType: 1
                };

                $.fileDownload("/TMS/Dispatch/Proc/OrderDispatchArrivalHandler.ashx", {
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

        function fnOrderDispatchArrival() {
            window.open("/TMS/Dispatch/OrderDispatchArrivalIns", "도착보고 비용등록", "width=1620, height=850px, scrollbars=Yes");
            return;
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="ClientCode" />
    <asp:HiddenField runat="server" ID="ChargeSeqNo" />
    <asp:HiddenField runat="server" ID="ClientCenterCode" />
    <asp:HiddenField runat="server" ID="HidFileCenterCode" />
    <asp:HiddenField runat="server" ID="HidFileOrderNo" />
    <asp:HiddenField runat="server" ID="OrderItemCodes" />
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:DropDownList runat="server" ID="GetStandardType" class="type_01" AutoPostBack="false" Width="110"></asp:DropDownList>
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:DropDownList runat="server" ID="SearchClientType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchClientText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    <asp:TextBox runat="server" ID="CarNo" class="type_01" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DispatchAdminName" class="type_01" AutoPostBack="false" placeholder="배차자"/>
                </div>
                <div>
                    <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;
                    <asp:CheckBox runat="server" id="ChkFilter" Text="<span></span>필터유지" Checked="False"/>
                </div>
            </div>  
            <div class="search" style="margin-top:10px;">
                <ul class="action" style="padding:0px; overflow:hidden;">
                    <li class="left">
                        <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 ml_0 find" placeholder="업체명 검색"></asp:TextBox>
                        <asp:TextBox runat="server" ID="ChargeName" CssClass="type_01 ml_0 find" placeholder="업체 담당자명 검색"></asp:TextBox>
                        <asp:TextBox runat="server" ID="ArrivalReportNo" CssClass="type_01 ml_0" placeholder="입고 번호"></asp:TextBox>
                        <button type="button" id="BtnClientNameReset" class="btn_03" style="display:none;">다시입력</button>
                        &nbsp;&nbsp;
                        <button type="button" runat="server" class="btn_02" onclick="fnArrivalInsConfirm('N');">도착보고 등록</button>
                        <button type="button" runat="server" class="btn_03" onclick="fnArrivalInsConfirm('Y');">도착보고 취소</button>
                        &nbsp;&nbsp;
                        <button type="button" runat="server" class="btn_02" onclick="fnArrivalDocumentConfirm('Y');">서류등록</button>
                        <button type="button" runat="server" class="btn_03" onclick="fnArrivalDocumentConfirm('N');">서류취소</button>
                    </li>
                    <li class="right">
                        <button type="button" runat="server" class="btn_01" onclick="fnOrderDispatchArrival();">비용등록</button>
                        <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운</button>
                    </li>
                </ul>
            </div>
            <p class="Client_info" style="margin-top:10px;"></p>
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
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchArrivalListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchArrivalListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="OrderDispatchArrivalListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchArrivalListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchArrivalListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchArrivalListGrid');">취소</button>
            </div>
        </div>
    </div>
    
    <!--파일다운로드 레이어-->
    <div id="FileDownLoadLayer">
        <div class="file_area">
            <a href="javascript:fnCloseFileDown();" class="close_btn"><img src="/images/icon/notice_close.png"/></a>
            <h1>첨부파일<span>(파일명을 클릭하시면 다운로드 됩니다.)</span></h1>
            <!-- DISPLAY LIST START -->
            <div style="width: 100%;">
                <ul id="UlFileList">
                </ul>
            </div>
            <!-- DISPLAY LIST END -->
        </div>
    </div>
    
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
