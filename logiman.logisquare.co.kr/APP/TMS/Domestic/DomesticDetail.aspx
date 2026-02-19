<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="DomesticDetail.aspx.cs" Inherits="APP.TMS.Domestic.DomesticDetail" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/TMS/Domestic/Proc/DomesticDetail.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
<asp:HiddenField runat="server" ID="HidCenterCode" />
<asp:HiddenField runat="server" ID="HidOrderNo" />
<asp:HiddenField runat="server" ID="HidErrMsg" />
<asp:HiddenField runat="server" ID="GoodsSeqNo"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="OrderItemCode"/>
<asp:HiddenField runat="server" ID="NetworkNo"/>
<asp:HiddenField runat="server" ID="TransType"/>
<asp:HiddenField runat="server" ID="TargetCenterCode"/>
<asp:HiddenField runat="server" ID="TargetOrderNo"/>
<asp:HiddenField runat="server" ID="ContractType"/>
<asp:HiddenField runat="server" ID="ContractStatus"/>
<asp:HiddenField runat="server" ID="TransDtlSeqNo"/>
<asp:HiddenField runat="server" ID="ApplySeqNo"/>
<asp:HiddenField runat="server" ID="DispatchSeqNo"/>
<asp:HiddenField runat="server" ID="RefSeqNo"/>
<asp:HiddenField runat="server" ID="QuickType"/>
<asp:HiddenField runat="server" ID="GoodsDispatchType"/>
<asp:HiddenField runat="server" ID="CarFixedFlag"/>
<!--리스트 검색조건 파라미터 BackButton-->
<asp:HiddenField runat="server" ID="HidParam"/>

    <div class="control_btn">
        <ul class="control_type_01">
            <li>
                <button type="button" class="type_01" id="BtnCopyOrder">오더복사</button>
            </li>
            <li>
                <button type="button" class="type_03" id="BtnCancelOrder">오더취소</button>
            </li>
            <li>
                <button type="button" class="type_02" id="BtnDispatchOrder" onclick="fnOpenDispatchCar();">차량배차</button>
            </li>
        </ul>
    </div>

    <div class="data_detail">
        <div class="detail_section hide" id="DivTrans">
            <h2>이관정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody class="tleft">
                <tr>
                    <td colspan="2">
                        <asp:Label runat="server" ID="TransInfo"></asp:Label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section hide" id="DivContract">
            <h2>위탁정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody class="tleft">
                <tr>
                    <td colspan="2">
                        <asp:Label runat="server" ID="ContractInfo"></asp:Label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section">
            <table>
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody>
                <tr>
                    <td>회원사명</td>
                    <td><asp:Label runat="server" id="CenterName"></asp:Label></td>
                </tr>
                <tr>
                    <td>접수번호</td>
                    <td>
                        <asp:Label runat="server" id="OrderStatusM"></asp:Label>&nbsp;
                        <asp:Label runat="server" id="OrderNo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>접수자</td>
                    <td>
                        <asp:Label runat="server" id="AcceptAdminName"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>접수일</td>
                    <td><asp:Label runat="server" id="AcceptDate"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <asp:Label runat="server" id="OrderLocationCodeM"></asp:Label>&nbsp;
                        <asp:Label runat="server" id="GoodsDispatchTypeM"></asp:Label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="detail_section hide">
            <h2>업체정보</h2>
            <table>
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
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
                        <td>화주명</td>
                        <td><asp:Label runat="server" id="ConsignorName"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
            <table>
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
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
                        <td>발주처명</td>
                        <td><asp:Label runat="server" id="OrderClientName"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>담당자명</td>
                        <td>
                            <asp:Label runat="server" id="OrderClientChargePosition"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="OrderClientChargeName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>전화번호</td>
                        <td><asp:Label runat="server" id="OrderClientChargeTelNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>휴대폰번호</td>
                        <td><asp:Label runat="server" id="OrderClientChargeCell"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
            <table>
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
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
                        <td>청구처명</td>
                        <td><asp:Label runat="server" id="PayClientName"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>사업자번호</td>
                        <td><asp:Label runat="server" id="PayClientCorpNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>담당자명</td>
                        <td>
                            <asp:Label runat="server" id="PayClientChargePosition"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="PayClientChargeName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>전화번호</td>
                        <td><asp:Label runat="server" id="PayClientChargeTelNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>휴대폰번호</td>
                        <td ><asp:Label runat="server" id="PayClientChargeCell"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section hide">
            <asp:HiddenField runat="server" ID="PickupPlaceFullAddr"/>
            <h2>상차정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody>
                    <tr>
                        <td>상차일</td>
                        <td><asp:Label runat="server" id="PickupYMD"></asp:Label> <asp:Label runat="server" id="PickupHM"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>상차방법</td>
                        <td><asp:Label runat="server" id="PickupWay"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>상차지명</td>
                        <td><asp:Label runat="server" id="PickupPlace"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>담당자명</td>
                        <td>
                            <asp:Label runat="server" id="PickupPlaceChargePosition"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="PickupPlaceChargeName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>전화번호</td>
                        <td><asp:Label runat="server" id="PickupPlaceChargeTelNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>휴대폰번호</td>
                        <td><asp:Label runat="server" id="PickupPlaceChargeCell"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>주소</td>
                        <td>
                            <asp:Label runat="server" id="PickupPlacePost"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="PickupPlaceAddr"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>상세주소</td>
                        <td><asp:Label runat="server" id="PickupPlaceAddrDtl"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section hide">
            <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
            <h2>하차정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody>
                    <tr>
                        <td>하차일</td>
                        <td><asp:Label runat="server" id="GetYMD"></asp:Label> <asp:Label runat="server" id="GetHM"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>하차방법</td>
                        <td><asp:Label runat="server" id="GetWay"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>하차지명</td>
                        <td><asp:Label runat="server" id="GetPlace"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>담당자명</td>
                        <td>
                            <asp:Label runat="server" id="GetPlaceChargePosition"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="GetPlaceChargeName"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>전화번호</td>
                        <td><asp:Label runat="server" id="GetPlaceChargeTelNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>휴대폰번호</td>
                        <td><asp:Label runat="server" id="GetPlaceChargeCell"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>주소</td>
                        <td>
                            <asp:Label runat="server" id="GetPlacePost"></asp:Label>&nbsp;
                            <asp:Label runat="server" id="GetPlaceAddr"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>상세주소</td>
                        <td><asp:Label runat="server" id="GetPlaceAddrDtl"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <div class="detail_section">
            <h2>화물정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:30%"/>
                    <col style="width:20%"/>
                    <col style="width:30%"/>
                </colgroup>
                <tbody>
                    <tr>
                        <td>요청톤급</td>
                        <td><asp:Label runat="server" id="CarTonCodeM"></asp:Label></td>
                        <td>요청차종</td>
                        <td><asp:Label runat="server" id="CarTypeCodeM"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>중량 (KG)</td>
                        <td><asp:Label runat="server" id="Weight"></asp:Label></td>
                        <td>수량 (EA)</td>
                        <td><asp:Label runat="server" id="Volume"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>길이 (CM)</td>
                        <td><asp:Label runat="server" id="Length"></asp:Label></td>
                        <td>부피 (CBM)</td>
                        <td><asp:Label runat="server" id="CBM"></asp:Label></td>
                    </tr>
                    <tr>          
                        <td>화물명</td>
                        <td><asp:Label runat="server" id="GoodsName"></asp:Label></td>              
                        <td>품목</td>
                        <td><asp:Label runat="server" id="GoodsItemCodeM"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>화물비고</td>
                        <td colspan="3"><asp:Label runat="server" id="GoodsNote"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section">
            <h2>배차정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:10%"/>
                    <col style="width:90%"/>
                </colgroup>
                <tbody id="TbodyDispatchInfo"></tbody>
            </table>
        </div>
        
        <div class="detail_section">
            <h2>운송정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:30%"/>
                    <col style="width:20%"/>
                    <col style="width:30%"/>
                </colgroup>
                <tbody>
                <tr>
                    <td>독차/혼적</td>
                    <td><asp:Label runat="server" id="FTLFlagM"></asp:Label></td>                       
                    <td>운행구분</td>
                    <td><asp:Label runat="server" id="GoodsRunTypeM"></asp:Label></td>
                </tr>
                <tr>
                    <td>고정/용차</td>
                    <td><asp:Label runat="server" id="CarFixedFlagM"></asp:Label></td>
                </tr>
                <tr>
                    <td>경유지</td>
                    <td><asp:Label runat="server" id="LayoverFlag"></asp:Label></td>
                </tr>
                <tr>
                    <td>동일지역수</td>
                    <td><asp:Label runat="server" id="SamePlaceCount"></asp:Label></td>
                    <td>타지역수</td>
                    <td><asp:Label runat="server" id="NonSamePlaceCount"></asp:Label></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section hide" id="DivUnitAmt">
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
                                    <asp:TextBox runat="server" CssClass="type_01" ID="SaleUnitAmt" ReadOnly="true"></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (고정)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="FixedPurchaseUnitAmt" ReadOnly="true"></asp:TextBox>
                                </li>
                                <li>
                                    <span>매입 (용차)</span>
                                    <asp:TextBox runat="server" CssClass="type_01" ID="PurchaseUnitAmt" ReadOnly="true"></asp:TextBox>
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
                    <tr class="TrUpdRequestAmt">
                        <td>
                            <button type="button" class="btn_100p" id="BtnUpdRequestAmt">자동운임 수정요청</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section">
            <h2>비용정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:10%"/>
                    <col style="width:20%"/>
                    <col style="width:20%"/>
                    <col style="width:50%"/>
                </colgroup>
                <tbody id="TbodyPayInfo"></tbody>
            </table>
        </div>

        <div class="detail_section" id="DivTransPay">
            <h2>이관매출정보</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:10%"/>
                    <col style="width:20%"/>
                    <col style="width:20%"/>
                    <col style="width:50%"/>
                </colgroup>
                <tbody id="TbodyTransPayInfo"></tbody>
            </table>
        </div>

        <div class="detail_section hide">
            <h2>비고</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:100%"/>
                </colgroup>
                <tbody class="tleft">
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="NoteInside"></asp:Label>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section hide">
            <h2>고객전달사항</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:100%"/>
                </colgroup>
                <tbody class="tleft">
                    <tr>
                        <td>
                            <asp:Label runat="server" ID="NoteClient"></asp:Label>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    
        <div class="reg_btn">
            <button type="button" id="BtnGoUpdOrder">수정하기</button>
        </div>
    </div>

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
            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="InsureExceptKind" style="margin-top:20px;"></asp:DropDownList>
            <button type="button" class="confirm_btn" onclick="fnSetDispatchCar();">배차등록</button>
        </div>
    </div>
    <!--차량배차 레이어팝업 끝-->

    <!--오더 취소 레이어팝업 시작-->
    <div id="OrderCancelLayer">
        <div class="ordercancel_area">
            <dl>
                <dt>
                    <strong>오더취소</strong>
                    <button type="button" onclick="fnCloseCnlOrder();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd>
                    <textarea id="CnlReason"></textarea>
                </dd>
            </dl>
            <button type="button" class="confirm_btn" onclick="fnCnlOrderProc();">오더취소</button>
        </div>
    </div>
    <!--오더 취소 레이어팝업 끝-->

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