<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppPopup.Master" AutoEventWireup="true" CodeBehind="InoutDetail.aspx.cs" Inherits="APP.TMS.Inout.InoutDetail" %>

<asp:Content ID="headscript" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/TMS/Inout/Proc/InoutDetail.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="MainFormPlaceHolder" ContentPlaceHolderID="MainFormPlaceHolder" runat="server">
<asp:HiddenField runat="server" ID="HidCenterCode" />
<asp:HiddenField runat="server" ID="HidOrderNo" />
<asp:HiddenField runat="server" ID="HidErrMsg" />
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="ChgSeqNo"/>
<asp:HiddenField runat="server" ID="ContractType"/>
<asp:HiddenField runat="server" ID="ContractStatus"/>
<asp:HiddenField runat="server" ID="OrderStatus"/>
<asp:HiddenField runat="server" ID="OrderRegType"/>
<asp:HiddenField runat="server" ID="OldPickupPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="OldGetPlaceFullAddr"/>
<asp:HiddenField runat="server" ID="GoodsSeqNo"/>
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
                <asp:DropDownList runat="server" CssClass="type_01" ID="OrderLocationCode"></asp:DropDownList>
            </li>
        </ul>
    </div>

    <div class="data_detail">
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
                        <asp:Label runat="server" id="GoodsDispatchTypeM"></asp:Label>&nbsp;
                        <asp:Label runat="server" id="OrderItemCodeM"></asp:Label>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="detail_section">
            <h2>체크사항</h2>
            <table>
                <tbody>
                    <tr>
                        <td>
                            <ul class="detail_check">
                                <li id="LiNoLayerFlag">이단불가</li>
                                <li id="LiNoTopFlag">무탑배차</li>
                                <li id="LiFTLFlag">FTL</li>
                                <li id="LiCustomFlag">통관</li>
                                <li id="LiBondedFlag">보세</li>
                                <li id="LiDocumentFlag">서류</li>   
                                <li id="LiArrivalReportFlag">도착보고</li>  
                                <li id="LiLicenseFlag">면허진행</li> 
                                <li id="LiInTimeFlag">시간엄수</li>
                                <li id="LiControlFlag">특별관제</li>
                                <li id="LiQuickGetFlag">하차긴급</li>
                            </ul>
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
                    <tr>
                        <td>청구사업장</td>
                        <td ><asp:Label runat="server" id="PayClientChargeLocation"></asp:Label></td>
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
                    <tr>
                        <td>특이사항</td>
                        <td><asp:Label runat="server" id="PickupPlaceNote"></asp:Label></td>
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
                    <tr>
                        <td>특이사항</td>
                        <td><asp:Label runat="server" id="GetPlaceNote"></asp:Label></td>
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
                        <td>목적국</td>
                        <td><asp:Label runat="server" id="Nation"></asp:Label></td>
                        <td>H/AWB</td>
                        <td><asp:Label runat="server" id="Hawb"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>M/AWB</td>
                        <td><asp:Label runat="server" id="Mawb"></asp:Label></td>
                        <td>Invoice No.</td>
                        <td><asp:Label runat="server" id="InvoiceNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Booking No.</td>
                        <td><asp:Label runat="server" id="BookingNo"></asp:Label></td>
                        <td>입고 No.</td>
                        <td><asp:Label runat="server" id="StockNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>수량(EA)</td>
                        <td><asp:Label runat="server" id="Volume"></asp:Label></td>
                        <td>부피(CBM)</td>
                        <td><asp:Label runat="server" id="CBM"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>중량(KG)</td>
                        <td><asp:Label runat="server" id="Weight"></asp:Label></td>
                        <td>길이(CM)</td>
                        <td><asp:Label runat="server" id="Length"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>화물상세</td>
                        <td colspan="3"><asp:Label runat="server" id="Quantity"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="detail_section DispatchInfo">
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

        <div class="detail_section hide">
            <h2>계산서</h2>
            <table style="margin-top: 20px;">
                <colgroup>
                    <col style="width:20%"/>
                    <col style="width:80%"/>
                </colgroup>
                <tbody>
                    <tr>
                        <td>업체명</td>
                        <td><asp:Label runat="server" id="TaxClientName"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>사업자번호</td>
                        <td><asp:Label runat="server" id="TaxClientCorpNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>담당자</td>
                        <td><asp:Label runat="server" id="TaxClientChargeName"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>전화번호</td>
                        <td><asp:Label runat="server" id="TaxClientChargeTelNo"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>이메일</td>
                        <td><asp:Label runat="server" id="TaxClientChargeEmail"></asp:Label></td>
                    </tr>
                </tbody>
            </table>
        </div>
    
        <div class="reg_btn">
            <button type="button" id="BtnGoUpdOrder">수정하기</button>
        </div>
    </div>

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
</asp:Content>