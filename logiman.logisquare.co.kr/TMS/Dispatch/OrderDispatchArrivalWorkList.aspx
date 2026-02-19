<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDispatchArrivalWorkList.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchArrivalWorkList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchArrivalWorkList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ClientName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#ViewOrderLocationCode").val("");
                $("#OrderLocationCode input[type='checkbox']").prop("checked", false);
                $("#ClientName").val("");
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {
                var LocationCode = [];
                var ClientCodes = [];
                var ClientNames = [];
                var ChargeNames = [];
                var ChargeCells = [];
                var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
                var intValidType = 0;

                if ($("#CenterCode").val() === "") {
                    fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                    return false;
                }

                if (CheckedItems.length === 0) {
                    fnDefaultAlert("업체를 선택해주세요.", "warning");
                    return false;
                }

                $.each($("#OrderLocationCode input[type='checkbox']:checked"), function (i, el) {
                    if ($(el).val() != "") {
                        LocationCode.push($(el).val());
                    }
                });

                $.each(CheckedItems, function (index, item) {
                    if ($("#CenterCode").val() != item.item.CenterCode) {
                        intValidType = 1;
                        return false;
                    }

                    if (ClientCodes.findIndex((e) => e === item.item.ArrivalReportClientCode) === -1
                        || ChargeNames.findIndex((e) => e === item.item.ArrivalReportChargeName) === -1) {
                        ClientCodes.push(item.item.ArrivalReportClientCode);
                        ClientNames.push(item.item.ArrivalReportClientName);
                        ChargeNames.push(item.item.ArrivalReportChargeName);
                        ChargeCells.push(item.item.ArrivalReportChargeCell);
                    } 
                });

                if (intValidType === 1) {
                    fnDefaultAlertFocus("선택한 회원사와 조회 차량의 회원사가 서로 다릅니다.", "CenterCode", "warning");
                    return false;
                }

                var objParam = {
                    CallType: "OrderDispatchArrivalWorkListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    OrderLocationCodes: LocationCode.join(","),
                    OrderItemCodes: $("#OrderItemCodes").val(),
                    ClientCodes: ClientCodes.join(","),
                    ClientNames: ClientNames.join(","),
                    ChargeNames: ChargeNames.join(","),
                    ChargeCells: ChargeCells.join(",")
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
            return false;
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
                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                    </div>
                    <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>  

            <ul class="action">
                <li class="left">
                    
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">도보 작업지시서</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left" style="width:20%;">
                    <h1>업체목록</h1>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
                <li class="right" style="width:80%; text-align: left;">
                    <h1 style="margin-left: 3px;">운송내역</h1>
                    <ul class="drop_btn" style="float: right; margin-right: -3px;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage2('OrderDispatchArrivalWorkListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchArrivalWorkListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                    <div style="float: left; margin: 2px 0 0 5px;">
                        <strong id="GridResult2" style="display: inline-block;"></strong>
                        <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    </div>
                </li>
            </ul>
            <div class="grid_type_03">
                <div class="left" style="width:20%;">
                    <div id="OrderDispatchArrivalWorkClientListGrid"></div>
                </div>
                <div class="right" style="width:80%; position:relative;">
                    <div id="OrderDispatchArrivalWorkListGrid"></div>
                    <div id="page"></div>
                </div>
            </div>
            

            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="거래처 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ClientName">업체명</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
            
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog2" title="오더 검색">
                <a href="#" id="LinkGridSearchClose2" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField2" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="OrderClientName">발주처명</option>
                        <option value="PayClientName">청구처명</option>
                        <option value="ConsignorName">화주명</option>
                        <option value="OrderNo">오더번호</option>
                    </select>
                    <input type="text" id="GridSearchText2"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch2" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive2" type="checkbox" /><label for="ChkCaseSensitive2"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>

    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchArrivalWorkClientListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchArrivalWorkClientListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchArrivalWorkClientListGrid');">취소</button>
            </div>
        </div>
    </div>

    <div id="GRID_COLUMN_LAYER2">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck2" type="checkbox" onclick="fnColumnChkAll2('OrderDispatchArrivalWorkListGrid');" /><label for="AllGridColumnCheck2"><span></span></label> 항목관리</h1>
            <div id="GridColumn2"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout2('OrderDispatchArrivalWorkListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout2('OrderDispatchArrivalWorkListGrid');">취소</button>
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
