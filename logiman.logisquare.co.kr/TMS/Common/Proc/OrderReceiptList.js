$(document).ready(function () {
    fnSetInitData();
});

//기본 설정
function fnSetInitData() {
    var strHandlerURL = "/TMS/Common/Proc/OrderReceiptListHandler.ashx";
    var strCallBackFunc = "fnSetOrderDispatchFileList";
    var strFailCallBackFunc = "fnCallDetailFailResult";

    var objParam = {
        CallType: "OrderReceiptList",
        CenterCode: $("#CenterCode").val(),
        OrderNo: $("#OrderNo").val(),
        DispatchSeqNo: $("#DispatchSeqNo").val(),
        PageSize : "3000",
        PageNo : "1"
    }

    UTILJS.Ajax.fnHandlerRequest(objParam, strHandlerURL, strCallBackFunc, false, strFailCallBackFunc, "", false);
}

function fnSetOrderDispatchFileList(objRes) {
    
    var FileDomain = $("#HidFileUrl").val();
    var strPickup = "";
    var strGet = "";
    var strReceipt = "";
    if (objRes) {
        if (objRes[0].data.list.length > 0) {
            $("#PickupYMD").val(objRes[0].data.list[0].PickupYMD);
            $("#ConsignorName").val(objRes[0].data.list[0].ConsignorName);

            for (var i = 0; i < objRes[0].data.list.length; i++) {
                if (objRes[0].data.list[i].FileGubun === 1) {
                    strPickup += "<li>";
                    strPickup += "<img src=" + FileDomain + objRes[0].data.list[i].FileDir + "/" + objRes[0].data.list[i].FileNameNew + ">";
                    strPickup += "<span class='ImageOpen' title='새창으로 보기' onclick='fnOpenImage(this); return false;'></span>";
                    strPickup += "<span class='ImageDownload' title='다운로드' onclick='fnDownloadImage(this); return false;'></span>";
                    strPickup += "</li>";
                }
                if (objRes[0].data.list[i].FileGubun === 2) {
                    strGet += "<li>";
                    strGet += "<img src=" + FileDomain + objRes[0].data.list[i].FileDir + "/" + objRes[0].data.list[i].FileNameNew + ">";
                    strGet += "<span class='ImageOpen' title='새창으로 보기' onclick='fnOpenImage(this); return false;'></span>";
                    strGet += "<span class='ImageDownload' title='다운로드' onclick='fnDownloadImage(this); return false;'></span>";
                    strGet += "</li>";
                }
                if (objRes[0].data.list[i].FileGubun === 3) {
                    strReceipt += "<li>";
                    strReceipt += "<img src=" + FileDomain + objRes[0].data.list[i].FileDir + "/" + objRes[0].data.list[i].FileNameNew + ">";
                    strReceipt += "<span class='ImageOpen' title='새창으로 보기' onclick='fnOpenImage(this); return false;'></span>";
                    strReceipt += "<span class='ImageDownload' title='다운로드' onclick='fnDownloadImage(this); return false;'></span>";
                    strReceipt += "</li>";
                }
            }

            $("#PickupList").append(strPickup);
            $("#GetList").append(strGet);
            $("#ReceiptList").append(strReceipt);
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
        CallType: "OrderReceiptFileDownload",
        FileUrl: strUrl,
        FileName: strFileName
    }

    $.fileDownload("/TMS/Common/Proc/OrderReceiptListHandler.ashx", {
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
