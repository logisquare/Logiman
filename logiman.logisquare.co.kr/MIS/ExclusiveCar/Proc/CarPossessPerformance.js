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
});

function fnSearchData() {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.");
        return;
    }
    fnCarPossessChartData();
}

function fnCarPossessChartData() {
    var strSearchYM = "";
    strSearchYM = $("#DateYear").val() + $("#DateMonth").val();

    var strHandlerURL = "/MIS/ExclusiveCar/Proc/CarProssessHandler.ashx";
    var strCallBackFunc = "fnCarDispatchListSuccResult";

    var objParam = {
        CallType        : "CarDispatchList",
        CenterCode      : $("#CenterCode").val(),
        OrderItemCodes: $("#OrderItemCode").val(),
        SearchYM: strSearchYM
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnCarDispatchListSuccResult(objData) {
    if (objData) {
        if (objData[0].data) {
            //오더건수
            var intCarDivTypeCnt = objData[0].data.CarDivTypeCnt;
            var intCarDivType3Cnt = objData[0].data.CarDivType3Cnt;
            var intCarDivType5Cnt = objData[0].data.CarDivType5Cnt;

            //매출
            var intCarDivTypeSale = objData[0].data.CarDivTypeSale;
            var intCarDivType3Sale = objData[0].data.CarDivType3Sale;
            var intCarDivType5Sale = objData[0].data.CarDivType5Sale;

            //매출
            var intCarDivTypePurchase = objData[0].data.CarDivTypePurchase;
            var intCarDivType3Purchase = objData[0].data.CarDivType3Purchase;
            var intCarDivType5Purchase = objData[0].data.CarDivType5Purchase;

            fnCarPossessPerformance(intCarDivTypeCnt, intCarDivType3Cnt, intCarDivType5Cnt, intCarDivTypeSale, intCarDivType3Sale, intCarDivType5Sale, intCarDivTypePurchase, intCarDivType3Purchase, intCarDivType5Purchase);

            if (objData[0].data.list.length > 0) {
                fnAnotherChartList(objData[0].data.list)
            } else {
                fnDefaultAlert("조회 된 데이터가 없습니다.");
                return;
            }
        }
    }
}

function fnCarPossessPerformance(intCarDivTypeCnt, intCarDivType3Cnt, intCarDivType5Cnt, intCarDivTypeSale, intCarDivType3Sale, intCarDivType5Sale, intCarDivTypePurchase, intCarDivType3Purchase, intCarDivType5Purchase) {
    /*원형 그래프 -- 시작*/
    var chart1 = bb.generate({
        data: {
            columns: [
                ["전담차량(" + fnMoneyComma(intCarDivTypeCnt) + "건)", intCarDivTypeCnt],
                ["협력사(" + fnMoneyComma(intCarDivType5Cnt) + "건)", intCarDivType5Cnt],
                ["용차(" + fnMoneyComma(intCarDivType3Cnt) + "건)", intCarDivType3Cnt]
            ],
            type: "pie", // for ESM specify as: pie()
        },
        pie: {
            startingAngle: 1,
            label: {
                ratio: 1.3,
                format: function (value, ratio, id) {
                    return id;
                }
            }
        },
        tooltip: {
            order: "desc",
        },
        bindto: "#OrderCountChart"
    });

    var chart2 = bb.generate({
        data: {
            columns: [
                ["전담차량(" + fnMoneyComma(intCarDivTypeSale) + "원)", intCarDivTypeSale],
                ["협력사(" + fnMoneyComma(intCarDivType5Sale) + "원)", intCarDivType5Sale],
                ["용차(" + fnMoneyComma(intCarDivType3Sale) + "원)", intCarDivType3Sale]
            ],
            type: "pie", // for ESM specify as: pie()
        },
        pie: {
            startingAngle: 1,
            label: {
                ratio: 1.3,
                format: function (value, ratio, id) {
                    return id;
                }
            }
        },
        tooltip: {
            order: "desc"
        },
        bindto: "#SalesChart"
    });

    var chart3 = bb.generate({
        data: {
            columns: [
                ["전담차량(" + fnMoneyComma(intCarDivTypePurchase) + "원)", intCarDivTypePurchase],
                ["협력사(" + fnMoneyComma(intCarDivType5Purchase) + "원)", intCarDivType5Purchase],
                ["용차(" + fnMoneyComma(intCarDivType3Purchase) + "원)", intCarDivType3Purchase]
            ],
            type: "pie", // for ESM specify as: pie()
        },
        pie: {
            startingAngle: 1,
            label: {
                ratio: 1.3,
                format: function (value, ratio, id) {
                    return id;
                }
            }
        },
        tooltip: {
            order: "desc"
        },
        bindto: "#PurchaseChart"
    });
    /*-- 끝*/
}

function fnAnotherChartList(objSes) {
    var ArrayCarDispatchSaleData = new Array();
    var ArrayCarDispatchProfitData = new Array();

    ArrayCarDispatchSaleData[0] = ["x", "전담차량", "협력차량", "단기용차"];
    ArrayCarDispatchProfitData[0] = ["x", "전담차량", "협력차량", "단기용차"];

    for (var i = 0; i < objSes.length; i++) {
        ArrayCarDispatchSaleData[i + 1] = [GetStrMonthFormat(objSes[i].PickupYearMonth, "-") + "-01", objSes[i].SalesProfitAmt, objSes[i].SalesProfitAmt5, objSes[i].SalesProfitAmt3];
        ArrayCarDispatchProfitData[i + 1] = [GetStrMonthFormat(objSes[i].PickupYearMonth, "-") + "-01", objSes[i].ProfitRate, objSes[i].ProfitRate5, objSes[i].ProfitRate3];
    }

    var BarChart = bb.generate({
        padding: {
            bottom: 20
        },
        data: {
            x: "x",
            rows: ArrayCarDispatchSaleData,
            type: "bar"
        }, axis: {
            x: {
                type: "timeseries",
                tick: {
                    culling: false,
                    format: function (x) {
                        return x.getFullYear() + "년\n" + (x.getMonth() + 1) + "월";
                    }
                }
            }
        },
        bar: {
            width: {
                max: 20
            }
        },
        tooltip: {
            format: {
                value: function (x) {
                    return d3.format(",")(x);
                }
            },
        },
        bindto: "#SalesProfitChart"
    });

    var LineChart = bb.generate({
        padding: {
            bottom: 20
        },
        data: {
            x: "x",
            rows: ArrayCarDispatchProfitData,
            type: "line"
        }, axis: {
            x: {
                type: "timeseries",
                tick: {
                    culling: false,
                    format: function (x) {
                        return x.getFullYear() + "년\n" + (x.getMonth() + 1) + "월";
                    }
                }
            }
        },
        bar: {
            width: {
                max: 20,
                ratio: 0.5
            }
        },
        tooltip: {
            format: {
                value: function (x) {
                    return x + "%";
                }
            },
        },
        bindto: "#ProfitRateChart"
     
    });
}

function GetStrMonthFormat(ym, delimiter) {
    if (ym.length === 6) {
        var yy = ym.substring(0, 4);
        var mm = ym.substring(4, 6);
        if (delimiter === null) delimiter = "";
        return yy + delimiter + mm;
    }
    else {
        return ym;
    }
}