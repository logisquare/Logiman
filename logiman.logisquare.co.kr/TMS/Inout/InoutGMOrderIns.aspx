<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="InoutGMOrderIns.aspx.cs" Inherits="TMS.Inout.InoutGMOrderIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Inout/Proc/InoutGMOrderIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#BtnAddRow").on("click", function () {
                fnAddRow();
                return;
            });

            $("#BtnDelRow").on("click", function () {
                fnRemoveRow();
                return;
            });

            $("#BtnDelFailRow").on("click", function () {
                fnDelFailRow();
                return;
            });

            $("#BtnRegOrder").on("click", function () {
                fnRegOrder();
                return;
            });

            $("#BtnDelSuccRow").on("click", function () {
                BtnDelSuccRow();
                return;
            });

            $("#BtnSaveExcel").on("click", function () {
                fnGridExportAs(GridID, 'xlsx', '세바(GM)오더등록', '세바(GM)오더등록');
                return;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="contents">
        <h3 class="H3Name">오더등록</h3>
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <div>
                        <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                        <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderItemCode"></asp:DropDownList>
                        &nbsp;상차일
                        <asp:TextBox runat="server" CssClass="type_01 date essential" ID="PickupYMD" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="PickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                        &nbsp;하차일
                        <asp:TextBox runat="server" CssClass="type_01 date essential" ID="GetYMD" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="GetHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                    </div>
                    <div style="margin-top: 10px;" class="TdClient">
                        <asp:HiddenField runat="server" ID="OrderClientCode"/>
                        <asp:TextBox runat="server" CssClass="type_01 find essential" ID="OrderClientName" placeholder="* 발주처명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_small find essential" ID="OrderClientChargeName" placeholder="* 담당자명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="OrderClientChargePosition" placeholder="직급"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="OrderClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="OrderClientChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="OrderClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                    </div>
                    <div style="margin-top: 10px;" class="TdClient">
                        <asp:HiddenField runat="server" ID="PayClientCode"/>
                        <asp:HiddenField runat="server" ID="PayClientInfo"/>
                        <asp:HiddenField runat="server" ID="PayClientCorpNo"/>
                        <asp:TextBox runat="server" CssClass="type_01 find essential" ID="PayClientName" placeholder="* 청구처명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_small find essential" ID="PayClientChargeName" placeholder="* 담당자명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="PayClientChargePosition" placeholder="직급"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="PayClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="PayClientChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="PayClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_small essential" ID="PayClientChargeLocation" placeholder="* 청구사업장"></asp:TextBox>
                    </div>
                    <div style="margin-top: 10px;">
                        <asp:TextBox runat="server" CssClass="type_01 find essential" ID="GetPlace" placeholder="* 하차지 상호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_small find" ID="GetPlaceChargeName" placeholder="담당자명"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargePosition" placeholder="직급"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="GetPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01 essential" ID="GetPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                    </div>
                    <div style="margin-top: 10px;">
                        <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
                        <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="GetPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_02 essential" ID="GetPlaceAddr" placeholder="주소" readonly></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_02" ID="GetPlaceAddrDtl" placeholder="상세주소"></asp:TextBox>
                        <button type="button" class="btn_02" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                        <asp:TextBox runat="server" CssClass="type_small" ID="GetPlaceLocalCode" placeholder="지역코드" ></asp:TextBox>
                        <asp:TextBox runat="server" CssClass="type_01" ID="GetPlaceLocalName" placeholder="지역명" ></asp:TextBox>
                    </div>
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
                    <button type="button" runat="server" ID="BtnAddRow" class="btn_01">행추가</button>
                    <button type="button" runat="server" ID="BtnDelRow" class="btn_03">행삭제</button>
                    <button type="button" runat="server" ID="BtnDelFailRow" class="btn_03">미검증행삭제</button>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnRegOrder" class="btn_01">오더등록</button>
                    <button type="button" runat="server" ID="BtnDelSuccRow" class="btn_03">등록행삭제</button>
                    &nbsp;&nbsp;
                    <button type="button" runat="server" ID="BtnSaveExcel" class="btn_02 download">엑셀다운로드</button>
                </li>
            </ul>

            <div id="InoutGMOrderInsGrid"></div>
			<div id="page"></div>
            <!-- 검색 다이얼로그 UI -->
            <div id="gridDialog" title="Grid 검색">
                <a href="#" id="LinkGridSearchClose" title="검색 레이어 닫기" class="layer_close"></a>
                <div>
                    <select id="GridSearchDataField" class="type_01">
                        <option value="ALL">전체</option>
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
</asp:Content>
