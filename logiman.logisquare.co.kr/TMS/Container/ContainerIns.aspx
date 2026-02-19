<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ContainerIns.aspx.cs" Inherits="TMS.Container.ContainerIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Container/Proc/ContainerIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="OldPickupPlaceFullAddr"/>
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
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderLocationCode"></asp:DropDownList>
                                    <asp:DropDownList runat="server" CssClass="type_01 essential" ID="OrderItemCode"></asp:DropDownList>
                                </td>
                                <td>
                                    <button type="button" class="btn_01" id="BtnRegOrder" style="float:right;">등록 (F2)</button>
                                    <div runat="server" ID="DivOrderInfo" style="float:right;">
                                        <asp:Label runat="server" ID="OrderStatusM" style="font-weight: bold; color: #5674C8;"></asp:Label>&nbsp;
                                        <asp:Label runat="server" ID="OrderNoInfo"></asp:Label>&nbsp;&nbsp;
                                        접수일 : <asp:Label runat="server" ID="AcceptDate"></asp:Label>&nbsp;&nbsp;
                                        접수자 : <asp:Label runat="server" ID="AcceptAdminName"></asp:Label>&nbsp;&nbsp;
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:CheckBox runat="server" ID="CustomFlag" Text="<span></span> 통관"/>
                                    &nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="BondedFlag" Text="<span></span> 보세"/>
                                    &nbsp;&nbsp;
                                    <asp:CheckBox runat="server" ID="DocumentFlag" Text="<span></span> 서류"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div style="margin-bottom:2px;"  runat="server" ID="DivButtons">
                        <button type="button" class="btn_02" id="BtnChangeRequestList">변경요청목록</button>
                        <button type="button" class="btn_02" id="BtnOriginalOrder">원본오더</button>
                        <button type="button" class="btn_02" id="BtnSQI">서비스 이슈</button>
                        <button type="button" class="btn_02" id="BtnCopyOrder">오더복사</button>
                        <button type="button" class="btn_02" id="BtnCopyOrders">오더대량복사</button>
                        <button type="button" class="btn_02" id="BtnGoWrite">새로등록</button>
                        <button type="button" class="btn_03" id="BtnCancelOrder">오더취소</button>
                    </div>
                </div>
                <table class="popup_table order_table">
                    <colgroup>
                        <col style="width:135px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3" class="bdbt">업체정보</th>
                        <td class="TdClient bdnbt">
                            <asp:HiddenField runat="server" ID="OrderClientCode"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="OrderClientName" placeholder="* 발주처명"></asp:TextBox>
                            <button type="button" class="btn_find" id="BtnSearchOrderClient"></button>
                            <button type="button" class="btn_help" id="BtnSearchOrderClientInfo"></button>
                            <asp:TextBox runat="server" CssClass="type_small find essential" ID="OrderClientChargeName" placeholder="* 담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="OrderClientChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="OrderClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="OrderClientChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="OrderClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            &nbsp;<span style="font-weight: 700; color: #ff0000; vertical-align: unset;" id="SpanOrderClientMisuAmt"></span>
                            &nbsp;<button type="button" class="btn_01" id="BtnOrderClientMisuAmt" style="display:none;">미수내역</button>
                        </td>
                    </tr>
                    <tr class="border">
                        <td class="TdClient bdnbt">
                            <asp:HiddenField runat="server" ID="PayClientCode"/>
                            <asp:HiddenField runat="server" ID="PayClientInfo"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="PayClientName" placeholder="* 청구처명"></asp:TextBox>
                            <button type="button" class="btn_find" id="BtnSearchPayClient"></button>
                            <button type="button" class="btn_help" id="BtnSearchPayClientInfo"></button>
                            <asp:TextBox runat="server" CssClass="type_small find essential" ID="PayClientChargeName" placeholder="* 담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PayClientChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PayClientChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PayClientChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PayClientChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small essential" ID="PayClientChargeLocation" placeholder="* 청구사업장"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PayClientCorpNo" placeholder="사업자번호" readonly></asp:TextBox>
                            &nbsp;<span style="font-weight: 700; color: #ff0000; vertical-align: unset;" id="SpanPayClientMisuAmt"></span>
                            &nbsp;<button type="button" class="btn_01" id="BtnPayClientMisuAmt" style="display:none;">미수내역</button>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdClient bdbt">
                            <asp:HiddenField runat="server" ID="ConsignorCode"/>
                            <asp:TextBox runat="server" CssClass="type_02 find essential" ID="ConsignorName" placeholder="* 화주명"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnSearchConsignorInfo"></button>
                            <button type="button" class="btn_01" id="BtnOpenConsignor">화주간편등록</button>
                        </td>
                    </tr>

                    <tr>
                        <th rowspan="4" class="bdbt">
                            작업지정보<br/>
                            <button type="button" class="btn_02" id="BtnResetPickupPlace">다시입력</button>
                        </th>
                        <td class="TdPickup bdnbt">
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="PickupYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="PickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 find essential find" ID="PickupPlace" placeholder="* 상호"></asp:TextBox>
                            <button type="button" class="btn_help" id="BtnOpenPickupPlaceNote"></button>
                            <asp:TextBox runat="server" CssClass="type_small essential find" ID="PickupPlaceChargeName" placeholder="* 담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PickupPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PickupPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PickupPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup bdnbt">
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="PickupPlaceSearch" placeholder="주소검색" Width="150"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="PickupPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03 essential" ID="PickupPlaceAddr" placeholder="주소" readonly Width="295"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03" ID="PickupPlaceAddrDtl" placeholder="상세주소" Width="295"></asp:TextBox>
                            &nbsp;&nbsp;<span style="font-weight: 700; color: #999999;">적용주소</span>
                            <asp:TextBox runat="server" CssClass="type_02" ID="PickupPlaceFullAddr" placeholder="적용주소" readonly></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup bdnbt">
                            <asp:DropDownList runat="server" CssClass="type_01" ID="PickupPlaceLocal"></asp:DropDownList>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PickupPlaceLocalCode" placeholder="DOOR 지역코드" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="PickupPlaceLocalName" placeholder="DOOR 지역명" readonly></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td class="TdPickup bdbt">
                            <asp:TextBox runat="server" CssClass="type_100p" ID="PickupPlaceNote" width="99%" placeholder="특이사항" style="margin-left: 5px;"></asp:TextBox>
                        </td>
                    </tr>

                    <tr class="TrGoods">
                        <th rowspan="3" class="bdbt">
                            화물정보
                            <br/>
                            <button type="button" class="btn_02" onclick="fnUnipassPopup();">유니패스</button>
                        </th>
                        <td class="bdnbt">
                            <asp:HiddenField runat="server" ID="GoodsSeqNo"/>
                            <asp:DropDownList runat="server" CssClass="type_01 essential in out" ID="GoodsItemCode" width="80"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small Volume essential in out" placeholder="* 총수량" MaxLength="10"></asp:TextBox>개
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small Weight in out" placeholder="총중량" MaxLength="10"></asp:TextBox>kg
                            <asp:TextBox runat="server" ID="BookingNo" CssClass="type_small onlyAlphabetNum out" placeholder="부킹 No" Width="145"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GoodsOrderNo" CssClass="type_small onlyAlphabetNum out" placeholder="오더 No" Width="145"></asp:TextBox>
                            <asp:TextBox runat="server" ID="CntrNo" CssClass="type_small onlyAlphabetNum in out" placeholder="CTNR No" Width="145"></asp:TextBox>
                            <asp:TextBox runat="server" ID="SealNo" CssClass="type_small onlyAlphabetNum in out" placeholder="SEAL No" Width="145"></asp:TextBox>
                            <asp:TextBox runat="server" ID="DONo" CssClass="type_small onlyAlphabetNum in" placeholder="D/O No" Width="145"></asp:TextBox>
                            <asp:TextBox runat="server" ID="BLNo" CssClass="type_small onlyAlphabetNum in out" placeholder="B/L No" Width="145"></asp:TextBox>
                        </td>
                    </tr>
                    <tr class="TrGoods">
                        <td class="bdnbt">
                            <asp:TextBox runat="server" ID="Port" CssClass="type_small in out" placeholder="PORT"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShippingCompany" CssClass="type_small in out" placeholder="선사"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShippingShipName" CssClass="type_small in out" placeholder="선명" Width="240"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShippingCharge" CssClass="type_small out" placeholder="선사담당자"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShippingTelNo" CssClass="type_01 out" placeholder="선사연락처"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShipmentPort" CssClass="type_small out" placeholder="선적항"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShipmentYMD" CssClass="type_01 date in out" placeholder="선적일"></asp:TextBox>
                            <asp:TextBox runat="server" ID="EnterYMD" CssClass="type_01 date in" placeholder="입항일"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShipCode" CssClass="type_small in out" placeholder="모선코드"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ShipName" CssClass="type_small in out" placeholder="모선명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="DivCode" CssClass="type_small in" placeholder="DIV 코드"></asp:TextBox>
                            <asp:TextBox runat="server" ID="CargoClosingTime" CssClass="type_small out" placeholder="CCT"></asp:TextBox>
                        </td>
                    </tr>
                    <tr class="TrGoods">
                        <td class="bdbt">
                            <asp:TextBox runat="server" ID="PickupCY" CssClass="type_small in out" placeholder="픽업 CY"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PickupCYCharge" CssClass="type_small in out" placeholder="픽업CY 담당자"></asp:TextBox>
                            <asp:TextBox runat="server" ID="PickupCYTelNo" CssClass="type_01 in out" placeholder="픽업CY 연락처"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GetCY" CssClass="type_small out" placeholder="하차 CY"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GetCYCharge" CssClass="type_small out" placeholder="하차CY 담당자"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GetCYTelNo" CssClass="type_01 out" placeholder="하차CY 연락처"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ReturnCY" CssClass="type_small in" placeholder="반납 CY"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ReturnCYCharge" CssClass="type_small in" placeholder="반납CY 담당자"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ReturnCYTelNo" CssClass="type_01 in" placeholder="반납CY 연락처"></asp:TextBox>
                            <asp:TextBox runat="server" ID="Item" CssClass="type_small in out" placeholder="아이템"></asp:TextBox>
                            <asp:TextBox runat="server" ID="Consignor" CssClass="type_small in out" placeholder="화주사업자"></asp:TextBox>
                        </td>
                    </tr>
                    <tr class="TrPay">
                        <th rowspan="4" class="bdbt">비용정보</th>
                        <td class="bdnbt">
                            <asp:HiddenField runat="server" ID="SeqNo"/>
                            <asp:HiddenField runat="server" ID="PaySeqNo"/>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="PayType" Width="80"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="TaxKind" Width="80"></asp:DropDownList>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="ItemCode" Width="80"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_small Money" placeholder="* 공급가액" MaxLength="11"></asp:TextBox>
                            <asp:TextBox runat="server" ID="TaxAmt" CssClass="type_small Money" placeholder="부가세" MaxLength="10"></asp:TextBox>
                            <span style="float: right;">
                                <button type="button" class="btn_01" id="BtnAddPay">추가</button>
                                <button type="button" class="btn_02" id="BtnUpdPay" style="display: none;">수정</button>
                                <button type="button" class="btn_03" id="BtnDelPay" style="display: none;">삭제</button>
                                <button type="button" class="btn_02" id="BtnResetPay">다시입력</button>
                            </span>
                        </td>
                    </tr>
                    <tr class="TrPayClient">
                        <td class="bdnbt">
                            <asp:HiddenField runat="server" ID="ClientCode"/>
                            <asp:HiddenField runat="server" ID="ClientInfo"/>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find" placeholder="업체명 (고객사)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr class="TrPayCar">
                        <td class="bdnbt">
                            <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
                            <asp:HiddenField runat="server" ID="RefSeqNo"/>
                            <asp:HiddenField runat="server" ID="DispatchInfo"/>
                            <asp:HiddenField runat="server" ID="ComCode"/>
                            <asp:HiddenField runat="server" ID="ComInfo"/>
                            <asp:HiddenField runat="server" ID="CarSeqNo"/>
                            <asp:HiddenField runat="server" ID="CarInfo"/>
                            <asp:HiddenField runat="server" ID="DriverSeqNo"/>
                            <asp:HiddenField runat="server" ID="DriverInfo"/>
                            <asp:TextBox runat="server" ID="RefCarNo" CssClass="type_01 find" placeholder="차량번호 (배차)"></asp:TextBox>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CarDivType" Width="100"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="ComName" CssClass="type_01 find" placeholder="차량업체명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="CarNo" CssClass="type_01 find" placeholder="차량번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="DriverName" CssClass="type_small find" placeholder="기사명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="DriverCell" CssClass="type_01 find" placeholder="기사휴대폰"></asp:TextBox>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="InsureExceptKind" Width="128"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td class="bdbt">
                            <div class="grid_list" style="margin-top: 0px;">
                                <div id="ContainerOrderPayListGrid" class="subGridWrap"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="bdbt">비고</th>
                        <td class="bdbt">
                            <asp:TextBox runat="server" CssClass="type_100p" ID="NoteInside" placeholder="비고" TextMode="MultiLine" Height="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th class="bdbt">고객전달사항</th>
                        <td class="bdbt">
                            <asp:TextBox runat="server" CssClass="type_100p" ID="NoteClient" placeholder="고객전달사항" TextMode="MultiLine" Height="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>파일첨부</th>
                        <td>
                            <input type="file" class="type_02" id="FileUpload"/><!--
                            <button type="button" class="btn_02 upload" id="BtnAddFile">첨부</button> -->
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
