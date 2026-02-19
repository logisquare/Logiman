var CarTonCodeList = null; //톤수 Select
var CarTypeCodeList = null; //차종 Select
var FullAddrList = []; //차종 Select
var GoodsRunTypeList = [{ "value": "1", "name": "편도" }, { "value": "2", "name": "왕복" }, { "value": "3", "name": "기타" }];

$(window).on("load", function () {
    fnCarTonList();
    fnCarTypeList();
});
$(document).ready(function () {
    fnCarTonList();
    fnCarTypeList();
    fnAddrList();
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
    });

    if (Number($("#RateRegKind").val()) >= 4) {
        $("#FTLFlag").hide();
    }

    if ($("#HidMode").val() === "Update") {
        parent.$("#hid_LAYER_TITLE").val("요율표 수정");
    }

    //---------------------------------------------------------------------------------
    //---- Export Excel 버튼 이벤트
    //---------------------------------------------------------------------------------
    $("#CarTruckExcelbtn").on("click", function () {
        var objParam = {
            CallType: "CarTruckExcel",
            CenterCode: $("#CenterCode").val()
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });

    $("#CarTonExcelbtn").on("click", function () {
        var objParam = {
            CallType: "CarTonExcel",
            CenterCode: $("#CenterCode").val()
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });

    $("#AddrExcelBtn").on("click", function () {
        var objParam = {
            CallType: "AddrListExcel"
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
                fnDefaultAlert("나중에 다시 시도해 주세요.", "warning");
            }
        });
    });
});

//==========================================
// 그리드
var GridID = "#TransRateInsGrid";
var GridDataLength = 0;
var logCache = [];
var styleMap = {};
var recentAddrList = [];

$(document).ready(function () {
    if ($("#HidMode").val() === "Update") {
        fnCallGridData(); //요율표 호출
        $("#CenterCode option:not(:selected)").attr("disabled", true);
        $("#CenterCode").addClass("read");
        $("#RateType option:not(:selected)").attr("disabled", true);
        $("#RateType").addClass("read");
        $("#FTLFlag option:not(:selected)").attr("disabled", true);
        $("#FTLFlag").addClass("read");
        $("#TransRateName").attr("readonly", true);
        //중복확인 버튼
        $("#BtnDuplication").hide();
    } else {
        SetColumns();
    }

    // 사이즈 세팅
    var intHeight = $(document).height() - 210;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 210);
    });

    $("#RateType").on("change", function () {
        if ($(this).val() === "1") {
            AUIGrid.showColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.showColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.showColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.hideColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.hideColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)
        } else if ($(this).val() === "2"){
            AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.showColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

            AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
                headerText: "시간(분) ~ 이상"
            });
            AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
                headerText: "시간(분) ~ 미만"
            });
        } else if ($(this).val() === "3") {
            AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

            AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
                headerText: "수량(ea) ~ 이상"
            });
            AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
                headerText: "수량(ea) ~ 미만"
            });
        } else if ($(this).val() === "4") {
            AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

            AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
                headerText: "부피(cbm) ~ 이상"
            });
            AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
                headerText: "부피(cbm) ~ 미만"
            });
        } else if ($(this).val() === "5") {
            AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

            AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
                headerText: "중량(kg) ~ 이상"
            });
            AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
                headerText: "중량(kg) ~ 미만"
            });
        } else if ($(this).val() === "6") {
            AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
            AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
            AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
            AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
            AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

            AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
                headerText: "길이(cm) ~ 이상"
            });
            AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
                headerText: "길이(cm) ~ 미만"
            });
        }
    });
});

//기본 레이아웃 세팅
function CreateGridLayout(strGID) {

    var GridProps = {};

    GridProps.enableSorting = true;
    GridProps.enableMovingColumn = false;
    // 그룹핑 패널 사용	
    GridProps.useGroupingPanel = false;
    // No Data message;
    GridProps.noDataMessage = "조회 된 데이터가 없습니다.";
    // 헤더 높이 지정
    GridProps.headerHeight = 50;
    //로우 높이 지정
    GridProps.rowHeight = 25;
    // singleRow 선택모드
    GridProps.selectionMode = "multipleCells";
    // 고정 칼럼 1개
    GridProps.fixedColumnCount = 1;
    // 푸터 보이게 설정
    GridProps.showFooter = false;
    // 줄번호 칼럼 렌더러 출력 안함
    GridProps.showRowNumColumn = true;
    // 체크박스 표시 렌더러 출력 안함
    GridProps.showRowCheckColumn = true;
    //필터 표시
    GridProps.enableFilter = true;
    GridProps.rowIdField = "DtlSeqNo";
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
        if (event.isClipboard && event.columnIndex === 0)
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

        if (event.dataField == "GoodsRunType") {
            retStr = retStr.toString().replace(/ /gi, "");

            if (retStr !== "편도" && retStr !== "왕복" && retStr !== "기타" && retStr !== "1" && retStr !== "2" && retStr !== "3") {
                retStr = "";
            }

            if (retStr == "") {
                retStr = "";
            }
        }

        if (event.dataField == "PurchaseUnitAmt" || event.dataField == "SaleUnitAmt" || event.dataField == "FixedPurchaseUnitAmt") {
            retStr = retStr.toString().replace(/ /gi, "");
            if (Number($("#RateRegKind").val()) !== 5) {
                retStr = retStr.toString().replace(/[^0-9,\-]/gi, '');
            } else if (Number($("#RateRegKind").val()) === 5) {
                //retStr = retStr + "%";
            }
            if (retStr == "") {
                retStr = "0";
            }
            
        }

        return retStr;
    } else if (event.type == "pasteBegin") {

        /*if (!event.clipboardData) {
            return false;
        }*/

        var arr = [];
        if (AUIGrid.getSelectedIndex(event.pid)[0] < 0 && AUIGrid.getSelectedIndex(event.pid)[1] < 0) {
            fnDefaultAlert("행추가 or 셀선택 후 붙여넣을 수 있습니다.", "warning");
            return false;
        }
    } else if (event.type == "pasteEnd") {
    } else if (event.type == "addRowFinish") {
    } else if (event.type == "addRow") {
        
        for (i = 0; i < event.items.length; i++) {
            event.items[i].ValidationCheck = "미검증";
            AUIGrid.updateRowsById(GridID, event.items[i]);
        }
    }
};


// 기본 컬럼 세팅 
function fnGetDefaultColumnLayout() {
    var RateType = $("#RateType").val();

    var ColumnLayout = [
               
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "ValidationCheck",
            headerText: "상태",
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
            wordWrap: true,
            editRenderer: {
                type: "RemoteListRenderer",
                showEditorBtn: true, // 마우스 오버 시 에디터버턴 보이기
                showEditorBtnOver: true, // 마우스 오버 시 에디터버턴 보이기
                fieldName: "ADDR", // remoter 에서 가져온 데이터 중 실제 그리드에 적용시킬 필드명 (단순 배열이 아닌 경우 반드시 지정해야 함.)
                listAlign: "left",
                remoter: function (request, response) { // remoter 지정 필수
                    recentAddrList = [];
                    $.ajax({
                        url: "/TMS/TransRate/Proc/TransRateHandler.ashx",
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
                },
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "FromSido",
            headerText: "(상)광역시, 도",
            editable: true,
            wordWrap: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "FromGugun",
            headerText: "(상)시, 군, 구",
            editable: true,
            wordWrap: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "FromDong",
            headerText: "(상)읍, 동, 면",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
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
                        url: "/TMS/TransRate/Proc/TransRateHandler.ashx",
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
                },
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
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
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "ToGugun",
            headerText: "(하)시, 군, 구",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "ToDong",
            headerText: "(하)읍, 동, 면",
            editable: true,
            width: 100,
            filter: {
                showIcon: true
            },
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo) && item.DtlSeqNo !== "") {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            }
        }, {
            dataField: "GoodsRunType",
            headerText: "운행구분",
            width: 100,
            editRenderer: {
                type: "DropDownListRenderer",
                //list: GoodsRunTypeList,
                listFunction: function (rowIndex, columnIndex, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return item.GoodsRunType;
                    } else {
                        return GoodsRunTypeList;
                    }
                },
                keyField: "value", // key 에 해당되는 필드명
                valueField: "name" // value 에 해당되는 필드명
                ,
                validator: function (oldValue, newValue, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return { "validate": false, "message": "수정 할 수 없는 항목입니다." };
                    }
                }
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {  // key-value 에서 엑셀 내보내기 할 때 value 로 내보내기 위한 정의
                var retStr = ""; // key 값에 맞는 value 를 찾아 반환함.
                for (var i = 0, len = GoodsRunTypeList.length; i < len; i++) {
                    if (GoodsRunTypeList[i]["value"] == value) {
                        retStr = GoodsRunTypeList[i]["name"];
                        break;
                    }
                }
                return retStr == "" ? value : retStr;
            }
        }, {
            dataField: "CarTonCodeM",
            headerText: "차량톤급",
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
                //list: CarTonCodeList, //key-value Object 로 구성된 리스트
                listFunction: function (rowIndex, columnIndex, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return item.CarTonCodeM;
                    } else {
                        return CarTonCodeList;
                    }
                },
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
                //list: CarTypeCodeList, //key-value Object 로 구성된 리스트
                listFunction: function (rowIndex, columnIndex, item, dataField) {
                    if (!isNaN(item.DtlSeqNo)) {
                        return item.CarTypeCodeM;
                    } else {
                        return CarTypeCodeList;
                    }
                },
                keyField: "ItemName", // key 에 해당되는 필드명
                valueField: "ItemName" // value 에 해당되는 필드명
            },
            styleFunction: CellStyleFunction
        }, {
            dataField: "TypeValueFrom",
            headerText: "시간(분) ~ 이상",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true // 0~9 까지만 허용
            },
            visible: false
        }, {
            dataField: "TypeValueTo",
            headerText: "시간(분) ~ 미만",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true // 0~9 까지만 허용
            },
            visible: false
        }, {
            dataField: "SaleUnitAmt",
            headerText: "매출",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            dataType: "numeric",
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                
                if (typeof value !== "undefined" & value !== "" & value !== null) {
                    if (Number($("#RateRegKind").val()) === 5) {
                        return value + "%";
                    }
                }
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "ExtSaleUnitAmt",
            headerText: "매출<br>(타지역/1곳)",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            visible: false,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            }
        }, {
            dataField: "FixedPurchaseUnitAmt",
            headerText: "매입(고정차)",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {

                if (typeof value !== "undefined" & value !== "" & value !== null) {
                    if (Number($("#RateRegKind").val()) === 5) {
                        return value + "%";
                    }
                }
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "ExtFixedPurchaseUnitAmt",
            headerText: "매입 - 고정차<br>(타지역/1곳)",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            visible: false,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            }
        }, {
            dataField: "PurchaseUnitAmt",
            headerText: "매입(용차)",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            },
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {

                if (typeof value !== "undefined" & value !== "" & value !== null) {
                    if (Number($("#RateRegKind").val()) === 5) {
                        return value + "%";
                    }
                }
                return AUIGrid.formatNumber(value, "#,##0");
            }
        }, {
            dataField: "ExtPurchaseUnitAmt",
            headerText: "매입-용차<br>(타지역/1곳)",
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            editable: true,
            width: 100,
            styleFunction: CellStyleFunction,
            visible: false,
            editRenderer: {
                type: "InputEditRenderer",
                onlyNumeric: true, // 0~9 까지만 허용
                allowPoint: true // onlyNumeric 인 경우 소수점(.) 도 허용
            }
        },
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "DtlSeqNo",
            headerText: "DtlSeqNo",
            width: 0,
            editable: false,
            visible: false
        },{
            dataField: "TransSeqNo",
            headerText: "TransSeqNo",
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
        }, {
            dataField: "RegType",
            headerText: "RegType",
            width: 0,
            editable: false,
            visible: false
        }

        /*************/
    ];

    var columnObj = null;
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
    item.RegType = "Insert";
    AUIGrid.addRow(GridID, item, "last");
    AUIGrid.clearSelection(GridID);
    if (Number($("#RateRegKind").val()) === 4) {
        AUIGrid.setSelectionByIndex(GridID, AUIGrid.getRowCount(GridID) - 1, 10);
    } else if (Number($("#RateRegKind").val()) === 5) {
        AUIGrid.setSelectionByIndex(GridID, AUIGrid.getRowCount(GridID) - 1, 12);
    } else {
        AUIGrid.setSelectionByIndex(GridID, AUIGrid.getRowCount(GridID) - 1, 1);
    }
    
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
            item.item.DtlSeqNo = null;
            item.item.RegType = "Insert";
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
            if (!isNaN(item.item.DtlSeqNo)) {
                fnDefaultAlert("기존에 등록 된 데이터는 삭제 할 수 없습니다.");
                return;
            }
            AUIGrid.removeRowByRowId(GridID, item.item.DtlSeqNo);
        });
        return;
    }
}

var timer;

var UpdRowsCnt = 0;
var UpdRowsCompleteCnt = 0;
var UpdRowsFailCnt = 0;
var UpdRows;

var refreshChk = false;

function rateData() {
    
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("선택된 회원사가 없습니다.","CenterCode", "warning");
        return false;
    }

    if ($("#RateType").val() === "") {
        fnDefaultAlertFocus("선택된 요율표가 없습니다.", "RateType", "warning");
        return false;
    }

    if (Number($("#RateRegKind").val()) < 4) {
        if ($("#FTLFlag").val() === "") {
            fnDefaultAlertFocus("선택된 운송구분 없습니다.", "FTLFlag", "warning");
            return false;
        }
    }

    if ($("#TransRateName").val() === "") {
        fnDefaultAlertFocus("요울표명을 입력해주세요.", "TransRateName", "warning");
        return false;
    }

    if ($("#HidTransRateChk").val() !== "Y") {
        fnDefaultAlertFocus("중복확인이 필요합니다.", "FTLFlag", "warning");
        return false;
    }

    //추가했다가 삭제한 행 삭제
    $.each(AUIGrid.getRemovedNewItems(GridID), function (index, item) {
        AUIGrid.removeSoftRows(GridID, item.DtlSeqNo);
    });

    if (!validationData()) {
        fnDefaultAlert("검증이 완료되지 않은 데이터가 있습니다.", "warning");
        AUIGrid.setSelectionByIndex(GridID, 2, 2);
        return false;
    } else {
        UpdRowsCnt = 0;
        UpdRowsFailCnt = 0;
        UpdRowsCompleteCnt = 0;
        refreshChk = false;

        UpdRows = AUIGrid.getAddedRowItems(GridID).concat(AUIGrid.getEditedRowItems(GridID));
        for (i = 0; i < UpdRows.length; i++) {
            if (UpdRows[i].ValidationCheck !== "검증") {
                UpdRows.splice(i, 1);
            }
        }
        UpdRowsCnt = UpdRows.length;

        if (UpdRowsCnt <= 0) {
            fnDefaultAlert("등록할 내역이 없습니다.", "warning");
            return false;
        }
        
        if (UpdRowsCnt > 0) {
            timer = setTimeout(function () {
                clearTimeout(timer);
                fnDefaultConfirm("요율표를 저장하시겠습니까?", "fnRateDataRegUpdProc", "");
            }, 50);
        }
    }
}

function fnRateDataRegUpdProc() {
    var strCallType = "";

    if (UpdRowsCnt <= 0) {
        if (UpdRowsFailCnt > 0) {
            fnDefaultAlert("운임이 등록되었습니다.<br>▶ 등록+수정 : " + UpdRowsCompleteCnt + "건 (실패 : " + UpdRowsFailCnt + "건)", "warning", "", "");
            AUIGrid.setSelectionByIndex(GridID, 2, 2);
            return;
        } else {
            fnDefaultAlert("운임이 등록되었습니다.<br>▶ 등록+수정 : " + UpdRowsCompleteCnt + "건 (실패 : " + UpdRowsFailCnt + "건)", "warning", "fnCompleteCall", "");
            return;
        }
        
        $("#divLoadingImage").hide();
        return;
    }

    var rowItem = AUIGrid.getItemByRowId(GridID, UpdRows[UpdRowsCnt - 1].DtlSeqNo);
    
    if (isNaN(rowItem.DtlSeqNo)) {
        strCallType = "TransRateDtlInsert";
    } else {
        strCallType = "TransRateDtlUpdate";
    }
    
    rowItem.CallType = strCallType
    rowItem.CenterCode = $("#CenterCode").val();
    rowItem.RateType = $("#RateType").val();
    rowItem.FTLFlag = $("#FTLFlag").val();
    rowItem.TransRateName = $("#TransRateName").val();
    rowItem.DelFlag = $("#DelFlag").val();
    rowItem.RateRegKind = $("#RateRegKind").val();
    rowItem.TransSeqNo = $("#TransSeqNo").val();

    for (var v = 0, len = GoodsRunTypeList.length; v < len; v++) {
        if (GoodsRunTypeList[v]["name"] === rowItem.GoodsRunType) {
            rowItem.GoodsRunType = GoodsRunTypeList[v]["value"]
        }
    }

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
        var strHandlerURL   = "/TMS/TransRate/Proc/TransRateHandler.ashx";
        var strCallBackFunc = "fnAjaxInsClientTransRate";
        var strFailFunc     = "fnAjaxFailClientTransRate";
        var strCompleteFunc = "fnAjaxCompleteClientTransRate";

        UTILJS.Ajax.fnHandlerRequest(rowItem, strHandlerURL, strCallBackFunc, true, strFailFunc, strCompleteFunc, true);
    }
}

function fnAjaxInsClientTransRate(data) {
    $("#divLoadingImage").hide();
    var rowItem = AUIGrid.getItemByRowId(GridID, UpdRows[UpdRowsCnt - 1].DtlSeqNo);
    if (data) {
        $.map(data, function (item) {
            if (item.RetCode !== 0) { //실패한경우
                UpdRowsFailCnt++;
                rowItem.ValidationCheck = "실패 [사유 : " + item.ErrMsg + "]";
                AUIGrid.updateRowsById(GridID, rowItem, false);
            } else {
                UpdRowsCompleteCnt++;
                refreshChk = true;
                rowItem.DtlSeqNo = item.DtlSeqNo;
                rowItem.TransSeqNo = item.TransSeqNo;
                AUIGrid.resetUpdatedItems(GridID, "c");
                rowItem.ValidationCheck = "저장";
                AUIGrid.updateRowsById(GridID, rowItem, false);
                if ($("#HidMode").val() === "Insert") {
                    $("#TransSeqNo").val(item.TransSeqNo);
                }
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

function validationData() {
    var chk = false;
    var subChkCnt = 0;
    var rowIndex = 0;
    var gridData = AUIGrid.getGridData(GridID);
    var CarTonResult = "N";
    var CarTypeResult = "N";
    // 원하는 결과로 필터링
    var items = gridData.filter(function (v) {
        if ((String(v.ValidationCheck).indexOf("미검증") > -1)) return true; // 1010 포함된 행만 추리기
        return false;
    });

    var TypeValueFromTxt = "";
    switch ($("#RateType").val()) {
        case "3":
            TypeValueFromTxt = "수량(ea)";
            break
        case "4":
            TypeValueFromTxt = "부피(cbm)";
            break
        case "5":
            TypeValueFromTxt = "중량(kg)";
            break
        case "6":
            TypeValueFromTxt = "길이(cm)";
            break
        case "8":
            TypeValueFromTxt = "유가금액(원)";
            break
    }

    var msg = "";
    styleMap = {};
    
    for (i = 0; i < items.length; i++) {
        subChkCnt = 0;
        msg = "";
        rowIndex = AUIGrid.rowIdToIndex(GridID, items[i].DtlSeqNo);
        if (Number($("#RateRegKind").val()) < 4) {
            var strFromFullAddr = "";
            var intFromAddrCount = 0;
            var strToFullAddr = "";
            var intToAddrCount = 0;
            strFromFullAddr = items[i].FromSido;
            strFromFullAddr += typeof items[i].FromGugun === "string" ? items[i].FromGugun : "";
            strFromFullAddr += typeof items[i].FromDong === "string" ? items[i].FromDong : "";
            strToFullAddr = items[i].ToSido;
            strToFullAddr += typeof items[i].ToGugun === "string" ? items[i].ToGugun : "";
            strToFullAddr += typeof items[i].ToDong === "string" ? items[i].ToDong : "";

            if (FullAddrList.length > 0) {
                for (var j = 0; FullAddrList.length > j; j++) {
                    if (strFromFullAddr.replace(/ /g, '') === FullAddrList[j].replace(/ /g, '')) {
                        intFromAddrCount++;
                    }

                    if (strToFullAddr.replace(/ /g, '') === FullAddrList[j].replace(/ /g, '')) {
                        intToAddrCount++;
                    }
                }
            }
           
            if (!(items[i].FromSido && items[i].FromSido.replace(/ /gi, "") != "")) {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FromSido");
                msg += msg === "" ? "상차지(시,도) 정보가 없습니다." : " / " + "상차지(시,도) 정보가 없습니다.";
            }

            if (intFromAddrCount === 0) {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FromAddrSearch");
                msg += msg === "" ? "잘못 된 상차지 주소 값입니다.." : " / " + "잘못 된 상차지 주소 값입니다.";
            }

            if (!(items[i].ToSido && items[i].ToSido.replace(/ /gi, "") != "")) {
                subChkCnt++;
                changeStyleFunction(rowIndex, "ToSido");
                msg += msg === "" ? "하차지(시,도) 정보가 없습니다." : " / " + "하차지(시,도) 정보가 없습니다.";
            }

            if (intToAddrCount === 0) {
                subChkCnt++;
                changeStyleFunction(rowIndex, "ToAddrSearch");
                msg += msg === "" ? "잘못 된 하차지 주소 값입니다.." : " / " + "잘못 된 하차지 주소 값입니다.";
            }
        }

        if ($("#RateType").val() == "1") { //차량
            var GoodsRunType = items[i].GoodsRunType;
            if (typeof GoodsRunType === "undefined" || GoodsRunType === null) { GoodsRunType = ""; }
            GoodsRunType = GoodsRunType.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (GoodsRunType == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "GoodsRunType");
                msg += msg === "" ? "운행구분이 선택되지 않았습니다." : " / " + "운행구분이 선택되지 않았습니다.";
            }

            var ton = items[i].CarTonCodeM;
            if (!typeof ton == "undefined" || ton == null) { ton = ""; }
            ton = ton.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (ton == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "CarTonCodeM");
                msg += msg === "" ? "차량톤급 정보가 없습니다." : " / " + "차량톤급 정보가 없습니다.";
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
                    msg += msg === "" ? "잘못 된 차량톤급입니다." : " / " + "잘못 된 차량톤급입니다.";
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
        }else if ($("#RateType").val() == "2") { //시간

            var ton = items[i].CarTonCodeM;
            if (!typeof ton == "undefined" || ton == null) { ton = ""; }
            ton = ton.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (ton == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "CarTonCodeM");
                msg += msg === "" ? "차량톤급 정보가 없습니다." : " / " + "차량톤급 정보가 없습니다.";
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
                    msg += msg === "" ? "잘못 된 차량톤급입니다." : " / " + "잘못 된 차량톤급입니다.";
                }
            }

            var TypeValueFrom = items[i].TypeValueFrom;
            if (typeof TypeValueFrom == "undefined" || TypeValueFrom == null) { TypeValueFrom = ""; }
            TypeValueFrom = TypeValueFrom.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueFrom == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueFrom");
                msg += msg === "" ? "시간(분) 이상 값이 없습니다." : " / " + "시간(분) 이상 값이 없습니다.";
            }

            var TypeValueTo = items[i].TypeValueTo;
            if (typeof TypeValueTo == "undefined" || TypeValueTo == null) { TypeValueTo = ""; }
            TypeValueTo = TypeValueTo.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueTo == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueTo");
                msg += msg === "" ? "시간(분) 미만 값이 없습니다." : " / " + "시간(분) 미만 값이 없습니다.";
            }
        } else if (Number($("#RateType").val()) >= 3 && Number($("#RateType").val()) < 7) {
            
            var TypeValueFrom = items[i].TypeValueFrom;
            if (typeof TypeValueFrom == "undefined" || TypeValueFrom == null) { TypeValueFrom = ""; }
            TypeValueFrom = TypeValueFrom.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueFrom == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueFrom");
                msg += msg === "" ? TypeValueFromTxt + " 이상 값이 없습니다." : " / " + TypeValueFromTxt + " 이상 값이 없습니다.";
            }

            var TypeValueTo = items[i].TypeValueTo;
            if (typeof TypeValueTo == "undefined" || TypeValueTo == null) { TypeValueTo = ""; }
            TypeValueTo = TypeValueTo.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueTo == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueTo");
                msg += msg === "" ? TypeValueFromTxt + " 미만 값이 없습니다." : " / " + TypeValueFromTxt + " 미만 값이 없습니다.";
            }
        }

        if (Number($("#RateRegKind").val()) === 1) {
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
                msg += msg === "" ? "매입(용차) 정보가 없습니다." : " / " + "매입(용차) 정보가 없습니다.";
            }

            var Fixedpurchase = items[i].FixedPurchaseUnitAmt;
            if (typeof Fixedpurchase == "undefined" || Fixedpurchase == null) { Fixedpurchase = ""; }
            Fixedpurchase = Fixedpurchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (Fixedpurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FixedPurchaseUnitAmt");
                msg += msg === "" ? "매입(고정차) 정보가 없습니다." : " / " + "매입(고정차) 정보가 없습니다.";
            }
        }

        if (Number($("#RateRegKind").val()) === 2) {
            var sale = items[i].SaleUnitAmt;
            if (typeof sale == "undefined" || sale == null) { sale = ""; }
            sale = sale.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (sale == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "SaleUnitAmt");
                msg += msg === "" ? "매출 정보가 없습니다." : " / " + "매출 정보가 없습니다.";
            }
        }

        if (Number($("#RateRegKind").val()) === 3) {
            var purchase = items[i].PurchaseUnitAmt;
            if (typeof purchase == "undefined" || purchase == null) { purchase = ""; }
            purchase = purchase.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (purchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "PurchaseUnitAmt");
                msg += msg === "" ? "매입(용차) 정보가 없습니다." : " / " + "매입(용차) 정보가 없습니다.";
            }

            var FixedPurchase = items[i].FixedPurchaseUnitAmt;
            if (typeof FixedPurchase == "undefined" || FixedPurchase == null) { FixedPurchase = ""; }
            FixedPurchase = FixedPurchase.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (FixedPurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FixedPurchaseUnitAmt");
                msg += msg === "" ? "매입(고정차) 정보가 없습니다." : " / " + "매입(고정차) 정보가 없습니다.";
            }
        }

        //추가요율표 - 경유지
        if (Number($("#RateRegKind").val()) === 4) {
            var ton = items[i].CarTonCodeM;
            if (!typeof ton == "undefined" || ton == null) { ton = ""; }
            ton = ton.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (ton == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "CarTonCodeM");
                msg += msg === "" ? "차량톤급 정보가 없습니다." : " / " + "차량톤급 정보가 없습니다.";
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
                    msg += msg === "" ? "잘못 된 차량톤급입니다." : " / " + "잘못 된 차량톤급입니다.";
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

            var sale = items[i].SaleUnitAmt;
            if (typeof sale == "undefined" || sale == null) { sale = ""; }
            sale = sale.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (sale == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "SaleUnitAmt");
                msg += msg === "" ? "매출(동일지역) 정보가 없습니다." : " / " + "매출(동일지역) 정보가 없습니다.";
            }

            var Extsale = items[i].ExtSaleUnitAmt;
            if (typeof Extsale == "undefined" || Extsale == null) { Extsale = ""; }
            Extsale = Extsale.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (Extsale == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "ExtSaleUnitAmt");
                msg += msg === "" ? "매출(타지역) 정보가 없습니다." : " / " + "매출(타지역) 정보가 없습니다.";
            }

            var purchase = items[i].PurchaseUnitAmt;
            if (typeof purchase == "undefined" || purchase == null) { purchase = ""; }
            purchase = purchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (purchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "PurchaseUnitAmt");
                msg += msg === "" ? "매입(동일지역) 정보가 없습니다." : " / " + "매입(동일지역) 정보가 없습니다.";
            }

            var Extpurchase = items[i].ExtPurchaseUnitAmt;
            if (typeof Extpurchase == "undefined" || Extpurchase == null) { Extpurchase = ""; }
            Extpurchase = Extpurchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (Extpurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "ExtPurchaseUnitAmt");
                msg += msg === "" ? "매입(타지역) 정보가 없습니다." : " / " + "매입(타지역) 정보가 없습니다.";
            }

            var Fixedpurchase = items[i].FixedPurchaseUnitAmt;
            if (typeof Fixedpurchase == "undefined" || Fixedpurchase == null) { Fixedpurchase = ""; }
            Fixedpurchase = Fixedpurchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (Fixedpurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FixedPurchaseUnitAmt");
                msg += msg === "" ? "매입 - 고정차(동일지역) 정보가 없습니다." : " / " + "매입 - 고정차(동일지역) 정보가 없습니다.";
            }

            var ExtFixedPurchase = items[i].ExtFixedPurchaseUnitAmt;
            if (typeof ExtFixedPurchase == "undefined" || ExtFixedPurchase == null) { ExtFixedPurchase = ""; }
            ExtFixedPurchase = ExtFixedPurchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (ExtFixedPurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "ExtFixedPurchaseUnitAmt");
                msg += msg === "" ? "매입 - 고정차(타지역) 정보가 없습니다." : " / " + "매입 - 고정차(타지역) 정보가 없습니다.";
            }
        }

        //추가요율표 - 유가연동
        if (Number($("#RateRegKind").val()) === 5) {

            var TypeValueFrom = items[i].TypeValueFrom;
            if (typeof TypeValueFrom == "undefined" || TypeValueFrom == null) { TypeValueFrom = ""; }
            TypeValueFrom = TypeValueFrom.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueFrom == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueFrom");
                msg += msg === "" ? TypeValueFromTxt + " 이상 값이 없습니다." : " / " + TypeValueFromTxt + " 이상 값이 없습니다.";
            }

            var TypeValueTo = items[i].TypeValueTo;
            if (typeof TypeValueTo == "undefined" || TypeValueTo == null) { TypeValueTo = ""; }
            TypeValueTo = TypeValueTo.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (TypeValueTo == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "TypeValueTo");
                msg += msg === "" ? TypeValueFromTxt + " 미만 값이 없습니다." : " / " + TypeValueFromTxt + " 미만 값이 없습니다.";
            }

            var sale = items[i].SaleUnitAmt;
            if (typeof sale == "undefined" || sale == null) { sale = ""; }
            sale = sale.toString().replace(/ /gi, "").replace(/,/gi, "");

            if (sale == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "SaleUnitAmt");
                msg += msg === "" ? "매출(%) 정보가 없습니다." : " / " + "매출(%) 정보가 없습니다.";
            }

            var purchase = items[i].PurchaseUnitAmt;
            if (typeof purchase == "undefined" || purchase == null) { purchase = ""; }
            purchase = purchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (purchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "PurchaseUnitAmt");
                msg += msg === "" ? "매입 - 용차(%) 정보가 없습니다." : " / " + "매입 - 용차(%) 정보가 없습니다.";
            }

            var Fixedpurchase = items[i].FixedPurchaseUnitAmt;
            if (typeof Fixedpurchase == "undefined" || Fixedpurchase == null) { Fixedpurchase = ""; }
            Fixedpurchase = Fixedpurchase.toString().replace(/ /gi, "").replace(/,/gi, "");
            if (Fixedpurchase == "") {
                subChkCnt++;
                changeStyleFunction(rowIndex, "FixedPurchaseUnitAmt");
                msg += msg === "" ? "매입 - 고정차(%) 정보가 없습니다." : " / " + "매입 - 고정차(%) 정보가 없습니다.";
            }
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

    gridData = AUIGrid.getGridData(GridID);
    // 원하는 결과로 필터링
    items = gridData.filter(function (v) {
        if ((String(v.ValidationCheck).indexOf("미검증") > -1)) return true; // 1010 포함된 행만 추리기
        return false;
    });

    chk = !items.length > 0;

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
    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";
    var objParam = {
        CallType: "TransRateDtlList",
        TransSeqNo: $("#TransSeqNo").val(),
        CenterCode: $("#CenterCode").val(),
        RateRegKind: $("#RateRegKind").val(),
        GoodsRunType: "0",
        DelFlag: $("#DelFlag").val()
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
    fnSetGridEvent(GridID, "GridReady", "", "GridKeyDown", "", "", "", "", "fnGridCellDblClick");

    //에디팅 이벤트
    AUIGrid.bind(GridID, ["cellEditBegin", "cellEditEndBefore", "cellEditEnd", "pasteBegin", "addRow"], GridCellEditingHandler);

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
    });

    if (Number($("#RateRegKind").val()) === 2) {

        AUIGrid.hideColumnByDataField(GridID, "FixedPurchaseUnitAmt");//매입고정
        AUIGrid.hideColumnByDataField(GridID, "PurchaseUnitAmt");//매입
    } else if (Number($("#RateRegKind").val()) === 3) {
        AUIGrid.hideColumnByDataField(GridID, "SaleUnitAmt");//매출
    } else if (Number($("#RateRegKind").val()) === 4) {
        /*숨김*/
        AUIGrid.hideColumnByDataField(GridID, "FromAddrSearch");//주소검색
        AUIGrid.hideColumnByDataField(GridID, "FromSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "FromGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "FromDong");//동
        AUIGrid.hideColumnByDataField(GridID, "ToAddrSearch");//주소검색
        AUIGrid.hideColumnByDataField(GridID, "ToSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "ToGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "ToDong");//동
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분

        /*보임*/
        AUIGrid.showColumnByDataField(GridID, "ExtSaleUnitAmt");//매출
        AUIGrid.showColumnByDataField(GridID, "ExtFixedPurchaseUnitAmt");//매입 고정
        AUIGrid.showColumnByDataField(GridID, "ExtPurchaseUnitAmt");//매입 용차

        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "SaleUnitAmt", {
			headerText : "매출<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "FixedPurchaseUnitAmt", {
            headerText: "매입 - 고정차<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "PurchaseUnitAmt", {
            headerText: "매입 - 용차<br>(동일지역/1곳)"
        });
    } else if (Number($("#RateRegKind").val()) === 5) {

        /*숨김*/
        AUIGrid.hideColumnByDataField(GridID, "FromAddrSearch");//주소검색
        AUIGrid.hideColumnByDataField(GridID, "FromSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "FromGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "FromDong");//동
        AUIGrid.hideColumnByDataField(GridID, "ToAddrSearch");//주소검색
        AUIGrid.hideColumnByDataField(GridID, "ToSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "ToGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "ToDong");//동
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류

        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//유가금액 이상
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//유가금액 미만

        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "SaleUnitAmt", {
            headerText: "매출(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "FixedPurchaseUnitAmt", {
            headerText: "매입 - 고정(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "PurchaseUnitAmt", {
            headerText: "매입 - 용차(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "유가금액(원)<br>~이상"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "유가금액(원)<br>~미만"
        });
    }

    /*요율표 구분에 따른 항목 편집*/
    if ($("#RateType").val() === "1") {
        AUIGrid.showColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.showColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.showColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.hideColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)
    } else if ($("#RateType").val() === "2") {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.showColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "시간(분) ~ 이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "시간(분) ~ 미만"
        });
    } else if ($("#RateType").val() === "3") {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "수량(ea) ~ 이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "수량(ea) ~ 미만"
        });
    } else if ($("#RateType").val() === "4") {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "부피(cbm) ~ 이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "부피(cbm) ~ 미만"
        });
    } else if ($("#RateType").val() === "5") {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "중량(kg) ~ 이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "중량(kg) ~ 미만"
        });
    } else if ($("#RateType").val() === "6") {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunType");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.showColumnByDataField(GridID, "TypeValueFrom");//From 설정값(보통 ~이상)
        AUIGrid.showColumnByDataField(GridID, "TypeValueTo");//To 설정값(보통 ~미만)

        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "길이(cm) ~ 이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "길이(cm) ~ 미만"
        });
    }
}


/*요청톤급 받아오기*/
function fnCarTonList() {

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
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

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
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

function fnAddrList() {
    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnAddrSuccResult";

    var objParam = {
        CallType: "AddrList",
        AddrText: ""
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);
}

function fnAddrSuccResult(objSes) {
    if (objSes) {
        if (objSes[0].List.length > 0) {
            for (var i = 0; objSes[0].List.length > i; i++) {
                FullAddrList.push(objSes[0].List[i].KKO_FULLADDR);
            }
        }
    }
    
}

function fnCompleteCall() {
    if ($("#HidMode").val() === "Update") {
        AUIGrid.setGridData(GridID, []);
        fnCallGridData();
    } else {
        var Param = "";
        Param = "HidMode=Update";
        Param += "&CenterCode=" + $("#CenterCode").val();
        Param += "&TransSeqNo=" + $("#TransSeqNo").val();
        Param += "&RateType=" + $("#RateType").val();
        Param += "&FTLFlag=" + $("#FTLFlag").val();
        Param += "&TransRateName=" + $("#TransRateName").val();
        Param += "&RateRegKind=" + $("#RateRegKind").val();
        Param += "&DelFlag=" + $("#DelFlag").val();
        location.href = "/TMS/TransRate/TransRateIns?" + Param;
    }
    return;
}

function fnTransRateDupBtn() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode");
        return;
    }

    if ($("#RateType").val() === "") {
        fnDefaultAlertFocus("요율표 구분을 선택해주세요.", "RateType");
        return;
    }

    if (Number($("#RateRegKind").val()) < 4) {
        if ($("#FTLFlag").val() === "") {
            fnDefaultAlertFocus("운송구분을 선택해주세요.", "FTLFlag");
            return;
        }
    }

    if ($("#TransRateName").val() === "") {
        fnDefaultAlertFocus("요율표명을 입력해주세요.", "TransRateName");
        return;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnTransRateSuccResult";

    var objParam = {
        CallType: "TransRateGet",
        CenterCode: $("#CenterCode").val(),
        RateType: $("#RateType").val(),
        FTLFlag: $("#FTLFlag").val(),
        TransRateName: $("#TransRateName").val(),
        RateRegKind: $("#RateRegKind").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnTransRateSuccResult(objData) {
    if (objData) {
        if (objData[0].RetCode !== 0) {
            fnDefaultAlert(objData[0].ErrMsg);
            $("#HidTransRateChk").val("");
            return;
        } else {
            if (objData[0].DelFlag === "Y") {
                fnDefaultAlert("사용중지 처리된 요율표입니다.", "warning");
                $("#HidTransRateChk").val("");
                return;
            } else if (objData[0].Exists === "Y") {
                fnDefaultAlert("중복된 요율표가 존재하여,<br>신규 등록을 진행할 수 없습니다.", "warning");
                return;
            }

            fnDefaultAlert("중복된 요율표가 없습니다.<br>요율표를 등록해주세요.", "warning");
            $("#HidTransRateChk").val("Y");
            $("#CenterCode option:not(:selected)").attr("disabled", true);
            $("#CenterCode").addClass("read");
            $("#RateType option:not(:selected)").attr("disabled", true);
            $("#RateType").addClass("read");
            $("#FTLFlag option:not(:selected)").attr("disabled", true);
            $("#FTLFlag").addClass("read");
            $("#TransRateName").attr("readonly", true);
            $("#BtnDuplication").hide();
            $("#BtnReset").show();
        }
    }
}

function fnTransRateReset() {
    $("#CenterCode option:not(:selected)").attr("disabled", false);
    $("#CenterCode").removeClass("read");
    $("#RateType option:not(:selected)").attr("disabled", false);
    $("#RateType").removeClass("read");
    $("#FTLFlag option:not(:selected)").attr("disabled", false);
    $("#FTLFlag").removeClass("read");
    $("#TransRateName").attr("readonly", false);
    if ($("#CenterCode option").length > 1) {
        $("#CenterCode").val("");
    }
    if ($("#RateType option").length > 1) {
        $("#RateType").val("");
    }
    $("#FTLFlag").val("");
    $("#TransRateName").val("");
    $("#TransSeqNo").val("");
    $("#HidTransRateChk").val("");
    $("#CenterCode").focus();
    $("#BtnDuplication").show();
    $("#BtnReset").hide();
}

function fnTransRateDelConfirm() {
    fnDefaultConfirm("사용여부 상태를 저장하시겠습니까?", "fnTransRateDel", "");
}

function fnTransRateDel() {
    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnTransRateDelSuccResult";
    var strCallBackFailFunc = "fnTransRateDelResult";

    var objParam = {
        CallType: "TransRateUpd",
        CenterCode: $("#CenterCode").val(),
        TransSeqNo: $("#TransSeqNo").val(),
        RateRegKind: $("#RateRegKind").val(),
        DelFlag: $("#DelFlag").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strCallBackFailFunc, "", true);
}

function fnTransRateDelSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnDefaultAlert(objRes[0].ErrMsg.replace(/\\n/g, "<br />"), "warning");
            return;
        } else {
            parent.fnReloadPageNotice("저장되었습니다.");
            return;
        }
    }
}

function fnTransRateDelResult() {
    fnDefaultAlert("저장 실패했습니다.", "error");
    return false;
}

function fnGridCellDblClick() {
    if (Number($("#GradeCode").val()) >= 5) {
        fnDefaultAlert("수정 권한이 없습니다.");
        return;
    }
}

function fnRefreshData() {
    if (Number($("#TransSeqNo").val()) !== 0) {
        fnCallGridData();
        return;
    } else {
        SetColumns();
        return;
    }
}