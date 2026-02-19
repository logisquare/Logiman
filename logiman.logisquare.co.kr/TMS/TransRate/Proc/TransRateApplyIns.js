$(document).ready(function () {

    fnSetInitAutoComplete();

    //독차
    $("#RatioChkY").on("click", function () {
        if ($(this).is(":checked")) {
            $("#HidTransRateFTLYChk").val("Y");
            $("#FtlSPTransSeqNoM").attr("readonly", true);
            $("#FtlPTransSeqNoM").attr("readonly", true);
            $("#FtlPTransSeqNoM").val("");
            $("#FtlPTransSeqNo").val("");
            $("#FtlFixedPurchaseRate").attr("readonly", false);
            $("#FtlPurchaseRate").attr("readonly", false);
            $("#FtlRoundAmtKind option").attr("disabled", false);
            $("#FtlRoundAmtKind").removeClass("read");
            $("#FtlRoundType option").attr("disabled", false);
            $("#FtlRoundType").removeClass("read");
            $("#FtlFixedPurchaseRate").focus();
        } else {
            $("#HidTransRateFTLYChk").val("");
            $("#FtlSPTransSeqNoM").attr("readonly", false);
            $("#FtlPTransSeqNoM").attr("readonly", false);
            $("#FtlFixedPurchaseRate").attr("readonly", true);
            $("#FtlFixedPurchaseRate").val("");
            $("#FtlPurchaseRate").attr("readonly", true);
            $("#FtlPurchaseRate").val("");
            $("#FtlRoundAmtKind").val("");
            $("#FtlRoundAmtKind option").attr("disabled", true);
            $("#FtlRoundAmtKind").addClass("read");
            $("#FtlRoundType").val("");
            $("#FtlRoundType option").attr("disabled", true);
            $("#FtlRoundType").addClass("read");
        }
    });

    //혼적
    $("#RatioChkN").on("click", function () {
        if ($(this).is(":checked")) {
            $("#HidTransRateFTLNChk").val("Y");
            $("#LtlSPTransSeqNoM").attr("readonly", true);
            $("#LtlPTransSeqNo").val("");
            $("#LtlPTransSeqNoM").attr("readonly", true);
            $("#LtlPTransSeqNoM").val("");
            $("#LtlFixedPurchaseRate").attr("readonly", false);
            $("#LtlPurchaseRate").attr("readonly", false);
            $("#LtlRoundAmtKind option").attr("disabled", false);
            $("#LtlRoundAmtKind").removeClass("read");
            $("#LtlRoundType option").attr("disabled", false);
            $("#LtlRoundType").removeClass("read");
            $("#LtlFixedPurchaseRate").focus();
        } else {
            $("#HidTransRateFTLNChk").val("");
            $("#LtlSPTransSeqNoM").attr("readonly", false);
            $("#LtlPTransSeqNoM").attr("readonly", false);
            $("#LtlFixedPurchaseRate").attr("readonly", true);
            $("#LtlFixedPurchaseRate").val("");
            $("#LtlPurchaseRate").attr("readonly", true);
            $("#LtlPurchaseRate").val("");
            $("#LtlRoundAmtKind option").attr("disabled", true);
            $("#LtlRoundAmtKind").addClass("read");
            $("#LtlRoundAmtKind").val("");
            $("#LtlRoundType").val("");
            $("#LtlRoundType option").attr("disabled", true);
            $("#LtlRoundType").addClass("read");
        }
    });

    //적용유가기간
    $("input:radio[name$=OilPeriodType]").on("click", function () {
        if ($(this).val() === "4") {
            $("#OilPrice").attr("readonly", false);
            $("#OilPrice").focus();
        } else {
            $("#OilPrice").attr("readonly", true);
            $("#OilPrice").val("");
            fnDefaultAlertFocus("적용유가를 불러오려면 오른쪽 지역선택 후 확인버튼을 눌러주세요.", "OilSearchArea", "info");
        }
        return false;
    });

    //상품구분
    $("#OrderItemCode").on("change", function () {
        if ($(this).val() === "OA007") { //내수
            $("#DivOrderLocationCode input[type='checkbox']").prop("checked", false);
            $("#DivOrderLocationCode").hide();
        } else { //수출입
            $("#DivOrderLocationCode input[type='checkbox']").prop("checked", false);
            $("#DivOrderLocationCode").show();
        }
    });

    //사업장
    $("#DivOrderLocationCode input[type='checkbox']").on("change", function (e) {
        e.preventDefault();
        var strID = $(this).attr("id");
        var strChkAllID = "";
        strID = strID.substring(0, strID.lastIndexOf("_"));
        strChkAllID = $("label[for^='" + strID + "'] span.ChkAll").parent("label").attr("for");

        if ($(this).attr("id") !== strChkAllID) {
            if ($("input[type='checkbox'][id^='" + strID + "']:not(:disabled):checked").filter(function () { return $(this).attr("id") !== strChkAllID }).length + 1 === $("input[type='checkbox'][id^='" + strID + "']:not(:disabled)").length) {
                $("input[type='checkbox'][id='" + strChkAllID + "']").prop("checked", true);
            } else {
                $("input[type='checkbox'][id='" + strChkAllID + "']").prop("checked", false);
            }
        } else {
            $("input[type='checkbox'][id^='" + strID + "']:not(:disabled)").prop("checked", $(this).is(":checked"));
        }
    });

    if ($("#HidMode").val() === "Update") {
        fnGetTransRateApplyDtl();
        return false;
    }
});

function fnSetInitAutoComplete() {
    //고객사
    if ($("#ClientName").length > 0) {
        fnSetAutocomplete({
            formId: "ClientName",
            width: 500,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
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
                    $("#CenterCode option:not(:selected)").attr("disabled", true);
                    $("#CenterCode").addClass("read");
                    $("#ClientCode").val(ui.item.etc.ClientCode);
                    $("#ClientName").val(ui.item.etc.ClientName);
                    $("#ClientName").attr("readonly", true);
                    $("#ClientCorpNo").val(ui.item.etc.ClientCorpNo);
                    $("#ConsignorName").focus();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("Client", ul, item);
                }
            }
        });
    }

    //화주
    if ($("#ConsignorName").length > 0) {
        fnSetAutocomplete({
            formId: "ConsignorName",
            width: 300,
            useTemplate: false,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
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
                    $("#CenterCode option:not(:selected)").attr("disabled", true);
                    $("#CenterCode").addClass("read");
                    $("#ConsignorCode").val(ui.item.etc.ConsignorCode);
                    $("#ConsignorName").val(ui.item.etc.ConsignorName);
                    $("#ConsignorName").attr("readonly", true);
                    $("#OrderItemCode").focus();
                }
            }
        });
    }

    //요율표 검색 1:매출/매입, 2:매출, 3:매입, 4:추가요율표
    //독차 매출매입
    if ($("#FtlSPTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "FtlSPTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 1,
                    FTLFlag: "Y",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ConsignorName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#FtlSPTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#FtlSPTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#FtlSPTransSeqNoM").attr("readonly", true);
                    $("#FtlSTransSeqNoM").attr("readonly", true);
                    $("#FtlSTransSeqNo").val("");
                    $("#FtlPTransSeqNoM").attr("readonly", true);
                    $("#FtlPTransSeqNo").val("");
                    $("#HidTransRateFTLYChk").val("Y");
                    $("#DivFTLFlagY").hide();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //독차 매출
    if ($("#FtlSTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "FtlSTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 2,
                    FTLFlag: "Y",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ConsignorName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#FtlSTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#FtlSTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#FtlSTransSeqNoM").attr("readonly", true);
                    $("#FtlSPTransSeqNoM").attr("readonly", true);
                    $("#FtlSPTransSeqNoM").val("");
                    $("#FtlSPTransSeqNo").val("");
                    $("#HidTransRateFTLYChk").val("Y");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //독차 매입
    if ($("#FtlPTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "FtlPTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 3,
                    FTLFlag: "Y",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return false;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "ConsignorName", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#FtlPTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#FtlPTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#FtlPTransSeqNoM").attr("readonly", true);
                    $("#FtlSPTransSeqNoM").attr("readonly", true);
                    $("#FtlSPTransSeqNoM").val("");
                    $("#FtlSPTransSeqNo").val("");
                    $("#HidTransRateFTLYChk").val("Y");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //혼적 매출매입
    if ($("#LtlSPTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "LtlSPTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 1,
                    FTLFlag: "N",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "LtlSPTransSeqNoM", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#LtlSPTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#LtlSPTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#LtlSPTransSeqNoM").attr("readonly", true);
                    $("#LtlSTransSeqNoM").attr("readonly", true);
                    $("#LtlSTransSeqNo").val("");
                    $("#LtlPTransSeqNoM").attr("readonly", true);
                    $("#LtlPTransSeqNo").val("");
                    $("#HidTransRateFTLNChk").val("Y");
                    $("#DivFTLFlagN").hide();
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //혼적 매출
    if ($("#LtlSTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "LtlSTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 2,
                    FTLFlag: "N",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "LtlSTransSeqNoM", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#LtlSTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#LtlSTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#LtlSTransSeqNoM").attr("readonly", true);
                    $("#LtlSPTransSeqNoM").attr("readonly", true);
                    $("#LtlSPTransSeqNoM").val("");
                    $("#LtlSPTransSeqNo").val("");
                    $("#HidTransRateFTLNChk").val("Y");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //혼적 매입
    if ($("#LtlPTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "LtlPTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 3,
                    FTLFlag: "N",
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateApplyChk").val() !== "Y") {
                        fnDefaultAlert("고객사 정보 중복확인이 필요합니다.");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "LtlPTransSeqNoM", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#LtlPTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#LtlPTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#LtlPTransSeqNoM").attr("readonly", true);
                    $("#LtlSPTransSeqNoM").attr("readonly", true);
                    $("#LtlSPTransSeqNoM").val("");
                    $("#LtlSPTransSeqNo").val("");
                    $("#HidTransRateFTLNChk").val("Y");
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //추가 요율표 경유지
    if ($("#LayoverTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "LayoverTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 4,
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateFTLYChk").val() !== "Y" && $("#HidTransRateFTLNChk").val() !== "Y") {
                        fnDefaultAlert("기본 요율표(독차 또는 혼적) 정보 입력 후 적용가능합니다.");
                        $("#LayoverTransSeqNoM").val("");
                        $("#LayoverTransSeqNo").val("");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "LayoverTransSeqNoM", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#LayoverTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#LayoverTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#LayoverTransSeqNoM").attr("readonly", true);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }

    //추가 요율표 유가연동
    if ($("#OilTransSeqNoM").length > 0) {
        fnSetAutocomplete({
            formId: "OilTransSeqNoM",
            width: 400,
            callbacks: {
                getUrl: () => {
                    return "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
                },
                getParam: (request, state) => ({
                    CallType: "TransRateList",
                    CenterCode: $("#CenterCode").val(),
                    RateRegKind: 5,
                    TransRateName: request.term,
                    DelFlag: "N",
                    PageSize: state.pageSize,
                    PageNo: state.pageNo
                }),
                beforeSend: (request) => {
                    if (!$("#CenterCode").val()) {
                        fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                        $("#CenterCode").focus();
                        return false;
                    }

                    if ($("#HidTransRateFTLYChk").val() !== "Y" && $("#HidTransRateFTLNChk").val() !== "Y") {
                        fnDefaultAlert("기본 요율표(독차 또는 혼적) 정보 입력 후 적용가능합니다.");
                        $("#OilTransSeqNoM").val("");
                        $("#OilTransSeqNo").val("");
                        return;
                    }

                    if (request.term.legnth < 2) {
                        fnDefaultAlertFocus("검색어를 2자 이상 입력하세요.", "OilTransSeqNoM", "warning");
                        return false;
                    }
                    return true;
                },
                getLabel: (item) => item.TransRateName,
                getValue: (item) => item.TransRateName,
                onSelect: (event, ui) => {
                    $("#OilTransSeqNoM").val(ui.item.etc.TransRateName);
                    $("#OilTransSeqNo").val(ui.item.etc.TransSeqNo);
                    $("#OilTransSeqNoM").attr("readonly", true);
                },
                getTemplate: (ul, item) => {
                    return fnGetAutocompleteTemplate("TransRate", ul, item);
                }
            }
        });
    }
}
//중복확인
function fnTransRateApplyCheck() {

    if (!$("#CenterCode").val()) {
        fnDefaultAlertFocus("회원사를 선택하세요.", "CenterCode", "warning");
        return false;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlertFocus("고객사를 검색하세요.", "ClientName", "warning");
        return false;
    }

    if (!$("#OrderItemCode").val()) {
        fnDefaultAlertFocus("상품을 선택하세요.", "OrderItemCode", "warning");
        return false;
    }

    if ($("#OrderItemCode").val() !== "OA007") {

        var strChkAllID = $("label[for^='OrderLocationCode'] span.ChkAll").parent("label").attr("for");
        var intChkCnt = $("input[type='checkbox'][id^='OrderLocationCode']:checked").filter(function () { return $(this).attr("id") !== strChkAllID }).length;

        if (intChkCnt === 0) {
            fnDefaultAlert("사업장을 선택하세요.");
            return false;
        }
    }

    var objOrderLocationCode = [];
    $.each($("#DivOrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            objOrderLocationCode.push($(el).val());
        }
    });

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnTransRateApplyCheckSuccResult";
    var strFailCallBackFunc = "fnTransRateApplyCheckFailResult";

    var objParam = {
        CallType: "TransRateApplyGet",
        ClientCode: $("#ClientCode").val(),
        CenterCode: $("#CenterCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        OrderLocationCodes: objOrderLocationCode.join(",")
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    return false;
}

function fnTransRateApplyCheckSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].RetCode !== 0) {
            fnTransRateApplyCheckFailResult(objRes[0].ErrMsg);
            return false;
        }

        if (objRes[0].DelFlag === "Y") {
            fnDefaultAlert("사용중지 처리된 적용 내역입니다.", "warning");
            return false;
        }

        if (objRes[0].Exists === "Y") {
            var strMsg = "적용된 내역이 있어, 신규 등록을 진행할 수 없습니다.";
            if (objRes[0].OrderLocationCodes !== "") {
                strMsg += "<br/>(이미 등록된 사업장입니다.)";
                $.each($("#DivOrderLocationCode input[type='checkbox']"), function (index, item) {
                    if ($(item).val() !== "" && objRes[0].OrderLocationCodes.indexOf($(item).val()) > -1) {
                        $(item).prop("checked", false);
                        $(item).attr("disabled", true);
                    }
                });
            }
            fnDefaultAlert(strMsg, "warning");
            return false;
        }

        $("#HidTransRateApplyChk").val("Y");
        $("#CenterCode option:not(:selected)").attr("disabled", true);
        $("#CenterCode").addClass("read");
        $("#ClientName").attr("readonly", true);
        $("#ConsignorName").attr("readonly", true);
        $("#OrderItemCode option:not(:selected)").attr("disabled", true);
        $("#OrderItemCode").addClass("read");
        $("#DivOrderLocationCode .NotAllowed").show();
        $("#BtnApplyCheck").hide();

        fnTransRateApplyDetailOpen();
        fnDefaultAlert("적용된 내역이 없습니다.<br>요율표 적용을 진행주세요.", "info");
        return false;
    } else {
        fnTransRateApplyCheckFailResult();
        return false;
    }
}

function fnTransRateApplyCheckFailResult(msg) {
    fnDetailFailResultAlert(msg);
    return false;
}

//다시입력
function fnTransRateApplyReset() {
    fnTransRateApplyDetailClose();
    $("#HidTransRateApplyChk").val("");
    $("#CenterCode").removeClass("read");
    $("#CenterCode option").attr("disabled", false);
    $("#ClientCode").val("");
    $("#ClientName").val("");
    $("#ClientCorpNo").val("");
    $("#ClientName").attr("readonly", false);
    $("#ConsignorCode").val("");
    $("#ConsignorName").val("");
    $("#ConsignorName").attr("readonly", false);
    $("#OrderItemCode").val("");
    $("#OrderItemCode").removeClass("read");
    $("#OrderItemCode option").attr("disabled", false);
    $("#DivOrderLocationCode input[type='checkbox']").prop("checked", false);
    $("#DivOrderLocationCode .NotAllowed").hide();
    $("#DivOrderLocationCode").hide();
    $("#BtnApplyCheck").show();
    $("#ClientName").focus();
    return false;
}

//상세 열기
function fnTransRateApplyDetailOpen() {
    fnTransRateApplyDetailReset();
    $("#DivTransRateApply").show();
    if ($("#OrderItemCode option:selected").val() != "OA007") { //내수외
        $(".TblFtlN").hide();
        $(".TblLayover").hide();
        $(".TblOil").hide();
    } else {
        $(".TblFtlN").show();
        $(".TblLayover").show();
        $(".TblOil").show();
    }
    return false;
}

//상세 닫기
function fnTransRateApplyDetailClose() {
    fnTransRateApplyDetailReset();
    $("#DivTransRateApply").hide();
    return false;
}

//상세 초기화
function fnTransRateApplyDetailReset() {
    fnTransRateApplyDetailFtlYReset();
    fnTransRateApplyDetailFtlNReset();
    fnTransRateApplyDetailLayoverReset();
    fnTransRateApplyDetailOilReset();
    return false;
}

//상세 - 독차 초기화
function fnTransRateApplyDetailFtlYReset() {
    $("#HidTransRateFTLYChk").val("");
    $("#FtlSPTransSeqNoM").attr("readonly", false);
    $("#FtlSPTransSeqNoM").val("");
    $("#FtlSPTransSeqNo").val("");
    $("#FtlSTransSeqNoM").attr("readonly", false);
    $("#FtlSTransSeqNoM").val("");
    $("#FtlSTransSeqNo").val("");
    $("#FtlPTransSeqNoM").attr("readonly", false);
    $("#FtlPTransSeqNoM").val("");
    $("#FtlPTransSeqNo").val("");
    $("#RatioChkY").prop("checked", false);
    $(".RatioChkY").parents("label").show();
    $("#FtlFixedPurchaseRate").attr("readonly", true);
    $("#FtlFixedPurchaseRate").val("");
    $("#FtlPurchaseRate").attr("readonly", true);
    $("#FtlPurchaseRate").val("");
    $("#FtlRoundAmtKind").val("");
    $("#FtlRoundAmtKind option").attr("disabled", true);
    $("#FtlRoundAmtKind").addClass("read");
    $("#FtlRoundType").val("");
    $("#FtlRoundType option").attr("disabled", true);
    $("#FtlRoundType").addClass("read");
    $("#FtlSPTransSeqNoM").focus();
    $("#DivFTLFlagY").show();
    return false;
}

//상세 - 혼적 초기화
function fnTransRateApplyDetailFtlNReset() {
    $("#HidTransRateFTLNChk").val("");
    $("#LtlSPTransSeqNoM").attr("readonly", false);
    $("#LtlSPTransSeqNoM").val("");
    $("#LtlSPTransSeqNo").val("");
    $("#LtlSTransSeqNoM").attr("readonly", false);
    $("#LtlSTransSeqNoM").val("");
    $("#LtlSTransSeqNo").val("");
    $("#LtlPTransSeqNoM").attr("readonly", false);
    $("#LtlPTransSeqNoM").val("");
    $("#LtlPTransSeqNo").val("");
    $("#RatioChkN").prop("checked", false);
    $(".RatioChkN").parents("label").show();
    $("#LtlFixedPurchaseRate").attr("readonly", true);
    $("#LtlFixedPurchaseRate").val("");
    $("#LtlPurchaseRate").attr("readonly", true);
    $("#LtlPurchaseRate").val("");
    $("#LtlRoundAmtKind").val("");
    $("#LtlRoundAmtKind option").attr("disabled", true);
    $("#LtlRoundAmtKind").addClass("read");
    $("#LtlRoundType").val("");
    $("#LtlRoundType option").attr("disabled", true);
    $("#LtlRoundType").addClass("read");
    $("#DivFTLFlagN").show();
    $("#LtlSPTransSeqNoM").focus();
    return false;
}

//상세 - 경유지 초기화
function fnTransRateApplyDetailLayoverReset() {
    $("#LayoverTransSeqNoM").val("");
    $("#LayoverTransSeqNoM").attr("readonly", false);
    $("#LayoverTransSeqNo").val("");
    $("#LayoverTransSeqNoM").focus();
    return false;
}

//상세 - 유가연동 초기화
function fnTransRateApplyDetailOilReset() {
    $("#OilPeriodType1").prop("checked", true);
    $("#OilPeriodType2").prop("checked", false);
    $("#OilPeriodType3").prop("checked", false);
    $("#OilSearchArea").val("");
    $("#OilPrice").val("");
    $("#OilPrice").attr("readonly", true);
    $("#OilTransSeqNoM").val("");
    $("#OilTransSeqNoM").attr("readonly", false);
    $("#OilTransSeqNo").val("");
    $("#OilGetPlace1").val("");
    $("#OilGetPlace1 option").attr("disabled", false);
    $("#OilGetPlace1").removeClass("read");
    $("#OilGetPlace2").val("");
    $("#OilGetPlace2 option").attr("disabled", false);
    $("#OilGetPlace2").removeClass("read");
    $("#OilGetPlace3").val("");
    $("#OilGetPlace3 option").attr("disabled", false);
    $("#OilGetPlace3").removeClass("read");
    $("#OilSaleRoundAmtKind").val("");
    $("#OilSaleRoundAmtKind option").attr("disabled", false);
    $("#OilSaleRoundAmtKind").removeClass("read");
    $("#OilSaleRoundType").val("");
    $("#OilSaleRoundType option").attr("disabled", false);
    $("#OilSaleRoundType").removeClass("read");
    $("#OilFixedRoundAmtKind").val("");
    $("#OilFixedRoundAmtKind option").attr("disabled", false);
    $("#OilFixedRoundAmtKind").removeClass("read");
    $("#OilFixedRoundType").val("");
    $("#OilFixedRoundType option").attr("disabled", false);
    $("#OilFixedRoundType").removeClass("read");
    $("#OilPurchaseRoundAmtKind").val("");
    $("#OilPurchaseRoundAmtKind option").attr("disabled", false);
    $("#OilPurchaseRoundAmtKind").removeClass("read");
    $("#OilPurchaseRoundType").val("");
    $("#OilPurchaseRoundType option").attr("disabled", false);
    $("#OilPurchaseRoundType").removeClass("read");
    return false;
}

//적용 유가 확인
function fnOilAvgPrioceGet() {
    if (typeof $("input[name$='OilPeriodType']:checked").val() === "undefined") {
        fnDefaultAlert("적용유가를 확인하려면 기간을 선택해주세요.");
        return false;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnOilAvgPrioceGetSuccResult";
    var strFailCallBackFunc = "fnOilAvgPrioceGetFailResult";

    var objParam = {
        CallType: "OilAvgPriceGet",
        OilType: 3,
        OrderItemCode: $("#OrderItemCode").val(),
        AvgType: $("input[name$='OilPeriodType']:checked").val(),
        Sido: $("#OilSearchArea").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnOilAvgPrioceGetSuccResult(objData) {
    if (objData) {
        if (objData[0].RetCode !== 0) {
            fnOilAvgPrioceGetFailResult(objData[0].ErrMsg);
            return false;
        }

        $("#OilPrice").val(objData[0].AvgPrice);
        return false;
    } else {
        fnOilAvgPrioceGetFailResult();
        return false;
    }
}

function fnOilAvgPrioceGetFailResult(msg) {
    fnDetailFailResultAlert(msg);
    return false;
}

//저장
function fnTransRateApplyInsConfirm() {
    var strCallType = "";

    if (!$("#CenterCode").val()) {
        fnDefaultAlert("회원사 정보가 없습니다.");
        return false;
    }

    if (!$("#ClientCode").val()) {
        fnDefaultAlert("고객사 정보가 없습니다.");
        return false;
    }

    if ($("#HidTransRateApplyChk").val() !== "Y") {
        fnDefaultAlert("요율 중복확인 정보가 없습니다.");
        return false;
    }

    if ($("#HidTransRateFTLYChk").val() !== "Y" && $("#HidTransRateFTLNChk").val() !== "Y") {
        fnDefaultAlert("기본요율(독차/혼적) 정보가 없습니다.");
        return false;
    }

    //기본요율-독차
    if ($("#FtlPTransSeqNo").val() && $("#FtlPTransSeqNo").val() !== "0" || $("#RatioChkY").is(":checked")) {
        if ((!$("#FtlSTransSeqNo").val() || $("#FtlSTransSeqNo").val() === "0")) {
            fnDefaultAlertFocus("(기본요율-독차) 매출 요율표 검색 후 적용가능합니다.", "FtlSTransSeqNoM");
            return false;
        }
    }

    if ($("#FtlSTransSeqNo").val() && $("#FtlSTransSeqNo").val() !== "0") {
        if ((!$("#FtlPTransSeqNo").val() || $("#FtlPTransSeqNo").val() === "0") && !$("#RatioChkY").is(":checked")) {
            fnDefaultAlertFocus("(기본요율-독차) 매입 요율표를 검색하거나 비율적용 후 저장할 수 있습니다.", "FtlPTransSeqNoM");
            return false;
        }
    }

    if ($("#RatioChkY").is(":checked")) {
        if (!$("#FtlFixedPurchaseRate").val()) {
            fnDefaultAlertFocus("(기본요율-독차) 고정차 비율을 입력하세요.", "FtlFixedPurchaseRate");
            return false;
        }

        if (!$("#FtlPurchaseRate").val()) {
            fnDefaultAlertFocus("(기본요율-독차) 용차 비율을 입력하세요.", "FtlPurchaseRate");
            return false;
        }

        if (!$("#FtlRoundAmtKind").val()) {
            fnDefaultAlertFocus("(기본요율-독차) 단위를 선택하세요.", "FtlRoundAmtKind");
            return false;
        }

        if (!$("#FtlRoundType").val()) {
            fnDefaultAlertFocus("(기본요율-독차) 단위 조건을 선택하세요.", "FtlRoundType");
            return false;
        }
    }

    //기본요율-혼적
    if (($("#LtlPTransSeqNo").val() && $("#LtlPTransSeqNo").val() !== "0") || $("#RatioChkN").is(":checked")) {
        if ((!$("#LtlSTransSeqNo").val() || $("#LtlSTransSeqNo").val() === "0")) {
            fnDefaultAlertFocus("(기본요율-혼적) 매출 요율표명 검색 후 적용가능합니다.", "LtlSTransSeqNoM");
            return false;
        }
    }

    if ($("#LtlSTransSeqNo").val() && $("#LtlSTransSeqNo").val() !== "0") {
        if ((!$("#LtlPTransSeqNo").val() || $("#LtlPTransSeqNo").val() === "0") && !$("#RatioChkN").is(":checked")) {
            fnDefaultAlertFocus("(기본요율-혼적) 매입 요율표를 검색하거나 비율적용 후 저장할 수 있습니다.", "LtlPTransSeqNoM");
            return false;
        }
    }

    if ($("#RatioChkN").is(":checked")) {
        if (!$("#LtlFixedPurchaseRate").val()) {
            fnDefaultAlertFocus("(기본요율-혼적) 고정차 비율을 입력하세요.", "LtlFixedPurchaseRate");
            return false;
        }

        if (!$("#LtlPurchaseRate").val()) {
            fnDefaultAlertFocus("(기본요율-혼적) 용차 비율을 입력하세요.", "LtlPurchaseRate");
            return false;
        }

        if (!$("#LtlRoundAmtKind").val()) {
            fnDefaultAlertFocus("(기본요율-혼적) 단위를 선택하세요.", "LtlRoundAmtKind");
            return false;
        }

        if (!$("#LtlRoundType").val()) {
            fnDefaultAlertFocus("(기본요율-혼적) 단위 조건을 선택하세요.", "LtlRoundType");
            return false;
        }
    }

    if ($("#HidMode").val() === "Update") {
        strCallType = "TransRateApplyUpd"
    } else {
        strCallType = "TransRateApplyIns"
    }

    fnDefaultConfirm("요율표를 저장하시겠습니까?", "fnTransRateApplyInsConfirmProc", strCallType);
    return false;
}

function fnTransRateApplyInsConfirmProc(strCallType) {

    var objOrderLocationCode = [];
    $.each($("#DivOrderLocationCode input[type='checkbox']:checked"), function (i, el) {
        if ($(el).val() != "") {
            objOrderLocationCode.push($(el).val());
        }
    });

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnTransRateApplyInsConfirmProcSuccResult";
    var strFailCallBackFunc = "fnTransRateApplyInsConfirmProcFailResult";

    var objParam = {
        CallType: strCallType,
        ApplySeqNo: $("#ApplySeqNo").val(),
        ClientCode: $("#ClientCode").val(),
        CenterCode: $("#CenterCode").val(),
        ConsignorCode: $("#ConsignorCode").val(),
        OrderItemCode: $("#OrderItemCode").val(),
        OrderLocationCodes: objOrderLocationCode.join(","),
        FtlSPTransSeqNo: $("#FtlSPTransSeqNo").val(),
        FtlSTransSeqNo: $("#FtlSTransSeqNo").val(),
        FtlPTransSeqNo: $("#FtlPTransSeqNo").val(),
        FtlPRateFlag: $("#RatioChkY").is(":checked") ? "Y" : "N",
        FtlPurchaseRate: $("#FtlPurchaseRate").val(),
        FtlFixedPurchaseRate: $("#FtlFixedPurchaseRate").val(),
        FtlFixedPurchaseRate: $("#FtlFixedPurchaseRate").val(),
        FtlRoundAmtKind: $("#FtlRoundAmtKind").val(),
        FtlRoundType: $("#FtlRoundType").val(),
        LtlSPTransSeqNo: $("#LtlSPTransSeqNo").val(),
        LtlSTransSeqNo: $("#LtlSTransSeqNo ").val(),
        LtlPTransSeqNo: $("#LtlPTransSeqNo").val(),
        LtlPRateFlag: $("#RatioChkN").is(":checked") ? "Y" : "N",
        LtlPurchaseRate: $("#LtlPurchaseRate").val(),
        LtlFixedPurchaseRate: $("#LtlFixedPurchaseRate").val(),
        LtlRoundAmtKind: $("#LtlRoundAmtKind").val(),
        LtlRoundType: $("#LtlRoundType").val(),
        LayoverTransSeqNo: $("#LayoverTransSeqNo").val(),
        OilTransSeqNo: $("#OilTransSeqNo").val(),
        OilPeriodType: $("input[name$='OilPeriodType']:checked").val(),
        OilSearchArea: $("#OilSearchArea").val(),
        OilPrice: $("#OilPrice").val(),
        OilGetPlace1: $("#OilGetPlace1").val(),
        OilGetPlace2: $("#OilGetPlace2").val(),
        OilGetPlace3: $("#OilGetPlace3").val(),
        OilGetPlace4: $("#OilGetPlace4").val(),
        OilGetPlace5: $("#OilGetPlace5").val(),
        OilSaleRoundAmtKind: $("#OilSaleRoundAmtKind").val(),
        OilSaleRoundType: $("#OilSaleRoundType").val(),
        OilPurchaseRoundAmtKind: $("#OilPurchaseRoundAmtKind").val(),
        OilPurchaseRoundType: $("#OilPurchaseRoundType").val(),
        OilFixedRoundAmtKind: $("#OilFixedRoundAmtKind").val(),
        OilFixedRoundType: $("#OilFixedRoundType").val()
    };

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
}

function fnTransRateApplyInsConfirmProcSuccResult(objData) {
    if (objData) {
        if (objData[0].RetCode !== 0) {
            fnTransRateApplyInsConfirmProcFailResult(objData[0].ErrMsg);
            return false;

        }

        fnDefaultAlert("저장되었습니다.", "success", "fnTransRateApplyLocation", objData[0].ApplySeqNo);
        return false;
    } else {
        fnTransRateApplyInsConfirmProcFailResult();
        return false;
    }
}

function fnTransRateApplyInsConfirmProcFailResult(msg) {
    fnDetailFailResultAlert(msg);
    return false;
}

function fnTransRateApplyLocation(ApplySeqNo) {;
    if ($("#CenterCode", window.parent.document.body).val()) {
        parent.fnCallGridData("#TransRateListGrid");
    }
    document.location.replace("/TMS/TransRate/TransRateApplyIns?HidMode=Update&ApplySeqNo=" + ApplySeqNo);
    return false;
}

//적용관리 상세정보 조회
function fnGetTransRateApplyDtl() {
    if (!$("#ApplySeqNo").val()) {
        return false;
    }

    var strHandlerURL = "/TMS/TransRate/Proc/TransRateApplyHandler.ashx";
    var strCallBackFunc = "fnGetTransRateApplyDtlSuccResult";
    var strFailCallBackFunc = "fnGetTransRateApplyDtlFailResult";

    var objParam = {
        CallType: "TransRateApplyList",
        ApplySeqNo: $("#ApplySeqNo").val()
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", false);
    return false;
}

function fnGetTransRateApplyDtlSuccResult(objRes) {
    if (objRes) {

        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnGetTransRateApplyDtlFailResult(objRes[0].ErrMsg);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode) {
            if (objRes[0].result.ErrorCode !== 0) {
                fnGetTransRateApplyDtlFailResult(objRes[0].result.ErrorMsg);
                return false;
            }
        }

        if (objRes[0].data.RecordCnt !== 1) {
            fnGetTransRateApplyDtlFailResult();
            return false;
        }

        var item = objRes[0].data.list[0];

        //hidden
        $.each($("input[type='hidden']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //textbox
        $.each($("input[type='text']"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                }
            });

        //select
        $.each($("select"),
            function (index, input) {
                if (eval("item." + $(input).attr("id")) != null) {
                    if ($("#" + $(input).attr("id") + " option[value='" + eval("item." + $(input).attr("id")) + "']").length > 0) {
                        $("#" + $(input).attr("id")).val(eval("item." + $(input).attr("id")));
                    }
                }
            });

        if (Number(item.FtlSPTransSeqNo) !== 0 || Number(item.FtlSTransSeqNo) !== 0 || Number(item.FtlPTransSeqNo) !== 0) {
            $("#HidTransRateFTLYChk").val("Y");
        }

        if (Number(item.LtlSPTransSeqNo) !== 0 || Number(item.LtlSTransSeqNo) !== 0 || Number(item.LtlPTransSeqNo) !== 0) {
            $("#HidTransRateFTLNChk").val("Y");
        }

        if (item.FtlPRateFlag === "Y") {
            $("#RatioChkY").prop("checked", true);
        } else {
            $("#RatioChkY").prop("checked", false);
        }

        if (item.LtlPRateFlag === "Y") {
            $("#RatioChkN").prop("checked", true);
        } else {
            $("#RatioChkN").prop("checked", false);
        }

        //고객사 정보
        $("#HidTransRateApplyChk").val("Y");
        $("#CenterCode option:not(:selected)").attr("disabled", true);
        $("#CenterCode").attr("readonly", true);
        $("#CenterCode").addClass("read");
        $("#ClientName").attr("readonly", true);
        $("#ConsignorName").attr("readonly", true);
        $("#OrderItemCode option:not(:selected)").attr("disabled", true);
        $("#OrderItemCode").addClass("read");
        $("#DivTransRateApplyClient").remove();

        //요율표적용
        $("#FtlSPTransSeqNoM").attr("readonly", true);
        $("#FtlSTransSeqNoM").attr("readonly", true);
        $("#FtlPTransSeqNoM").attr("readonly", true);
        $("#FtlRoundAmtKind option:not(:selected)").attr("disabled", true);
        $("#FtlRoundAmtKind").addClass("read");
        $("#FtlRoundType option:not(:selected)").attr("disabled", true);
        $("#FtlRoundType").addClass("read");

        $("#LtlSPTransSeqNoM").attr("readonly", true);
        $("#LtlSTransSeqNoM").attr("readonly", true);
        $("#LtlPTransSeqNoM").attr("readonly", true);
        $("#LtlRoundAmtKind option:not(:selected)").attr("disabled", true);
        $("#LtlRoundAmtKind").addClass("read");
        $("#LtlRoundType option:not(:selected)").attr("disabled", true);
        $("#LtlRoundType").addClass("read");

        $(".RatioChkY").parents("label").hide();
        $(".RatioChkN").parents("label").hide();

        $("#DivTransRateApply").show();

        //추가요율표 경유지
        $("#LayoverTransSeqNoM").attr("readonly", true);

        //추가요율표 유가연동
        $("#OilTransSeqNoM").attr("readonly", true);
        $("#OilGetPlace1 option:not(:selected)").attr("disabled", true);
        $("#OilGetPlace1").addClass("read");
        $("#OilGetPlace2 option:not(:selected)").attr("disabled", true);
        $("#OilGetPlace2").addClass("read");
        $("#OilGetPlace3 option:not(:selected)").attr("disabled", true);
        $("#OilGetPlace3").addClass("read");

        $("#OilSaleRoundAmtKind option:not(:selected)").attr("disabled", true);
        $("#OilSaleRoundType option:not(:selected)").attr("disabled", true);
        $("#OilFixedRoundAmtKind option:not(:selected)").attr("disabled", true);
        $("#OilFixedRoundType option:not(:selected)").attr("disabled", true);
        $("#OilPurchaseRoundAmtKind option:not(:selected)").attr("disabled", true);
        $("#OilPurchaseRoundType option:not(:selected)").attr("disabled", true);

        $("#OilSaleRoundAmtKind").addClass("read");
        $("#OilSaleRoundType").addClass("read");
        $("#OilFixedRoundAmtKind").addClass("read");
        $("#OilFixedRoundType").addClass("read");
        $("#OilPurchaseRoundAmtKind").addClass("read");
        $("#OilPurchaseRoundType").addClass("read");

        if ($("#OrderItemCode").val() !== "OA007") {
            $("#DivOrderLocationCode").show();
            $(".TblFtlN").hide();
            $(".TblLayover").hide();
            $(".TblOil").hide();
            $.each($("#DivOrderLocationCode input[type='checkbox']"), function (index, chkItem) {
                if ($(chkItem).val() !== "") {
                    if (item.OrderLocationCodes.indexOf($(chkItem).val()) > -1) {
                        $(chkItem).prop("checked", true);
                    }

                    if (item.RegOrderLocationCodes.indexOf($(chkItem).val()) > -1) {
                        $(chkItem).prop("checked", false);
                        $(chkItem).attr("disabled", true);
                    }
                }
            });
        }

        return false;
    } else {
        fnGetTransRateApplyDtlFailResult();
        return false;
    }
}

function fnGetTransRateApplyDtlFailResult(msg) {
    fnDetailFailResultReload(msg);
    return false;
}

function fnDetailFailResultReload(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    parent.fnReloadPageNotice("일시적인 오류가 발생했습니다." + (msg == "" ? "" : ("<br>(" + msg + ")")), "error");
    return false;
}

function fnDetailFailResultAlert(msg) {
    if (typeof msg !== "string") {
        msg = "";
    }
    fnDefaultAlert("일시적인 오류가 발생했습니다." + (msg == "" ? "" : ("<br>(" + msg + ")")), "error");
    return false;
}