// 그리드
var GridID = "#TransRateModifyListGrid";
var GridSort = [];

$(document).ready(function () {
    // 그리드 초기화
    fnGridInit();
});

function fnGridInit() {
    // 그리드 레이아웃 생성
    fnCreateGridLayout(GridID, "");

    fnSetGridEvent(GridID, "", "", "", "", "", "", "", "");

    // 사이즈 세팅
    var intHeight = $(document).height() - 220;
    AUIGrid.resize(GridID, $(".grid_list").width(), intHeight);

    // 브라우저 리사이징
    $(window).on("resize", function () {
        AUIGrid.resize(GridID, $(".grid_list").width(), $(document).height() - 220);
    });

    //그리드 데이터
    fnCallGridData(GridID);

    //그리드에 포커스
    AUIGrid.setFocus(GridID);

    if (Number($("#RateType").val()) === 1) {
        AUIGrid.hideColumnByDataField(GridID, "TypeValueFrom");
        AUIGrid.hideColumnByDataField(GridID, "TypeValueTo");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "NewTypeValueFrom");
        AUIGrid.hideColumnByDataField(GridID, "NewTypeValueTo");//차량종류
    } else if (Number($("#RateType").val()) === 2) {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "시간(분)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "시간(분)~미만"
        });

        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueFrom", {
            headerText: "변경 후 시간(분)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueTo", {
            headerText: "변경 후 시간(분)~미만"
        });

    } else if (Number($("#RateType").val()) === 3) {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량종류
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "수량(ea)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "수량(ea)~미만"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueFrom", {
            headerText: "변경 후 수량(ea)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueTo", {
            headerText: "변경 후 수량(ea)~미만"
        });

    } else if (Number($("#RateType").val()) === 4) {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량종류
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "부피(cbm)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "부피(cbm)~미만"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueFrom", {
            headerText: "변경 후 부피(cbm)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueTo", {
            headerText: "변경 후 부피(cbm)~미만"
        });

    } else if (Number($("#RateType").val()) === 5) {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량종류
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "중량(kg)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "중량(kg)~미만"
        });

    } else if (Number($("#RateType").val()) === 6) {
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량종류
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "길이(cm)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "길이(cm)~미만"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueFrom", {
            headerText: "변경 후 길이(cm)~이상"
        });
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueTo", {
            headerText: "변경 후 길이(cm)~미만"
        });

    }

    if (Number($("#RateRegKind").val()) === 2) {
        AUIGrid.hideColumnByDataField(GridID, "FixedPurchaseUnitAmt");
        AUIGrid.hideColumnByDataField(GridID, "NewFixedPurchaseUnitAmt");
        AUIGrid.hideColumnByDataField(GridID, "PurchaseUnitAmt");
        AUIGrid.hideColumnByDataField(GridID, "NewPurchaseUnitAmt");
    } else if (Number($("#RateRegKind").val()) === 3) {
        AUIGrid.hideColumnByDataField(GridID, "SaleUnitAmt");
        AUIGrid.hideColumnByDataField(GridID, "NewSaleUnitAmt");
    } else if (Number($("#RateRegKind").val()) === 4) {
        AUIGrid.hideColumnByDataField(GridID, "FromSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "FromGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "FromDong");//동
        AUIGrid.hideColumnByDataField(GridID, "ToSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "ToGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "ToDong");//동
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "TypeValueFrom");
        AUIGrid.hideColumnByDataField(GridID, "TypeValueTo");
        AUIGrid.hideColumnByDataField(GridID, "NewTypeValueFrom");
        AUIGrid.hideColumnByDataField(GridID, "NewTypeValueTo");

        AUIGrid.showColumnByDataField(GridID, "ExtSaleUnitAmt");//기타 매출단가(ex. 타지역경유지...)
        AUIGrid.showColumnByDataField(GridID, "ExtPurchaseUnitAmt");//기타 용차 매입단가(ex. 타지역경유지...)
        AUIGrid.showColumnByDataField(GridID, "ExtFixedPurchaseUnitAmt");//기타 고정 매입단가(ex. 타지역경유지...)

        AUIGrid.showColumnByDataField(GridID, "NewSaleUnitAmt");//신규 매출단가
        AUIGrid.showColumnByDataField(GridID, "NewPurchaseUnitAmt");//신규 용차 매입단가
        AUIGrid.showColumnByDataField(GridID, "NewFixedPurchaseUnitAmt");//신규 고정 매입단가

        AUIGrid.showColumnByDataField(GridID, "NewExtSaleUnitAmt");//신규 기타 매출단가(ex. 타지역경유지...)
        AUIGrid.showColumnByDataField(GridID, "NewExtPurchaseUnitAmt");//신규 기타 용차 매입단가(ex. 타지역경유지...)
        AUIGrid.showColumnByDataField(GridID, "NewExtFixedPurchaseUnitAmt");//신규 기타 고정 매입단가(ex. 타지역경유지...)

        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "SaleUnitAmt", {
            headerText: "매출<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewSaleUnitAmt", {
            headerText: "변경 후 매출<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "FixedPurchaseUnitAmt", {
            headerText: "매입 - 고정차<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewFixedPurchaseUnitAmt", {
            headerText: "변경 후 매입 - 고정차<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "PurchaseUnitAmt", {
            headerText: "매입 - 용차<br>(동일지역/1곳)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewPurchaseUnitAmt", {
            headerText: "변경 후 매입 - 용차<br>(동일지역/1곳)"
        });
    } else if (Number($("#RateRegKind").val()) === 5) {
        AUIGrid.hideColumnByDataField(GridID, "FromSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "FromGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "FromDong");//동
        AUIGrid.hideColumnByDataField(GridID, "ToSido");//시도
        AUIGrid.hideColumnByDataField(GridID, "ToGugun");//구군
        AUIGrid.hideColumnByDataField(GridID, "ToDong");//동
        AUIGrid.hideColumnByDataField(GridID, "GoodsRunTypeM");//운행구분
        AUIGrid.hideColumnByDataField(GridID, "CarTonCodeM");//차량톤급
        AUIGrid.hideColumnByDataField(GridID, "CarTypeCodeM");//차량종류

        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "SaleUnitAmt", {
            headerText: "매출(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewSaleUnitAmt", {
            headerText: "매출(%)<br>수정 후"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "FixedPurchaseUnitAmt", {
            headerText: "매입 - 고정(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewFixedPurchaseUnitAmt", {
            headerText: "매입 - 고정(%)<br>수정 후"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "PurchaseUnitAmt", {
            headerText: "매입 - 용차(%)"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewPurchaseUnitAmt", {
            headerText: "매입 - 용차(%)<br>수정 후"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueFrom", {
            headerText: "유가금액(원)<br>~이상"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "TypeValueTo", {
            headerText: "유가금액(원)<br>~미만"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueFrom", {
            headerText: "변경 후 유가금액(원)<br>~이상"
        });
        //-- dataField 로 변경하기
        AUIGrid.setColumnPropByDataField(GridID, "NewTypeValueTo", {
            headerText: "변경 후 유가금액(원)<br>~미만"
        });
    }
}

//기본 레이아웃 세팅
function fnCreateGridLayout(strGID, strRowIdField) {

    var objGridProps = {};

    objGridProps.enableSorting = true; //다중 칼럼 필드 정렬(Sorting) 여부
    objGridProps.enableMovingColumn = false; //칼럼 헤더를 드래그앤드랍으로 자리를 옮기는 기능 활성화
    objGridProps.useGroupingPanel = false; // 그룹핑 패널 사용	
    objGridProps.processValidData = true; // 숫자 정렬
    objGridProps.noDataMessage = "검색된 데이터가 없습니다."; // No Data message
    objGridProps.headerHeight = 40; // 헤더 높이 지정
    objGridProps.rowHeight = 25; //로우 높이 지정
    objGridProps.selectionMode = "multipleCells"; // 셀 선택 모드
    objGridProps.copySingleCellOnRowMode = true; //셀렉션모드(selectionMode) 가 "singleRow" 또는 "multipleRows" 인 경우 복사(Ctrl+C) 할 때 단일 셀을 복사할지 여부를 지정
    objGridProps.fixedColumnCount = 0; // 고정 칼럼 개수
    objGridProps.showFooter = true; // 푸터 보이게 설정
    objGridProps.footerHeight = 25; //푸터 높이
    objGridProps.showRowNumColumn = true; // 줄번호 칼럼 렌더러 출력
    objGridProps.showRowCheckColumn = false; // 체크박스 표시 렌더러 출력
    objGridProps.rowIdField = "DtlSeqNo"; // 키 필드 지정
    objGridProps.enableFilter = true; //필터 표시
    objGridProps.editable = false; // 편집 수정 가능 여부
    objGridProps.showStateColumn = false; //좌측에 행의 상태를 나타내는 칼럼 출력 여부
    objGridProps.softRemoveRowMode = false; //수정 가능한 상태(editable = true) 인 경우 행을 삭제하면 그리드에서 바로 제거하지 않고, 삭제된 표시를 하고 남겨 둘 지 여부
    objGridProps.enableRestore = false; //편집 가능 그리드(editable=true)에서 수정, 추가, 삭제 행을 원래 상태로 복구 가능하게 할지 여부
    objGridProps.isGenNewRowsOnPaste = false; //다수의 행을 클립 보드 붙여넣기(Ctrl+V) 할 때 그리드의 마지막 하단 행보다 클립보드 양이 많은 경우, 새 행을 만들고 붙여넣기 할지 여부
    objGridProps.showTooltip = true; //툴팁 표시 여부
    objGridProps.filterMenuItemMaxCount = 200; //필터링 가능한 체크박스의 최대값

    var strItemKey = strGID.replace("#", "");
    var objLoadLayout = fnLoadColumnLayout(strItemKey, "fnGetDefaultColumnLayout()");
    var objOriLayout = fnGetDefaultColumnLayout();
    var objResultLayout = fnGetLayoutOptions(objOriLayout, objLoadLayout);

    //그리드 출력
    AUIGrid.create(strGID, objResultLayout, objGridProps);
};

// 컬럼 세팅 - 사용자 정의(페이지 기능별 수정 필요)
function fnGetDefaultColumnLayout() {
    var objColumnLayout = [
        /*************/
        /* 숨김필드 */
        /*************/
        {
            dataField: "DtlSeqNo",
            headerText: "요율표 상세 일련번호",
            editable: false,
            width: 0
        },
        {
            dataField: "TransSeqNo",
            headerText: "요율표 일련번호",
            editable: false,
            width: 0
        },
        {
            dataField: "CenterCode",
            headerText: "회원사코드",
            editable: false,
            width: 0
        },
        /*************/
        /* 일반필드 */
        /*************/
        {
            dataField: "FromSido",
            headerText: "(상)광역시, 도",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "FromGugun",
            headerText: "(상)시,군,구",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "FromDong",
            headerText: "(상)읍,동,면",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ToSido",
            headerText: "(하)광역시,도",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ToGugun",
            headerText: "(하)시,군,구",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "ToDong",
            headerText: "(하)읍,동,면",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "GoodsRunTypeM",
            headerText: "운행구분",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTonCodeM",
            headerText: "차량톤급",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "CarTypeCodeM",
            headerText: "차량종류",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "TypeValueFrom",
            headerText: "이상",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "TypeValueTo",
            headerText: "미만",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            viewstatus: true
        },
        {
            dataField: "NewTypeValueFrom",
            headerText: "이상(변경후)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "my-column-new2",
            viewstatus: true
        },
        {
            dataField: "NewTypeValueTo",
            headerText: "미만(변경후)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            filter: { showIcon: true },
            style: "my-column-new2",
            viewstatus: true
        },
        {
            dataField: "SaleUnitAmt",
            headerText: "매출",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true
        },
        {
            dataField: "NewSaleUnitAmt",
            headerText: "변경 후 매출",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true
        },
        {
            dataField: "ExtSaleUnitAmt",
            headerText: "매출<br>(타지역/1곳)",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true,
            visible: false
        },
        {
            dataField: "NewExtSaleUnitAmt",
            headerText: "변경 후 매출<br>(타지역/1곳)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true,
            visible: false
        },
        {
            dataField: "FixedPurchaseUnitAmt",
            headerText: "매입(고정차)",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true
        },
        {
            dataField: "NewFixedPurchaseUnitAmt",
            headerText: "변경 후 매입(고정차)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true
        },
        {
            dataField: "ExtFixedPurchaseUnitAmt",
            headerText: "매입-고정차<br>(타지역/1곳)",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true,
            visible: false
        },
        {
            dataField: "NewExtFixedPurchaseUnitAmt",
            headerText: "변경 후 매입 - 고정차<br>(타지역/1곳)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true,
            visible:false
        },
        {
            dataField: "PurchaseUnitAmt",
            headerText: "매입(용차)",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true
        },
        {
            dataField: "NewPurchaseUnitAmt",
            headerText: "변경 후 매입(용차)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true
        },
        {
            dataField: "ExtPurchaseUnitAmt",
            headerText: "매입-용차<br>(타지역/1곳)",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "aui-grid-my-column-right",
            viewstatus: true,
            visible:false
        },
        {
            dataField: "NewExtPurchaseUnitAmt",
            headerText: "변경 후 매입-용차<br>(타지역/1곳)",
            headerStyle: "my-header-column-new",
            editable: false,
            width: 150,
            dataType: "numeric",
            style: "my-column-new",
            viewstatus: true,
            visible: false
        },
        {
            dataField: "RegDate",
            headerText: "등록일시",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "RegAdminName",
            headerText: "등록자",
            editable: false,
            width: 150,
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                return value + "(" + item.RegAdminID + ")";
            }
        },
        {
            dataField: "UpdDate",
            headerText: "수정일시",
            headerStyle: "my-header-column-new",
            style: "my-column-new2",
            editable: false,
            width: 150,
            viewstatus: true
        },
        {
            dataField: "UpdAdminName",
            headerText: "수정자",
            headerStyle: "my-header-column-new",
            style: "my-column-new2",
            editable: false,
            width: 150,
            viewstatus: true,
            labelFunction: function (rowIndex, columnIndex, value, headerText, item) {
                if (typeof value !== "undefined" && value !== "") {
                    return value + "(" + item.UpdAdminID + ")";
                }

                return value
            }
        }
    ];

    return objColumnLayout;
}

//---------------------------------------------------------------------------------
//---- 이벤트 핸들러 END
//---------------------------------------------------------------------------------


//그리드 데이터 호출 - 사용자 정의(페이지 기능별 수정 필요)
function fnCallGridData(strGID) {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlert("회원사 정보가 없어 조회 할 수 없습니다.");
        return;
    }

    if ($("#TransSeqNo").val() === "") {
        fnDefaultAlert("요율표 정보가 없어 조회 할 수 없습니다.");
        return;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "TransRateDtlHistList",
        TransSeqNo: $("#TransSeqNo").val(),
        CenterCode: $("#CenterCode").val(),
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

        // 그리드 정렬
        AUIGrid.setSorting(GridID, GridSort);

        return false;
    }
}