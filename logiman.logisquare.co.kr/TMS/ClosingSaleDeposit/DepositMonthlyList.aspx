<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DepositMonthlyList.aspx.cs" Inherits="TMS.ClosingSaleDeposit.DepositMonthlyList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSaleDeposit/Proc/DepositMonthlyList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });

            $("#BtnUpdData").on("click", function () {
                fnUpdData();
                return;
            });
        });

    </script>
    
    <style>
        .ui-datepicker-calendar { display:none; }
        #ChkViewMonth { margin: 10px 0; height: 16px; }
        #ChkViewMonth li { float: left; margin-right: 20px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="SearchYear" class="type_01" AutoPostBack="false" Width="80"></asp:DropDownList>
                <asp:DropDownList runat="server" ID="ClientBusinessStatus" class="type_01" AutoPostBack="false"></asp:DropDownList>
                <asp:TextBox runat="server" ID="ClientName" class="type_01" AutoPostBack="false" placeholder="거래처명"/>
                &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
            </div>
            <div class="action">
                <asp:CheckBoxList runat="server" ID="ChkViewMonth" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
            </div>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li class="right">
                    <asp:TextBox runat="server" ID="UpdateYM" class="type_small date" AutoPostBack="false" placeholder="작성월" autocomplete="off"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnUpdData" class="btn_01">업데이트</button>
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download" onclick="fnGridExportAs(GridID, 'xlsx', '미수업체관리', '미수업체관리'); return;">엑셀다운로드</button>
                </li>
            </ul>
            <div id="DepositMonthlyListGrid"></div>
			<div id="GridResult2"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
                        <option value="ClientName">거래처명</option>
                    </select>
                    <input type="text" id="GridSearchText"  alt="검색어" placeholder="검색어" class="type_01 ime" />&nbsp;
                    <button type="button" id="BtnGridSearch" class="btn_01">검색</button>
                    <br/>
                    <input id="ChkCaseSensitive" type="checkbox" /><label for="ChkCaseSensitive"><span></span>대/소문자 구분</label>
                </div>
            </div>
        </div>
	</div>
        
</asp:Content>
