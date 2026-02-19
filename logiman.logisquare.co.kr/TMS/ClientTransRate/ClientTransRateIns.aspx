<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientTransRateIns.aspx.cs" Inherits="TMS.ClientTransRate.ClientTransRateIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClientTransRate/Proc/ClientTransRateIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
            fnDefaultAlert("엑셀 양식을 다운로드 하었습니다.");
            location.href = '/TMS/ClientTransRate/요울표엑셀등록양식.xlsx?ver=1';
            return;
        }
        
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="SeqNo" />
    <asp:HiddenField runat="server" ID="ConsignorCode" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <span>적용일 <a href="javascript:fnInfoAlert();" class="caution_icon"></a></span>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                        <asp:TextBox runat="server" ID="FromYMD" class="type_01 date" ReadOnly="true" placeholder="적용일" AutoPostBack="false"/>
                        <asp:TextBox runat="server" ID="ClientName" class="type_01 find" AutoPostBack="false" placeholder="고객사명"/>
                        <asp:TextBox runat="server" ID="ClientCode" class="type_small" style="text-align:center; width:60px;" AutoPostBack="false" placeholder="코드"/>
                        <asp:TextBox runat="server" ID="ConsignorName" class="type_01 find" AutoPostBack="false" placeholder="화주명"/>
                        <asp:DropDownList runat="server" ID="RateType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    </div>
                    <ul class="action">
                        <li class="left">
                            <button type="button" class="btn_02 download" onclick="fnTransRateExcelDown();">엑셀양식받기</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02 download" ID="CarTonExcelbtn">차량톤수 엑셀받기</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02 download" ID="CarTruckExcelbtn">차량종류 엑셀받기</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02 download" ID="AddrExcelBtn">주소양식 엑셀받기</button>
                        </li>
                        <li class="right">
                            <button type="button" class="btn_01" onclick="rateData();">요율표 저장</button>
                        </li>
                    </ul>
                </div>
                <div class="grid_list">
                    <ul class="grid_option">
                        <li class="left">
                            <button type="button" class="btn_02" onclick="addRow();">행추가 +</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_03" onclick="removeRow();">행삭제 -</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02" onclick="addCopyRow();">행복사</button>
                        </li>
                        <li class="right">
                            <button type="button" class="btn_02 download" onclick="fnGridExportAs(GridID, 'xlsx', '요율표', '요율표');">엑셀 다운로드</button>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_02 refresh" onclick="fnCallGridData(); return false;">새로고침</button>
                        </li>
                    </ul>

                    <div id="ClientTransRateInsGrid"></div>
			        <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>