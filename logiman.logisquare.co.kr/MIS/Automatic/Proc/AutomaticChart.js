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


function fnSearchData(type) {
    if ($("#CenterCode").val() === "") {
        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode");
        return;
    }

    if (type === "M") {
        if (Number($("#PreMonFromYMD").val()) > Number($("#SelMonToYMD").val().replace(/-/gi, ""))) {
            fnDefaultAlertFocus("전월 날짜 시작일보다 이전 날짜는 선택 할 수 없습니다.", "SelMonToYMD");
            return;
        }
    }

    var DateFrom = new Date($("#DateFrom").val());
    var DateTo = new Date($("#DateTo").val());
    var PreFrom = getFormatDate(new Date(DateFrom.getFullYear(), DateFrom.getMonth() - 1, DateFrom.getDate()));
    var PreTo = getFormatDate(new Date(DateTo.getFullYear(), DateTo.getMonth() - 1, DateTo.getDate()));
    if (type !== "M") {
        $("#PreMonFromYMD").val(PreFrom);
        $("#PreMonToYMD").val(PreTo);
        $("#SelMonToYMD").val(PreTo);
    } else {
        $("#PreMonToYMD").val($("#SelMonToYMD").val().replace(/-/gi, ""));
    }
    

    var strHandlerURL = "/MIS/Automatic/Proc/AutomaticHandler.ashx";
    var strCallBackFunc = "fnChartSuccResult";

    var objParam = {
        CallType: "AutomaticSummaryList",
        CenterCode: $("#CenterCode").val(),
        DateFrom: $("#DateFrom").val(),
        DateTo: $("#DateTo").val(),
        PreMonFromYMD: PreFrom,
        PreMonToYMD: type !== "M" ? PreTo : $("#SelMonToYMD").val().replace(/-/gi, ""),
        SearchType: $("#SearchType").val(),
        SearchText: $("#SearchText").val(),
        OrderItemCodes: $("#OrderItemCode").val()
    };
    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, "", "", true);
}

function fnChartSuccResult(objData) {
    if (objData) {
        if (objData[0].data.list.length > 0) {
            fnAutomaticPieChart(objData[0].data.list[0], objData[0].data.PreWeekFromYMD, objData[0].data.PreWeekToYMD);
            fnAutomaticBarChart(objData[0].data.list[0], objData[0].data.PreWeekFromYMD, objData[0].data.PreWeekToYMD);
        } else {
            fnDefaultAlert("조회된 데이터가 없습니다.");
            return;
        }
    }
    
    
}

function fnAutomaticPieChart(item, PreWeekFromYMD, PreWeekToYMD) {
    /*선택한 일자*/
    var AppliedOrderCnt = item.AppliedOrderCnt; //적용 오더 건수
    var AppliedOrderRate = item.AppliedOrderRate; //적용오더울 
    var AppliedProfitRate = item.AppliedProfitRate; //적용이익률
    var AppliedPurchaseSupplyAmt = item.AppliedPurchaseSupplyAmt; //적용매입금액
    var AppliedSaleSupplyAmt = item.AppliedSaleSupplyAmt;//적용매출금액

    var UnappliedOrderCnt = item.UnappliedOrderCnt; //미적용 오더 건수
    var UnappliedOrderRate = item.UnappliedOrderRate; //미적용오더울
    var UnappliedProfitRate = item.UnappliedProfitRate; //미적용이익률
    var UnappliedPurchaseSupplyAmt = item.UnappliedPurchaseSupplyAmt; //미적용매입금액
    var UnappliedSaleSupplyAmt = item.UnappliedSaleSupplyAmt;//미적용매출금액
    /*전주 일자*/
    var PreWOrderCnt = item.PreWOrderCnt; //전주 적용 오더 건수
    var PreWAppliedOrderCnt = item.PreWAppliedOrderCnt; //전주 적용오더울
    var PreWAppliedOrderRate = item.PreWAppliedOrderRate; //전주 적용이익률
    var PreWAppliedProfitRate = item.PreWAppliedProfitRate; //전주 적용이익률
    var PreWAppliedPurchaseSupplyAmt = item.PreWAppliedPurchaseSupplyAmt; //전주 적용매입금액
    var PreWAppliedSaleSupplyAmt = item.PreWAppliedSaleSupplyAmt;//전주 적용매출금액

    var PreWUnappliedOrderCnt = item.PreWUnappliedOrderCnt; //전주 미적용 오더 건수
    var PreWUnappliedOrderRate = item.PreWUnappliedOrderRate; //전주 미적용오더울
    var PreWUnappliedProfitRate = item.PreWUnappliedProfitRate; //전주 미적용이익률
    var PreWUnappliedPurchaseSupplyAmt = item.PreWUnappliedPurchaseSupplyAmt; //전주 미적용매입금액
    var PreWUnappliedSaleSupplyAmt = item.PreWUnappliedSaleSupplyAmt;//전주 미적용매출금액
    /*전월 일자*/
    var PreMOrderCnt = item.PreWOrderCnt; //전월 적용 오더 건수
    var PreMAppliedOrderCnt = item.PreMAppliedOrderCnt; //전월 적용오더울
    var PreMAppliedOrderRate = item.PreMAppliedOrderRate; //전월 적용이익률
    var PreMAppliedProfitRate = item.PreMAppliedProfitRate; //전월 적용이익률
    var PreMAppliedPurchaseSupplyAmt = item.PreMAppliedPurchaseSupplyAmt; //전월 적용매입금액
    var PreMAppliedSaleSupplyAmt = item.PreMAppliedSaleSupplyAmt;//전월 적용매출금액

    var PreMUnappliedOrderCnt = item.PreMUnappliedOrderCnt; //전월 미적용 오더 건수
    var PreMUnappliedOrderRate = item.PreMUnappliedOrderRate; //전월 미적용오더울
    var PreMUnappliedProfitRate = item.PreMUnappliedProfitRate; //전월 미적용이익률
    var PreMUnappliedPurchaseSupplyAmt = item.PreMUnappliedPurchaseSupplyAmt; //전월 미적용매입금액
    var PreMUnappliedSaleSupplyAmt = item.PreMUnappliedSaleSupplyAmt;//전월 미적용매출금액

    var PreWOrderRate = AppliedOrderRate - PreWAppliedOrderRate;
    var PreMOrderRate = AppliedOrderRate - PreMAppliedOrderRate;
    PreWOrderRate = PreWOrderRate.toFixed(1);
    PreMOrderRate = PreMOrderRate.toFixed(1);

    /*********************/
    /*자동운임 전체 적용현황*/
    /*********************/
    var chart1 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            columns: [
                ["적용 : " + fnMoneyComma(AppliedOrderCnt) + "건, " + AppliedOrderRate + "%", AppliedOrderCnt],
                ["미적용 : " + fnMoneyComma(UnappliedOrderCnt) + "건, " + UnappliedOrderRate + "%", UnappliedOrderCnt]
            ],
            type: "donut", // for ESM specify as: donut()
        },
        donut: {
            startingAngle: 1,
            label: {
                ratio: 1.5,
                format: function (value, ratio, id) {
                    return fnMoneyComma(value) + "건";
                }
            }
        },
        bindto: "#PieChartSelectedDate"
    });
    //----------------------

    /*********************/
    /*자동운임 전주 적용현황*/
    /*********************/
    var chart2 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            columns: [
                ["적용 : " + fnMoneyComma(PreWAppliedOrderCnt) + "건, " + PreWAppliedOrderRate + "%", PreWAppliedOrderCnt],
                ["미적용 : " + fnMoneyComma(PreWUnappliedOrderCnt) + "건, " + PreWUnappliedOrderRate + "%", PreWUnappliedOrderCnt]
            ],
            type: "donut", // for ESM specify as: donut()
        },
        donut: {
            startingAngle: 1,
            label: {
                ratio: 1.5,
                format: function (value, ratio, id) {
                    return fnMoneyComma(value) + "건";
                }
            }
        },
        bindto: "#PieChartLastWeekDate"
    });
    
    //----------------------

    /*********************/
    /*자동운임 전월 적용현황*/
    /*********************/
    var chart3 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            columns: [
                ["적용 : " + fnMoneyComma(PreMAppliedOrderCnt) + "건, " + PreMAppliedOrderRate + "%", PreMAppliedOrderCnt],
                ["미적용 : " + fnMoneyComma(PreMUnappliedOrderCnt) + "건, " + PreMUnappliedOrderRate + "%", PreMUnappliedOrderCnt]
            ],
            type: "donut", // for ESM specify as: donut()
        },
        donut: {
            startingAngle: 1,
            label: {
                ratio: 1.5,
                format: function (value, ratio, id) {
                    return fnMoneyComma(value) + "건";
                }
            }
        },
        bindto: "#PieChartLastMonthDate"
    });
    $(".SelectedDate").text("선택 기간 : " + $("#DateFrom").val() + " ~ " + $("#DateTo").val());
    $(".preWDate").text("선택 기간 전주 : " + fnGetStrDateFormat(PreWeekFromYMD, "-") + " ~ " + fnGetStrDateFormat(PreWeekToYMD, "-"));
    $(".preMDateSearch").html("선택 기간 전월 : " + fnGetStrDateFormat($("#PreMonFromYMD").val(), "-") + " ~ " + "<input type=\"text\" class=\"type_01 date\" id=\"SelMonToYMD\"><button type=\"button\" class=\"btn_01\" onclick=\"fnSearchData('M');\">조회</button>");
    $(".preMDate").text("선택 기간 전월 : " + fnGetStrDateFormat($("#PreMonFromYMD").val(), "-") + " ~ " + fnGetStrDateFormat($("#PreMonToYMD").val(), "-"));
    $("#RateTextData").html("전주 대비 적용률 : <span " + (PreWOrderRate < 0 ? "class='minus'" : "") + ">" + PreWOrderRate + "%</span> | 전월 대비 적용률 : <span " + (PreMOrderRate < 0 ? "class='minus'" : "") + ">" + PreMOrderRate + "%</span>");
    $("#SelMonToYMD").datepicker({
        dateFormat: "yy-mm-dd",
        //beforeShowDay: fnGetStrDateFormat($("#PreMonFromYMD").val(), "-")
    });
    $("#SelMonToYMD").datepicker("setDate", fnGetStrDateFormat($("#PreMonToYMD").val(), "-"));
    //----------------------
}

function noBefore(date) {
    if (date < new Date())
        return [false];
    return [true];
}

function fnAutomaticBarChart(item) {
    //선택월 적용
    var AppliedPurchaseSupplyAmt = item.AppliedPurchaseSupplyAmt;
    var AppliedSaleSupplyAmt = item.AppliedSaleSupplyAmt;
    var AppliedProfitRate = item.AppliedProfitRate;
    //선택월 미적용
    var UnappliedPurchaseSupplyAmt = item.UnappliedPurchaseSupplyAmt;
    var UnappliedSaleSupplyAmt = item.UnappliedSaleSupplyAmt;
    var UnappliedProfitRate = item.UnappliedProfitRate;
    //전주 적용
    var PreWAppliedPurchaseSupplyAmt = item.PreWAppliedPurchaseSupplyAmt;
    var PreWAppliedSaleSupplyAmt = item.PreWAppliedSaleSupplyAmt;
    var PreWAppliedProfitRate = item.PreWAppliedProfitRate;
    //전주 미적용
    var PreWUnappliedPurchaseSupplyAmt = item.PreWUnappliedPurchaseSupplyAmt;
    var PreWUnappliedSaleSupplyAmt = item.PreWUnappliedSaleSupplyAmt;
    var PreWUnappliedProfitRate = item.PreWUnappliedProfitRate;
    //전주 적용
    var PreMAppliedPurchaseSupplyAmt = item.PreMAppliedPurchaseSupplyAmt;
    var PreMAppliedSaleSupplyAmt = item.PreMAppliedSaleSupplyAmt;
    var PreMAppliedProfitRate = item.PreMAppliedProfitRate;
    //전주 미적용
    var PreMUnappliedPurchaseSupplyAmt = item.PreMUnappliedPurchaseSupplyAmt;
    var PreMUnappliedSaleSupplyAmt = item.PreMUnappliedSaleSupplyAmt;
    var PreMUnappliedProfitRate = item.PreMUnappliedProfitRate;

    //적용오더
    var PreWRate = AppliedProfitRate - PreWAppliedProfitRate;
    var PreMRate = AppliedProfitRate - PreMAppliedProfitRate;

    //미적용오더
    var PreWUnRate = UnappliedProfitRate - PreWUnappliedProfitRate;
    var PreMUnRate = UnappliedProfitRate - PreMUnappliedProfitRate;

    /**********************/
    /*자동운임 전체 오더현황*/
    /**********************/
    var chart1 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더", "미적용 오더"],
                ["매출(적용)", AppliedSaleSupplyAmt, null],
                ["매입(적용)", AppliedPurchaseSupplyAmt, null],
                ["매출(미적용)", null, UnappliedSaleSupplyAmt],
                ["매입(미적용)", null, UnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartSelectedDate"
    });

    var chart2 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더", "미적용 오더"],
                ["매출(적용)", PreWAppliedSaleSupplyAmt, null],
                ["매입(적용)", PreWAppliedPurchaseSupplyAmt, null],
                ["매출(미적용)", null, PreWUnappliedSaleSupplyAmt],
                ["매입(미적용)", null, PreWUnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartLastWeekDate"
    });

    var chart3 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더", "미적용 오더"],
                ["매출(적용)", PreMAppliedSaleSupplyAmt, null],
                ["매입(적용)", PreMAppliedPurchaseSupplyAmt, null],
                ["매출(미적용)", null, PreMUnappliedSaleSupplyAmt],
                ["매입(미적용)", null, PreMUnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartLastMonthDate"
    });

    $(".rate_data1").html("수익률(적용) : <span " + (AppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + AppliedProfitRate.toFixed(1) + "%</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수익률(미적용) : <span " + (UnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + UnappliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_data2").html("수익률(적용) : <span " + (PreWAppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWAppliedProfitRate.toFixed(1) + "%</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수익률(미적용) : <span " + (PreWUnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWUnappliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_data3").html("수익률(적용) : <span " + (PreMAppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMAppliedProfitRate.toFixed(1) + "%</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수익률(미적용) : <span " + (PreMUnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMUnappliedProfitRate.toFixed(1) + "%</span>");
    var strBarTextData = "";
    strBarTextData += "<strong>적용오더 - </strong> 전주 대비 수익률: <span " + (PreWRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWRate.toFixed(1) + "%</span> | 전월 대비 수익률: <span " + (PreMRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMRate.toFixed(1) + "%</span>"
    strBarTextData += "<br/>";
    strBarTextData += "<strong>미 적용오더 - </strong> 전주 대비 수익률: <span " + (PreWUnRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWUnRate.toFixed(1) + "%</span> | 전월 대비 수익률: <span " + (PreMUnRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMUnRate.toFixed(1) + "%</span>";
    $("#BarRateTextData").html(strBarTextData);

    /**********************/
    /*자동운임 적용 오더현황*/
    /**********************/
    var chart4 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더"],
                ["매출", AppliedSaleSupplyAmt],
                ["매입", AppliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartAppliedSelectedDate"
    });
    $("#BarAppliedRateTextData").html("전주 대비 수익률: <span " + (PreWRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWRate.toFixed(1) + "%</span> | 전월 대비 수익률: <span " + (PreMRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMRate.toFixed(1) + "%</span>");
    $(".rate_applied_data1").html("수익률(적용) : <span " + (AppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + AppliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_applied_data2").html("수익률(적용) : <span " + (PreWAppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWAppliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_applied_data3").html("수익률(적용) : <span " + (PreMAppliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMAppliedProfitRate.toFixed(1) + "%</span>");

    var chart5 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더"],
                ["매출", PreWAppliedSaleSupplyAmt],
                ["매입", PreWAppliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartAppliedLastWeekDate"
    });

    var chart6 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "적용 오더"],
                ["매출", PreMAppliedSaleSupplyAmt],
                ["매입", PreMAppliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartAppliedLastMonthDate"
    });

    /**********************/
    /*자동운임 미적용 오더현황*/
    /**********************/
    var chart7 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "미적용 오더"],
                ["매출", UnappliedSaleSupplyAmt],
                ["매입", UnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartUnAppliedSelectedDate"
    });

    var chart8 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "미적용 오더"],
                ["매출", PreWUnappliedSaleSupplyAmt],
                ["매입", PreWUnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartUnAppliedLastWeekDate"
    });

    var chart9 = bb.generate({
        padding: {
            bottom: 30
        },
        data: {
            x: "x",
            columns: [
                ["x", "미적용 오더"],
                ["매출", PreMUnappliedSaleSupplyAmt],
                ["매입", PreMUnappliedPurchaseSupplyAmt]
            ],
            type: "bar", // for ESM specify as: line()
        },
        axis: {
            x: {
                type: "category"
            },
            y: {
                tick: {
                    format: function (d) {
                        return d.toLocaleString() + "원"; // 콤마로 구분된 문자열로 변환
                    }
                }
            }
        },
        bindto: "#BarChartUnAppliedLastMonthDate"
    });

    $("#BarUnAppliedRateTextData").html("전주 대비 수익률: <span " + (PreWUnRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWUnRate.toFixed(1) + "%</span> | 전월 대비 수익률 : <span " + (PreMUnRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMUnRate.toFixed(1) + "%</span>");
    $(".rate_unapplied_data1").html("수익률(미적용) : <span " + (UnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + UnappliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_unapplied_data2").html("수익률(미적용) : <span " + (PreWUnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreWUnappliedProfitRate.toFixed(1) + "%</span>");
    $(".rate_unapplied_data3").html("수익률(미적용) : <span " + (PreMUnappliedProfitRate.toFixed(1) < 0 ? "class='minus'" : "") + ">" + PreMUnappliedProfitRate.toFixed(1) + "%</span>");
}

function getFormatDate(date) {
    var year = date.getFullYear();              //yyyy
    var month = (1 + date.getMonth());          //M
    month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
    var day = date.getDate();                   //d
    day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
    return year + '' + month + '' + day;       //'-' 추가하여 yyyy-mm-dd 형태 생성 가능
}

function fnChartLayerMove(n, obj) {
    $(".sec" + n).toggleClass("on", function () {
        if ($(".sec" + n).hasClass("on") === true) {
            $(".sec" + n).css("height", "0px");
            $(".img" + n).attr("src", "/images/icon/down_arr.png");
        } else {
            $(".sec" + n).css("height", "");
            $(".img" + n).attr("src", "/images/icon/up_arr.png");
        }
    });
}