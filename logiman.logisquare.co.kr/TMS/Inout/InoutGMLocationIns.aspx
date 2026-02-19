<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="InoutGMLocationIns.aspx.cs" Inherits="TMS.Inout.InoutGMLocationIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Inout/Proc/InoutGMLocationIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#Origin").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#LocationAlias").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });


            $("#Shipper").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });

            $("#BtnResetListSearch").on("click", function () {
                $("#Origin").val("");
                $("#LocationAlias").val("");
                $("#Shipper").val("");
                $("#ConsignorName").val("");
                return;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSaveExcel").on("click", function () {

                var objParam = {
                    CallType: "ConsignorGMListExcel",
                    CenterCode: $("#CenterCode").val(),
                    Origin: $("#Origin").val(),
                    LocationAlias: $("#LocationAlias").val(),
                    Shipper: $("#Shipper").val(),
                    ConsignorName: $("#ConsignorName").val()
                };

                $.fileDownload("/TMS/Inout/Proc/InoutGMHandler.ashx", {
                    httpMethod: "POST",
                    data: objParam,
                    prepareCallback: function () {
                        UTILJS.Ajax.fnAjaxBlock();
                    },
                    successCallback: function (url) {
                        $.unblockUI();
                        fnDefaultAlert("엑셀을 다운로드 하였습니다.", "success");
                    },
                    failCallback: function (html, url) {
                        $.unblockUI();
                        fnDefaultAlert("나중에 다시 시도해 주세요.");
                    }
                });
            });

        });

        function fnAjaxSaveExcel(objData) {
            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }
            return;
        }

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <div id="contents">
        <h3 class="H3Name">Location 코드관리</h3>
        <div class="data_list">
            <div class="search">
                <div class="search_line RegForm">
                    <asp:HiddenField runat="server" ID="RGMSeqNo"/>
                    <div>
                        <asp:DropDownList runat="server" ID="RCenterCode" class="type_01 essential" AutoPostBack="false"></asp:DropDownList>
                        <asp:TextBox runat="server" ID="RLocationAlias" class="type_01 essential" AutoPostBack="false" placeholder="Location Alias"/>
                        <asp:TextBox runat="server" ID="RShipper" class="type_01 essential" AutoPostBack="false" placeholder="Shipper"/>
                        <asp:TextBox runat="server" ID="ROrigin" class="type_01 essential" AutoPostBack="false" placeholder="Origin"/>
                    </div>
                    <div style="margin-top: 10px;">
                        <asp:HiddenField runat="server" ID="RConsignorCode"/>
                        <asp:TextBox runat="server" CssClass="type_01 find essential" ID="RConsignorName" placeholder="* 화주명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 find essential" ID="RPickupPlace" placeholder="* 상차지 상호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_small find" ID="RPickupPlaceChargeName" placeholder="담당자"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="RPickupPlaceChargePosition" placeholder="직급"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="RPickupPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="RPickupPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="RPickupPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                    </div>
                    <div style="margin-top: 10px;">
                        <asp:HiddenField runat="server" ID="RPickupPlaceFullAddr"/>
                        <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="RPickupPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_02 essential" ID="RPickupPlaceAddr" placeholder="주소" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_02" ID="RPickupPlaceAddrDtl" placeholder="상세주소"></asp:TextBox>
                        <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                        <asp:TextBox runat="server" CssClass="type_small" ID="RPickupPlaceLocalCode" placeholder="지역코드" ></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01" ID="RPickupPlaceLocalName" placeholder="지역명" ></asp:TextBox>
                        <button type="button" runat="server" ID="BtnInsLocation" onclick="fnInsLocation();" class="btn_01">등록</button>
                        <button type="button" runat="server" ID="BtnUpdLocation" onclick="fnUpdLocation();" class="btn_01" style="display: none;">수정</button>
                        <button type="button" runat="server" ID="BtnDelLocation" onclick="fnDelLocation();" class="btn_03" style="display: none;">삭제</button>
                        <button type="button" runat="server" ID="BtnReset" onclick="fnResetLocation();" class="btn_02">새로입력</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="data_list" style="margin-top: 20px;">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_01" placeholder="화주명"></asp:TextBox>
                    <asp:TextBox runat="server" ID="LocationAlias" class="type_01" AutoPostBack="false" placeholder="Location Alias"/>
                    <asp:TextBox runat="server" ID="Shipper" class="type_01" AutoPostBack="false" placeholder="Shipper"/>
                    <asp:TextBox runat="server" ID="Origin" class="type_01" AutoPostBack="false" placeholder="Origin"/>
                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    <button type="button" runat="server" ID="BtnResetListSearch" class="btn_02">다시입력</button>
                </div>
            </div>  
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                    &nbsp;&nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
							<dl>
								<dt>항목 설정</dt>
								<dd>
									<asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('InoutGMLocationListGrid');">항목관리</asp:LinkButton>
									<asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('InoutGMLocationListGrid');">항목순서 초기화</asp:LinkButton>
								</dd>
							</dl>
						</li>
					</ul>
                </li>
            </ul>

            <div id="InoutGMLocationListGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ConsignorName">화주명</option>
                        <option value="LocationAlias">Location Alias</option>
                        <option value="Shipper">Shipper</option>
                        <option value="Origin">Origin</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('InoutGMLocationListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('InoutGMLocationListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('InoutGMLocationListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
