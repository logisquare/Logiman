//이벤트 바인딩
function fnSetGridEvent(GID, ready, sChange, kDown, nFound, hClick, fDblClick, cClick, cDblClick) {

    // 그리드 ready 이벤트 바인딩
    if (ready !== "") {
        AUIGrid.bind(GID, "ready", eval(ready));
    }

    // 그리드 selectionChange 이벤트 바인딩
    if (sChange !== "") {
        AUIGrid.bind(GID, "selectionChange", eval(sChange));
    }

    // keyDown 핸들러 바인딩
    if (kDown !== "") {
        AUIGrid.bind(GID, "keyDown", eval(kDown));
    }

    // 검색(search) Not Found 핸들러 바인딩
    if (nFound !== "") {
        AUIGrid.bind(GID, "notFound", eval(nFound));
    }

    // 헤더 클릭 핸들러 바인딩
    if (hClick !== "") {
        AUIGrid.bind(GID, "headerClick", eval(hClick));
    }

    // 푸터 더블 클릭 핸들러 바인딩
    if (fDblClick !== "") {
        AUIGrid.bind(GID, "footerDoubleClick", eval(fDblClick));
    }

    // 셀 클릭 핸들러 바인딩
    if (cClick !== "") {
        AUIGrid.bind(GID, "cellClick", eval(cClick));
    }

    // 셀 더블클릭 핸들러 바인딩
    if (cDblClick !== "") {
        AUIGrid.bind(GID, "cellDoubleClick", eval(cDblClick));
    }
}

/********************************/
/* 그리드 레이아웃 저장 관련 */
/********************************/

// AUIGrid 의 현재 칼럼 레이아웃을 얻어 보관
function fnSaveColumnLayout(strGridID, strItemKey) {
    // 칼럼 레이아웃 정보 가져오기
    var objColumns = AUIGrid.getColumnLayout(strGridID);
    var strColumns = JSON.stringify(objColumns);
    if (strColumns !== "") {
        strColumns = strColumns.replace(/\/>/gi, "★").replace(/"/gi, "^").replace(/</gi, "☆");
    }

    var strHandlerURL = "/Lib/AUIGridLayoutHandler.ashx";
    var strCallBackFunc = "fnSaveColumnLayoutSuccResult";
    var strFailCallBack = "fnSaveColumnLayoutFailResult";

    var objParam = {
        CallType: "GridHeaderSave",
        GridKey: strItemKey,
        GridHeader: strColumns
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBack, "", true);
};

function fnSaveColumnLayoutSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            fnDefaultAlert("현재 그리드의 상태가 보관되었습니다.<br/>브라우저를 종료하거나 페이지를 새로 갱신했을 때 현재 상태로 그리드가 출력됩니다.", "success");
            return false;
        } else {
            fnDefaultAlert("항목 저장에 실패하였습니다.", "error");
            return false;
        }
    } else {
        fnDefaultAlert("항목 저장에 실패하였습니다.", "error");
        return false;
    }
}

function fnSaveColumnLayoutFailResult() {
    fnDefaultAlert("항목 저장에 실패하였습니다.", "error");
    return false;
}

// AUIGrid 의 현재 칼럼 레이아웃을 얻어 보관합니다.
// 데모에서는 HTML5의 localStrage 를 사용하여 보관합니다.
// 만약 DB 상에 보관하고자 한다면 해당 정보를 Ajax 요청으로 코딩하십시오.
function fnSaveColumnLayoutAuto(strGridID, strItemKey) {
    // 칼럼 레이아웃 정보 가져오기
    var objColumns = AUIGrid.getColumnLayout(strGridID);
    var strColumns = JSON.stringify(objColumns);
    if (strColumns !== "") {
        strColumns = strColumns.replace(/\/>/gi, "★").replace(/"/gi, "^").replace(/</gi, "☆");
    }

    var strHandlerURL = "/Lib/AUIGridLayoutHandler.ashx";
    var strCallBackFunc = "fnSaveColumnLayoutSuccResultAuto";
    var strFailCallBack = "fnSaveColumnLayoutFailResult";

    var objParam = {
        CallType: "GridHeaderSave",
        GridKey: strItemKey,
        GridHeader: strColumns
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBack, "", true);
};

function fnSaveColumnLayoutSuccResultAuto(objRes) {
    if (objRes) {
        if (objRes[0].RetCode === 0) {
            return false;
        } else {
            fnDefaultAlert("항목 저장에 실패하였습니다.", "error");
            return false;
        }
    } else {
        fnDefaultAlert("항목 저장에 실패하였습니다.", "error");
        return false;
    }
}

// 보관된 칼럼 정보를 얻어와 반환
var AuiGridColumnLayout = null;
function fnLoadColumnLayout(strItemKey, strDefaultColumnMethod) {
    AuiGridColumnLayout = null;

    var strHandlerURL = "/Lib/AUIGridLayoutHandler.ashx";
    var strCallBackFunc = "fnLoadColumnLayoutSuccResult";

    var objParam = {
        CallType: "GridHeaderLoad",
        GridKey: strItemKey
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", false);

    if (!AuiGridColumnLayout) {
        AuiGridColumnLayout = eval(strDefaultColumnMethod);
    }

    return AuiGridColumnLayout;
};

function fnLoadColumnLayoutSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode == null) {
            return false;
        }

        if (objRes[0].RetCode != 0) {
            return false;
        }

        if (objRes[0].GridLayout == null || objRes[0].GridLayout == "") {
            return false;
        }

        var objJson = null;

        try {
            objJson = JSON.parse(JSON.parse(JSON.parse(JSON.stringify(objRes[0].GridLayout))));
        } catch (e) {
        }

        AuiGridColumnLayout = objJson;
    }
}

// 레이아웃 정보 삭제
function fnResetColumnLayout(strItemKey) {
    var strHandlerURL = "/Lib/AUIGridLayoutHandler.ashx";
    var strCallBackFunc = "fnResetColumnLayoutSuccResult";

    var objParam = {
        CallType: "GridHeaderDelete",
        GridKey: strItemKey
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
};

function fnResetColumnLayoutSuccResult(objRes) {
    fnDefaultAlert("저장된 그리드의 상태를 초기화했습니다.<br/>브라우저를 종료하거나 페이지를 새로 갱신했을 때 원래 상태로 출력됩니다.", "success");
    return false;
}

/********************************/


/*********/
/* 필터 */
/*********/
function fnCustomFilter(strGID, strFID, strSTXT) {

    // 사용자 필터링 설정
    AUIGrid.setFilter(strGID, strFID, function (dataField, value, item) {
        //console.log(GID)	
        return value.indexOf(strSTXT) > -1;

    });
}

function fnClearFilter(strGID, strFID) {
    // name 필터링 해제
    AUIGrid.clearFilter(strGID, strFID);
}

function fnClearFilterAll(strGID) {
    AUIGrid.clearFilterAll(strGID);
}
/*********/

// 감춰진 칼럼에 따라 데모 상에 보이는 체크박스 동기화 시킴.
function fnSyncCheckbox(objColumns) {
    fnRecursive(objColumns);

    function fnRecursive(objChildren) {
        var objC;
        var objDom;
        for (var i = 0, len = objChildren.length; i < len; i++) {
            objC = objChildren[i];
            if (objC.visible === false) {
                objDom = document.getElementById(objC.dataField);
                if (objDom) objDom.checked = false;
            }
            if (typeof objC.objChildren != "undefined") {
                fnRecursive(objC.objChildren);
            }
        }
    }
};

// 내보내기(GridObj, 내보내기 타입, 내보내기 파일명, 제목) 
var objGridExport = null;
var strGridExportID = "";
var strGridExportFileType = "";
function fnGridExportAs(GID, fType, fName, title) {
    //FileSaver.js 로 로컬 다운로드가능 여부 확인
    if (!AUIGrid.isAvailableLocalDownload(GID)) {
        alert("다운로드 불가능한 브라우저 입니다.");
        return;
    }

    objGridExport = null;
    strGridExportID = GID;
    strGridExportFileType = fType;

    var strHandlerURL = "/js/lib/AUIGrid/export/GridDataExportHandler.ashx";
    var strCallBackFunc = "fnGridExportAsSuccResult";
    var strFailCallBackFunc = "fnGridExportAsFailResult";

    var objParam = {
        fileName: fName,// 저장하기 파일명
        param: "GridDataExportLog^" + GID + "^" + fName
    };

    objGridExport = {
        fileName: fName + "_" + fnGetToday("") ,// 저장하기 파일명
        exceptColumnFields : AUIGrid.getHiddenColumnDataFields(GID),
        showRowNumColumn: false
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
};

function fnGridExportAsSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode != 0) {
            fnGridExportAsFailResult(objRes[0].ErrMsg);
            return false;
        }

        if (strGridExportFileType === "xlsx") {
            AUIGrid.exportToXlsx(strGridExportID, objGridExport);
            return false;
        }
    } else {
        fnGridExportAsFailResult();
    }
}

function fnGridExportAsFailResult(msg) {
    msg = typeof msg === "undefined" || msg === null ? "" : ("(" + msg + ")");
    fnDefaultAlert("엑셀 다운로드에 실패했습니다. 나중에 다시 시도해 주세요." + msg);
    return false;
}

function fnSetGridFilter(strGID, objCache) {
    if (objCache != null) {
        $.each(objCache, function (index, item) {
            AUIGrid.setFilterByValues(strGID, index, item);
        });
    }
}

//그리드 기타 속성 세팅
function fnGetLayoutOptions(objOriLayout, objLoadLayout) {
    var objResultLayout = [];
    $.each(objLoadLayout, function (intIndex, objItem) {
        $.each(objOriLayout, function (intSubIndex, objSubItem) {

            if (objItem.dataField === objSubItem.dataField && objItem.labelFunction !== objSubItem.labelFunction) {
                objItem.labelFunction = objSubItem.labelFunction;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.editRenderer !== objSubItem.editRenderer) {
                objItem.editRenderer = objSubItem.editRenderer;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.renderer !== objSubItem.renderer) {
                objItem.renderer = objSubItem.renderer;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.style !== objSubItem.style) {
                objItem.style = objSubItem.style;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.styleFunction !== objSubItem.styleFunction) {
                objItem.styleFunction = objSubItem.styleFunction;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.expFunction !== objSubItem.expFunction) {
                objItem.expFunction = objSubItem.expFunction;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.headerTooltip !== objSubItem.headerTooltip) {
                objItem.headerTooltip = objSubItem.headerTooltip;
            }

            if (objItem.dataField === objSubItem.dataField && objItem.tooltip !== objSubItem.tooltip) {
                objItem.tooltip = objSubItem.tooltip;
            }
        });

        objResultLayout.push(objItem);
    });

    var objResultLayoutTemp = [];
    $.each(objResultLayout, function (intIndex, objItem) {
        if (objOriLayout.findIndex((e) => e.dataField === objItem.dataField) >= 0) {
            objResultLayoutTemp.push(objItem);
        }
    });

    objResultLayout = objResultLayoutTemp;
    $.each(objOriLayout, function (intIndex, objItem) {
        var intCnt = 0;
        if (objResultLayoutTemp.findIndex((e) => e.dataField === objItem.dataField) === -1) {
            objResultLayout.splice(intIndex + intCnt, 0, objItem);
            intCnt++;
        }
    });

    return objResultLayout;
}