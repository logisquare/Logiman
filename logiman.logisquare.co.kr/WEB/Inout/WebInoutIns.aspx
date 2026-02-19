<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebInoutIns.aspx.cs" Inherits="WEB.Inout.WebInoutIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/WEB/Inout/Proc/WebInoutIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="OrderNo"/>
<asp:HiddenField runat="server" ID="ReqSeqNo"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="OrderStatus"/>
<asp:HiddenField runat="server" ID="OrderClientCode"/>
<asp:HiddenField runat="server" ID="PayClientCode"/>
<asp:HiddenField runat="server" ID="CnlFlag"/>
<asp:HiddenField runat="server" ID="GoodsSeqNo"/>
<asp:HiddenField runat="server" ID="OrderLocationCode"/>

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="fcl_tb_type_01" style="margin-bottom:0px;">
                    <colgroup>
                        <col style="width:50%"/> 
                        <col style="width:50%;"/> 
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>
                                <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                            </td>
                            <td>
                                <button type="button" class="btn_01" id="BtnRegOrder">등록 (F2)</button>
                                <button type="button" class="btn_02" runat="server" id="BtnCopyOrder" style="display:none;">오더복사</button>
                                <button type="button" class="btn_03" runat="server" id="BtnCancelOrder" style="display:none;">오더취소</button>
                                <button type="button" class="btn_01" runat="server" id="BtnChangeReq" style="display:none;">변경요청</button>
                                <button type="button" class="btn_01" runat="server" id="BtnOrgOrderView" style="display:none;">원본보기</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="popup_table order_table">
                    <colgroup>
                        <col style="width:130px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>
                            요청정보
                        </th>
                        <td style="font-weight:bold;">
                            요청자 : <asp:TextBox runat="server" ID="ReqChargeName" CssClass="type_01" style="vertical-align:middle;" placeholder="요청자"></asp:TextBox>
                            &nbsp;
                            요청팀 : <asp:TextBox runat="server" ID="ReqChargeTeam" CssClass="type_01" style="vertical-align:middle;" placeholder="요청팀"></asp:TextBox> 
                            &nbsp;
                            요청자연락처 : <asp:TextBox runat="server" ID="ReqChargeTel" CssClass="type_01" style="vertical-align:middle;" placeholder="요청자연락처"></asp:TextBox> 
                            &nbsp;
                            요청자휴대폰 : <asp:TextBox runat="server" ID="ReqChargeCell" CssClass="type_01" style="vertical-align:middle;" placeholder="요청자휴대폰"></asp:TextBox> 
                            <p runat="server" id="OrderInfo" style="width:100%; margin-top:3px; display:none;">
                                요청일 : <asp:Label runat="server" ID="ReqRegDate"></asp:Label>
                                &nbsp;
                                접수번호 : <asp:Label runat="server" ID="OrderNoInfo"></asp:Label>
                                &nbsp;
                                접수일 : <asp:Label runat="server" ID="AcceptDate"></asp:Label>
                                &nbsp;
                                접수자 : <asp:Label runat="server" ID="AcceptAdminName"></asp:Label>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            상품선택
                        </th>
                        <td>
                            <asp:DropDownList runat="server" ID="OrderItemCode" CssClass="type_01 essential"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            화주정보
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_02 find" placeholder="화주명 검색"></asp:TextBox> 
                            <asp:HiddenField runat="server" ID="ConsignorCode" />
                            <button type="button" id="BtnReset" class="btn_03" style="display:none;" onclick="fnConsReset();">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="4">
                            상차정보
                            <div><p class="change_place change_place_img1" onclick="fnChangePlace(); return false;"><span class="change_txt_top">상</span><br><span class="change_txt_bottom">하</span></p></div>
                        </th>
                        <td class="TdPickup">
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="PickupYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber essential" ID="PickupHM" placeholder="* 시간" MaxLength="4"></asp:TextBox>
                            <span>※ ex) 14시30분 요청 시 1430으로 숫자만 입력</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find essential" ID="PickupPlace" placeholder="* 상차지명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="PickupPlaceChargeName" placeholder="담당자"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PickupPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="PickupPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup">
                            <asp:HiddenField runat="server" ID="PickupPlaceFullAddr"/>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="PickupPlaceSearch" placeholder="주소검색"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="PickupPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="PickupPlaceAddr" placeholder="주소" readonly ></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02" ID="PickupPlaceAddrDtl" placeholder="상세주소"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup">
                            <asp:TextBox runat="server" CssClass="type_100p" ID="PickupPlaceNote" placeholder="상차지 비고"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="4">
                            하차정보
                            <div><p class="change_place change_place_img2" onclick="fnChangePlace(); return false;"><span class="change_txt_top">하</span><br><span class="change_txt_bottom">상</span></p></div>
                        </th>
                        <td class="TdGet">
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="GetYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber essential" ID="GetHM" placeholder="* 시간" MaxLength="4"></asp:TextBox>
                            <span>※ ex) 14시30분 요청 시 1430으로 숫자만 입력</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find essential" ID="GetPlace" placeholder="* 하차지명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small" ID="GetPlaceChargeName" placeholder="담당자"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="GetPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="GetPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdGet">
                            <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
                            <asp:TextBox runat="server" CssClass="type_small find" ID="GetPlaceSearch" placeholder="주소검색"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="GetPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="GetPlaceAddr" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02" ID="GetPlaceAddrDtl" placeholder="상세주소"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdGet">
                            <asp:TextBox runat="server" CssClass="type_100p" ID="GetPlaceNote" width="100%" placeholder="하차지 비고"></asp:TextBox>
                        </td>
                    </tr>

                    <tr class="TrGoods">
                        <th>운송정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="Nation" CssClass="type_small" placeholder="목적국"></asp:TextBox>
                            <asp:TextBox runat="server" ID="Hawb" CssClass="type_small" placeholder="H/AWB"></asp:TextBox>
                            <asp:TextBox runat="server" ID="Mawb" CssClass="type_small" placeholder="M/AWB"></asp:TextBox>
                            <asp:TextBox runat="server" ID="InvoiceNo" CssClass="type_small" placeholder="Invoice No."></asp:TextBox>
                            <asp:TextBox runat="server" ID="BookingNo" CssClass="type_small" placeholder="Booking No."></asp:TextBox>
                            <asp:TextBox runat="server" ID="StockNo" CssClass="type_small" placeholder="입고 No."></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="ArrivalReportFlag" Text="<span></span> 도착보고"/>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="BondedFlag" Text="<span></span> 보세"/>
                        </td>
                    </tr>

                    <tr class="TrGoods">
                        <th rowspan="2">화물정보</th>
                        <td class="">
                            <asp:DropDownList runat="server" ID="GoodsItemCode" CssClass="type_01" width="80"/>
                            <asp:TextBox runat="server" ID="GoodsItemWidth" CssClass="type_xsmall Volume" placeholder="가로(cm)"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GoodsItemHeight" CssClass="type_xsmall Volume" placeholder="세로(cm)"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GoodsItemLength" CssClass="type_xsmall Volume" placeholder="높이(cm)"></asp:TextBox>
                            <asp:TextBox runat="server" ID="GoodsItemVolume" CssClass="type_xsmall Volume" placeholder="수량(ea)"></asp:TextBox>
                            <button type="button" class="btn_01" id="BtnAddGoodsItem">추가</button>
                            <button type="button" class="btn_02" id="BtnResetGoodsItem">다시입력</button>
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small OnlyNumber" placeholder="총수량" MaxLength="10"></asp:TextBox>개
                            <asp:TextBox runat="server" ID="CBM" CssClass="type_small Weight" placeholder="총부피" MaxLength="10"></asp:TextBox>CBM
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small OnlyNumber" placeholder="총중량" MaxLength="10"></asp:TextBox>kg
                            <p style="margin:2px 0 0 5px;">※ 화물정보 입력 후 화물추가 버튼을 눌러주세요. 입력된 정보는 아래에 표기됩니다.</p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" id="Quantity" CssClass="type_100p" style="width:calc(100% - 95px);" placeholder="화물정보" readonly></asp:TextBox>
                            <button type="button" class="btn_01" id="BtnOpenPopGoodsItem">상세수정</button>
                            <div style="width: 100%; color: red; font-size: 12px;">
                                * 각각 다른 배차가 필요한 화물 정보인 경우 오더를 복사하여 나누어 등록해주세요.
                            </div>
                        </td>
                    </tr>
                    
                    <tr>
                        <th>
                            기타정보
                        </th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_100p" ID="NoteClient" placeholder="요청사항"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <th>파일첨부</th>
                        <td>
                            <input type="file" class="type_02" id="FileUpload"/>
                            <span style="padding-left:10px; color:#808080;">드래그 & 드롭으로 파일 업로드(한번에 여러 파일 첨부가능)</span>
                            <!-- DISPLAY LIST START -->
                            <div style="width: 100%;">
                                <ul id="UlFileList">
                                </ul>
                            </div>
                            <!-- DISPLAY LIST END -->
                        </td>
                    </tr>

                    <tr class="TrDispatch" style="display:none;">
                        <th>
                            배차정보<br/>
                        </th>
                        <td>
                            <asp:HiddenField runat="server" ID="DispatchSeqNo"/>
                            <asp:HiddenField runat="server" ID="RefSeqNo"/>
                            <table class="popup_table">
                                <colgroup>
                                    <col style="width:80px;"/> 
                                    <col style="width:160px;"/> 
                                    <col style="width:160px;"/> 
                                    <col style="width:160px;"/> 
                                </colgroup>
                                <tr>
                                    <th>구분</th>
                                    <th>차량번호</th>
                                    <th>기사명</th>
                                    <th>기사 휴대폰</th>
                                </tr>
                                <tbody id="TBodyDispatch" class="DispatchType3" style="display: none;">
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    <tr class="TrPay" style="display:none;">
                        <th>비용정보</th>
                        <td>
                            <div class="grid_list" style="margin-top: 0px;">
                                <div id="InoutPayListGrid" class="subGridWrap"></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>

    <div id="DivGoods">
        <div>
            <h1>화물 상세 정보</h1>
            <a href="#" id="LinkClosePopGoodsItem" class="close_btn">x</a>
            <div class="btnWrap" style="text-align: right;">
                <asp:TextBox runat="server" ID="PopVolume" CssClass="type_small Volume" placeholder="총수량" MaxLength="10" ></asp:TextBox>개&nbsp;&nbsp;
                <asp:TextBox runat="server" ID="PopCBM" CssClass="type_small Weight" placeholder="총부피" MaxLength="10" ></asp:TextBox>CBM&nbsp;&nbsp;
                <asp:TextBox runat="server" ID="PopWeight" CssClass="type_small Weight" placeholder="총중량" MaxLength="10" ></asp:TextBox>kg&nbsp;&nbsp;&nbsp;
                <button type="button" class="btn_01" id="BtnSetPopGoodsItem">적용하기</button>
            </div>
            <div class="btnWrap">
                <asp:DropDownList runat="server" ID="PopGoodsItemCode" CssClass="type_01" width="80"/>
                <asp:TextBox runat="server" ID="PopGoodsItemWidth" CssClass="type_xsmall Volume" placeholder="가로"></asp:TextBox>
                <asp:TextBox runat="server" ID="PopGoodsItemHeight" CssClass="type_xsmall Volume" placeholder="세로"></asp:TextBox>
                <asp:TextBox runat="server" ID="PopGoodsItemLength" CssClass="type_xsmall Volume" placeholder="높이"></asp:TextBox>
                <asp:TextBox runat="server" ID="PopGoodsItemVolume" CssClass="type_xsmall Volume" placeholder="수량"></asp:TextBox>&nbsp;
                <button type="button" class="btn_01" id="BtnAddPopGoodsItem">추가</button>
                <button type="button" class="btn_02" id="BtnResetPopGoodsItem">다시입력</button>
            </div>
            <div class="goodsItemScroll">
                <ul id="UlGoodsItemList">
                </ul>
            </div>
        </div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
