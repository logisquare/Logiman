<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DepositList.aspx.cs" Inherits="TMS.ClosingSaleDeposit.DepositList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSaleDeposit/Proc/DepositList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return false;
            });

            //---------------------------------------------------------------------------------
            //---- Export Excel 버튼 이벤트
            //---------------------------------------------------------------------------------
            $("#BtnSetOffExcel").on("click", function () {

                if (!$("#HidCenterCode").val()) {
                    fnDefaultAlert("회원사를 선택하세요.", "warning");
                    return false;
                }

                if (!$("#HidClientCode").val()) {
                    fnDefaultAlert("사업자를 선택하세요.", "warning");
                    return false;
                }

                if (!$("#SetOffExcelYear").val()) {
                    fnDefaultAlertFocus("연도를 선택하세요.", "SetOffExcelYear", "warning");
                    return false;
                }

                var objParam = {
                    CallType: "DepositDetailListExcel",
                    DepositTypes: "3,4",
                    CenterCode: $("#HidCenterCode").val(),
                    ClientCode: $("#HidClientCode").val(),
                    DateFrom: $("#SetOffExcelYear").val() + "01",
                    DateTo: $("#SetOffExcelYear").val() + "12"
                };

                $.fileDownload("/TMS/ClosingSaleDeposit/Proc/DepositHandler.ashx", {
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

            //입금 작성월 변경
            $("#BtnUpdMonthDeposit").on("click", function () {
                fnUpdMonthDeposit();
                return false;
            });

            //입금 등록
            $("#BtnInsDeposit").on("click", function () {
                fnInsDeposit();
                return false;
            });

            //입금 수정
            $("#BtnUpdDeposit").on("click", function () {
                fnUpdDeposit();
                return false;
            });

            //입금 삭제
            $("#BtnDelDeposit").on("click", function () {
                fnDelDeposit();
                return false;
            });

            //입금 다시 입력
            $("#BtnResetDeposit").on("click", function () {
                fnResetDeposit();
                return false;
            });

            //입금 엑셀등록
            $("#BtnOpenDepositExcel").on("click", function () {
                fnOpenDepositExcel();
                return false;
            });            

            //입금 검색
            $("#BtnListSearchDeposit").on("click", function () {
                fnCallDepositSaleGridData(GridDepositSaleID);
                fnCallDepositDetailGridData(GridDepositDetailID);
                return false;
            });

            $("#BtnInsMatching").on("click", function () {
                fnInsMatching();
                return false;
            });

            $("#BtnDelMatching").on("click", function () {
                fnDelMatching();
                return false;
            });

            //상계 열기+닫기
            $("#BtnSetOff").on("click", function () {
                fnSetOffToggle(this);
                return false;
            });

            //상계 등록
            $("#BtnInsSetOff").on("click", function () {
                fnInsSetOff();
                return false;
            });

            //상계 수정
            $("#BtnUpdSetOff").on("click", function () {
                fnUpdSetOff();
                return false;
            });

            //상계 삭제
            $("#BtnDelSetOff").on("click", function () {
                fnDelSetOff();
                return false;
            });

            //상계 다시 입력
            $("#BtnResetSetOff").on("click", function () {
                fnResetSetOff();
                return false;
            });

            //상계 검색
            $("#BtnListSearchSetOff").on("click", function () {
                fnCallDepositSetOffGridData(GridDepositSetOffID);
                return false;
            });


            //행추가
            $("#BtnAddRow").on("click", function () {
                fnAddRow();
                return false;
            });

            //행삭제
            $("#BtnDelRow").on("click", function () {
                fnRemoveRow();
                return false;
            });

            //검증
            $("#BtnValidationRow").on("click", function () {
                fnValidationRow();
                return false;
            });

            //미검증행 삭제
            $("#BtnDelValidationFailRow").on("click", function () {
                fnDelNoValidationRow();
                return false;
            });

            //입금 등록
            $("#BtnInsDepositExcel").on("click", function () {
                fnInsDepositExcel();
                return false;
            });

            //등록행 삭제
            $("#BtnDelSuccRow").on("click", function () {
                fnDelSuccRow();
                return false;
            });

            //실패행 삭제
            $("#BtnDelFailRow").on("click", function () {
                fnDelFailRow();
                return false;
            });

            //화면 초기화
            $("#BtnResetAll").on("click", function () {
                fnResetAll();
                return false;
            });

            //양식 다운로드
            $("#BtnDownloadForm").on("click", function () {
                location.href = "/TMS/ClosingSaleDeposit/입금엑셀등록양식.xlsx?ver=1";
                return false;
            });

            //엑셀 다운로드
            $("#BtnSaveDepositExcel").on("click", function () {
                fnGridExportAs(GridDepositExcelID, 'xlsx', '입금엑셀등록', '입금엑셀등록');
                return false;
            });
        });

        function fnAjaxSaveExcel(objData) {
            if (objData[0].RetCode !== 0) {
                fnDefaultAlert("나중에 다시 시도해 주세요.(" + objData[0].ErrMsg + ")");
            }
            return false;
        }

    </script>
    
    <style>
        .ui-datepicker-calendar { display:none; }
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidClientCode" />
    <asp:HiddenField runat="server" ID="HidClientName" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="거래처명"/>
                    <asp:TextBox runat="server" ID="CsAdminName" class="type_01" AutoPostBack="false" placeholder="업무담당"/>
                    <asp:TextBox runat="server" ID="CsClosingAdminName" class="type_01" AutoPostBack="false" placeholder="마감담당"/>
                    &nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    &nbsp;<button type="button" class="btn_02" id="BtnOpenDepositExcel" style="float:right; margin-right: 5px;">입금엑셀등록</button>
                </div>
            </div>  
        </div>
        <div class="grid_list">
            <div class="grid_type_03">
                <div class="left" style="width:490px;">
                    <div id="DepositClientListGrid"></div>
                </div>
                <div class="right" style="width:calc(100% - 490px);">
                    <div style="float:left; width: 100%; position: relative;">
                        <ul class="DepositFormTitle">
                            <li>
                                <h1>총미수내역</h1>
                            </li>
                            <li>
                                <button type="button" runat="server" id="BtnTotalExcel" class="btn_02 download" style="float: right; margin-right: 10px;" onclick="fnGridExportAs(GridDepositID, 'xlsx', '미수관리-총미수내역', '미수관리-총미수내역'); return;">엑셀다운로드</button>
                            </li>
                        </ul>
                        <div id="DepositClientTotalListGrid" style="float: left; margin-top: 10px; width: 100%; height: 168px;"></div>
                    </div>
                    <div style="float:left; width: 100%; margin-top: 22px;">
                        <ul class="DepositFormTitle">
                            <li style="width:100px;">
                                <h1>입금등록</h1>
                            </li>
                            <li style="width: calc(100% - 100px); text-align:left;">
                                <asp:TextBox runat="server" ID="DateFrom" class="type_small date" width="90" AutoPostBack="false" placeholder="기간 From" autocomplete="off"/>
                                <asp:TextBox runat="server" ID="DateTo" class="type_small date" width="90" AutoPostBack="false" placeholder="기간 To" autocomplete="off"/>
                                &nbsp;<asp:CheckBox runat="server" id="ChkNoMatching" Text="<span></span>미매칭"/>
                                &nbsp;<button type="button" class="btn_01" id="BtnListSearchDeposit" style="margin-right: 5px;">검색</button>
                                &nbsp;<button type="button" class="btn_01" id="BtnInsMatching" style="">매칭</button>
                                <button type="button" class="btn_03" id="BtnDelMatching" style="margin-right: 10px;">매칭해제</button>
                            </li>
                        </ul>
                        <div style="float:left; width: 100%; text-align: right; margin-top:10px;">
                            <asp:HiddenField runat="server" ID="SaleClosingSeqNos"/>
                            <asp:HiddenField runat="server" ID="MatchingClosingSeqNo"/>
                            <asp:HiddenField runat="server" ID="DepositClosingSeqNo"/>
                            <asp:TextBox runat="server" ID="InputYM" class="type_small date" width="90" AutoPostBack="false" placeholder="작성월" autocomplete="off"/>
                            <button type="button" class="btn_01" id="BtnUpdMonthDeposit" style="margin-right: 5px; display: none;">작성월변경</button>
                            <asp:TextBox runat="server" ID="InputYMD" class="type_01 date" AutoPostBack="false" placeholder="입금일" autocomplete="off"/>
                            <asp:TextBox runat="server" ID="Amt" class="type_small Money" AutoPostBack="false" placeholder="금액"/>
                            <asp:TextBox runat="server" ID="Note" class="type_02" AutoPostBack="false" placeholder="적요"/>
                            <button type="button" class="btn_01" id="BtnInsDeposit" style="">등록</button>
                            <button type="button" class="btn_01" id="BtnUpdDeposit" style="display: none;">수정</button>
                            <button type="button" class="btn_03" id="BtnDelDeposit" style="display: none;">삭제</button>
                            <button type="button" class="btn_02" id="BtnResetDeposit" style="margin-right: 10px;">다시입력</button>
                        </div>
                    </div>
                    <div style="float:left; width: 100%; margin-top: 10px;">
                        <div>
                            <div class="left" style="width:50%;">
                                <ul class="DepositFormSubTitle">
                                    <li>
                                        <h1>• 매출마감내역</h1>
                                    </li>
                                    <li>
                                        <span id="SpanDepositSaleCnt"></span>
                                        <button type="button" runat="server" id="BtnSaleExcel" class="btn_02 download" style="margin-right: 10px;" onclick="fnGridExportAs(GridDepositSaleID, 'xlsx', '미수관리-매출마감내역', '미수관리-매출마감내역'); return;">엑셀다운로드</button>
                                    </li>
                                </ul>
                                <div id="DepositSaleListGrid" style="float: left; margin-top: 10px; width: 100%; height: 365px;"></div>
                            </div>
                            <div class="right" style="width:50%;">
                                <ul class="DepositFormSubTitle">
                                    <li>
                                        <h1>• 입금내역</h1>
                                    </li>
                                    <li>
                                        <span id="SpanDepositDetailCnt"></span>
                                        <button type="button" runat="server" id="BtnDepositExcel" class="btn_02 download" style="margin-right: 10px;" onclick="fnGridExportAs(GridDepositDetailID, 'xlsx', '미수관리-입금내역', '미수관리-입금내역'); return;">엑셀다운로드</button>
                                    </li>
                                </ul>
                                <div id="DepositDetailListGrid" style="float: left; margin-top: 10px; width: 100%; height: 365px;"></div>
                            </div>
                        </div>
                    </div>
                    <div style="float:left; width: 100%; margin-top: 21px;">
                        <ul class="DepositFormTitle">
                            <li style="width:100px;">
                                <h1>상계내역</h1>
                            </li>
                            <li style="width: calc(100%-100px); text-align:left;">
                                <asp:TextBox runat="server" ID="DateFrom2" class="type_small date" width="90" AutoPostBack="false" placeholder="기간 From" autocomplete="off"/>
                                <asp:TextBox runat="server" ID="DateTo2" class="type_small date" width="90" AutoPostBack="false" placeholder="기간 To" autocomplete="off"/>
                                &nbsp;<button type="button" class="btn_01" id="BtnListSearchSetOff" style="margin-right: 5px;">검색</button>
                                <span id="BtnSetOff" style="cursor:hand;" ></span>
                            </li>
                        </ul>
                        <div id="DivSetOffWrap" style="display:none; float:left; position:relative; width:100%;">
                            <div style="margin-top: 10px; width: 100%;">
                                <asp:HiddenField runat="server" ID="SetOffClosingSeqNo"/>
                                <asp:HiddenField runat="server" ID="SetOffClientCode"/>
                                <asp:DropDownList runat="server" ID="SetOffType" class="type_01" AutoPostBack="false" Width="100"></asp:DropDownList>
                                <asp:TextBox runat="server" ID="SetOffInputYM" class="type_small date" AutoPostBack="false" placeholder="작성월" autocomplete="off"/>
                                <asp:TextBox runat="server" ID="SetOffAmt" class="type_small Money" AutoPostBack="false" placeholder="금액"/>
                                <asp:TextBox runat="server" ID="SetOffClientName" class="type_01 find" AutoPostBack="false" placeholder="거래처명"/>
                                <asp:TextBox runat="server" ID="SetOffNote" class="type_02" AutoPostBack="false" placeholder="적요"/>
                                <button type="button" class="btn_01" id="BtnInsSetOff" style="margin-right: 5px;">등록</button>
                                <button type="button" class="btn_01" id="BtnUpdSetOff" style="margin-right: 5px; display: none;">수정</button>
                                <button type="button" class="btn_03" id="BtnDelSetOff" style="margin-right: 5px; display: none;">삭제</button>
                                <button type="button" class="btn_02" id="BtnResetSetOff" style="margin-right: 5px;">다시입력</button>
                                <div style="width:250px; float:right;">
                                    <asp:DropDownList runat="server" ID="SetOffExcelYear" class="type_01" AutoPostBack="false" Width="100"></asp:DropDownList>&nbsp;&nbsp;
                                    <button type="button" runat="server" id="BtnSetOffExcel" class="btn_02 download" style="float: right; margin-right: 10px;">엑셀다운로드</button>
                                </div>
                            </div>
                            <div id="DepositSetOffListGrid" style="float:left; margin-top: 10px; width: 100%; height: 147px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</div>
    
    <!-- 검색 다이얼로그 UI -->
    <div id="gridDialog" title="거래처 검색">
        <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
        <div>
            <select id="GridSearchDataField" class="type_01">
                <option value="ALL">전체</option>
                <option value="ComName">거래처</option>
                <option value="ComCorpNo">사업자번호</option>
            </select>
            <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
            <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
            <br/>
            <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
        </div>
    </div>
    
    <div id="DivDepositExcel">
        <asp:HiddenField runat="server" ID="DepositExcelCenterCode"/>
        <div>
            <h1>입금엑셀등록</h1>
            <a href="#" onclick="fnCloseDepositExcel(); return false;" class="close_btn">x</a>
            <div class="btnWrap">
                <ul>
                    <li class="left">
                        <button type="button" runat="server" ID="BtnAddRow" class="btn_02">행추가</button>
                        <button type="button" runat="server" ID="BtnDelRow" class="btn_03">행삭제</button>
                        <button type="button" runat="server" ID="BtnValidationRow" class="btn_01">검증</button>
                        <button type="button" runat="server" ID="BtnDelValidationFailRow" class="btn_03">미검증행삭제</button>
                    </li>
                    <li class="right">
                        <button type="button" runat="server" ID="BtnInsDepositExcel" class="btn_01">등록</button>
                        <button type="button" runat="server" ID="BtnDelSuccRow" class="btn_03">등록행삭제</button>
                        <button type="button" runat="server" ID="BtnDelFailRow" class="btn_03">실패행삭제</button>
                        <button type="button" runat="server" ID="BtnResetAll" class="btn_02">초기화</button>
                        <button type="button" runat="server" ID="BtnSaveDepositExcel" class="btn_02 download">엑셀다운로드</button>
                        <button type="button" runat="server" ID="BtnDownloadForm" class="btn_02 download">양식다운로드</button>
                    </li>
                </ul>
            </div>
            <div class="gridWrap">
                <div id="DepositExcelListGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
