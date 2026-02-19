<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDispatchCollectWorkList.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchCollectWorkList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchCollectWorkList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ListSearch").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnCallGridDataSub(SubGridID);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridDataSub(SubGridID);
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var CarNo = [];
                var LocationCode = [];
                var ItemCode = [];
                var CheckedItems = AUIGrid.getCheckedRowItems(SubGridID);
                var intValidType = 0;

                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                    return
                }

                if (CheckedItems.length === 0) {
                    fnDefaultAlert("차량을 선택해주세요.", "warning");
                    return false;
                }

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                $.each($("#OrderItemCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        ItemCode.push($(el).val());
                    }
                });

                $.each(CheckedItems, function (index, item) {
                    if ($("#CenterCode").val() != item.item.CenterCode) {
                        intValidType = 1;
                        return false;
                    }
                    CarNo.push(item.item.CarNo);
                });

                if (intValidType === 1) {
                    fnDefaultAlertFocus("선택한 회원사와 조회 차량의 회원사가 서로 다릅니다.", "CenterCode", "warning");
                    return false;
                }
                
                var objParam = {
                    CallType: "OrderDispatchCollectWorkListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    CarNo: CarNo.join(","),
                    DispatchType: "3",
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: ItemCode.join(","),
                    ComName: $("#ComName").val(),
                    PageNo: $("#PageNo").val(),
                    PageSize: $("#PageSize").val()
                };

                $.fileDownload("/TMS/Dispatch/Proc/OrderDispatchCollectHandler.ashx", {
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
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="ClientCode" />
    <asp:HiddenField runat="server" ID="HidFileCenterCode" />
    <asp:HiddenField runat="server" ID="HidFileOrderNo" />
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_small" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                    <div id="DivOrderItemCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" ID="CarNo" class="type_small" AutoPostBack="false" placeholder="차량번호"/>
                    <asp:TextBox runat="server" ID="DispatchAdminName" class="type_small" AutoPostBack="false" placeholder="배차자"/>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                    
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">작업지시서 엑셀다운</button>
                    <ul class="drop_btn" style="margin-left:15px;">
						<li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchCollectWorkListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchCollectWorkListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <div class="grid_type_01">
                <div class="left" style="width:15%;">
                    <div id="OrderDispatchCollectWorkCarListGrid"></div>
                </div>
                <div class="right" style="width:85%;">
                    <div id="OrderDispatchCollectWorkListGrid"></div>
                    <div id="page"></div>
                </div>
            </div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchCollectWorkListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchCollectWorkListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchCollectWorkListGrid');">취소</button>
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
