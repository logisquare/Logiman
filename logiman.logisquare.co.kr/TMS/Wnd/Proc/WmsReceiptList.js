$(document).ready(function () {
    fnSetInitData();
});

//기본 설정
function fnSetInitData() {
    var strHandlerURL = "/TMS/Wnd/Proc/WmsHandler.ashx";
    var strCallBackFunc = "fnSetOrderDispatchFileList";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "WmsOrderReceiptList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        DeliveryNo: $("#DeliveryNo").val(),
        ReceiptType: $("#ReceiptType").val(),
        PageSize : "100",
        PageNo : "1"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, true, strFailCallBackFunc, "", true);
}

function fnSetOrderDispatchFileList(objRes) {

    var FileDomain = $("#HidFileUrl").val();
    var strDispatch = "";
    var strLayover = "";

    if (objRes) {
        if (objRes[0].RetCode) {
            if (objRes[0].RetCode !== 0) {
                fnCallDetailFailResult(objRes);
                return false;
            }
        }

        if (objRes[0].result.ErrorCode !== 0) {
            fnCallDetailFailResult(objRes);
            return false;
        }

        if (objRes[0].data.DispatchFileRecordCnt > 0) {
            $("#DispatchList").show();

            $.each(objRes[0].data.DispatchFileList, function (index, item) {
                strDispatch += "<li>";
                strDispatch += "<img src=" + FileDomain + item.FileDir + "/" + item.FileNameNew + ">";
                strDispatch += "<span class='ImageOpen' title='새창으로 보기' onclick='fnOpenImage(this); return false;'></span>";
                strDispatch += "<span class='ImageDownload' title='다운로드' onclick='fnDownloadImage(this); return false;'></span>";
                strDispatch += "</li>";
                $("#PickupYMD").val(item.PickupYMD);
                $("#ConsignorName").val(item.ConsignorName);
            });
            $("#DispatchList ul").append(strDispatch);
        }

        if (objRes[0].data.LayoverFileRecordCnt > 0) {
            $("#LayoverList").show();

            $.each(objRes[0].data.LayoverFileList, function (index, item) {
                strLayover += "<li>";
                strLayover += "<img src=" + FileDomain + item.FileDir + "/" + item.FileNameNew + ">";
                strLayover += "<span class='ImageOpen' title='새창으로 보기' onclick='fnOpenImage(this); return false;'></span>";
                strLayover += "<span class='ImageDownload' title='다운로드' onclick='fnDownloadImage(this); return false;'></span>";
                strLayover += "</li>";

                $("#PickupYMD").val(item.PickupYMD);
                $("#ConsignorName").val(item.ConsignorName);
            });
            $("#LayoverList ul").append(strLayover);
        }
    }
}

function fnCallDetailFailResult(objRes) {
    console.log(objRes);
}

function fnOpenImage(obj) {
    if ($(obj).parent("li").children("img").length > 0) {
        var imgUrl = $(obj).parent("li").children("img").attr("src");
        window.open(imgUrl, "증빙이미지보기", "width=800px, height=500px, scrollbars=Yes");
    }
}

function fnDownloadImage(obj) {
    if ($(obj).parent("li").children("img").length === 0) {
        return false;
    }

    var strUrl = $(obj).parent("li").children("img").attr("src");
    var strFileName = $("#PickupYMD").val() + "_" + $("#ConsignorName").val();

    strFileName = strFileName === "_" ? strUrl.substring(strUrl.lastIndexOf("."), strUrl.length) : strFileName;
    
    var objParam = {
        CallType: "WmsOrderReceiptFileDownload",
        FileUrl: strUrl,
        FileName: strFileName
    }

    $.fileDownload("/TMS/Wnd/Proc/WmsHandler.ashx", {
        httpMethod: "POST",
        data: objParam,
        prepareCallback: function () {
            UTILJS.Ajax.fnAjaxBlock();
        },
        successCallback: function (url) {
            $.unblockUI();
            fnDefaultAlert("증빙파일을 다운로드 하였습니다.", "success");
            return false;
        },
        failCallback: function (html, url) {
            $.unblockUI();
            fnDefaultAlert("증빙파일 다운로드에 실패했습니다.<br>나중에 다시 시도해 주세요.");
            return false;
        }
    });
}
