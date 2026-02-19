<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarDriverList.aspx.cs" Inherits="TMS.Car.CarDriverList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Car/Proc/CarDriverList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#DriverName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#DriverCell").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#ListSearch").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCheckPeriodAndSearch(event);
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }


        function fnCheckPeriodAndSearch(event) {
            if (!$("#DriverName").val() && !$("#DriverCell").val()) {
                fnDefaultAlertFocus("기사명이나 기사 휴대폰 중 하나를 입력하세요.", "DriverName", "warning");
                return false;
            }

            fnMoveToPage(1);
            return false;
        }
    </script>

</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="UseFlag" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="DriverName" class="type_01" AutoPostBack="false" placeholder="기사명"/>
                <asp:TextBox runat="server" ID="DriverCell" class="type_01" AutoPostBack="false" placeholder="기사 휴대폰"/>
                <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
            </div>  

            <ul class="action">
                <li class="left">
                </li>
                <li class="right">
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                </li>
            </ul>

            <div id="CarDriverListGrid"></div>
			<div id="page"></div>
        </div>
	</div>
        
    <div id="DivDriverUpd">
        <asp:HiddenField runat="server" ID="DriverSeqNo" />
        <div>
            <h1>기사명 수정</h1>
            <a href="#" onclick="fnCloseDriverUpd(); return false;" class="close_btn">x</a>
            <table>
                <colgroup>
                    <col style="width:40%;"/>
                    <col style="width:60%;"/>
                </colgroup>
                <tbody>
                <tr>
                    <th>기사명</th>
                    <td><span id="SpanDriverName"></span></td>
                </tr>
                <tr>
                    <th>휴대폰번호</th>
                    <td><span id="SpanDriverCell"></span></td>
                </tr>
                <tr>
                    <th>변경할 기사명</th>
                    <td><asp:TextBox runat="server" ID="DriverNameNew" class="type_01" AutoPostBack="false" placeholder="기사명"/></td>
                </tr>
                </tbody>
            </table>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnDriverUpdReg(); return false;">등록</button>
                <button type="button" class="btn_03" onclick="fnCloseDriverUpd(); return false;">닫기</button>
            </div>
        </div>
    </div>
</asp:Content>
