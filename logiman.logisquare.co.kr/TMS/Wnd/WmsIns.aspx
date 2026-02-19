<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WmsIns.aspx.cs" Inherits="TMS.Wnd.WmsIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Wnd/Proc/WmsIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
    <style>
        .tbcar th { font-size: 13px !important; padding: 5px !important;}
        .tbcar td { font-size: 13px !important; padding: 5px !important; height: 45px;}
        .tbcar td:nth-child(3) { text-align: left !important; }
        .tbcar td span { font-size: 13px !important;}
        .tbcar td input { margin-left: 0px;}
        .tbcar td select { margin-left: 0px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidDisplayMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="OrderItemCode"/>
<asp:HiddenField runat="server" ID="NetworkNo"/>
<asp:HiddenField runat="server" ID="CargopassOrderNo"/>
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

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div id="OrderFixed">
                    <table class="fcl_tb_type_01" style="margin-bottom:0px;">
                        <colgroup>
                            <col style="width:50%"/> 
                            <col style="width:50%;"/> 
                        </colgroup>
                        <tbody>
                            <tr>
                                <td>
                                    <asp:HiddenField runat="server" ID="OrderNo"/>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="GoodsDispatchType"></asp:DropDownList>
                                    <asp:DropDownList runat="server" CssClass="type_01 DispatchType3 essential" ID="OrderLocationCode" style="display: none;"></asp:DropDownList>
                                    <span id="DeliveryLocationCodeM"></span>
                                </td>
                                <td>
                                    <button type="button" class="btn_03" id="BtnCancelOrder" runat="server"  style="float:right;">오더취소</button>
                                    <button type="button" class="btn_01" id="BtnRegOrder" style="float:right; margin-right:5px;">등록 (F2)</button>
                                    <div runat="server" ID="DivOrderInfo" style="float:right;">
                                        <asp:Label runat="server" ID="OrderStatusM" style="font-weight: bold; color: #5674C8;"></asp:Label>&nbsp;
                                        <asp:Label runat="server" ID="OrderNoInfo"></asp:Label>&nbsp;&nbsp;
                                        접수일 : <asp:Label runat="server" ID="AcceptDate"></asp:Label>&nbsp;&nbsp;
                                        접수자 : <asp:Label runat="server" ID="AcceptAdminName"></asp:Label>&nbsp;&nbsp;
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <table class="popup_table order_table">
                    <colgroup>
                        <col style="width:135px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3" class="bdbt">
                            업체정보<br/>
                            <button type="button" class="btn_02" id="BtnResetClient">다시입력</button>
                        </th>
                        <td class="TdClient bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="ConsignorCode"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="ConsignorName" placeholder="* 화주명"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnSearchConsignorInfo"></button>
                            <button type="button" class="btn_01" id="BtnOpenConsignor">화주간편등록</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdClient bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="OrderClientCode"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="OrderClientName" placeholder="* 발주처명"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnSearchOrderClientInfo"></button>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="OrderClientChargeName" placeholder="담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="OrderClientChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="OrderClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="OrderClientChargeTelNo" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="OrderClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            &nbsp;<span style="font-weight: 700; color: #ff0000; vertical-align: unset;" id="SpanOrderClientMisuAmt"></span>
                            &nbsp;<button type="button" class="btn_01" id="BtnOrderClientMisuAmt" style="display:none;">미수내역</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdClient bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="PayClientCode"/>
                            <asp:HiddenField runat="server" ID="PayClientInfo"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="PayClientName" placeholder="* 청구처명"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnSearchPayClientInfo"></button>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="PayClientChargeName" placeholder="담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PayClientChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PayClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="PayClientChargeTelNo" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="PayClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PayClientCorpNo" placeholder="사업자번호" readonly></asp:TextBox>
                            &nbsp;<span style="font-weight: 700; color: #ff0000; vertical-align: unset;" id="SpanPayClientMisuAmt"></span>
                            &nbsp;<button type="button" class="btn_01" id="BtnPayClientMisuAmt" style="display:none;">미수내역</button>
                        </td>
                    </tr>

                    <tr>
                        <th rowspan="3" class="bdbt">
                            상차정보<br/>
                            <button type="button" class="btn_02" id="BtnResetPickupPlace">다시입력</button>
                            <p class="change_place change_place_img1" onclick="fnChangePlace(); return false;" style="display:none;" ><span class="change_txt_top">상</span><br><span class="change_txt_bottom">하</span></p>
                        </th>
                        <td class="TdPickup bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="PickupPlaceSeqNo"/>
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="PickupYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="PickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="PickupPlace" placeholder="* 상호"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnOpenPickupPlaceNote"></button>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="PickupPlaceChargeName" placeholder="담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PickupPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="PickupPlaceChargeTelNo" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="PickupPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="PickupWay" CssClass="type_01"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="PickupPlaceSearch" placeholder="주소검색" Width="150"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03" ID="PickupPlaceAddr" placeholder="주소" readonly Width="300"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03" ID="PickupPlaceAddrDtl" placeholder="상세주소" Width="300"></asp:TextBox>
                            &nbsp;&nbsp;<span style="font-weight: 700; color: #999999;">적용주소</span>
                            <asp:TextBox runat="server" CssClass="type_02" ID="PickupPlaceFullAddr" placeholder="적용주소" readonly></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" CssClass="type_100p" ID="PickupPlaceNote" width="99%" placeholder="특이사항" style="margin-left: 5px;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <th rowspan="3" class="bdbt">
                            하차정보
                            <div><button type="button" class="btn_02" id="BtnResetGetPlace">다시입력</button></div>
                            <div><p class="change_place change_place_img2" onclick="fnChangePlace(); return false;"><span class="change_txt_top">하</span><br><span class="change_txt_bottom">상</span></p></div>
                        </th>
                        <td class="TdGet bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="GetPlaceSeqNo"/>
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="GetYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="GetHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="GetPlace" placeholder="* 상호"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnOpenGetPlaceNote"></button>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="GetPlaceChargeName" placeholder="담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="GetPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="GetPlaceChargeTelNo" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="GetPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="GetWay" CssClass="type_01"/>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td class="TdGet bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="GetPlaceSearch" placeholder="주소검색" Width="150"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03" ID="GetPlaceAddr" placeholder="주소" readonly Width="300"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03" ID="GetPlaceAddrDtl" placeholder="상세주소" Width="300"></asp:TextBox>
                            &nbsp;&nbsp;<span style="font-weight: 700; color: #999999;">적용주소</span>
                            <asp:TextBox runat="server" CssClass="type_02" ID="GetPlaceFullAddr" placeholder="적용주소" readonly></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td class="TdGet bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" CssClass="type_100p" ID="GetPlaceNote" width="99%" placeholder="특이사항"  style="margin-left: 5px;"></asp:TextBox>
                        </td>
                    </tr>

                    <tr class="TrGoods" style="display:none;">
                        <th rowspan="2" class="bdbt">화물정보</th>
                        <td class="bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:HiddenField runat="server" ID="GoodsSeqNo"/>
                            <asp:DropDownList runat="server" ID="CarTonCode" CssClass="type_01 essential" Width="95"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="CarTypeCode" CssClass="type_01 essential" Width="95"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="GoodsItemCode" CssClass="type_01" Width="95"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small Volume" placeholder="총수량" MaxLength="10"></asp:TextBox>개
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small Weight" placeholder="총중량" MaxLength="10"></asp:TextBox>kg
                            <asp:TextBox runat="server" ID="CBM" CssClass="type_small Weight" placeholder="총부피" MaxLength="10"></asp:TextBox>cbm
                            <asp:TextBox runat="server" ID="Length" CssClass="type_small Volume" placeholder="길이" MaxLength="10"></asp:TextBox>cm
                        </td>
                    </tr>
                    <tr class="TrGoods" style="display:none;">
                        <td class="bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" ID="GoodsName" CssClass="type_02" placeholder="화물명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GoodsNote" CssClass="type_04" placeholder="화물비고"></asp:TextBox>
                        </td>
                    </tr>

                    <tr class="TrTransport" style="display:none;">
                        <th class="bdbt">운송정보</th>
                        <td class="bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:DropDownList runat="server" ID="FTLFlag" CssClass="type_01 essential" Width="100"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="GoodsRunType" CssClass="type_01 essential" Width="100"></asp:DropDownList>&nbsp;&nbsp;
                            <asp:DropDownList runat="server" ID="CarFixedFlag" CssClass="type_01 essential" Width="100"></asp:DropDownList>
                            <button type="button" class="btn_help" id="BtnCarFixedFlagHelp"></button>&nbsp;&nbsp;
                            <span>경유지</span>
                            <asp:CheckBox runat="server" ID="LayoverFlag" Text="<span></span>"/>
                            <asp:TextBox runat="server" ID="SamePlaceCount" CssClass="type_small Volume" placeholder="동일 지역 수" MaxLength="3" readonly></asp:TextBox>
                            <asp:TextBox runat="server" ID="NonSamePlaceCount" CssClass="type_small Volume" placeholder="타지역 수" MaxLength="3" readonly></asp:TextBox>
                        </td>
                    </tr>

                    <tr class="TrDispatch">
                        <th class = "bdbt">
                            배차정보<br/>
                            <button type="button" class="btn_02 DispatchType2" id="BtnResetDispatch">배차취소</button>
                        </th>
                        <td class="bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContract"></div>
                            <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
                            <asp:HiddenField runat="server" ID="RefSeqNo"/>
                            <asp:HiddenField runat="server" ID="CarManageFlag"/>
                            <asp:HiddenField runat="server" ID="CarDispatchType"/>
                            <asp:HiddenField runat="server" ID="AreaDistance"/>
                            <asp:HiddenField runat="server" ID="OrgCenterCode"/>
                            <asp:HiddenField runat="server" ID="OrgOrderNo"/>
                            <table class="popup_table tbcar">
                                <colgroup>
                                    <col style="width:80px;"/> 
                                    <col style="width:135px;"/> 
                                    <col style="width:auto;"/> 
                                    <col style="width:100px;"/> 
                                    <col style="width:100px;"/> 
                                    <col style="width:160px;"/> 
                                    <col style="width:95px;"/> 
                                    <col style="width:115px;"/> 
                                </colgroup>
                                <tr>
                                    <th>구분</th>
                                    <th>차량번호</th>
                                    <th>차량정보</th>
                                    <th>상차완료</th>
                                    <th>하차완료</th>
                                    <th>위탁정보</th>
                                    <th>결제정보</th>
                                    <th>산재보험신고</th>
                                </tr>
                                <tbody class="DispatchType2">
                                    <tr class = "center">
                                        <td><span runat="server" id="SpanDispatchTypeM">직송</span></td>
                                        <td><asp:TextBox runat="server" CssClass="type_01 find" ID="RefCarNo" placeholder="차량번호" Width="125"></asp:TextBox></td>
                                        <td><span runat="server" id="SpanDispatchInfo"></span></td>
                                        <td><span runat="server" id="SpanPickupDT"></span></td>
                                        <td><span runat="server" id="SpanGetDT"></span></td>
                                        <td><span runat="server" id="SpanContractCenter"></span></td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="QuickType" CssClass="type_01" Width="95"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:DropDownList runat="server" ID="InsureExceptKind" CssClass="type_01" Width="128"></asp:DropDownList>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr class="TrPay">
                        <th rowspan="2" class="bdbt">비용정보</th>
                        <td class="bdnbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <asp:HiddenField runat="server" ID="SeqNo"/>
                            <asp:HiddenField runat="server" ID="PaySeqNo"/>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="PayType" Width="80"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="TaxKind" Width="80"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="ItemCode"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_small Money" placeholder="* 공급가액" MaxLength="11"></asp:TextBox>
                            <asp:TextBox runat="server" ID="TaxAmt" CssClass="type_small Money" placeholder="부가세" MaxLength="10"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="ClientCode"/>
                            <asp:HiddenField runat="server" ID="ClientInfo"/>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find TrPayClient" placeholder="업체명 (고객사)"></asp:TextBox>
                            <span style="float: right;">
                                <button type="button" class="btn_01" id="BtnAddPay">추가</button>
                                <button type="button" class="btn_02" id="BtnUpdPay" style="display: none;">수정</button>
                                <button type="button" class="btn_03" id="BtnDelPay" style="display: none;">삭제</button>
                                <button type="button" class="btn_02" id="BtnResetPay">다시입력</button>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td class="bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div id="WmsPayListGrid" class="subGridWrap"></div>
                        </td>
                    </tr>

                    <tr>
                        <th class="bdbt">비고</th>
                        <td class="bdbt">
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <div class="NotAllowed NotAllowedContractTarget"></div>
                            <asp:TextBox runat="server" CssClass="type_100p" ID="NoteInside" placeholder="비고" TextMode="MultiLine" Height="50"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                         <th class="bdbt">고객전달사항</th>
                         <td class="bdbt">
                             <div class="NotAllowed NotAllowedTrans"></div>
                             <div class="NotAllowed NotAllowedContractTarget"></div>
                             <asp:TextBox runat="server" CssClass="type_100p" ID="NoteClient" placeholder="고객전달사항" TextMode="MultiLine" Height="50"></asp:TextBox>
                         </td>
                     </tr>
                    <tr>
                        <th>파일첨부</th>
                        <td>
                            <div class="NotAllowed NotAllowedTrans"></div>
                            <input type="file" class="type_02" id="FileUpload"/>
                            <!-- DISPLAY LIST START -->
                            <div style="width: 100%;">
                                <ul id="UlFileList">
                                </ul>
                            </div>
                            <!-- DISPLAY LIST END -->
                        </td>
                    </tr>
                </table>
            </div>
        <br/>
        </div>
    </div>
        
    <div id="DivCancel">
        <div>
            <h1>오더 취소 사유</h1>
            <a href="#" onclick="fnCloseCnlOrder(); return;" class="close_btn">x</a>
            <textarea id="CnlReason" rows="3" cols="50"></textarea>
            <div class="btnWrap">
                <button type="button" class="btn_01" onclick="fnCnlOrderProc(); return;">등록</button>
                <button type="button" class="btn_03" onclick="fnCloseCnlOrder(); return;">닫기</button>
            </div>
        </div>
    </div>
        
    <div id="DivConsignor">
        <div>
            <h1>화주 간편 등록</h1>
            <a href="#" id="LinkPopCloseConsignor" class="close_btn">x</a>
            <div style="margin-top: 20px;">
                <table class="popup_table">
                <colgroup>
                    <col style="width:180px"/> 
                    <col style="width:auto;"/> 
                </colgroup>
                <tr>
                    <th>화주명</th>
                    <td>
                        <asp:TextBox runat="server" ID="PopConsignorName" CssClass="type_01 essential"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>비고</th>
                    <td>
                        <asp:TextBox runat="server" ID="PopConsignorNote" CssClass="type_01" Width="100%"></asp:TextBox>
                    </td>
                </tr>
                </table>
            </div>
            <div class="btnWrap" style="text-align: center; margin-top: 20px;">
                <button type="button" class="btn_01" id="BtnPopRegConsignor">등록하기</button>
                <button type="button" class="btn_02" id="BtnPopCloseConsignor">닫기</button>
            </div>
        </div>
    </div>
    
    <div id="DivMisuList">
        <div>
            <h1>총미수내역</h1>
            <a href="#" onclick="fnCloseMisuList(); return false;" class="close_btn">x</a>
            <div class="req_grid_list" style="margin-top:20px;">
                <div id="OrderMisuListGrid"></div>
            </div>
        </div>
    </div>

<iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
