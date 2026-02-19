<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DomesticHwaseungIns.aspx.cs" Inherits="TMS.Domestic.DomesticHwaseungIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Domestic/Proc/DomesticHwaseungIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //차량적용
            $("#BtnCarNoSet").on("click", function () {
                fnCarNoSet();
                return false;
            });

            //차량정보 다시입력
            $("#BtnCarNoReset").on("click", function () {
                fnCarNoReset();
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

            //미검증행 삭제
            $("#BtnDelValidationFailRow").on("click", function () {
                fnDelNoValidationRow();
                return false;
            });

            //검증
            $("#BtnValidationRow").on("click", function () {
                fnValidationRow();
                return false;
            });

            //오더 등록
            $("#BtnRegOrder").on("click", function () {
                fnRegOrder();
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


            //엑셀 다운로드
            $("#BtnSaveExcel").on("click", function () {
                fnGridExportAs(GridID, 'xlsx', '화승R&A오더등록', '화승R&A오더등록');
                return;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:HiddenField runat="server" ID="CarCenterCode"/>
                    <asp:HiddenField runat="server" ID="RefSeqNo"/>
                    <asp:HiddenField runat="server" ID="CarNo"/>
                    <asp:HiddenField runat="server" ID="DriverName"/>
                    <asp:HiddenField runat="server" ID="DriverCell"/>
                    <asp:HiddenField runat="server" ID="CarDivTypeM"/>
                    <asp:TextBox runat="server" ID="SearchCarNo" CssClass="type_01 find" placeholder="차량번호 검색"></asp:TextBox>
                    <span runat="server" id="SpanDispatchInfo"></span>
                    <button type="button" class="btn_01" id="BtnCarNoSet">차량적용</button>
                    <button type="button" class="btn_03" id="BtnCarNoReset" style="display:none;">다시입력</button>
                </div>
            </div>  
            <ul class="action">
                <li class="left">
                    <button type="button" runat="server" ID="BtnAddRow" class="btn_02">행추가</button>
                    <button type="button" runat="server" ID="BtnDelRow" class="btn_03">행삭제</button>
                    <button type="button" runat="server" ID="BtnDelValidationFailRow" class="btn_03">미검증행삭제</button>
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnValidationRow" class="btn_01">검증</button>
                    <button type="button" runat="server" ID="BtnRegOrder" class="btn_01">오더등록</button>
                    <button type="button" runat="server" ID="BtnDelSuccRow" class="btn_03">등록행삭제</button>
                    <button type="button" runat="server" ID="BtnDelFailRow" class="btn_03">실패행삭제</button>
                    <button type="button" runat="server" ID="BtnResetAll" class="btn_02">초기화</button>
                </li>
            </ul>
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li class="left">
                </li>
                <li class="right">
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                </li>
            </ul>
            <div id="DomesticHwaseungInsGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
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
