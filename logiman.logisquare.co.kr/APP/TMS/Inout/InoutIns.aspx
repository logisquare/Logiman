<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="InoutIns.aspx.cs" Inherits="APP.TMS.Inout.InoutIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/TMS/Inout/Proc/InoutIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <!-- AUIGrid CSS -->
    <link rel="stylesheet" href="/js/lib/AUIGrid/AUIGrid_style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <link rel="stylesheet" href="/js/lib/AUIGrid/AUIGrid_custom_style.css?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>" />
    <!-- AUIGrid JS -->
    <script type="text/javascript" src="/js/lib/AUIGrid/AUIGridLicense.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/lib/AUIGrid/AUIGrid.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript" src="/js/lib/AUIGrid_Common.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="OrderNo"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="ChgSeqNo"/>
<asp:HiddenField runat="server" ID="ContractType"/>
<asp:HiddenField runat="server" ID="ContractStatus"/>
<asp:HiddenField runat="server" ID="OrderStatus"/>
<asp:HiddenField runat="server" ID="OrderRegType"/>
<asp:HiddenField runat="server" ID="OldPickupPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="OldGetPlaceFullAddr"/>
<!--리스트 검색조건 파라미터 BackButton-->
<asp:HiddenField runat="server" ID="HidParam"/>

    <div class="tab_btn">
        <ul class="control_type_02">
            <li>
                <button type="button" onclick="fnPositionMove('#Sec1');">업체정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec2');">상차정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec3');">하차지</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec4');">화물정보</button>
            </li>
            <li class="DispatchInfo" style="display: none;">
                <button type="button" onclick="fnPositionMove('#Sec5');">배차정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec6');">비용정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec7');">비고</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec8');">계산서</button>
            </li>
        </ul>
    </div>
    <div class="contents">
        <div class="data_detail">
            <div class="ins_section" id="DivContract" style="display: none;">
                <h2>위탁정보</h2>
                <table>
                    <tbody>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="ContractInfo"></asp:Label>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="ins_section">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <td>
                            <ul class="ul_type_01">
                                <li>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <ul class="ul_type_02">
                                <li>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderLocationCode"></asp:DropDownList>
                                </li>
                                <li>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderItemCode"></asp:DropDownList>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:HiddenField runat="server" ID="CarTonCode"/>
                            <asp:HiddenField runat="server" ID="CarTypeCode"/>
                            <ul class="detail_check">
                                <li><asp:CheckBox runat="server" ID="NoLayerFlag" Text="이단불가<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="NoTopFlag" Text="무탑배차<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="FTLFlag" Text="FTL<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="CustomFlag" Text="통관<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="BondedFlag" Text="보세<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="DocumentFlag" Text="서류<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="ArrivalReportFlag" Text="도착보고<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="LicenseFlag" Text="면허진행<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="InTimeFlag" Text="시간엄수<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="ControlFlag" Text="특별관제<span></span>"/></li>
                                <li><asp:CheckBox runat="server" ID="QuickGetFlag" Text="하차긴급<span></span>"/></li>
                            </ul>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="data_detail">
            <div class="ins_section" id="Sec1">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>업체정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2">
                                발주처
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="OrderClientCode"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>발주처명</span>
                                        <asp:TextBox runat="server" ID="OrderClientName" CssClass="type_01 find essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>담당자명</span>
                                        <asp:TextBox runat="server" ID="OrderClientChargeName" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchOrderClientCharge" class="find">검색</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>직급</span>
                                        <asp:TextBox runat="server" ID="OrderClientChargePosition" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>내선</span>
                                        <asp:TextBox runat="server" ID="OrderClientChargeTelExtNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>전화번호</span>
                                        <asp:TextBox runat="server" ID="OrderClientChargeTelNo" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>휴대폰번호</span>
                                        <asp:TextBox runat="server" ID="OrderClientChargeCell" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2">
                                청구처
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="PayClientCode"/>
                                <asp:HiddenField runat="server" ID="PayClientInfo"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>청구처명</span>
                                        <asp:TextBox runat="server" ID="PayClientName" CssClass="type_01 find essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>담당자명</span>
                                        <asp:TextBox runat="server" ID="PayClientChargeName" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchPayClientChargeName" class="find">검색</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>직급</span>
                                        <asp:TextBox runat="server" ID="PayClientChargePosition" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>내선</span>
                                        <asp:TextBox runat="server" ID="PayClientChargeTelExtNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>전화번호</span>
                                        <asp:TextBox runat="server" ID="PayClientChargeTelNo" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>휴대폰번호</span>
                                        <asp:TextBox runat="server" ID="PayClientChargeCell" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>청구사업장</span>
                                        <asp:TextBox runat="server" ID="PayClientChargeLocation" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>사업자번호</span>
                                        <asp:TextBox runat="server" CssClass="type_01" ID="PayClientCorpNo" placeholder="사업자번호" readonly></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <thead>
                    <tr>
                        <th colspan="2">
                            화주
                        </th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <asp:HiddenField runat="server" ID="ConsignorCode"/>
                            <ul class="ul_type_01">
                                <li>
                                    <span>화주명</span>
                                    <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_01 find essential"></asp:TextBox>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec2">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>상차정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="PickupPlaceSeqNo"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceFullAddr"/>
                                <asp:HiddenField runat="server" ID="PickupWay"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceLocalCode"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceLocalName"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>날짜</span>
                                        <asp:TextBox runat="server" ID="PickupYMD" TextMode="Date" CssClass="type_01 date essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>시간</span>
                                        <asp:TextBox runat="server" ID="PickupHM" CssClass="type_01 OnlyNumber"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>상호</span>
                                        <asp:TextBox runat="server" ID="PickupPlace" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchPickupPlace" class="find">검색</button>
                                    </li>
                                    <li>
                                        <span>담당자명</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceChargeName" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchPickupPlaceChargeName" class="find">검색</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>직급</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceChargePosition" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>내선</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceChargeTelExtNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>전화번호</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceChargeTelNo" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>휴대폰번호</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceChargeCell" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="dispatch_search">
                                    <li style="width:65%;">
                                        <span>주소</span>
                                        <asp:TextBox runat="server" ID="PickupPlacePost" CssClass="essential" placeholder="우편번호를 검색하세요" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li style="width:35%;">
                                        <span>&nbsp;</span>
                                        <button type="button" class="btn_100p" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                                    </li>
                                </ul>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="PickupPlaceAddr" CssClass="type_01 essential" placeholder="주소" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="PickupPlaceAddrDtl" CssClass="type_01 " placeholder="상세주소"></asp:TextBox>
                                    </li>
                                </ul>
                                <div id="DivPickupPlaceAddrWrap"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>특이사항</span>
                                        <asp:TextBox runat="server" ID="PickupPlaceNote" CssClass="type_01 "></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec3">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>하차정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="GetPlaceSeqNo"/>
                                <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
                                <asp:HiddenField runat="server" ID="GetWay"/>
                                <asp:HiddenField runat="server" ID="GetPlaceLocalCode"/>
                                <asp:HiddenField runat="server" ID="GetPlaceLocalName"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>날짜</span>
                                        <asp:TextBox runat="server" ID="GetYMD" TextMode="Date" CssClass="type_01 date essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>시간</span>
                                        <asp:TextBox runat="server" ID="GetHM" CssClass="type_01 OnlyNumber"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>상호</span>
                                        <asp:TextBox runat="server" ID="GetPlace" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchGetPlace" class="find">검색</button>
                                    </li>
                                    <li>
                                        <span>담당자명</span>
                                        <asp:TextBox runat="server" ID="GetPlaceChargeName" CssClass="type_01_1 essential"></asp:TextBox>
                                        <button type="button" id="BtnSearchGetPlaceChargeName" class="find">검색</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>직급</span>
                                        <asp:TextBox runat="server" ID="GetPlaceChargePosition" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>내선</span>
                                        <asp:TextBox runat="server" ID="GetPlaceChargeTelExtNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>전화번호</span>
                                        <asp:TextBox runat="server" ID="GetPlaceChargeTelNo" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>휴대폰번호</span>
                                        <asp:TextBox runat="server" ID="GetPlaceChargeCell" CssClass="type_01 essential"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="dispatch_search">
                                    <li style="width:65%;">
                                        <span>주소</span>
                                        <asp:TextBox runat="server" ID="GetPlacePost" CssClass="essential" placeholder="우편번호를 검색하세요" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li style="width:35%;">
                                        <span>&nbsp;</span>
                                        <button type="button" class="btn_100p" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                                    </li>
                                </ul>
                                <ul class="ul_type_01">
                                    <li>
                                        <asp:TextBox runat="server" ID="GetPlaceAddr" CssClass="type_01 essential" placeholder="주소" ReadOnly="true"></asp:TextBox>
                                    </li>
                                    <li>
                                        <asp:TextBox runat="server" ID="GetPlaceAddrDtl" CssClass="type_01" placeholder="상세주소"></asp:TextBox>
                                    </li>
                                </ul>
                                <div id="DivGetPlaceAddrWrap"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>특이사항</span>
                                        <asp:TextBox runat="server" ID="GetPlaceNote" CssClass="type_01 "></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec4">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>화물정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <asp:HiddenField runat="server" ID="GoodsSeqNo"/>
                                <asp:HiddenField runat="server" ID="GoodsDispatchType"/>
                                <asp:HiddenField runat="server" ID="GMOrderType"/>
                                <asp:HiddenField runat="server" ID="GMTripID"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>목적국</span>
                                        <asp:TextBox runat="server" ID="Nation" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>H/AWB</span>
                                        <asp:TextBox runat="server" ID="Hawb" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>M/AWB</span>
                                        <asp:TextBox runat="server" ID="Mawb" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>Invoice No.</span>
                                        <asp:TextBox runat="server" ID="InvoiceNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>Booking No.</span>
                                        <asp:TextBox runat="server" ID="BookingNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>입고 No.</span>
                                        <asp:TextBox runat="server" ID="StockNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>총수량 (EA)</span>
                                        <asp:TextBox runat="server" ID="Volume" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>총부피 (CBM)</span>
                                        <asp:TextBox runat="server" ID="CBM" CssClass="type_01 Weight"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>총중량 (KG)</span>
                                        <asp:TextBox runat="server" ID="Weight" CssClass="type_01 Weight"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>길이 (CM)</span>
                                        <asp:TextBox runat="server" ID="Length" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_04_1">
                                    <li>
                                        <span>품목</span>
                                        <asp:DropDownList runat="server" ID="GoodsItemCode" CssClass="type_01" width="80"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <span>가로</span>
                                        <asp:TextBox runat="server" ID="GoodsItemWidth" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>세로</span>
                                        <asp:TextBox runat="server" ID="GoodsItemHeight" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>높이</span>
                                        <asp:TextBox runat="server" ID="GoodsItemLength" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>수량</span>
                                        <asp:TextBox runat="server" ID="GoodsItemVolume" CssClass="type_01 Volume"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>&nbsp;</span>
                                        <button type="button" class="type_01" id="BtnAddGoodsItem">추가</button>
                                    </li>
                                    <li>
                                        <span>&nbsp;</span>
                                        <button type="button" class="type_01" id="BtnResetGoodsItem">다시입력</button>
                                    </li>
                                </ul>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>화물정보</span>
                                        <asp:TextBox runat="server" ID="Quantity" CssClass="type_01" readonly></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section DispatchInfo" id="Sec5" style="display: none;">
                <h2>배차정보</h2>
                <table>
                    <colgroup>
                        <col style="width:10%"/>
                        <col style="width:90%"/>
                    </colgroup>
                    <tbody id="TbodyDispatchInfo"></tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec6">
                <h2>비용정보</h2>
                <table>
                    <colgroup>
                        <col style="width:10%"/>
                        <col style="width:20%"/>
                        <col style="width:20%"/>
                        <col style="width:50%"/>
                    </colgroup>
                    <tbody id="TbodyPayInfo"></tbody>
                </table>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <button type="button" class="btn_100p" onclick="fnOpenPay();">비용등록</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec7">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>비고</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>비고</span>
                                        <asp:TextBox TextMode="MultiLine" runat="server" ID="NoteInside" CssClass="textarea_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>고객전달사항</span>
                                        <asp:TextBox TextMode="MultiLine" runat="server" ID="NoteClient" CssClass="textarea_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        
            <div class="ins_section" id="Sec8">
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>계산서</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>업체명</span>
                                        <asp:TextBox runat="server" ID="TaxClientName" CssClass="type_01 find"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>사업자번호</span>
                                        <asp:TextBox runat="server" ID="TaxClientCorpNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>담당자</span>
                                        <asp:TextBox runat="server" ID="TaxClientChargeName" CssClass="type_01"></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>전화번호</span>
                                        <asp:TextBox runat="server" ID="TaxClientChargeTelNo" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>이메일</span>
                                        <asp:TextBox runat="server" ID="TaxClientChargeEmail" CssClass="type_01 "></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="reg_btn">
            <button type="button" id="BtnRegOrder">등록하기</button>
        </div>
    </div>
    
    <!--검색용 레이어팝업 시작-->
    <div id="SearchInfoLayer">
        <asp:HiddenField runat="server" ID="HidSearchInfoType"/>
        <div class="info_area">
            <dl>
                <dt>
                    <strong></strong>
                    <button type="button" onclick="fnCloseSearchInfo();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd>
                    <ul class="info_search">
                        <li>
                            <asp:TextBox runat="server" ID="SearchText" placeholder="검색어 (2자리 이상 입력)"></asp:TextBox>
                        </li>
                        <li>
                            <button type="button" class="btn_100p" id="BtnSearchInfo">검색</button>
                        </li>
                    </ul>
                    <ul class="info_list">
                    </ul>
                </dd>
            </dl>
            <button type="button" class="confirm_btn" onclick="fnSetSearchInfo();">선택 적용</button>
        </div>
    </div>
    <!--검색용 레이어팝업 끝-->

    <!--비용등록 선택 팝업 시작-->
    <div id="CostMulti">
        <asp:HiddenField runat="server" ID="SeqNo"/>
        <asp:HiddenField runat="server" ID="PaySeqNo"/>
        <div class="cost_area">
            <dl>
                <dt>
                    <strong>비용등록</strong>
                    <button type="button" onclick="fnClosePay();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd>
                    <asp:HiddenField runat="server" ID="ClientCode"/>
                    <asp:HiddenField runat="server" ID="ClientInfo"/>
                    <table>
                        <tbody>
                            <tr>
                                <td>
                                    <ul class="ul_type_03">
                                        <li>
                                            <asp:DropDownList runat="server" ID="PayType" CssClass="type_01"></asp:DropDownList>
                                        </li>
                                        <li>
                                            <asp:DropDownList runat="server" ID="TaxKind" CssClass="type_01"></asp:DropDownList>
                                        </li>
                                        <li>
                                            <asp:DropDownList runat="server" ID="ItemCode" CssClass="type_01"></asp:DropDownList>
                                        </li>
                                        <li>
                                            <asp:TextBox runat="server" ID="SupplyAmt" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                                        </li>
                                        <li>
                                            <asp:TextBox runat="server" ID="TaxAmt" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                                        </li>
                                        <li>
                                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="업체명"></asp:TextBox>
                                        </li>
                                        <li>
                                            <button type="button" class="btn_100p" id="BtnAddPay">추가</button>
                                        </li>
                                        <li>
                                            <button type="button" class="btn_100p" id="BtnUpdPay" style="display: none;">수정</button>
                                        </li>
                                        <li>
                                            <button type="button" class="btn_100p" id="BtnResetPay">다시입력</button>
                                        </li>
                                    </ul>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                </dd>
                <dd>
                    <div class="cost_list">
                        <div id="AppInoutPayListGrid"></div>
                    </div>
                </dd>
            </dl>
            <ul class="btn_double">
                <li>
                    <button type="button" id="BtnDelPay">삭제</button>
                </li>
                <li>
                    <button type="button" id="BtnSetPay">비용등록</button>
                </li>
            </ul>
        </div>
    </div>
    <!--비용등록 선택 팝업 끝-->
</asp:Content>