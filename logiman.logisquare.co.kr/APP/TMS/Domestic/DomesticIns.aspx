<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="DomesticIns.aspx.cs" Inherits="APP.TMS.Domestic.DomesticIns" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/TMS/Domestic/Proc/DomesticIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
<asp:HiddenField runat="server" ID="HidDisplayMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="OrderNo"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="OrderItemCode"/>
<asp:HiddenField runat="server" ID="NetworkNo"/>
<asp:HiddenField runat="server" ID="TransType"/>
<asp:HiddenField runat="server" ID="TargetCenterCode"/>
<asp:HiddenField runat="server" ID="TargetOrderNo"/>
<asp:HiddenField runat="server" ID="ContractType"/>
<asp:HiddenField runat="server" ID="ContractStatus"/>
<asp:HiddenField runat="server" ID="DispatchRefSeqNo1"/>
<asp:HiddenField runat="server" ID="ChgSeqNo"/>
<asp:HiddenField runat="server" ID="OldPickupPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="OldGetPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="OrderRegType"/>
<%//자동운임 비교 항목 시작%>
<asp:HiddenField runat="server" ID="HidCenterCode"/>
<asp:HiddenField runat="server" ID="HidGoodsDispatchType"/>
<asp:HiddenField runat="server" ID="HidOrderLocationCode"/>
<asp:HiddenField runat="server" ID="HidPayClientCode"/>
<asp:HiddenField runat="server" ID="HidConsignorCode"/>
<asp:HiddenField runat="server" ID="HidPickupYMD"/>
<asp:HiddenField runat="server" ID="HidPickupHM"/>
<asp:HiddenField runat="server" ID="HidPickupPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="HidGetYMD"/>
<asp:HiddenField runat="server" ID="HidGetHM"/>
<asp:HiddenField runat="server" ID="HidGetPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="HidCarTonCode"/>
<asp:HiddenField runat="server" ID="HidCarTypeCode"/>
<asp:HiddenField runat="server" ID="HidVolume"/>
<asp:HiddenField runat="server" ID="HidWeight"/>
<asp:HiddenField runat="server" ID="HidCBM"/>
<asp:HiddenField runat="server" ID="HidLength"/>
<asp:HiddenField runat="server" ID="HidFTLFlag"/>
<asp:HiddenField runat="server" ID="HidGoodsRunType"/>
<asp:HiddenField runat="server" ID="HidCarFixedFlag"/>
<asp:HiddenField runat="server" ID="HidLayoverFlag"/>
<asp:HiddenField runat="server" ID="HidSamePlaceCount"/>
<asp:HiddenField runat="server" ID="HidNonSamePlaceCount"/>
<%//자동운임 비교 항목 끝 %>
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
            <li>
                <button type="button" onclick="fnPositionMove('#Sec5');">배차정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec8');">운송정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec6');">비용정보</button>
            </li>
            <li>
                <button type="button" onclick="fnPositionMove('#Sec7');">비고</button>
            </li>
        </ul>
    </div>
    <div class="contents">
        <div class="data_detail">
            <div class="ins_section" id="DivTrans" style="display: none;">
                <h2>이관정보</h2>
                <table>
                    <tbody>
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="TransInfo"></asp:Label>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

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
                <div class="NotAllowed NotAllowedTrans"></div>
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <td>
                            <ul class="ul_type_02">
                                <li>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                                </li>
                                <li>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="GoodsDispatchType"></asp:DropDownList>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr style="display: none;" class="DispatchType3">
                        <td>
                            <ul class="ul_type_01">
                                <li>
                                    <span>사업장</span>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderLocationCode"></asp:DropDownList>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="data_detail">
            <div class="ins_section" id="Sec1">
                <div class="NotAllowed NotAllowedTrans"></div>
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>업체정보</h2>
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
                                <asp:HiddenField runat="server" ID="OrderClientChargePosition"/>
                                <asp:HiddenField runat="server" ID="OrderClientChargeTelExtNo"/>
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
                                <asp:HiddenField runat="server" ID="PayClientChargePosition"/>
                                <asp:HiddenField runat="server" ID="PayClientChargeTelExtNo"/>
                                <asp:HiddenField runat="server" ID="PayClientCorpNo"/>
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
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec2">
                <div class="NotAllowed NotAllowedTrans"></div>
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
                                <asp:HiddenField runat="server" ID="PickupPlaceChargePosition"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceChargeTelExtNo"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceFullAddr"/>
                                <asp:HiddenField runat="server" ID="PickupPlaceNote"/>
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
                                <ul class="ul_type_02">
                                    <li style="float:none;">
                                        <span>상차방법</span>
                                        <asp:DropDownList runat="server" ID="PickupWay"></asp:DropDownList>
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
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec3">
                <div class="NotAllowed NotAllowedTrans"></div>
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
                                <asp:HiddenField runat="server" ID="GetPlaceChargePosition"/>
                                <asp:HiddenField runat="server" ID="GetPlaceChargeTelExtNo"/>
                                <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
                                <asp:HiddenField runat="server" ID="GetPlaceNote"/>
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
                                <ul class="ul_type_02">
                                    <li style="float:none;">
                                        <span>하차방법</span>
                                        <asp:DropDownList runat="server" ID="GetWay"></asp:DropDownList>
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
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec4">
                <div class="NotAllowed NotAllowedTrans"></div>
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
                                <asp:HiddenField runat="server" ID="GoodsItemCode"/>
                                <ul class="ul_type_02">
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarTonCode" CssClass="essential"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <asp:DropDownList runat="server" ID="CarTypeCode" CssClass="essential"></asp:DropDownList>
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
                                        <span>총중량 (KG)</span>
                                        <asp:TextBox runat="server" ID="Weight" CssClass="type_01 Weight"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>부피 (CBM)</span>
                                        <asp:TextBox runat="server" ID="CBM" CssClass="type_01 Weight"></asp:TextBox>
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
                                <ul class="ul_type_02">
                                    <li style="float:none;">
                                        <span>화물명</span>
                                        <asp:TextBox runat="server" ID="GoodsName" CssClass="type_01"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_01">
                                    <li>
                                        <span>화물비고</span>
                                        <asp:TextBox runat="server" CssClass="type_01" ID="GoodsNote"></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec5">
                <div class="NotAllowed NotAllowedTrans"></div>
                <div class="NotAllowed NotAllowedContract"></div>
                <h2>배차정보</h2>
                <table>
                    <asp:HiddenField runat="server" ID="QuickType"/>
                    <asp:HiddenField runat="server" ID="InsureExceptKind"/>
                    <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
                    <asp:HiddenField runat="server" ID="RefSeqNo"/>
                    <colgroup>
                        <col style="width:10%"/>
                        <col style="width:90%"/>
                    </colgroup>
                    <tbody id="TbodyDispatchInfo"></tbody>
                </table>
                <table class="DispatchType2">
                    <colgroup>
                        <col style="width:50%"/>
                        <col style="width:50%"/>
                    </colgroup>
                    <tbody>
                        <tr class="DispatchType2Reg">
                            <td colspan="2">
                                <ul class="ul_type_01">
                                    <li>
                                        <button type="button" class="btn_100p" onclick="fnOpenDispatchCar();">차량배차등록</button>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr class="DispatchType2Upd"  style="display: none;">
                            <td>
                                <button type="button" class="btn_100p" onclick="fnOpenDispatchCar();">차량배차변경</button>
                            </td>
                            <td>
                                <button type="button" class="btn_100p" id="BtnResetDispatch">차량배차취소</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="ins_section" id="Sec8">
                <div class="NotAllowed NotAllowedTrans"></div>
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <h2>운송정보</h2>
                <table>
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li>
                                        <span>독차/혼적</span>
                                        <asp:DropDownList runat="server" ID="FTLFlag" CssClass="essential"></asp:DropDownList>
                                    </li>
                                    <li>
                                        <span>운행구분</span>
                                        <asp:DropDownList runat="server" ID="GoodsRunType" CssClass="essential"></asp:DropDownList>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_02">
                                    <li style="float:none;">
                                        <span>고정/용차</span>
                                        <asp:DropDownList runat="server" ID="CarFixedFlag" CssClass="essential"></asp:DropDownList>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox runat="server" ID="LayoverFlag" Text="경유지<span></span>"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <ul class="ul_type_03_1">
                                    <li>
                                        <span>동일 지역 수</span>
                                        <asp:TextBox runat="server" ID="SamePlaceCount" CssClass="type_01 Volume" MaxLength="3" readonly></asp:TextBox>
                                    </li>
                                    <li>
                                        <span>타지역 수</span>
                                        <asp:TextBox runat="server" ID="NonSamePlaceCount" CssClass="type_01 Volume" MaxLength="3" readonly></asp:TextBox>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="DivUnitAmt">
                <div class="NotAllowed NotAllowedTrans"></div>
                <div class="NotAllowed NotAllowedContractTarget"></div>
                <asp:HiddenField runat="server" ID="ApplySeqNo"/>
                <h2>자동운임</h2>
                <table style="margin-top: 20px;">
                    <colgroup>
                        <col style="width:100%"/>
                    </colgroup>
                    <tbody class="tleft">
                    <tr>
                        <td>
                            <span style = "font-weight: 700;">기본운임</span> <p id="PTransRateInfo" style="font-size: 3.61vw;"></p>
                            <ul class="ul_type_03_1">
                                <li>
                                    <span>매출</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="SaleUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (고정)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="FixedPurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (용차)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="PurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span style = "font-weight: 700;">경유지</span> <p id="PLayoverTransRateInfo" style="font-size: 3.61vw;"></p>
                            <ul class="ul_type_03_1">
                                <li>
                                    <span>매출</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="LayoverSaleUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (고정)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="LayoverFixedPurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (용차)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="LayoverPurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span style = "font-weight: 700;">유가연동</span> <p id="POilTransRateInfo" style="font-size: 3.61vw;"></p>
                            <ul class="ul_type_03_1">
                                <li>
                                    <span>매출</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="OilSaleUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (고정)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="OilFixedPurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (용차)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="OilPurchaseUnitAmt" readonly></asp:TextBox>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr class="TrCallTransRate">
                        <td>
                            <button type="button" class="btn_100p" id="BtnCallTransRate">자동운임확인</button>
                        </td>
                    </tr>
                    <tr class="TrUpdRequestAmt" style="display: none;">
                        <td>
                            <button type="button" class="btn_100p" id="BtnUpdRequestAmt">자동운임수정요청</button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec6">
                <div class="NotAllowed NotAllowedTrans"></div>
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

            <div class="detail_section" id="DivTransPay">
                <h2>이관매출정보</h2>
                <table>
                    <colgroup>
                        <col style="width:10%"/>
                        <col style="width:20%"/>
                        <col style="width:20%"/>
                        <col style="width:50%"/>
                    </colgroup>
                    <tbody id="TbodyTransPayInfo"></tbody>
                </table>
            </div>

            <div class="ins_section" id="Sec7">
                <div class="NotAllowed NotAllowedTrans"></div>
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

    <!--차량배차 레이어팝업 시작-->
    <div id="DispatchLayer">
        <div class="dispatch_area">
            <dl>
                <dt>
                    <strong>차량배차</strong>
                    <button type="button" onclick="fnCloseDispatchCar();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd>
                    <ul class="dispatch_search">
                        <li>
                            <asp:TextBox runat="server" ID="SearchCarNo" placeholder="차량번호(4차리이상입력)"></asp:TextBox>
                        </li>
                        <li>
                            <button type="button" class="btn_100p" id="BtnSearchDispatchCar">검색</button>
                        </li>
                    </ul>
                    <ul class="dispatch_list">
                    </ul>
                </dd>
            </dl>
            <button type="button" class="confirm_btn" onclick="fnSetDispatchCar();">배차등록</button>
        </div>
    </div>
    <!--차량배차 레이어팝업 끝-->

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
                        <div id="AppDomesticPayListGrid"></div>
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

    <!--자동운임 수정요청 시작-->
    <div id="PayRateLayer">
        <asp:HiddenField runat="server" id="RateSaleTaxKind1" Value="1"/>
        <asp:HiddenField runat="server" id="RateSalePaySeqNo1"/>
        <asp:HiddenField runat="server" id="RatePurchaseTaxKind1" Value="1"/>
        <asp:HiddenField runat="server" id="RatePurchasePaySeqNo1"/>
        <asp:HiddenField runat="server" id="RateSaleTaxKind2" Value="1"/>
        <asp:HiddenField runat="server" id="RateSalePaySeqNo2"/>
        <asp:HiddenField runat="server" id="RatePurchaseTaxKind2" Value="1"/>
        <asp:HiddenField runat="server" id="RatePurchasePaySeqNo2"/>
        <asp:HiddenField runat="server" id="RateSaleTaxKind3" Value="1"/>
        <asp:HiddenField runat="server" id="RateSalePaySeqNo3"/>
        <asp:HiddenField runat="server" id="RatePurchaseTaxKind3" Value="1"/>
        <asp:HiddenField runat="server" id="RatePurchasePaySeqNo3"/>
        <div class="payrate_area">
            <dl>
                <dt>
                    <strong>자동운임 수정요청</strong>
                    <button type="button" onclick="fnClosePayRate();"><img src="/APP/images/layer_close.png"/></button>
                </dt>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px;" class="DlRate">
                <dd>
                    <p>기본운임 <span class="red">매출</span> 공급가액 : <strong id="RateOriSaleSupplyAmt1"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleSupplyAmt1" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleTaxAmt1" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RateSaleReason1" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnSale1">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(1, 1);">요청</button>
                </dd>
                <dd class="RateStatusSale1 status" style="display: none;"></dd>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px;" class="DlRate">
                <dd>
                    <p>기본운임 <span class="blue">매입</span> 공급가액 :  <strong id="RateOriPurchaseSupplyAmt1"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseSupplyAmt1" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseTaxAmt1" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RatePurchaseReason1" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnPurchase1">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(1, 2);">요청</button>
                </dd>
                <dd class="RateStatusPurchase1 status" style="display: none;"></dd>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px; display: none;" class="DlRateLayover">
                <dd>
                    <p>경유지 <span class="red">매출</span> 공급가액 :  <strong id="RateOriSaleSupplyAmt2"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleSupplyAmt2" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleTaxAmt2" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RateSaleReason2" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnSale2">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(2, 1);">요청</button>
                </dd>
                <dd class="RateStatusSale2 status" style="display: none;"></dd>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px; display: none;" class="DlRateLayover">
                <dd>
                    <p>경유지 <span class="blue">매입</span> 공급가액 :  <strong id="RateOriPurchaseSupplyAmt2"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseSupplyAmt2" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseTaxAmt2" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RatePurchaseReason2" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnPurchase2">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(2, 2);">요청</button>
                </dd>
                <dd class="RateStatusPurchase2 status" style="display: none;"></dd>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px; display: none;" class="DlRateOil">
                <dd>
                    <p>유가연동 <span class="red">매출</span> 공급가액 :  <strong id="RateOriSaleSupplyAmt3"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleSupplyAmt3" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RateSaleTaxAmt3" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RateSaleReason3" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnSale3">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(3, 1);">요청</button>
                </dd>
                <dd class="RateStatusSale3 status" style="display: none;"></dd>
            </dl>
            <dl style="border-top: 1px solid #eee; margin-top: 15px; display: none;" class="DlRateOil">
                <dd>
                    <p>유가연동 <span class="blue">매입</span> 공급가액 :  <strong id="RateOriPurchaseSupplyAmt3"></strong></p>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseSupplyAmt3" placeholder="공급가액" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd style="width: 50%; float: left;">
                    <asp:TextBox runat="server" ID="RatePurchaseTaxAmt3" placeholder="부가세" CssClass="type_01 Money"></asp:TextBox>
                </dd>
                <dd>
                    <asp:TextBox runat="server" ID="RatePurchaseReason3" placeholder="요청사유" CssClass="type_01"></asp:TextBox>
                </dd>
                <dd class="RateBtnPurchase3">
                    <button type="button" class="confirm_btn" onclick="fnSetPayRate(3, 2);">요청</button>
                </dd>
                <dd class="RateStatusPurchase3 status" style="display: none;"></dd>
            </dl>
        </div>
    </div>
    <!--자동운임 수정요청 끝-->
</asp:Content>