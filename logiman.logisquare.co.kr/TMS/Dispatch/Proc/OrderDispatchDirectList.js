// 그리드
var GridID = "#OrderDispatchDirectListGrid";
var GridSort = [];
var GridFilter = null;

$(document).ready(function () {

    $("#DateFrom").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateFromText, inst) {
            var dateToText = $("#DateTo").val().replace(/-/gi, "");
            if (dateToText.length !== 8) {
                dateToText = GetDateToday("");
            }

            if (parseInt(dateFromText.replace(/-/gi, "")) > parseInt(dateToText)) {
                $("#DateTo").datepicker("setDate", dateFromText);
            }
        }
    });
    $("#DateFrom").datepicker("setDate", GetDateToday("-"));

    $("#DateTo").datepicker({
        dateFormat: "yy-mm-dd",
        onSelect: function (dateToText, inst) {
            var dateFromText = $("#DateFrom").val().replace(/-/gi, "");
            if (dateFromText.length !== 8) {
                dateFromText = GetDateToday("");
            }

            if (parseInt(dateFromText) > parseInt(dateToText.replace(/-/gi, ""))) {
                $("#DateFrom").datepicker("setDate", dateToText);
            }
        }
    });
    $("#DateTo").datepicker("setDate", GetDateToday("-"));

    // 브라우저의 키 이벤트 세팅
    $(this).keydown(function (event) {
        // Ctrl + F
        if (event.ctrlKey && event.keyCode === 70) {
            fnSearchDialog("gridDialog", "open");
            return false;
        }

        // ESC
        if (event.keyCode === 27) {
            fnSearchDialog("gridDialog", "close");
            return false;
        }
    });

    // 그리드 초기화
    fnGridInit();

    // 그리드 검색 이벤트
    if ($("#gridDialog").length > 0) {
        $("#LinkGridSearchClose").on("click", function () {
            fnSearchDialog("gridDialog", "close");
            return false;
        });

        $("#BtnGridSearch").on("click", function () {
            fnSearchClick();
            return false;
        });

        $("#GridSearchText").on("keydown", function (event) {
            if (event.keyCode === 13) {
                fnSearchClick();
                return false;
            }

            if (event.keyCode === 27) {
                fnSearchDialog("gridDialog", "close");
                return false;
            }
        });
    }

    $(".search_line > input[type=text]").on("keydown", function (event) {
        if (event.keyCode === 13) {
            fnCallGridData(GridID);
            return false;
        }
    });

    fnSetInitAutoComplete();

    //카운트 표시
    fnGetDispatchCount();

    //결제정보(빠른입금 일시 제한 20250903)
    $("#QuickType").on("change", function () {
        if ($(this).val() != "1" && fnGetToday() <= "20251214") {
            fnDefaultAlert("[빠른입금 서비스 점검 안내]<br/>12월 14일까지 빠른입금 마감 메뉴 이용이 제한됩니다.</br>이용에 불편을 드려 죄송합니다.", "info");
            $(this).val("1");
            return false;
        }
    });
});

function fnSetInitAutoComplete() {
    //차량번호 검색
    if ($("#SearchCarNo").length > 0) {
        fnSetAutocomplete({
            formId: "SearchCarNo",
            width: 800,
            callbacks: {
                getUrl: () => {
                    return "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "CarDispatchRefSearch",
                    CenterCode: $("#CenterCode").val(),
                    CarNo: request.term,
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if ($("#CenterCode").val() === "") {
                        fnDefaultAlert("회원사를 선택해주세요.", "warning");
                        return false;
                    }

                    if (request.term.length < 4) {
                        fnDefaultAlert("검색어를 4자 이상 입력하세요.", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.CarNo,
                getValue: (item) => item.CarNo,
                onSelect: (event, ui) => {
                    $("#CarCenterCode").val(ui.item.etc.CenterCode);
                    $("#RefSeqNo").val(ui.item.etc.RefSeqNo);
                    $("#CarSeqNo").val(ui.item.etc.CarSeqNo);
                    $("p.car_info").text(ui.item.etc.DispatchInfo);
                    $("#BtnCarNoReset").show();
                    $("#SearchCarNo").attr("readonly", true);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("CarDispatchRef", ul, item);
                }
            }
        });
    }

    $("#BtnCarNoReset").on("click", function () {
        $("#CarCenterCode").val("");
        $("#RefSeqNo").val("");
        $("#CarSeqNo").val("");
        $("p.car_info").text("");
        $("#BtnCarNoReset").hide();
        $("#SearchCarNo").attr("readonly", false);
        $("#SearchCarNo").val("");
        $("#SearchCarNo").focus();
        $("#InsureExceptKind").val("");
    });
}

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "OrderNo");

    fnSetGridEvent(GridID, "", "", "fnGridKeyDown", "", "", "", "fnGridCellClick", "fnGridCellDblClick");

    AUIGrid.bind(GridID, "filtering", function (evt) {
        GridFilter = evt.filterCache;
    });

    AUIGrid.bind(GridID, "sorting", function (evt) {
        GridSort = evt.sortingFields;
    });

    // 사이즈 세팅
    var intHeight = $(document).height() - 270;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 270);
        clearTimeout(window.resizedEnd);
        window.resizedEnd = setTimeout(function () {
            AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 270);
        }, 100);
    });

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    // 푸터
    fnSetGridFooter(GridID);
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = true; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값
    objGridProps.isRowAllCheckCurrentView = true;
    objGridProps.nullsLastOnSorting = false; //빈값 상단 정렬

    objGridProps.rowStyleFunction = function (rowIndex, item) {
        if (AUIGrid.isCheckedRowById(GridID, item.OrderNo)) {
            return "aui-grid-extra-checked-row";
        }

        if (item.BondedFlag === "Y" && item.OrderStatusM !== "등록") {
            return "aui-grid-bonded-y-row-style";
        } else if (item.BondedFlag === "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-bonded-y-no-accept-row-style";
        } else if (item.BondedFlag !== "Y" && item.OrderStatusM === "등록") {
            return "aui-grid-no-accept-row-style";
        }

        return "";
    }

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);

    // 그리드 항목관리 이동 이벤트
    AUIGrid.bind(GridID, "columnStateChange", function (event) {
        fnSaveColumnLayoutAuto(GridID, 'OrderDispatchDirectListGrid');
        return;
    });
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BtnSms",
            headerText: "문자",
            editable: false,
            width: 60,
            renderer: {
                type: "IconRenderer",
                iconWidth: 16,
                iconHeight: 17,
                iconPosition: "center",
                iconTableRef: {
                    "default": "/images/icon/search_icon.png",
                }
            },
            viewstatus: false
        },
        {
            dataField: "CenterName",
            headerText: "회원사명",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderStatusM",
            headerText: "상태",
            width: 100,
            editable: false,
            renderer: {
                type: "IconRenderer",
                iconWidth: 20,
                iconHeight: 20,
                iconPosition: "aisle",
                iconTableRef: {
                    "등록": "/js/lib/AUIGrid/assets/yellow_circle.png",
                    "접수": "/js/lib/AUIGrid/assets/blue_circle.png",
                    "배차": "/js/lib/AUIGrid/assets/violet_circle.png",
                    "직송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "집하(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "간선(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "배송(상차)": "/js/lib/AUIGrid/assets/green_circle.png",
                    "직송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "집하(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "간선(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "배송(하차)": "/js/lib/AUIGrid/assets/orange2_circle.png",
                    "취소": "/js/lib/AUIGrid/assets/gray_circle.png"
                }
            },
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "QuickTypeM",
            headerText: "지급방법",
            editable: false,
            width: 80,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderNo",
            headerText: "오더번호",
            editable: false,
            width: 150,
            dataType: "string",
            filter: { showIcon: true },
            viewstatus: false
        }, {
            dataField: "ContractTypeM",
            headerText: "위탁구분",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "ContractInfo",
            headerText: "위탁정보",
            editable: false,
            width: 150,
            viewstatus: false
        },
        {
            dataField: "ContractStatusMView",
            headerText: "위탁상태",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderItemCodeM",
            headerText: "상품",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderLocationCodeM",
            headerText: "사업장",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderClientName",
            headerText: "발주처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "OrderClientChargeName",
            headerText: "(발)담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
        },
        {
            dataField: "OrderClientChargeTelExtNo",
            headerText: "(발)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "OrderClientChargeTelNo",
            headerText: "(발)전화번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "OrderClientChargeCell",
            headerText: "(발)휴대폰번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientTypeM",
            headerText: "청구처구분",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PayClientName",
            headerText: "청구처명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PayClientChargeName",
            headerText: "(청)담당자",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PayClientChargeTelExtNo",
            headerText: "(청)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PayClientChargeTelNo",
            headerText: "(청)전화번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientChargeCell",
            headerText: "(청)휴대폰번호",
            editable: false,
            width: 120,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PayClientChargeLocation",
            headerText: "청구사업장",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "ConsignorName",
            headerText: "화주명",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupStandard",
            headerText: "상차일 기준",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: false,
            dataType: "date",
            formatString: "yyyy-mm-dd",
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "PickupWay",
            headerText: "상차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlace",
            headerText: "상차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "PickupPlacePost",
            headerText: "(상)우편번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceAddr",
            headerText: "(상)주소",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceAddrDtl",
            headerText: "(상)주소상세",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeName",
            headerText: "(상)담당자명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargePosition",
            headerText: "(상)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelExtNo",
            headerText: "(상)내선",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "PickupPlaceChargeTelNo",
            headerText: "(상)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceChargeCell",
            headerText: "(상)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "PickupPlaceLocalCode",
            headerText: "(상)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "PickupPlaceLocalName",
            headerText: "(상)지역명",
            editable: false,
            width: 150,
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "PickupPlaceNote",
            headerText: "(상)특이사항",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차요청일",
            editable: false,
            width: 120,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 120,
            filter: { showIcon: true },
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "GetWay",
            headerText: "하차방법",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlace",
            headerText: "하차지",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: false
        },
        {
            dataField: "GetPlacePost",
            headerText: "(하)우편번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddr",
            headerText: "(하)주소",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetPlaceAddrDtl",
            headerText: "(하)주소상세",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeName",
            headerText: "(하)담당자명",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {

            dataField: "GetPlaceChargePosition",
            headerText: "(하)직급",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelExtNo",
            headerText: "(하)내선",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "GetPlaceChargeTelNo",
            headerText: "(하)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceChargeCell",
            headerText: "(하)휴대폰번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "GetPlaceLocalCode",
            headerText: "(하)지역코드",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GetPlaceLocalName",
            headerText: "(하)지역명",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "NoLayerFlag",
            headerText: "이단불가",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "NoTopFlag",
            headerText: "무탑배차",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "FTLFlag",
            headerText: "FTL",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "요청톤급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "요청차종",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CustomFlag",
            headerText: "통관",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BondedFlag",
            headerText: "보세",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DocumentFlag",
            headerText: "서류",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ArrivalReportFlag",
            headerText: "도착보고",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "LicenseFlag",
            headerText: "면허진행",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InTimeFlag",
            headerText: "시간엄수",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ControlFlag",
            headerText: "특별관제",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "QuickGetFlag",
            headerText: "하차긴급",
            editable: false,
            width: 80,
            visible: false,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Nation",
            headerText: "목적국",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Hawb",
            headerText: "H/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "Mawb",
            headerText: "M/AWB",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "BookingNo",
            headerText: "Booking No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "InvoiceNo",
            headerText: "Invoice No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "StockNo",
            headerText: "입고 No.",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GMOrderType",
            headerText: "오더구분",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GMTripID",
            headerText: "Trip ID",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "Volume",
            headerText: "총수량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "CBM",
            headerText: "총부피",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Weight",
            headerText: "총중량",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.###");
            }
        },
        {
            dataField: "Length",
            headerText: "총길이",
            width: 80,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "Quantity",
            headerText: "화물정보",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "NoteInside",
            headerText: "비고",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true,
            filter: { showIcon: true }
        },
        {
            dataField: "NoteClient",
            headerText: "고객전달사항",
            editable: false,
            width: 80,
            style: "aui-grid-text-left",
            viewstatus: true
        },
        {
            dataField: "TaxClientName",
            headerText: "(계)업체명",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientCorpNo",
            headerText: "(계)사업자번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeName",
            headerText: "(계)담당자",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "TaxClientChargeTelNo",
            headerText: "(계)전화번호",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "TaxClientChargeEmail",
            headerText: "(계)이메일",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "FileCnt",
            headerText: "첨부파일",
            editable: false,
            width: 80,
            visible: false,
            viewstatus: true
        },
        {
            dataField: "GoodsDispatchTypeM",
            headerText: "배차구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CargopassInfo",
            headerText: "카고패스",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DispatchCarNo1",
            headerText: "직송차량",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true,
            tooltip: {
                tooltipFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                    var str = "";
                    if (item.DispatchCarInfo1 == "") {
                        return str;
                    }
                    str += "<table cellpadding=3>";
                    str += "<tbody>";
                    str += "<tr>";
                    str += "<td style='padding:5px; border-right:1px solid #aaa; text-align:right;'>";
                    str += item.DispatchCarInfo1 + " <br> " + item.DispatchInfo1 + ")";
                    str += "</td>";
                    str += "</tr>";
                    str += "</tboby>";
                    str += "</table>";
                    return str;
                }
            }
        },
        {
            dataField: "CarDivTypeM1",
            headerText: "(직송)차량구분",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComName1",
            headerText: "(직송)차량업체명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ComCorpNo1",
            headerText: "(직송)차량사업자번호",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverName1",
            headerText: "(직송)기사명",
            editable: false,
            width: 80,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "DriverCell1",
            headerText: "(직송)기사휴대폰",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "TransRateInfo",
            headerText: "자동운임",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "SaleSupplyAmt",
            headerText: "매출",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "PurchaseSupplyAmt",
            headerText: "매입",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "Revenue",
            headerText: "수익",
            width: 100,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                return Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt) - Number(item.QuickPaySupplyFee);
            },
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (value <= 0) {
                    return "aui-grid-font-color-blue";
                } else if (value >= 20) {
                    return "aui-grid-font-color-red";
                }
                return null;
            },
            viewstatus: true
        },
        {
            dataField: "RevenuePer",
            headerText: "수익률",
            width: 100,
            editable: false,
            visible: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0.0");
            },
            expFunction: function (rowIndex, columnIndex, item, dataField) {
                var Revenue = Number(item.SaleSupplyAmt) - Number(item.PurchaseSupplyAmt) - Number(item.QuickPaySupplyFee);
                var RevenuePer = item.SaleSupplyAmt == 0 ? 0 : Revenue / Number(item.SaleSupplyAmt) * 100;
                return RevenuePer;
            },
            styleFunction: function (rowIndex, columnIndex, value, headerText, item, dataField) {
                if (value <= 0) {
                    return "aui-grid-font-color-blue";
                } else if (value >= 20) {
                    return "aui-grid-font-color-red";
                }
                return null;
            },
            viewstatus: true
        },
        {
            dataField: "AdvanceSupplyAmt3",
            headerText: "선급금",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "AdvanceSupplyAmt4",
            headerText: "예수금",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "QuickPaySupplyFee",
            headerText: "빠른입금수수료(공급가액)",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "QuickPayTaxFee",
            headerText: "빠른입금수수료(부가세)",
            editable: false,
            width: 100,
            viewstatus: true,
            dataType: "numeric",
            style: "aui-grid-text-right",
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return AUIGrid.formatNumber(value, "#,##0");
            }
        },
        {
            dataField: "SaleClosingFlag",
            headerText: "매출마감",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "PurchaseClosingFlag",
            headerText: "매입마감",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "AcceptDate",
            headerText: "접수일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "AcceptAdminName",
            headerText: "접수자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "최종수정일",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "최종수정자명",
            editable: false,
            width: 100,
            filter: { showIcon: true },
            viewstatus: true
        },
        /*숨김필드*/
        {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderStatus",
            headerText: "OrderStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo1",
            headerText: "DispatchRefSeqNo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo2",
            headerText: "DispatchRefSeqNo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo3",
            headerText: "DispatchRefSeqNo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchRefSeqNo4",
            headerText: "DispatchRefSeqNo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "GoodsDispatchType",
            headerText: "GoodsDispatchType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderLocationCode",
            headerText: "OrderLocationCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo1",
            headerText: "DispatchCarInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo1",
            headerText: "DispatchInfo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo2",
            headerText: "DispatchCarInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo2",
            headerText: "DispatchInfo2",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo3",
            headerText: "DispatchCarInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo3",
            headerText: "DispatchInfo3",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchCarInfo4",
            headerText: "DispatchCarInfo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchInfo4",
            headerText: "DispatchInfo4",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientCode",
            headerText: "ClientCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientName",
            headerText: "ClientName",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ClientFaxNo",
            headerText: "ClientFaxNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "DispatchSeqNo1",
            headerText: "DispatchSeqNo1",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "NetworkNo",
            headerText: "NetworkNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CnlFlag",
            headerText: "CnlFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "OrderItemCode",
            headerText: "OrderItemCode",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ContractType",
            headerText: "ContractType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "ContractStatus",
            headerText: "ContractStatus",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "TransType",
            headerText: "TransType",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CargopassOrderNo",
            headerText: "CargopassOrderNo",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        },
        {
            dataField: "CargopassFlag",
            headerText: "CargopassFlag",
            editable: false,
            width: 0,
            visible: false,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
// 키 다운 핸들러 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridKeyDown(event) {
    // Ctrl + F
    if (event.ctrlKey && event.keyCode === 70) {
        fnSearchDialog("gridDialog", "open");
        return false;
    }

    // ESC
    if (event.keyCode === 27) {
        fnSearchDialog("gridDialog", "close");
        return false;
    }
    return true;
}

//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridCellDblClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    if ((strKey === "CargopassFlag" || strKey === "CargopassInfo") && objItem.CargopassFlag === "Y") {
        var strCenterCode = (typeof objItem.CenterCode === "undefined" || objItem.CenterCode === null) ? "" : objItem.CenterCode;
        var strCargopassOrderNo = (typeof objItem.CargopassOrderNo === "undefined" || objItem.CargopassOrderNo === null) ? "" : objItem.CargopassOrderNo;
        var strURL = "/TMS/Cargopass/CargopassIns?CenterCode=" + strCenterCode + "&CargopassOrderNo=" + strCargopassOrderNo;
        $("#IfrmCargopass").attr("src", strURL);
        $("#DivCargopassIns").show();
        return false;
    }

    if (strKey === "OrderStatusM" && objItem.OrderStatusM !== "등록" && objItem.OrderStatusM !== "접수") {
        fnOpenDispatchCar(objItem.CenterCode, objItem.OrderNo, objItem.GoodsSeqNo);
        return false;
    }

    fnCommonOpenOrder(objItem);
    return false;
}

//셀 클릭
function fnGridCellClick(event) {
    var key = AUIGrid.getDataFieldByColumnIndex(GridID, event.columnIndex);

    if (key == "BtnSms") {
        var OrderNo = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).OrderNo;
        var CenterCode = AUIGrid.getItemByRowIndex(GridID, event.rowIndex).CenterCode;
        fnOpenRightSubLayer("문자 발송", "/TMS/Common/MsgSend?ParamOrderNos=" + OrderNo + "&ParamCenterCode=" + CenterCode + "&ParamOrderType=2", "1024px", "700px", "50%");
        return;
    }
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    var LocationCode = [];
    var ItemCode = [];
    var OrderStatus = [];
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    if (!$("#ChkFilter").is(":checked")) {
        GridFilter = null;
    }

    if (!$("#ChkSort").is(":checked")) {
        GridSort = [];
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

    $.each($("#OrderStatus input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            OrderStatus.push($(el).val());
        }
    });

    var objParam = {
        CallType: "OrderDispatchList",
        CenterCode: $("#CenterCode").val(),
        ListType : 3,
        DateType: $("#DateType").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        OrderLocationCodes: LocationCode.join(","),
        OrderItemCodes: ItemCode.join(","),
        OrderStatuses: OrderStatus.join(","),
        SearchClientType: $("#SearchClientType").val(),
        SearchClientText: $("#SearchClientText").val(),
        CarNo: $("#CarNo").val(),
        DispatchAdminName: $("#DispatchAdminName").val(),
        GoodsDispatchType: "2",
        ComName: $("#ComName").val(),
        OrderNo: $("#OrderNo").val(),
        MyChargeFlag: $("#ChkMyCharge").is(":checked") ? "Y" : "N",
        MyOrderFlag: $("#ChkMyOrder").is(":checked") ? "Y" : "N",
        PageNo: $("#PageNo").val(),
        PageSize: $("#PageSize").val()
    };
    
    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    
    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            $("#RecordCnt").val(0);
            $("#GridResult").html("");
            AUIGrid.setGridData(GridID, []);
            // 페이징
            fnCreatePagingNavigator();
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        $("#RecordCnt").val(objRes[0].data.RecordCnt);
        $("#GridResult").html("[" + objRes[0].data.RecordCnt + "건]");
        AUIGrid.setGridData(GridID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridID);

        // 페이징
        fnCreatePagingNavigator();

        if (GridFilter != null) {
            fnSetGridFilter(GridID, GridFilter);
        }

        if (GridSort.length > 0) {
            AUIGrid.setSorting(GridID, GridSort);
        }

        // 푸터
        fnSetGridFooter(GridID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [
        {
            positionField: "CenterName",
            dataField: "CenterName",
            operation: "COUNT",
            formatString: "#,##0",
            postfix: "건",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Volume",
            dataField: "Volume",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "CBM",
            dataField: "CBM",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Weight",
            dataField: "Weight",
            operation: "SUM",
            formatString: "#,##0.##",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Length",
            dataField: "Length",
            operation: "SUM",
            formatString: "#,##0",
            style: "aui-grid-text-right"
        },
        {
            positionField: "SaleSupplyAmt",
            dataField: "SaleSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "PurchaseSupplyAmt",
            dataField: "PurchaseSupplyAmt",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "Revenue",
            dataField: "Revenue",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "RevenuePer",
            dataField: "RevenuePer",
            formatString: "#,##0.0",
            postfix: "%",
            style: "aui-grid-text-right",
            labelFunction: function (value, columnValues, footerValues) {
                var newValue = "";
                if (footerValues[5] !== 0) {
                    newValue = (footerValues[7] / footerValues[5]) * 100;
                }
                return newValue;
            }
        },
        {
            positionField: "AdvanceSupplyAmt3",
            dataField: "AdvanceSupplyAmt3",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "AdvanceSupplyAmt4",
            dataField: "AdvanceSupplyAmt4",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "QuickPaySupplyFee",
            dataField: "QuickPaySupplyFee",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        },
        {
            positionField: "QuickPayTaxFee",
            dataField: "QuickPayTaxFee",
            operation: "SUM",
            formatString: "#,##0",
            postfix: "원",
            style: "aui-grid-text-right"
        }
    ];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

//---------------------배차등록---------------------//
function fnOrderDispatchInsConfirm() {
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var intValidType = 0;

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return
    }
    
    if ($("#RefSeqNo").val() === "") {
        fnDefaultAlertFocus("차량번호를 검색해주세요.", "SearchCarNo", "warning");
        return
    }
    
    if ($("#QuickType").val() === "") {
        fnDefaultAlertFocus("지급방법을 선택해주세요.", "QuickType", "warning");
        return
    }

    if ($("#InsureExceptKind").val() === "") {
        fnDefaultAlertFocus("산재보험 신고정보를 선택해주세요.", "InsureExceptKind", "warning");
        return
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 2;
            return false;
        }

        if ($("#CarCenterCode").val() != item.item.CenterCode) {
            intValidType = 3;
            return false;
        }

        if (item.item.CargopassFlag === "Y") {
            intValidType = 4;
            return false;
        }

        OrderNos.push(item.item.OrderNo);
    });

    if (intValidType === 2) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlertFocus("검색된 차량의 회원사와 오더의 회원사가 서로 다릅니다.<br>배차 차량을 다시 검색해주세요.", "BtnCarNoReset", "warning");
        return false;
    }

    if (intValidType === 4) {
        fnDefaultAlert("카고패스 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (OrderNos.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (OrderNos.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }

    fnDefaultConfirm("배차를 등록하시겠습니까?", "fnOrderDispatchIns", OrderNos);
    return;
}

function fnOrderDispatchIns(strOrderNos) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGridInsertSuccResult";

    var objParam = {
        CallType: "OrderDispatchInsert",
        CenterCode: $("#CenterCode").val(),
        OrderNos: strOrderNos.join(","),
        RefSeqNo: $("#RefSeqNo").val(),
        DispatchType: 1, //직송
        QuickType: $("#QuickType").val(),
        InsureExceptKind: $("#InsureExceptKind").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridInsertSuccResult(data) {
    if (data[0].RetCode != 0) {
        fnDefaultAlert(data[0].ErrMsg, "warning");
        return;
    } else {
        fnCallGridData(GridID);
        $("#BtnCarNoReset").click();
        fnDefaultAlert("배차 처리되었습니다.", "success");
        return;
    }
}

//배차취소
function fnOrderDispatchCnlConfirm() {
    var DispatchSeqNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var intValidType = 0;
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
            return false;
        }

        if (item.item.CargopassFlag === "Y") {
            intValidType = 2;
            return false;
        }

        DispatchSeqNos.push(item.item.DispatchSeqNo1);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("카고패스 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (DispatchSeqNos.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    if (DispatchSeqNos.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }

    fnDefaultConfirm("[오더" + DispatchSeqNos.length + "건]배차를 취소하시겠습니까?", "fnOrderDispatchCnl", DispatchSeqNos);
    return;
}
function fnOrderDispatchCnl(DispatchSeqNos) {

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGridCnlSuccResult";

    var objParam = {
        CallType: "OrderDispatchCnl",
        CenterCode: $("#CenterCode").val(),
        DispatchSeqNos: DispatchSeqNos.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridCnlSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnCallGridData(GridID);
        $("#BtnCarNoReset").click();
        fnDefaultAlert("취소되었습니다.", "success");
        return;
    }
}

//집하변경
function fnDispatchTypeUpdConfirm() {
    var OrderNo = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var intValidType = 0;

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return;
    }
    
    $.each(CheckedItems, function (index, item) {
        if (item.item.DispatchRefSeqNo1 !== "0" || item.item.DispatchRefSeqNo2 !== "0" || item.item.DispatchRefSeqNo3 !== "0" || item.item.DispatchRefSeqNo4 !== "0") {
            intValidType = 1;
            return false;
        }
        if (item.item.GoodsSeqNo === "0" || item.item.GoodsSeqNo === "") {
            intValidType = 2;
            return false;
        }
        if (item.item.GoodsDispatchType === 3) {
            intValidType = 3;
            return false;
        }
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 4;
            return false;
        }

        if (item.item.DispatchSeqNo1 !== "0" && item.item.ContractType === 3) {
            intValidType = 5;
        }

        if ((item.item.DispatchRefSeqNo1 === "0" || item.item.DispatchRefSeqNo1 === "") && (item.item.DispatchRefSeqNo2 === "0" || item.item.DispatchRefSeqNo2 === "") && (item.item.DispatchRefSeqNo3 === "0" || item.item.DispatchRefSeqNo3 === "") && (item.item.DispatchRefSeqNo4 === "0" || item.item.DispatchRefSeqNo4 === "") && $("#CenterCode").val() == item.item.CenterCode) {
            OrderNo.push(item.item.OrderNo);
        }
    });

    if (intValidType === 1) {
        fnDefaultAlert("배차된 오더가 포함되어있습니다.", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("화물정보가 없는 오더가 포함되어있습니다.", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlert("집하 오더가 포함되어 있습니다.", "warning");
        return false;
    }

    if (intValidType === 4) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 5) {
        fnDefaultAlert("오더(수탁)가 포함되어있습니다.<br>집하변경을 할 수 없습니다.", "warning");
        return false;
    }

    if (OrderNo.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (OrderNo.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }

    fnDefaultConfirm("집하로 변경하시겠습니까?", "fnDispatchTypeUpd", OrderNo);
    return;
}

function fnDispatchTypeUpd(OrderNo) {

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGridUpdSuccResult";

    var objParam = {
        CallType: "OrderDispatchTypeUpd",
        CenterCode: $("#CenterCode").val(),
        GoodsDispatchType: 3, //3 : 집하
        OrderNos: OrderNo.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridUpdSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("변경되었습니다.", "success");
        fnCallGridData(GridID);
        return;
    }
}

/***********************************************/
//출력물
/***********************************************/
function fnTransPortPrint() {
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 선택 후 오더를 조회해주세요..", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 100) {
        fnDefaultAlert("최대 100건까지 가능합니다.", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }

        if (item.item.OrderItemCode === "OA007") {
            intValidType = 2;
        }

        OrderNos.push(item.item.OrderNo);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlertFocus("수출입 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "CenterCode", "warning");
        return false;
    }

    fnPopupWindowPost("/TMS/Common/OrderInoutPrintTransport?OrderNos=" + OrderNos.join(",") + "&CenterCode=" + $("#CenterCode").val(), "운송장", "760px", "900px");
    return;
}

function fnPeriodPrint() {
    var intValidType = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var ClientCode = 0;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 선택 후 오더를 조회해주세요..", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 500) {
        fnDefaultAlert("최대 500건까지 가능합니다.", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }

        if (CheckedItems[0].item.ClientCode != item.item.ClientCode) {
            intValidType = 2;
        }

        if (item.item.OrderItemCode === "OA007") {
            intValidType = 3;
        }

        if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
            if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                arrCnt++;
            }

            eval("OrderList").push(item.item.OrderNo);
            eval("OrderList" + arrCnt).push(item.item.OrderNo);
        }
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("청구처가 다른 오더가 선택되어 있습니다.", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlert("수출입 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderInoutPrintPeriod", postData);
    return;
}

function fnClientPrint() {
    var intValidType = 0;
    var ClientCode = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 선택 후 오더를 조회해주세요..", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 30) {
        fnDefaultAlert("최대 30건까지 가능합니다.", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }

        if (CheckedItems[0].item.PayClientCode != item.item.PayClientCode) {
            intValidType = 2;
        }

        if (item.item.OrderItemCode === "OA007") {
            intValidType = 3;
        }

        if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
            if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                arrCnt++;
            }

            eval("OrderList").push(item.item.OrderNo);
            eval("OrderList" + arrCnt).push(item.item.OrderNo);
        }
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("청구처가 다른 오더가 선택되어 있습니다.", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlert("수출입 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    ClientCode = CheckedItems[0].item.PayClientCode;

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2
    };

    fnOpenWindowWithPost("/TMS/Common/OrderInoutPrintClient", postData);
    return;
}

function fnDomesticTransPortPrint() {
    var intValidType = 0;
    var ClientCode = 0;
    var OrderList = [];
    var OrderList1 = [];
    var OrderList2 = [];
    var arrCnt = 1;
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    if (CheckedItems.length > 300) {
        fnDefaultAlert("최대 300건까지 조회가능합니다.", "warning");
        return;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
        }

        if (CheckedItems[0].item.PayClientCode != item.item.PayClientCode) {
            intValidType = 2;
        }

        if (item.item.OrderItemCode !== "OA007") {
            intValidType = 3;
        }

        if (OrderList.findIndex((e) => e === item.item.OrderNo) === -1) {
            if ((eval("OrderList" + arrCnt).join(",") + "," + item.item.OrderNo).length > 4000) {
                arrCnt++;
            }

            eval("OrderList").push(item.item.OrderNo);
            eval("OrderList" + arrCnt).push(item.item.OrderNo);
        }
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("하나의 청구처만 선택가능합니다.", "warning");
        return false;
    } else {
        ClientCode = CheckedItems[0].item.PayClientCode;
    }

    if (intValidType === 3) {
        fnDefaultAlert("내수 오더만 선택가능합니다.<br>오더의 상품을 확인하세요.", "warning");
        return false;
    }

    var postData = {
        CenterCode: $("#CenterCode").val(),
        ClientCode: ClientCode,
        OrderNos1: OrderList1,
        OrderNos2: OrderList2,
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
    };

    fnOpenWindowWithPost("/TMS/Common/OrderDomesticPrint", postData);
    return;
}

//내역서 POST 방식
function fnOpenWindowWithPost(url, objPostData) {
    var newForm = $("<form></form>");
    newForm.attr("method", "post");
    newForm.attr("action", url);
    newForm.attr("target", "PrintList");

    newForm.append($("<input/>", { type: "hidden", name: "OrderNos1", value: objPostData.OrderNos1 }));
    newForm.append($("<input/>", { type: "hidden", name: "OrderNos2", value: objPostData.OrderNos2 }));
    newForm.append($("<input/>", { type: "hidden", name: "CenterCode", value: objPostData.CenterCode }));
    newForm.append($("<input/>", { type: "hidden", name: "ClientCode", value: objPostData.ClientCode }));
    newForm.append($("<input/>", { type: "hidden", name: "DateFrom", value: objPostData.DateFrom }));
    newForm.append($("<input/>", { type: "hidden", name: "DateTo", value: objPostData.DateTo }));

    // 새 창에서 폼을 열기
    window.open("", "PrintList", "width=1050, height=900, scrollbars=Yes");
    newForm.appendTo("body");
    newForm.submit();
    newForm.remove();

}

function fnContractUpd() {
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    var cnt = 0;

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
        return false;
    }

    $.each(CheckedItems, function (index, item) {
        if (item.item.DispatchRefSeqNo1 !== "0") {
            intValidType = 1;
            return false;
        }
        
        if (item.item.GoodsDispatchType != 2) {
            intValidType = 2;
            return false;
        }
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 3;
            return false;
        }
        
        if (item.item.DispatchRefSeqNo1 == "0" && item.item.CnlFlag == "N" && !(item.item.ContractType == 2 && item.item.ContractStatus == 2) && item.item.ContractType != 3 && item.item.TransType != 3 && $("#CenterCode").val() == item.item.CenterCode) {
            cnt++;
            OrderNos.push(item.item.OrderNos);
        } else {
            intValidType = 4;
        }
    });

    if (cnt <= 0) {
        fnDefaultAlert("위탁할 수 있는 오더가 없습니다.<br/>(직송, 취소x, 미배차, 위탁x, 위탁받음x, 위탁상태x, 이관받음x)", "warning");
        return false;
    }

    if (intValidType === 1) {
        fnDefaultAlert("이미 배차된 오더가 있습니다.<br>위탁하시려면 배차를 취소해주세요.", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlert("직송오더가 아닙니다.", "warning");
        return false;
    }

    if (intValidType === 3) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 4) {
        fnDefaultAlert("이미 위탁 된 오더가 포함되어있습니다.", "warning");
        return false;
    }

    if (OrderNos.length <= 0) {
        fnDefaultAlert("변경할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    if (OrderNos.length > 200) {
        fnDefaultAlert("최대 200건까지 변경가능합니다.", "warning");
        return false;
    }

    fnOpenRightSubLayer("위탁 운송사 선택", "/TMS/Dispatch/OrderDispatchContract?GridID=" + GridID.replace("#", "") + "&HidCenterCode=" + $("#CenterCode").val() + "&DispatchType=1", "1024px", "700px", "50%");
}

function fnContractCnlConfirm() {
    var intValidType = 0;
    var OrderNos = [];
    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);

    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사 선택 후 오더를 조회해주세요.", "CenterCode", "warning");
        return;
    }

    if (CheckedItems.length === 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return;
    }

    $.each(CheckedItems, function (index, item) {
        if ($("#CenterCode").val() != item.item.CenterCode) {
            intValidType = 1;
            return false;
        }

        if (item.item.ContractType === 3) {
            intValidType = 2;
            return false;
        }
        OrderNos.push(item.item.OrderNo);
    });

    if (intValidType === 1) {
        fnDefaultAlertFocus("선택한 회원사와 오더의 회원사가 서로 다릅니다.", "CenterCode", "warning");
        return false;
    }

    if (intValidType === 2) {
        fnDefaultAlertFocus("수탁 오더는 위탁 취소 할 수 없습니다.", "CenterCode", "warning");
        return false;
    }

    fnDefaultConfirm("위탁 취소하시겠습니까?", "fnContractCnl", OrderNos);
    return;
}

function fnContractCnl(OrderNos) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGridContractCnlSuccResult";

    var objParam = {
        CallType: "OrderDispatchContractCnl",
        CenterCode: $("#CenterCode").val(),
        DispatchType: 1, //1 : 직송
        OrderNos: OrderNos.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnGridContractCnlSuccResult(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert(data[0].ErrMsg, "error");
        return;
    } else {
        fnDefaultAlert("취소되었습니다.", "success");
        fnCallGridData(GridID);
        return;
    }
}

function fnOrderNetworkIns() {
    fnDefaultAlert("정보망 연동 서비스를 사용하실 수 없습니다.", "info");
    return false;
}

//정보망 현황
function fnOpenNetworkList() {
    fnDefaultAlert("정보망 연동 서비스를 사용하실 수 없습니다.", "info");
    return false;
}

//오더 배차 목록 오픈
function fnOpenDispatchCar(intCenterCode, intOrderNo, intGoodsSeqNo) {
    $("#HidCenterCode").val(intCenterCode);
    $("#HidOrderNo").val(intOrderNo);
    $("#HidGoodsSeqNo").val(intGoodsSeqNo);
    fnCallDispatchCarGridData(GridDispatchCarID);
    $("#DivDispatchCar").show();
    AUIGrid.resize(GridDispatchCarID, $("#DivDispatchCar .gridWrap").width(), $("#DivDispatchCar .gridWrap").height());
}

// 배차 목록 닫기
function fnCloseDispatchCar() {
    AUIGrid.setGridData(GridDispatchCarID, []);
    $("#DivDispatchCar").hide();
}

/**********************************************************/
// 오더 배차 목록 그리드
/**********************************************************/
var GridDispatchCarID = "#OrderDispatchCarListGrid";

$(document).ready(function () {
    if ($(GridDispatchCarID).length > 0) {
        // 그리드 초기화
        fnDispatchCarGridInit();
    }
});

function fnDispatchCarGridInit() {
    // 그리드 레이아웃 생성
    fnCreateDispatchCarGridLayout(GridDispatchCarID, "DispatchSeqNo");

    /* 기본 이벤트 바인딩
        Function SetGridEvent(strGID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick)
        ex) SetGridEvent(GridID, "fnGridReady", "fnGridSelectionChange", "fnGridKeyDown", "fnGridNotFound", "fnGridHeaderClick", "fnGridFooterDblClick", "fnGridCellClick", "fnGridCellDblClick");
    */
    fnSetGridEvent(GridDispatchCarID, "", "", "", "", "", "", "fnDispatchCarGridCellClick", "");

    // 사이즈 세팅
    AUIGrid.resize(GridDispatchCarID, $("#DivDispatchCar .gridWrap").width(), $("#DivDispatchCar .gridWrap").height());
}

//기본 레이아웃 세팅
function fnCreateDispatchCarGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = true; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 25; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = strRowIdField; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = true; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultDispatchCarColumnLayout()");
    var objOriLayout = fnGetDefaultDispatchCarColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultDispatchCarColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "BtnViewDispatchFile",
            headerText: "증빙",
            editable: false,
            width: 60,
            renderer: {
                type: "ButtonRenderer",
                labelText: "보기",
                onClick: function (event) {
                    fnViewDispatchFile(event.item);
                    return;
                }
            }
        }, {
            dataField: "DispatchTypeM",
            headerText: "구분",
            editable: false,
            width: 60,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "QuickTypeM",
            headerText: "지급방법",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "DeliveryLocationCodeM",
            headerText: "배송사업장",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "CarDivTypeM",
            headerText: "차량구분",
            editable: false,
            width: 80,
            viewstatus: true
        },
        {
            dataField: "CarNo",
            headerText: "차량번호",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DriverName",
            headerText: "기사명",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DriverCell",
            headerText: "기사휴대폰",
            editable: false,
            width: 100,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strValue = fnMakeCellNo(value);
                return strValue;
            }
        },
        {
            dataField: "ComName",
            headerText: "차량업체명",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "ComCorpNo",
            headerText: "차량사업자번호",
            editable: false,
            width: 120,
            viewstatus: true
        },
        {
            dataField: "InsureTargetFlag",
            headerText: "산재보험대상",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DispatchStatusM",
            headerText: "상태",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "PickupYMD",
            headerText: "상차요청일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            viewstatus: true
        },
        {
            dataField: "PickupHM",
            headerText: "상차요청시간",
            editable: false,
            width: 80,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "PickupDT",
            headerText: "상차완료",
            editable: true,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetYMD",
            headerText: "하차요청일",
            editable: false,
            width: 100,
            dataType: "date",
            formatString: "yyyy-mm-dd",
            viewstatus: true
        },
        {
            dataField: "GetHM",
            headerText: "하차요청시간",
            editable: false,
            width: 80,
            viewstatus: true,
            xlsxTextConversion: true, // 엑셀 저장 시 엑셀에서 "텍스트" 로 인식 시킴.
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                var strHM = value;
                if (typeof strHM === "string") {
                    if (strHM.length === 4) {
                        strHM = strHM.substring(0, 2) + ":" + strHM.substr(2, 2);
                    }
                }
                return strHM;
            }
        },
        {
            dataField: "ArrivalDT",
            headerText: "도착예정",
            editable: true,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "GetDT",
            headerText: "하차완료",
            editable: true,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "BtnUpd",
            headerText: "시간등록",
            width: 60,
            renderer: {
                type: "ButtonRenderer",
                labelText: "등록",
                onClick: function (event) {
                    fnUpdDispatchCarStatus(event.item);
                    return;
                }
            }
        },
        {
            dataField: "UpdAdminID",
            headerText: "수정자",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "UpdDate",
            headerText: "수정일",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "DispatchAdminName",
            headerText: "배차자",
            editable: false,
            width: 100,
            viewstatus: true
        },
        {
            dataField: "DispatchDate",
            headerText: "배차일",
            editable: false,
            width: 150,
            viewstatus: true
        }
        /*숨김필드*/
        , {
            dataField: "DispatchSeqNo",
            headerText: "DispatchSeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "GoodsSeqNo",
            headerText: "GoodsSeqNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "CenterCode",
            headerText: "CenterCode",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }, {
            dataField: "OrderNo",
            headerText: "OrderNo",
            editable: false,
            visible: false,
            width: 0,
            viewstatus: false
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 START
//---------------------------------------------------------------------------------
//셀 더블클릭 - 사용자 정의(페이지 기능별 수정 필요)
function fnDispatchCarGridCellClick(event) {
    var strKey = AUIGrid.getDataFieldByColumnIndex(GridDispatchCarID, event.columnIndex);
    var objItem = event.item;

    if (strKey.indexOf("Btn") > -1) {
        return;
    }

    if (strKey === "PickupDT" || strKey === "ArrivalDT" || strKey === "GetDT") {
        var nDate = fnGetDateToday("-");
        var nHour = new Date().getHours();
        var nMinute = new Date().getMinutes();
        if (nHour < 10) {
            nHour = "0" + nHour;
        }
        if (nMinute < 10) {
            nMinute = "0" + nMinute;
        }

        if (strKey == "PickupDT") {
            var item = {
                PickupDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        } else if (strKey == "ArrivalDT") {
            var item = {
                ArrivalDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        } else if (strKey == "GetDT") {
            var item = {
                GetDT: nDate + " " + nHour + ":" + nMinute
            };
            AUIGrid.updateRow(GridDispatchCarID, item, event.rowIndex);
        }
    }
}
//---------------------------------------------------------------------------------

//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallDispatchCarGridData(strGID) {

    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnDispatchCarGridSuccResult";

    var objParam = {
        CallType: "OrderDispatchCarList",
        CenterCode: $("#HidCenterCode").val(),
        OrderNo: $("#HidOrderNo").val(),
        GoodsSeqNo: $("#HidGoodsSeqNo").val()
    };

    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnDispatchCarGridSuccResult(objRes) {

    if (objRes) {

        if (objRes[0].result.ErrorCode !== 0) {
            AUIGrid.setGridData(GridDispatchCarID, []);
            fnDefaultAlert(objRes[0].result.ErrorMsg, "warning");
            return false;
        }

        AUIGrid.setGridData(GridDispatchCarID, objRes[0].data.list);
        AUIGrid.removeAjaxLoader(GridDispatchCarID);

        // 푸터
        fnSetDispatchCarGridFooter(GridDispatchCarID);
        return false;
    }
}

//푸터 설정 - 사용자 정의(페이지 기능별 수정 필요)
function fnSetDispatchCarGridFooter(strGID) {

    // 푸터 설정
    var GridFooterObject = [{
        positionField: "DispatchTypeM",
        dataField: "DispatchTypeM",
        operation: "COUNT",
        formatString: "#,##0",
        postfix: "건",
        style: "aui-grid-my-column-right"
    }];

    // 푸터 객체 세팅
    AUIGrid.setFooter(strGID, GridFooterObject);
}

// 상/하차 시간 등록
function fnUpdDispatchCarStatus(objItem) {
    var strConfMsg = "";
    strConfMsg = "상/하차 시간을 등록 하시겠습니까?";
    fnDefaultConfirm(strConfMsg, "fnUpdDispatchCarStatusProc", objItem);
    return;
}

function fnUpdDispatchCarStatusProc(objItem) {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnAjaxUpdDispatchCarStatus";

    var objParam = {
        CallType: "OrderDispatchCarStatusUpdate",
        CenterCode: objItem.CenterCode,
        OrderNo: objItem.OrderNo,
        DispatchSeqNo: objItem.DispatchSeqNo,
        PickupDT: objItem.PickupDT,
        ArrivalDT: objItem.ArrivalDT,
        GetDT: objItem.GetDT
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnAjaxUpdDispatchCarStatus(data) {
    if (data[0].RetCode !== 0) {
        fnDefaultAlert("나중에 다시 시도해 주세요.(" + data[0].ErrMsg + ")");
    } else {
        var msg = "상/하차 시간 등록에 성공하였습니다.";
        fnDefaultAlert(msg, "info");
        fnCallDispatchCarGridData(GridDispatchCarID);
    }
}
/************************************************************************/

// 상하차 파일 보기
function fnViewDispatchFile(item) {
    fnOpenRightSubLayer("증빙보기", "/TMS/Common/OrderReceiptList?ParamDispatchType=1&ParamCenterCode=" + item.CenterCode + "&ParamOrderNo=" + item.OrderNo + "&ParamDispatchSeqNo=" + item.DispatchSeqNo, "800px", "600px", "60%");
    return false;
}


/**********************************************************/
//카고패스 연동
function fnCloseRegCargopass() {
    $("#IfrmCargopass").attr("src", "about:blank");
    $("#DivCargopassIns").hide();
    return false;
}

function fnOpenRegCargopass() {
    var objArrOrderNo = [];
    var strOrderNos = "";
    var intCnt = 0;
    var intNoCnt = 0;
    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        $("#CenterCode").focus();
        return false;
    }

    var CheckedItems = AUIGrid.getCheckedRowItems(GridID);
    if (CheckedItems.length <= 0) {
        fnDefaultAlert("선택된 오더가 없습니다.", "warning");
        return false;
    }

    //이관대상, 위탁제외
    $.each(CheckedItems, function (index, item) {
        if (item.item.CnlFlag !== "Y"
            && $("#CenterCode").val() == item.item.CenterCode
            && item.item.OrderStatusM === "접수"
            && item.item.GoodsDispatchTypeM === "직송"
            && item.item.TransType != 3
            && !(item.item.ContractType == 2 && item.item.ContractStatus == 2)
            && (item.item.NetworkNo == "" || item.item.NetworkNo == "0")
            && item.item.CargopassFlag !== "Y") {

            if (objArrOrderNo.findIndex((e) => e === item.item.OrderNo) === -1) {
                objArrOrderNo.push(item.item.OrderNo);
                intCnt++;
            }
        } else {
            intNoCnt++;
        }
    });

    if (intCnt <= 0) {
        fnDefaultAlert("카고패스에 등록할 수 있는 오더가 없습니다.", "warning");
        return false;
    }

    strOrderNos = objArrOrderNo.join(",");

    var fnParam = {
        CenterCode: $("#CenterCode").val(),
        OrderNos: strOrderNos
    };

    if (intNoCnt > 0) {
        var strConfMsg = "선택한 오더 중 카고패스에 등록이 불가능한 오더가 포함되어있습니다.<br/>제외하고 진행 하시겠습니까?";
        fnDefaultConfirm(strConfMsg, "fnOpenRegCargopassConfirm", fnParam);
        return false;
    } else {
        fnOpenRegCargopassConfirm(fnParam);
        return false;
    }
}

function fnOpenRegCargopassConfirm(objParam) {
    var strURL = "/TMS/Cargopass/CargopassIns?DispatchType=1&CenterCode=" + objParam.CenterCode + "&OrderNos=" + objParam.OrderNos;
    $("#IfrmCargopass").attr("src", strURL);
    $("#DivCargopassIns").show();
    return false;
}

/**********************************************************/


//카운트 표시
function fnGetDispatchCount() {
    var strHandlerURL = "/TMS/Dispatch/Proc/OrderDispatchDirectHandler.ashx";
    var strCallBackFunc = "fnGetDispatchCountSuccResult";

    var objParam = {
        CallType: "OrderDispatchCount"
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

function fnGetDispatchCountSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetDispatchCountCallBack();
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnGetDispatchCountCallBack();
            return false;
        }

        $("#BtnOpenRegCargopass").text("카고패스등록 " + objRes[0].data.NetworkDispatchType1Cnt);

        $("#BtnAmtRequest").text("자동운임 수정승인 " + objRes[0].data.AmtRequestCnt);

        if (objRes[0].data.NetworkDispatchType1Cnt == "0") {
            $("#BtnOpenRegCargopass").removeClass("border_on");
        }

        if (objRes[0].data.AmtRequestCnt == "0") {
            $("#BtnAmtRequest").removeClass("border_on");
        }

        fnGetDispatchCountCallBack();
        return false;
    } else {
        fnGetDispatchCountCallBack();
        return false;
    }
}

function fnGetDispatchCountCallBack() {
    fnBorderSetting();
    setTimeout(fnGetDispatchCount, 1000 * 60);
}

var BorderTimer = null;
function fnBorderSetting() {

    if (BorderTimer) {
        clearTimeout(BorderTimer);
        BorderTimer = null;
    }

    var strBtnOpenRegCargopass = $("#BtnOpenRegCargopass").text().replace("카고패스등록", "").replace(/ /gi, "");
    var strBtnAmtRequest = $("#BtnAmtRequest").text().replace("자동운임", "").replace("수정승인", "").replace(/ /gi, "");

    if (!isNaN(Number(strBtnOpenRegCargopass))) {
        if (Number(strBtnOpenRegCargopass) > 0) {
            if ($("#BtnOpenRegCargopass").hasClass("border_on")) {
                $("#BtnOpenRegCargopass").removeClass("border_on");
            } else {
                $("#BtnOpenRegCargopass").addClass("border_on");
            }
        }
    }

    if (!isNaN(Number(strBtnAmtRequest))) {
        if (Number(strBtnAmtRequest) > 0) {
            if ($("#BtnAmtRequest").hasClass("border_on")) {
                $("#BtnAmtRequest").removeClass("border_on");
            } else {
                $("#BtnAmtRequest").addClass("border_on");
            }
        }
    }

    BorderTimer = setTimeout(fnBorderSetting, 1000);
}


//자동운임 수정승인
function fnConfirmRequestAmt() {
    window.open("/TMS/Common/OrderAmtConfirmList?ListType=2", "자동운임 수정승인", "width=1400, height=850, scrollbars=Yes");
    return false;
}
