<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="TransRateIns.aspx.cs" Inherits="TMS.TransRate.TransRateIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
            parent.fnMoveToPage(1);
        }

        function fnInfoAlert() {
            fnDefaultAlert("적용일이란?<br>등록된 요율표 적용 시작일을 의미합니다.<br>예) 적용일이 7월1일인 경우 상차일이 7월1일인 <br> 오더 등록 시 자동 요율표가 적용됩니다.", "info");
            return;
        }

        function fnTransRateExcelDown() {
            var RateRegKind = $("#RateRegKind").val();
            fnDefaultAlert("엑셀 양식을 다운로드 하었습니다.");

            if (Number(RateRegKind) === 1) {
                location.href = '/TMS/TransRate/기본요울표엑셀등록양식_매출,매입(시트구분).xlsx?ver=1';
            } else if (Number(RateRegKind) === 2) {
                location.href = '/TMS/TransRate/기본요울표엑셀등록양식_매출(시트구분).xlsx?ver=1';
            } else if (Number(RateRegKind) === 3) {
                location.href = '/TMS/TransRate/기본요울표엑셀등록양식_매입(시트구분).xlsx?ver=1';
            } else if (Number(RateRegKind) === 4) {
                location.href = '/TMS/TransRate/추가요울표엑셀등록양식-경유지.xlsx?ver=1';
            } else if (Number(RateRegKind) === 5) {
                location.href = '/TMS/TransRate/추가요울표엑셀등록양식-유가연동.xlsx?ver=1';
            }
            return;
        }
        
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="DtlSeqNo" />
    <asp:HiddenField runat="server" ID="TransSeqNo" />
    <asp:HiddenField runat="server" ID="RateRegKind" />
    <asp:HiddenField runat="server" ID="HidTransRateChk" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <ul class="action" style="overflow: hidden; padding-bottom: 10px;">
                            <li class="left">
                                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                                <asp:DropDownList runat="server" ID="RateType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                                <asp:DropDownList runat="server" ID="FTLFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                                <asp:TextBox runat="server" ID="TransRateName" class="type_01" AutoPostBack="false" placeholder="요율표명"/>
                                <button type="button" runat="server" ID="BtnDuplication" onclick="fnTransRateDupBtn();" class="btn_01">중복확인</button>
                                <button type="button" runat="server" ID="BtnReset" onclick="fnTransRateReset();" class="btn_03" style="display: none;">다시입력</button>
                            </li>
                            <li class="right">
                                <asp:DropDownList runat="server" ID="DelFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>    
                                <button type="button" runat="server" id="BtnUseFlag" onclick="fnTransRateDelConfirm()" class="btn_02" Visible="False">저장</button>
                            </li>
                        </ul>
                    </div>
                    <ul class="action">
                        <li class="left">
                            <button type="button" runat="server" class="btn_02 download" id="DefaultExcelSampleBtn" onclick="fnTransRateExcelDown(1);">엑셀양식받기</button>
                            <button type="button" runat="server" class="btn_02 download" id="AddExcelSampleBtn" Visible="False" onclick="fnTransRateExcelDown(2);">엑셀양식받기</button>
                            &nbsp;&nbsp;
                            <button type="button" runat="server" class="btn_02 download" ID="CarTonExcelbtn">차량톤수 엑셀받기</button>
                            &nbsp;&nbsp;
                            <button type="button" runat="server" class="btn_02 download" ID="CarTruckExcelbtn">차량종류 엑셀받기</button>
                            &nbsp;&nbsp;
                            <button type="button" runat="server" class="btn_02 download" ID="AddrExcelBtn">주소양식 엑셀받기</button>
                        </li>
                        <li class="right">
                            
                        </li>
                    </ul>
                </div>
                <div class="grid_list">
                    <ul class="grid_option" id="BtnTransRateReg" runat="server">
                        <li class="left">
                            <button type="button" class="btn_02" onclick="addRow();">행추가 +</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_03" onclick="removeRow();">행삭제 -</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02" onclick="addCopyRow();">행복사</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02 refresh" onclick="fnRefreshData(); return false;">새로고침</button>
                        </li>
                        <li class="right">
                            <button type="button" class="btn_01" onclick="rateData();">검증</button>
                        </li>
                    </ul>

                    <div id="TransRateInsGrid"></div>
			        <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>