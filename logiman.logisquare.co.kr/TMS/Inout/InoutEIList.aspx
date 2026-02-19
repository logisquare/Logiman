<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InoutEIList.aspx.cs" Inherits="TMS.Inout.InoutEIList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Inout/Proc/InoutEIList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    $("#BtnListSearch").click();
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnSearchList();
                return false;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#DateType").val("1");
                $("#DateChoice").val("");
                $(".search_line > input[type=text]").val("");
                $("#DateFrom").datepicker("setDate", GetDateToday("-"));
                $("#DateTo").datepicker("setDate", GetDateToday("-"));
                $("#WorkOrderStatuses").val("");
                $("#ChkMyOrder").prop("checked", false);
                return false;
            });

            //상차완료
            $("#BtnActualPickup").on("click", function (e) {
                fnRegActualPickup();
                return false;
            });

            //하차완료
            $("#BtnActualDelivery").on("click", function (e) {
                fnRegActualDelivery();
                return false;
            });

            //POD등록
            $("#BtnPOD").on("click", function (e) {
                fnRegPOD();
                return false;
            });

            //Reject
            $("#BtnReject").on("click", function (e) {
                fnRegReject();
                return false;
            });

            //새로고침
            $("#BtnReset").on("click", function (e) {
                fnCallResetDetailData();
                return false;
            });

            //오더상세
            $("#BtnOpenOrder").on("click", function (e) {
                fnOpenOrder();
                return false;
            });

            //오더등록
            $("#BtnOpenOrderReg").on("click", function (e) {
                fnOpenOrderReg();
                return false;
            });
            /*
            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                var objParam = {
                    CallType: "InoutEIListExcel",
                    CenterCode: $("#CenterCode").val(),
                    DateType: $("#DateType").val(),
                    DateFrom: $("#DateFrom").val(),
                    DateTo: $("#DateTo").val(),
                    Plant: $("#Plant").val(),
                    LocationAlias: $("#LocationAlias").val(),
                    Shipper: $("#Shipper").val()
                };

                $.fileDownload("/TMS/Inout/Proc/InoutEIHandler.ashx", {
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
            */
        });

        /*
        function fnAjaxSaveExcel(objData) {
            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }
            return false;
        }
        */

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
        }
    </script>
    
    <style>
        .grid_wrap {margin-top:20px; display: flex; flex-direction: row; flex-grow: 1;}
        .grid_left {flex-grow: 1;}
        .grid_left .grid_list {margin-top:0px; height:100%;}
        .grid_right {width: 600px; flex-shrink: 0; display: flex; flex-direction: column; background :#ffffff; border: 1px solid #E1E6EA; padding:5px; margin-left:5px;}
        .grid_right h1 {font-weight: bold; font-size: 16px; border-left: 5px solid #5674C8; padding-left: 10px; line-height: 120%;}
        .grid_right .detail_wrap {flex-grow: 1;}
        .grid_right .detail_wrap > div {height: calc(100% - 5px); overflow-y: auto;}
        .grid_right .detail_wrap table td {font-size:12px; padding:3px; text-align:center;}
        .grid_right .detail_wrap table a {font-size:12px; font-weight:bold; color: #5674C8; }
        .grid_right .detail_wrap table th {font-size:12px; padding:3px; height:30px;}
        .grid_right .detail_wrap table th.point1 {color:#ffffff; background: #7490df; }
        .grid_right .detail_wrap table th.point2 {color:#ffffff; background: #405aa1; }
        .grid_right .detail_wrap table th.point3 {color:#ffffff; background: #666666; }
        
        .grid_right .equipment_wrap {height:200px;}
        .grid_right .stop_wrap {height:200px;}
        .grid_right .tbl_proc {display:none;}
        .grid_right .tbl_proc td {text-align:left !important;}

        .grid_right .TRHide {display:none;}

        /* 커스텀 셀 스타일 */
	    .my-cell-style {background: #5674c8;}
        .my-cell-style div { font-weight: 600; color: #fff;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateType" class="type_01" width="100"></asp:DropDownList>
                    <asp:DropDownList runat="server" ID="DateChoice" class="type_01" width="70"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" AutoPostBack="false" placeholder="날짜 From"/>
                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" AutoPostBack="false" placeholder="날짜 To"/>
                    <asp:DropDownList runat="server" ID="WorkOrderStatuses" class="type_01" width="140"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="CreatedBy" class="type_01" AutoPostBack="false" placeholder="CreatedBy"/>
                    <asp:TextBox runat="server" ID="WorkOrderNumber" class="type_01" AutoPostBack="false" placeholder="WorkOrderNumber"/>
                    <asp:TextBox runat="server" ID="MasterAirWayBillNumber" class="type_01" AutoPostBack="false" placeholder="MasterAirWayBillNumber"/>
                    <asp:TextBox runat="server" ID="HouseAirWayBillNumber" class="type_01" AutoPostBack="false" placeholder="HouseAirWayBillNumber"/>
                    &nbsp;&nbsp;<asp:CheckBox runat="server" id="ChkMyOrder" Text="<span></span>내오더"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>  
        </div>
        <div class="grid_wrap">
            <div class="grid_left">
                <div class="grid_list">
                    <ul class="grid_option">
                        <li class="left">
                            <h1>WorkOrder List</h1>
                            <strong id="GridResult" style="display: inline-block; margin-left:10px; line-height:29px;"></strong>
                            <strong id="GridDataInfo" style="line-height: 29px; font-weight: 500; color: #666666; "></strong>
                        </li>
                        <li class="right">
                            <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download" Visible="False">엑셀다운로드</button>
                            &nbsp;&nbsp;
                            <ul class="drop_btn" style="float:right;">
                                <li>
                                    <dl>
                                        <dt>항목 설정</dt>
                                        <dd>
                                            <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', 'EDI오더내역', 'EDI오더내역');">엑셀다운로드</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('InoutEIListGrid');">항목관리</asp:LinkButton>
                                            <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('InoutEIListGrid');">항목순서 초기화</asp:LinkButton>
                                        </dd>
                                    </dl>
                                </li>
                            </ul>
                        </li>
                    </ul>
                    <div id="InoutEIListGrid"></div>

                    <!-- 검색 다이얼로그 UI -->
                    <div id="gridDialog" title="Grid 검색">
                        <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                        <div>
                            <select id="GridSearchDataField" class="type_01">
                                <option value="ALL">전체</option>
                                <option value="OrderNo">오더번호</option>
                            </select>
                            <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                            <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                            <br/>
                            <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="grid_right">
                <div class="detail_wrap">
                    <div>
                        <div>
                            <asp:HiddenField runat="server" ID="HidWoSeqNo" />
                            <asp:HiddenField runat="server" ID="HidOrderNo" />
                            <asp:HiddenField runat="server" ID="HidCenterCode" />
                            <asp:HiddenField runat="server" ID="HidDispatchSeqNo" />
                            <asp:HiddenField runat="server" ID="HidWorkOrderNumber" />
                            <asp:HiddenField runat="server" ID="HidWorkOrderStatus" />
                            <asp:HiddenField runat="server" ID="HidActualPickupDT" />
                            <asp:HiddenField runat="server" ID="HidActualDeliveryDT" />
                            <asp:HiddenField runat="server" ID="HidEdiPickupYMD" />
                            <div style="line-height:28px;">
                                <h1 style="display:inline; width:130px;">WorkOrder</h1>
                                <button type="button" id="BtnReset" class="btn_02" style="float:right; display:none;">새로고침</button>
                                <button type="button" id="BtnOpenOrder" class="btn_01" style="float:right; margin-right:5px; display:none;">오더상세</button>
                                <button type="button" id="BtnOpenOrderReg" class="btn_01" style="float:right; margin-right:5px; display:none;">오더등록</button>
                            </div>
                            <table class="popup_table tbl_info" style="margin-top:5px;">
                                <colgroup>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th>오더번호</th>
                                        <td id="TDOrderNo"></td>
                                        <th>오더상태</th>
                                        <td id="TDOrderStatusM"></td>
                                    </tr>
                                    <tr>
                                        <th>WorkOrderNumber</th>
                                        <td id="TDWorkOrderNumber"></td>
                                        <th>연동오더상태</th>
                                        <td id="TDWorkOrderStatusM"></td>
                                    </tr>
                                    <tr>
                                        <th>M/AWB</th>
                                        <td id="TDMasterAirWayBillNumber"></td>
                                        <th>H/AWB</th>
                                        <td id="TDHouseAirWayBillNumber"></td>
                                    </tr>
                                    <tr id="TRPickup" class="TRHide">
                                        <th>상차지</th>
                                        <td id="TDPickupPlace"></td>
                                        <th>상차요청</th>
                                        <td id="TDPickupYMDHM"></td>
                                    </tr>
                                    <tr id="TRGet" class="TRHide">
                                        <th>하차지</th>
                                        <td id="TDGetPlace"></td>
                                        <th>하차요청</th>
                                        <td id="TDGetYMDHM"></td>
                                    </tr>
                                    <tr id="TRActualPickup" class="TRHide">
                                        <th>Actual Pickup</th>
                                        <td id="TDActualPickupDT" colspan="3"></td>
                                    </tr>
                                    <tr id="TRActualDelivery" class="TRHide">
                                        <th>Actual Delivery</th>
                                        <td id="TDActualDeliveryDT" colspan="3"></td>
                                    </tr>
                                    <tr id="TRPOD" class="TRHide">
                                        <th>Proof Of Delivery</th>
                                        <td id="TDPOD" colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>
                            <table class="popup_table tbl_proc" style="margin-top:5px;" id="TblActualPickup">
                                <colgroup>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th class="point1">상차완료</th>
                                        <td colspan="3">
                                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="ActualPickupYMD" readonly></asp:TextBox>
                                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="ActualPickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                                            <button type="button" id="BtnActualPickup" class="btn_01">등록</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <table class="popup_table tbl_proc" style="margin-top:5px;" id="TblActualDelivery">
                                <colgroup>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th class="point1">하차완료</th>
                                        <td colspan="3">
                                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="ActualDeliveryYMD" readonly></asp:TextBox>
                                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="ActualDeliveryHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                                            <button type="button" id="BtnActualDelivery" class="btn_01">등록</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <table class="popup_table tbl_proc" style="margin-top:5px;" id="TblPOD">
                                <colgroup>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th class="point2">POD</th>
                                        <td colspan="3">
                                            <input type="file" class="type_02" id="FileUpload"/>
                                            <button type="button" id="BtnPOD" class="btn_01">업로드</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <table class="popup_table tbl_proc" style="margin-top:5px;" id="TblReject">
                                <colgroup>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                    <col style="width:23%;"/>
                                    <col style="width:27%;"/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th class="point3">Reject</th>
                                        <td colspan="3">
                                            <asp:DropDownList runat="server" ID="RejectReasonCode" class="type_01" AutoPostBack="false" width="190"></asp:DropDownList>
                                            <button type="button" id="BtnReject" class="btn_03">취소</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="equipment_wrap">
                    <h1>Equipment List</h1>
                    <div id="InoutEIEquipmentListGrid" style="margin-top:5px;"></div>
                </div>
                <div class="stop_wrap">
                    <h1>Stop List</h1>
                    <div id="InoutEIStopListGrid" style="margin-top:5px;"></div>
                </div>
            </div>
        </div>
        
        <!--그리드 칼럼관리 팝업-->
        <div id="GRID_COLUMN_LAYER">
            <div class="grid_manage">
                <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('InoutEIListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
                <div id="GridColumn"></div>
                <div class="gird_button">
                    <button type="button" class="save" onclick="fnSaveColumnCustomLayout('InoutEIListGrid');">저장</button>
                    &nbsp;&nbsp;
                    <button type="button" class="cancel" onclick="fnCloseColumnLayout('InoutEIListGrid');">취소</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
