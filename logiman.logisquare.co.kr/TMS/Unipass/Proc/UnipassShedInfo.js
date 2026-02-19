$(document).ready(function () {
    // 그리드 초기화
    fnCallShedInfo();
});

function fnCallShedInfo(strGID) {

    var strHandlerURL = "/TMS/Unipass/Proc/UnipassHandler.ashx";
    var strCallBackFunc = "fnGridSuccResult";

    var objParam = {
        CallType: "GetUnipassShedInfo",
        shedSgn: $("#shedSgn").val()
    };
    
    // ajax 요청 전 그리드에 로더 표시
    AUIGrid.showAjaxLoader(strGID);

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, "", "", true);
}

// 그리드 데이터 호출 성공 시 - 사용자 정의(페이지 기능별 수정 필요)
function fnGridSuccResult(objRes) {
    if (objRes) {
        if (objRes[0].Header.ResultCode !== 0) {
            fnDefaultAlert("장치장 정보를 조회하지 못했습니다.(" + objRes[0].ResultMessage + ")");
            return;
        } else {
            if (objRes[0].Payload.Common.tCnt > 0) {
                var item = objRes[0].Payload.List[0];
                $.each($("span"),
                    function (index, input) {
                        if (eval("item." + $(input).attr("id")) != null) {
                            $("#" + $(input).attr("id")).text(eval("item." + $(input).attr("id")));
                        }
                    });

                $("#snartelno").text(addDashToPhoneNumber(item.snartelno));
            } else {
                fnDefaultAlert("장치장 정보가 없습니다.");
                return;
            }
        }
    }
}


function addDashToPhoneNumber(phoneNumber) {
    // 숫자만 남기고 나머지 문자는 제거합니다.
    phoneNumber = phoneNumber.replace(/\D/g, '');

    // 전화번호를 대시로 구분하여 형식을 변경합니다.
    if (phoneNumber.length === 11) {
        var formattedPhoneNumber = phoneNumber.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
    } else if (phoneNumber.length === 10) {
        var formattedPhoneNumber = phoneNumber.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
    } else if (phoneNumber !== "" && phoneNumber.substring(0, 2) === "02" && phoneNumber.length === 9) {
        var formattedPhoneNumber = phoneNumber.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
    } else if (phoneNumber !== "" && phoneNumber.substring(0, 2) === "02" && phoneNumber.length === 10) {
        var formattedPhoneNumber = phoneNumber.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
    }


    

    return formattedPhoneNumber;
}