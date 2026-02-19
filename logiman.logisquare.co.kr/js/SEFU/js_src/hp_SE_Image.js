nhn.husky.SE_Image = $Class({
	name: "SE_Image",
	sUploadActionURL: "/js/SEFU/Upload/Upload",
	sUploadingMsg: "업로드 중입니다....",
	sNoFileMsg: "파일을 선택해 주세요.",
	sFailedUploadMsg: "이미지 파일이 아닙니다.",

	$init: function (elAppContainer) {
		this._assignHTMLObjects(elAppContainer);
	},

	_assignHTMLObjects: function (elAppContainer) {
		this.oDropdownLayer = cssquery.getSingle("DIV.husky_seditor_image_layer", elAppContainer);

		this.oFrmFile = cssquery.getSingle("FORM", this.oDropdownLayer);
		$Element(this.oFrmFile).attr("action", this.sUploadActionURL);
		this.oInputFile = cssquery.getSingle("FORM INPUT[type=file]", this.oDropdownLayer);
		this.oLblUpload = cssquery.getSingle("LABEL", this.oDropdownLayer);

		this.oBtnConfirm = cssquery.getSingle("BUTTON.confirm", this.oDropdownLayer);
		this.oBtnCancel = cssquery.getSingle("BUTTON.cancel", this.oDropdownLayer);
	},

	$ON_SE_TOGGLE_IMAGE_LAYER: function () {
		this.oApp.delayedExec("TOGGLE_TOOLBAR_ACTIVE_LAYER", [this.oDropdownLayer, "hyperlink", "SE_RESET_IMAGE_LAYER", []], 0);
	},

	$ON_MSG_APP_READY: function () {
		this.oApp.exec("REGISTER_UI_EVENT", ["image", "click", "SE_TOGGLE_IMAGE_LAYER"]);
		this.oApp.registerBrowserEvent(this.oBtnConfirm, "mousedown", "SE_APPLY_IMAGE");
		this.oApp.registerBrowserEvent(this.oBtnCancel, "mousedown", "HIDE_ACTIVE_LAYER");
	},

	$ON_SE_RESET_IMAGE_LAYER: function () {
		this.oFrmFile.reset();
		$Element(this.oLblUpload).html("");
	},

	$ON_SE_APPLY_IMAGE: function () {
		if (!this.oInputFile.value) {
			alert(this.sNoFileMsg);
			return;
		}
		var _this = this;
		jQuery(this.oFrmFile).ajaxSubmit(function (data) {
			console.log(data);
			if (String(data) == "0" || String(data) == "") {
				alert(_this.sFailedUploadMsg);
				return;
			}
			if (String(data) == "1") {
				alert("용량을 초과하였습니다.(5M 이하)");
				return;
			}

			var str = "<img src='" + data + "'>";

			_this.oApp.getSelection().pasteHTML(str);

			_this.oApp.exec("HIDE_ACTIVE_LAYER");
		});
		$Element(this.oLblUpload).html(this.sUploadingMsg);
	}
});