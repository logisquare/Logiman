var CarTonCodeList = null; //톤수 Select
var CarTypeCodeList = null; //차종 Select

$(window).on("load", function () {
    fnCarTonList();
    fnCarTypeList();
});

$(document).ready(function () {
    fnCarTonList();
    fnCarTypeList();
    $(document).keydown(function (e) {
        if (e.ctrlKey && e.keyCode == 49) {
            addRow();
            return false;
        }
        if (e.ctrlKey && e.keyCode == 50) {
            addCopyRow();
            return false;
        }
        if (e.ctrlKey && e.keyCode == 51) {
            removeRow();
            return false;
        }
        /*if (e.ctrlKey && e.keyCode == 52) {
            rateData();
            return false;
        }*/
        /*if (e.ctrlKey && e.keyCode == 53) {
            fnCallGridData();
            return false;
        }*/
    });

    $("#CenterCode").on("change", function () {
        $("#ClientName").val("");
        $("#ClientCode").val("");
        $("#ConsignorName").val("");
        $("#ConsignorCode").val("");
    });

    $("#ClientName").on("change", function () {
        //$("#ClientCode").val("");
    });

    $("#ConsignorName").on("change", function () {
        //$("#ConsignorCode").val("");
    });

    //---------------------------------------------------------------------------------
    //---- Export Excel 버튼 이벤트
    //---------------------------------------------------------------------------------
    $("#CarTruckExcelbtn").on("click", function () {
        var objParam = {
            CallType: "CarTruckExcel",
            CenterCode: $("#CenterCode").val()
        };

        $.fileDownload("/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx", {
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });

    $("#CarTonExcelbtn").on("click", function () {
        var objParam = {
            CallType: "CarTonExcel",
            CenterCode: $("#CenterCode").val()
        };

        $.fileDownload("/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx", {
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });

    $("#AddrExcelBtn").on("click", function () {
        var objParam = {
            CallType: "AddrListExcel"
        };

        $.fileDownload("/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx", {
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });

    //고객사명
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ClientList",
                    ClientName: request.term,
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ClientName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ClientName,
                getValue: (item) => item.ClientName,
                onSelect: (event, ui) => {
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }

    if ($("#ConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "ConsignorName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "ConsignorList",
                    ConsignorName: request.term,
                    UseFlag: "Y",
                    CenterCode: $("#CenterCode").val(),
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ConsignorName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.ConsignorInfo,
                getValue: (item) => item.ConsignorName,
                onSelect: (event, ui) => {
                    $("#ConsignorCode").val(ui.item.etc.ConsignorCode);
                    $("#ConsignorName").val(ui.item.etc.ConsignorName)
                }
            }
        });
    }

    $("#ClientCode").attr("readonly", true);
});

//==========================================
// 그리드
var GridID = "#ClientTransRateInsGrid";
var GridDataLength = 0;
var logCache = [];
var styleMap = {};
var recentAddrList = [];

$(document).ready(function () {
    if ($("#HidMode").val() === "Update") {
        fnCallGridData(); //요율표 호출

        $("#ClientName").attr("readonly", true);
        $("#ConsignorName").attr("readonly", true);
        $("#CenterCode option:not(:selected)").attr("disabled", true);
        $("#CenterCode").addClass("read");
        $("#RateType option:not(:selected)").attr("disabled", true);
        $("#RateType").addClass("read");
    } else {
        fnGetDatePicker();
        SetColumns();
    }

    // 사이즈 세팅
    var intHeight = $(document).height() - 210;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);
    });
});

function fnGetDatePicker() {
    $("#FromYMD").datepicker({
        changeMonth: true,
        changeYear: true,
        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        dateFormat: "yy-mm-dd"
    });
}


//기본 레이아웃 세팅
function CreateGridLayout(strGID) {

    var GridProps = {};

    GridProps.enableSorting = true;
    GridProps.enableMovingColumn = true;
    // 그룹핑 패널 사용	
    GridProps.useGroupingPanel = false;
    // No Data message;
    GridProps.noDataMessage = "";
    // 헤더 높이 지정
    GridProps.headerHeight = 38;
    //로우 높이 지정
    GridProps.rowHeight = 25;
    // singleRow 선택모드
    GridProps.selectionMode = "multipleCells";
    // 고정 칼럼 1개
    GridProps.fixedColumnCount = 2;
    // 푸터 보이게 설정
    GridProps.showFooter = false;
    // 줄번호 칼럼 렌더러 출력 안함
    GridProps.showRowNumColumn = true;
    // 체크박스 표시 렌더러 출력 안함
    GridProps.showRowCheckColumn = true;
    //필터 표시
    GridProps.enableFilter = true;
    GridProps.rowIdField = "SeqNo";
    GridProps.editable = true; // 수정 모드
    GridProps.showStateColumn = true;
    GridProps.softRemoveRowMode = true;
    GridProps.enableRestore = true;
    GridProps.showTooltip = true;
    GridProps.enableFocus = true;

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, GridProps);
};

/******************/
/* 이벤트 핸들러 */
/******************/
// READY 이벤트 핸들러
function GridReady(event) {
    GridDataLength = AUIGrid.getGridData(GridID).length; // 그리드 전체 행수 보관
}

//에디팅 이벤트 핸들러
function GridCellEditingHandler(event) {

    if (event.type == "cellEditBegin") {
        if (event.isClipboard && (event.columnIndex == 0 || event.columnIndex == 1 || event.columnIndex == 2))
            return false;
    } else if (event.type == "cellEditEnd") {
        var item = new Object();
        item.ValidationCheck = "미검증";

        if (event.dataField == "FromAddrSearch") {
            item.FromSido = "";
            item.FromGugun = "";
            item.FromDong = "";
            item.FromFullAddr = "";
            var addrItem = GetAddrItem(event.value);
            if (typeof addrItem !== "undefined") {
                if (addrItem.KKO_SIDO) {
                    item.FromSido = addrItem.KKO_SIDO;
                }
                if (addrItem.GUGUN) {
                    item.FromGugun = addrItem.GUGUN;
                }
                if (addrItem.DONG) {
                    item.FromDong = addrItem.DONG;
                }
                if (addrItem.KKO_FULLADDR) {
                    item.FromFullAddr = addrItem.KKO_FULLADDR;
                }
            }
        }

        if (event.dataField == "ToAddrSearch") {
            item.ToSido = "";
            item.ToGugun = "";
            item.ToDong = "";
            item.ToFullAddr = "";
            var addrItem = GetAddrItem(event.value);
            if (typeof addrItem !== "undefined") {
                if (addrItem.KKO_SIDO) {
                    item.ToSido = addrItem.KKO_SIDO;
                }
                if (addrItem.GUGUN) {
                    item.ToGugun = addrItem.GUGUN;
                }
                if (addrItem.DONG) {
                    item.ToDong = addrItem.DONG;
                }
                if (addrItem.KKO_FULLADDR) {
                    item.ToFullAddr = addrItem.KKO_FULLADDR;
                }
            }
        }

        AUIGrid.updateRow(GridID, item, event.rowIndex);

    } else if (event.type == "cellEditEndBefore") {
        var retStr = event.value;

        retStr = retStr.toString().replace(/\t/gi, "");
        retStr = retStr.toString().replace(/\n/gi, "");

        if (event.dataField == "CarTonCode") { //한글+숫자+.+영어
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9가-힣.a-zA-z]/gi, '');
            if (retStr == "") {
                retStr = "";
            }
        }

        if (event.dataField == "PurchaseUnitAmt" || event.dataField == "SaleUnitAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            retStr = retStr.toString().replace(/[^0-9,\-]/gi, '');
            if (retStr == "") {
                retStr = "0";
            }
        }
        return retStr;
    } else if (event.type == "pasteBegin") {

        if (!event.clipboardData) {
            return false;
        }

        var arr = [];
        if (AUIGrid.getSelectedIndex(event.pid)[0] < 0 && AUIGrid.getSelectedIndex(event.pid)[1] < 0) {
            fnDefaultAlert("행추가 or 셀선택 후 붙여넣을 수 있습니다.", "warning");
            return false;
        }
    }
};


// 기본 컬럼 세팅 
function fnGetDefaultColumnLayout() {
    var RateType = $("#RateType").val();

    var ColumnLayout = [

        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "SeqNo",
            headerText: "SeqNo",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "FromAreaCode",
            headerText: "출발지코드",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "ToAreaCode",
            headerText: "도착지코드",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "FromFullAddr",
            headerText: "출발지 전체주소",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "ToFullAddr",
            headerText: "도착지 전체주소",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "DelFlag",
            headerText: "삭제여부",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "CarTonCode",
            headerText: "차량톤수코드",
            width: 0,
            editable: false,
            visible: false
        }, {
            dataField: "CarTypeCode",
            headerText: "차량종류코드",
            width: 0,
            editable: false,
            visible: false
        },
        
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ValidationCheck",
            headerText: "상태 및 결과내용",
            width: 300,
            editable: false,
            filter: {
                showIcon: true
            }
        }, {
            dataField: "FromAddrSearch",
            headerText: "(상)주소검색",
            editable: true,
            width: 150,
            style: "aui-grid-my-column-left",
            editRenderer: {
                type: "RemoteListRenderer",
                showEditorBtn: true, // 마우스 오버 시 에디터버턴 보이기
                showEditorBtnOver: true, // 마우스 오버 시 에디터버턴 보이기
                fieldName: "ADDR", // remoter 에서 가져온 데이터 중 실제 그리드에 적용시킬 필드명 (단순 배열이 아닌 경우 반드시 지정해야 함.)
                listAlign: "left",
                remoter: function (request, response) { // remoter 지정 필수
                    recentAddrList = [];
                    $.ajax({
                        url: "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx",
                        type: 'POST',
                        cache: false,
                        dataType: "json",
                        data: "CallType=AddrList&AddrText=" + request.term,
                        beforeSend: function () {

                        },
                        success: function (data) {
                            if (data) {
                                if (data[0].TotalCount > 0) {
                                    recentAddrList = data[0].List;
                                    response(data[0].List);
                                } else {
                                    response(false);
                                    return;
                                }
                            } else {
                                response(false);
                                return;
                            }
                        },
                        error: function (xhr, status, error) {
                            //alert("데이터 전송 실패");
                            //alert(xhr.responseText);
                        }
                    });
                },
                listTemplateFunction: function (rowIndex, columnIndex, text, item, dataField, listItem) {
                    var html = '<div style="text-align:left;">' + listItem.ADDR + '</div>';
                    return html;
                }
            }
        }, {
            dataField: "FromSido",
            headerText: "(상)광역시,도",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "FromGugun",
            headerText: "(상)시, 군, 구",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "FromDong",
            headerText: "(상)읍, 동, 면",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "ToAddrSearch",
            headerText: "(하)주소검색",
            editable: true,
            width: 150,
            style: "aui-grid-my-column-left",
            editRenderer: {
                type: "RemoteListRenderer",
                showEditorBtn: true, // 마우스 오버 시 에디터버턴 보이기
                showEditorBtnOver: true, // 마우스 오버 시 에디터버턴 보이기
                fieldName: "ADDR", // remoter 에서 가져온 데이터 중 실제 그리드에 적용시킬 필드명 (단순 배열이 아닌 경우 반드시 지정해야 함.)
                listAlign: "left",
                remoter: function (request, response) { // remoter 지정 필수
                    recentAddrList = [];
                    $.ajax({
                        url: "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx",
                        type: 'POST',
                        cache: false,
                        dataType: "json",
                        data: "CallType=AddrList&AddrText=" + request.term,
                        beforeSend: function () {

                        },
                        success: function (data) {
                            if (data) {
                                if (data[0].TotalCount > 0) {
                                    recentAddrList = data[0].List;
                                    response(data[0].List);
                                } else {
                                    response(false);
                                    return;
                                }
                            } else {
                                response(false);
                                return;
                            }
                        },
                        error: function (xhr, status, error) {
                            //alert("데이터 전송 실패");
                            //alert(xhr.responseText);
                        }
                    });
                },
                listTemplateFunction: function (rowIndex, columnIndex, text, item, dataField, listItem) {
                    var html = '<div style="text-align:left;">' + listItem.ADDR + '</div>';
                    return html;
                }
            }
        }, {
            dataField: "ToSido",
            headerText: "(하)광역시, 도",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "ToGugun",
            headerText: "(하)시, 군, 구",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "ToDong",
            headerText: "(하)읍, 동, 면",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "CarTonCodeM",
            headerText: "차량톤수",
            editable: true,
            width: 100,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "";
                for (var i = 0, len = CarTonCodeList.length; i < len; i++) {
                    if (CarTonCodeList[i]["ItemName"] == value) {
                        retStr = CarTonCodeList[i]["ItemName"];
                        break;
                    }
                }
                return retStr == "" ? value : retStr;
            },
            editRenderer: {
                type: "DropDownListRenderer",
                list: CarTonCodeList, //key-value Object 로 구성된 리스트
                //keyField: "ItemFullCode", // key 에 해당되는 필드명
                keyField: "ItemName", // key 에 해당되는 필드명
                valueField: "ItemName" // value 에 해당되는 필드명
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "CarTypeCodeM",
            headerText: "차량종류",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var retStr = "";
                for (var i = 0, len = CarTypeCodeList.length; i < len; i++) {
                    if (CarTypeCodeList[i]["ItemName"] == value) {
                        retStr = CarTypeCodeList[i]["ItemName"];
                        break;
                    }
                }
                return retStr == "" ? value : retStr;
            },
            editRenderer: {

                type: "DropDownListRenderer",
                list: CarTypeCodeList, //key-value Object 로 구성된 리스트
                keyField: "ItemName", // key 에 해당되는 필드명
                valueField: "ItemName" // value 에 해당되는 필드명
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "SaleUnitAmt",
            headerText: "매출",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction
        }, {
            dataField: "PurchaseUnitAmt",
            headerText: "매입",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction
        }

        /*************/
    ];

    var columnObj = null;
    /*if (RateType == "1") {
        columnObj = { dataField: "CarTon", headerText: "차량 (t)", editable: true, width: 100, styleFunction: CellStyleFunction, filter: { showIcon: true } };
        ColumnLayout.splice(11, 0, columnObj);
        columnObj = { dataField: "CarType", headerText: "차종", editable: true, width: 100, styleFunction: CellStyleFunction, filter: { showIcon: true } };
        ColumnLayout.splice(12, 0, columnObj);

    } else if (RateType == "2") {
        columnObj = { dataField: "GOODS_VOLUME", headerText: "수량 (ea)", editable: true, width: 100, dataType: "numeric", style: "aui-grid-my-column-right", styleFunction: CellStyleFunction, filter: { showIcon: true } };
        ColumnLayout.splice(11, 0, columnObj);

    } else if (RateType == "3") {
        columnObj = { dataField: "GOODS_WEIGHT_FROM", headerText: "중량(kg)<br>~ 이상", editable: true, width: 100, dataType: "numeric", style: "aui-grid-my-column-right", styleFunction: CellStyleFunction, filter: { showIcon: true } };
        ColumnLayout.splice(11, 0, columnObj);
        columnObj = { dataField: "GOODS_WEIGHT_TO", headerText: "중량(kg)<br>~ 미만", editable: true, width: 100, dataType: "numeric", style: "aui-grid-my-column-right", styleFunction: CellStyleFunction, filter: { showIcon: true } };
        ColumnLayout.splice(12, 0, columnObj);
    }*/

    return ColumnLayout;
}

// 키 다운 핸들러
function GridKeyDown(e) {
    if (e.ctrlKey && e.keyCode == 49) {
        addRow();
        return false;
    }

    if (e.ctrlKey && e.keyCode == 50) {
        addCopyRow();
        return false;
    }

    if (e.ctrlKey && e.keyCode == 51) {
        removeRow();
        return false;
    }

    if (e.ctrlKey && e.keyCode == 52) {
        rateData();
        return false;
    }

    if (e.ctrlKey && e.keyCode == 53) {
        fnCallGridData();
        return false;
    }
}

function addRow() {
    var item = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    item.ValidationCheck = "미검증";
    AUIGrid.addRow(GridID, item, "last");
    AUIGrid.clearSelection(GridID);
    AUIGrid.setSelectionByIndex(GridID, AUIGrid.getRowCount(GridID) - 1, 3);
}

function addCopyRow() {
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    //item.ValidationCheck = "미검증";
    // AUIGrid.addRow(GridID, item, "last");
    if (AUIGrid.getCheckedRowItems(GridID).length <= 0) {
        fnDefaultAlert("복사할 행을 체크하세요.");
        return;
    } else {
        $.each(AUIGrid.getCheckedRowItems(GridID), function (index, item) {
            item.item.ValidationCheck = "미검증";
            item.item.SeqNo = null;
            //item.item.ID = null;

            if (!item.item.PurchaseUnitAmt) { item.item.PurchaseUnitAmt = "0" }
            if (!item.item.SaleUnitAmt) { item.item.SaleUnitAmt = "0" }
            AUIGrid.addRow(GridID, item.item, "last");
        });
        return;
    }
}


// 행 삭제
function removeRow() {
    if (AUIGrid.getCheckedRowItems(GridID).length <= 0) {
        fnDefaultAlert("삭제할 행을 체크하세요.");
        return;
    } else {
        $.each(AUIGrid.getCheckedRowItems(GridID), function (index, item) {
            AUIGrid.removeRowByRowId(GridID, item.item.SeqNo);
        });
        return;
    }
}

var timer;

var UpdRowsCnt = 0;
var UpdRowsCompleteCnt = 0;
var UpdRowsFailCnt = 0;
var UpdRows;

var DelRowsCnt = 0;
var DelRowsFailCnt = 0;
var DelRowsCompleteCnt = 0;
var DelRows;

var refreshChk = false;

function rateData() {
    
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("선택된 회원사가 없습니다.","CenterCode", "warning");
        return false;
    }

    if (!$("#FromYMD").val()) {
        fnDefaultAlertFocus("적용일을 선택해주세요.", "FromYMD", "warning");
        return false;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlertFocus("선택된 고객사가 없습니다.", "ClientName", "warning");
        return false;
    }

    if (!$("#RateType").val()) {
        fnDefaultAlertFocus("선택된 요율표가 없습니다.", "RateType", "warning");
        return false;
    }

    //추가했다가 삭제한 행 삭제
    $.each(AUIGrid.getRemovedNewItems(GridID), function (index, item) {
        AUIGrid.removeSoftRows(GridID, item.SeqNo);
    });

    if (!validationData()) {
        fnDefaultAlert("검증이 완료되지 않은 데이터가 있습니다.", "warning");
        AUIGrid.setSelectionByIndex(GridID, 2, 2);
        return false;
    }

    //삭제부터 처리
    DelRowsCnt = 0;
    DelRowsFailCnt = 0;
    DelRowsCompleteCnt = 0;
    UpdRowsCnt = 0;
    UpdRowsFailCnt = 0;
    UpdRowsCompleteCnt = 0;
    refreshChk = false;

    DelRows = AUIGrid.getRemovedItems(GridID);
    DelRowsCnt = DelRows.length;
    UpdRows = AUIGrid.getAddedRowItems(GridID).concat(AUIGrid.getEditedRowItems(GridID));
    for (i = 0; i < UpdRows.length; i++) {
        if (UpdRows[i].ValidationCheck !== "검증") {
            UpdRows.splice(i, 1);
        }
    }
    UpdRowsCnt = UpdRows.length;

    if ((UpdRowsCnt + DelRowsCnt) <= 0) {
        fnDefaultAlert("등록할 내역이 없습니다.", "warning");
        return false;
    }

    if (DelRowsCnt > 0) {
        timer = setTimeout(function () {
            clearTimeout(timer);
            fnDefaultConfirm("요율표를 삭제하시겠습니까?", "fnRateDataRegDelProc", "");
        }, 50);
    } else {
        timer = setTimeout(function () {
            clearTimeout(timer);
            fnDefaultConfirm("요율표를 저장하시겠습니까?", "fnRateDataRegUpdProc", "");
        }, 50);
    }
}

function fnRateDataRegUpdProc() {
    var strCallType = "";

    if (UpdRowsCnt <= 0) {
        if (UpdRowsFailCnt > 0) {
            fnDefaultAlert("운임이 등록되었습니다.<br>▶ 등록+수정 : " + UpdRowsCompleteCnt + "건 (실패 : " + UpdRowsFailCnt + "건)<br>▶ 삭제 : " + DelRowsCompleteCnt + "건 (실패 : " + DelRowsFailCnt + "건)", "warning", "", "");
            AUIGrid.setSelectionByIndex(GridID, 2, 2);
        } else {
            fnDefaultAlert("운임이 등록되었습니다.<br>▶ 등록+수정 : " + UpdRowsCompleteCnt + "건 (실패 : " + UpdRowsFailCnt + "건)<br>▶ 삭제 : " + DelRowsCompleteCnt + "건 (실패 : " + DelRowsFailCnt + "건)", "warning", "fnCompleteCall", "");
        }
        
        $("#divLoadingImage").hide();
        return;
    }

    var rowItem = AUIGrid.getItemByRowId(GridID, UpdRows[UpdRowsCnt - 1].SeqNo);
    if (isNaN(rowItem.SeqNo)) {
        strCallType = "TransRateItemIns";
    } else {
        if (rowItem.SeqNo != null && rowItem.SeqNo != 0 && rowItem.SeqNo != "") {
            strCallType = "TransRateItemUpd";
        }
    }
    
    rowItem.CallType        = strCallType
    rowItem.CenterCode      = $("#CenterCode").val();
    rowItem.ClientCode      = $("#ClientCode").val();
    rowItem.ConsignorCode   = $("#ConsignorCode").val();
    rowItem.RateType        = $("#RateType").val();
    rowItem.FromYMD         = $("#FromYMD").val().replace(/-/gi, "");
    for (var v = 0, len = CarTonCodeList.length; v < len; v++) {
        if (CarTonCodeList[v]["ItemName"] === rowItem.CarTonCodeM) {
            rowItem.CarTonCode = CarTonCodeList[v]["ItemFullCode"]
        }
    }
    for (var v = 0, len = CarTypeCodeList.length; v < len; v++) {
        if (CarTypeCodeList[v]["ItemName"] === rowItem.CarTypeCodeM) {
            rowItem.CarTypeCode = CarTypeCodeList[v]["ItemFullCode"];
        }
    }
    if (rowItem) {
        var strHandlerURL   = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
        var strCallBackFunc = "fnAjaxInsClientTransRate";
        var strFailFunc     = "fnAjaxFailClientTransRate";
        var strCompleteFunc = "fnAjaxCompleteClientTransRate";

        UTILJS.Ajax.fnHandlerRequest(rowItem, strHandlerURL, strCallBackFunc, true, strFailFunc, strCompleteFunc, true);
    }
}

function fnAjaxInsClientTransRate(data) {
    $("#divLoadingImage").hide();
    var rowItem = AUIGrid.getItemByRowId(GridID, UpdRows[UpdRowsCnt - 1].SeqNo);
    if (data) {
        $.map(data, function (item) {
            if (item.RetCode != 0) { //실패한경우
                UpdRowsFailCnt++;
                rowItem.ValidationCheck = "실패 [사유 : " + item.ErrMsg + "]";
                AUIGrid.updateRowsById(GridID, rowItem, false);
            } else {
                UpdRowsCompleteCnt++;
                rowItem.ValidationCheck = "처리";
                $("#CenterCode").prop("disabled", "disabled");
                $("#ClientName").prop("readonly", "readonly");
                $("#RateType").prop("disabled", "disabled");
                refreshChk = true;
                rowItem.SeqNo = item.SeqNo;
                AUIGrid.updateRowsById(GridID, rowItem, false);
                AUIGrid.resetUpdatedItems(GridID, "c");
            }
        });
    } else {
        UpdRowsFailCnt++;
    }
}

function fnAjaxFailClientTransRate(data) {
    UpdRowsCnt--;
    UpdRowsFailCnt++;
    fnRateDataRegUpdProc();
}

function fnAjaxCompleteClientTransRate(data) {
    UpdRowsCnt--;
    fnRateDataRegUpdProc();
}

function fnRateDataRegDelProc() {
    if (DelRowsCnt <= 0) {
        fnRateDataRegUpdProc();
        return;
    }

    var rowItem = AUIGrid.getItemByRowId(GridID, DelRows[DelRowsCnt - 1].SeqNo);
    rowItem.CallType        = "TransRateItemUpd"
    rowItem.CenterCode      = $("#CenterCode").val();
    rowItem.ClientCode      = $("#ClientCode").val();
    rowItem.ConsignorCode   = $("#ConsignorCode").val();
    rowItem.RateType        = $("#RateType").val();
    rowItem.FromYMD         = $("#FromYMD").val().replace(/-/gi, "");
    rowItem.DelFlag = "Y";
    if (rowItem) {
        var strHandlerURL   = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
        var strCallBackFunc = "fnAjaxDelClientTransRate";
        var strFailFunc     = "fnAjaxFailDelClientTransRate";
        var strCompleteFunc = "fnAjaxCompleteDelClientTransRate";

        UTILJS.Ajax.fnHandlerRequest(rowItem, strHandlerURL, strCallBackFunc, true, strFailFunc, strCompleteFunc, true);
    }
}

function fnAjaxDelClientTransRate(data) {
    var rowItem = AUIGrid.getItemByRowId(GridID, DelRows[DelRowsCnt - 1].SeqNo);
    if (data) {
        $.map(data, function (item) {
            if (item.RetCode != 0) { //실패한경우
                DelRowsFailCnt++;
                rowItem.ValidationCheck = "실패 [사유 : " + item.ErrMsg + "]";
                AUIGrid.updateRowsById(GridID, rowItem, false);
            } else {
                DelRowsCompleteCnt++;
                rowItem.ValidationCheck = "처리";
                AUIGrid.updateRowsById(GridID, rowItem, false);
                AUIGrid.resetUpdatedItems(GridID, "c");
            }
        });
    } else {
        DelRowsFailCnt++;
    }
}

function fnAjaxFailDelClientTransRate(data) {
    DelRowsCnt--;
    DelRowsFailCnt++;
    fnRateDataRegDelProc();
}

function fnAjaxCompleteDelClientTransRate(data) {
    DelRowsCnt--;
    fnRateDataRegDelProc();
}

function validationData() {
    var chk = false;
    var subChkCnt = 0;
    var rowIndex = 0;
    var gridData = AUIGrid.getGridData(GridID);
    var CarTonResult = "N";
    var CarTypeResult = "N";
    // 원하는 결과로 필터링
    var items = gridData.filter(function (v) {
        if ((String(v.ValidationCheck).indexOf("미검증") !== -1)) return true; // 1010 포함된 행만 추리기
        return false;
    });

    var msg = "";
    styleMap = {};
    
    for (i = 0; i < items.length; i++) {
        subChkCnt = 0;
        msg = "";
        rowIndex = AUIGrid.rowIdToIndex(GridID, items[i].SeqNo);

        if (!(items[i].FromSido && items[i].FromSido.replace(/ /gi, "") != "")) {
            subChkCnt++;
            changeStyleFunction(rowIndex, "FromSido");
            msg += msg === "" ? "상차지(시,도) 정보가 없습니다." : " / " + "상차지(시,도) 정보가 없습니다.";
        }

        if (!(items[i].ToSido && items[i].ToSido.replace(/ /gi, "") != "")) {
            subChkCnt++;
            changeStyleFunction(rowIndex, "ToSido");
            msg += msg === "" ? "하차지(시,도) 정보가 없습니다." : " / " + "하차지(시,도) 정보가 없습니다.";
        }

        if ($("#RateType").val() == "1") { //차량
            var ton = items[i].CarTonCodeM;
            if (!typeof ton == "undefined" || ton == null) { ton = ""; }
            ton = ton.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (ton == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "CarTonCodeM");
                msg += msg === "" ? "차량톤수 정보가 없습니다." : " / " + "차량톤수 정보가 없습니다.";
            } else {
                for (var v = 0, len = CarTonCodeList.length; v < len; v++) {
                    if (CarTonCodeList[v]["ItemName"] !== ton) {
                        changeStyleFunction(rowIndex, "CarTonCodeM");
                    } else {
                        CarTonResult = "Y"
                    }
                }
                
                if (CarTonResult === "N") {
                    subChkCnt++;
                    msg += msg === "" ? "잘못 된 차량톤수입니다.." : " / " + "잘못 된 차량톤수입니다.";
                }
            }

            var CarType = items[i].CarTypeCodeM;
            if (!typeof CarType == "undefined" || CarType == null) { CarType = ""; }
            CarType = CarType.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (CarType == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "CarTypeCodeM");
                msg += msg === "" ? "차량종류 정보가 없습니다." : " / " + "차량종류 정보가 없습니다.";
            } else {
                for (var v = 0, len = CarTypeCodeList.length; v < len; v++) {
                    if (CarTypeCodeList[v]["ItemName"] !== CarType) {
                        changeStyleFunction(rowIndex, "CarTypeCodeM");
                    } else {
                        
                        CarTypeResult = "Y"
                    }
                }

                if (CarTypeResult === "N") {
                    subChkCnt++;
                    msg += msg === "" ? "잘못 된 차량종류입니다.." : " / " + "잘못 된 차량종류입니다..";
                }
            }
        }

        var sale = items[i].SaleUnitAmt;
        if (typeof sale == "undefined" || sale == null) { sale = ""; }
        sale = sale.toString().replace(/ /gi, "").replace(/,/gi, "");

        if (sale == "") {
            subChkCnt++;
            changeStyleFunction(rowIndex, "SaleUnitAmt");
            msg += msg === "" ? "매출 정보가 없습니다." : " / " + "매출 정보가 없습니다.";
        }

        var purchase = items[i].PurchaseUnitAmt;
        if (typeof purchase == "undefined" || purchase == null) { purchase = ""; }
        purchase = purchase.toString().replace(/ /gi, "").replace(/,/gi, "");
        if (purchase == "") {
            subChkCnt++;
            changeStyleFunction(rowIndex, "PurchaseUnitAmt");
            msg += msg === "" ? "매입 정보가 없습니다." : " / " + "매입 정보가 없습니다.";
        }

        if (subChkCnt == 0) {
            msg = "검증";
        } else {
            msg = "미검증 : " + msg;
        }

        items[i].ValidationCheck = msg;
        AUIGrid.updateRowsById(GridID, items[i]);
    }

    AUIGrid.update(GridID);

    if (AUIGrid.getItemsByValue(GridID, "ValidationCheck", "검증").length == AUIGrid.getRowCount(GridID)) {
        chk = true;
    }

    AUIGrid.removeAjaxLoader(GridID);
    return chk;
}


function changeStyleFunction(rowIndex, datafield) {
    var key = rowIndex + "-" + datafield;
    styleMap[key] = "my-column-style";
};

// 셀 스타일 함수
function CellStyleFunction(rowIndex, columnIndex, value, headerText, item, dataField) {
    var key = rowIndex + "-" + dataField;
    if (typeof styleMap[key] != "undefined") {
        return styleMap[key];
    }
    return null;
};

function GetAddrItem(ADDR) {
    var item;
    $.each(recentAddrList, function (n, v) {
        if (v.ADDR == ADDR) {
            item = v;
            return false;
        }
    });
    return item;
};

function fnCallGridData() {
    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";
    if ($("#HidMode").val() === "Insert") {
        AUIGrid.setGridData(GridID, []);
        return;
    }
    var objParam = {
        CallType: "ClientTransRateList",
        CenterCode: $("#CenterCode").val(),
        ClientCode: $("#ClientCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        FromYMD: $("#FromYMD").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnGridSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }
        SetColumns();
        // 그리드 정렬
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);
        return false;
    }
}

function SetColumns() {
    AUIGrid.destroy(GridID);
    // 그리드 레이아웃 생성
    CreateGridLayout(GridID);

    // 이벤트 바인딩 
    fnSetGridEvent(GridID, "GridReady", "", "", "", "", "", "GridKeyDown");

    //에디팅 이벤트
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "pasteBegin"], GridCellEditingHandler);

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
    });
}


/*요청톤급 받아오기*/
function fnCarTonList() {

    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnCarTonSuccResult";

    var objParam = {
        CallType : "ItemCodeList",
        CodeType : "CB"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCarTonSuccResult(objRes) {
    
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CarTonCodeList = objRes[0].LocationCode;
        } else {
            CarTonCodeList = null;
        }
    }
}

/*차량종류 받아오기*/
function fnCarTypeList() {

    var strHandlerURL = "/TMS/ClientTransRate/Proc/ClientTransRateHandler.ashx";
    var strCallBackFunc = "fnCarTypeSuccResult";

    var objParam = {
        CallType: "ItemCodeList",
        CodeType: "CA"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnCarTypeSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            CarTypeCodeList = objRes[0].LocationCode;
        } else {
            CarTypeCodeList = null;
        }
    }
}

function fnCompleteCall() {
    if ($("#HidMode").val() === "Update") {
        fnCallGridData();
    } else {
        var Param = "";
        Param = "HidMode=Update";
        Param += "&ParamCenterCode=" + $("#CenterCode").val();
        Param += "&ParamClientCode=" + $("#ClientCode").val();
        Param += "&ParamClientName=" + $("#ClientName").val();
        Param += "&ParamConsignorCode=" + $("#ConsignorCode").val();
        Param += "&ParamConsignorName=" + $("#ConsignorName").val();
        Param += "&ParamFromYMD=" + $("#FromYMD").val().replace(/-/gi, "");;
        Param += "&ParamRateType=" + $("#RateType").val();

        document.location.replace("/TMS/ClientTransRate/ClientTransRateIns?" + Param);
    }
    return;
}