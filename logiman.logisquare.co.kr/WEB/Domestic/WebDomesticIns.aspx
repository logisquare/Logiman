<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebDomesticIns.aspx.cs" Inherits="WEB.Domestic.WebDomesticIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/WEB/Domestic/Proc/WebDomesticIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="OrderNo"/>
<asp:HiddenField runat="server" ID="ReqSeqNo"/>
<asp:HiddenField runat="server" ID="CopyFlag"/>
<asp:HiddenField runat="server" ID="OrderItemCode"/>
<asp:HiddenField runat="server" ID="OrderStatus"/>
<asp:HiddenField runat="server" ID="OrderClientCode"/>

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control" style="padding-bottom:10px;">
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
                                &nbsp;&nbsp;
                                <button type="button" class="btn_02" runat="server" id="BtnCopyOrder" style="display:none;">오더복사</button>
                                &nbsp;&nbsp;
                                <button type="button" class="btn_03" runat="server" id="BtnCancelOrder" style="display:none;">오더취소</button>
                                &nbsp;&nbsp;
                                <button type="button" class="btn_01" runat="server" id="BtnChangeReq" style="display:none;">변경요청</button>
                                &nbsp;&nbsp;
                                <button type="button" class="btn_01" runat="server" id="BtnOrgOrderView" style="display:none;">원본보기</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="popup_table order_table">
                    <colgroup>
                        <col style="width:140px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>
                            요청정보
                        </th>
                        <td style="font-weight:bold;">
                            요청일 : <asp:Label runat="server" ID="ReqRegDate"></asp:Label>
                            &nbsp;&nbsp;
                            요청자 : <asp:TextBox runat="server" ID="ReqChargeName" CssClass="type_01" style="vertical-align:middle;"></asp:TextBox>
                            &nbsp;&nbsp;
                            요청팀 : <asp:TextBox runat="server" ID="ReqChargeTeam" CssClass="type_01" style="vertical-align:middle;" placeholder="요청팀"></asp:TextBox> 
                            <span runat="server" id="AcceptView" visible="false">
                                &nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;
                                접수번호 : 
                                <asp:Label runat="server" id="OrderNoView"></asp:Label>
                                &nbsp;&nbsp;
                                접수자 : 
                                <asp:Label runat="server" id="AcceptAdminName"></asp:Label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            화주정보
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_02 find essential" placeholder="화주명 검색"></asp:TextBox> 
                            <asp:HiddenField runat="server" ID="ConsignorCode" />
                            <button type="button" runat="server" id="BtnReset" onclick="fnConsReset();" class="btn_03" style="display:none;">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="4">
                            상차정보
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
                            <asp:TextBox runat="server" CssClass="type_small essential" ID="PickupPlaceChargeName" placeholder="* 담당자"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential OnlyNumber" ID="PickupPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="PickupPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential OnlyNumber" ID="PickupPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdPickup">
                            <asp:HiddenField runat="server" ID="PickupPlaceFullAddr"/>
                            <asp:TextBox runat="server" CssClass="type_01 find" ID="PickupPlaceSearch" placeholder="주소검색"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_xsmall essential" ID="PickupPlacePost" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="PickupPlaceAddr" placeholder="주소" readonly></asp:TextBox>
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
                        </th>
                        <td class="TdGet">
                            <asp:HiddenField runat="server" ID="GetPlaceSeqNo"/>
                            <asp:TextBox runat="server" CssClass="type_01 date essential" ID="GetYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber essential" ID="GetHM" placeholder="* 시간" MaxLength="4"></asp:TextBox>
                            <span>※ ex) 14시30분 요청 시 1430으로 숫자만 입력</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find essential" ID="GetPlace" placeholder="* 하차지명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_small essential" ID="GetPlaceChargeName" placeholder="* 담당자"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargePosition" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential OnlyNumber" ID="GetPlaceChargeTelNo" placeholder="* 전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall" ID="GetPlaceChargeTelExtNo" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01 essential OnlyNumber" ID="GetPlaceChargeCell" placeholder="휴대폰번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="TdGet">
                            <asp:HiddenField runat="server" ID="GetPlaceFullAddr"/>
                            <asp:TextBox runat="server" CssClass="type_01 find" ID="GetPlaceSearch" placeholder="주소검색"></asp:TextBox>
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
                        <th rowspan="2">화물정보</th>
                        <td>
                            <asp:HiddenField runat="server" ID="GoodsSeqNo"/>
                            <asp:DropDownList runat="server" ID="CarTonCode" CssClass="type_01" Width="95"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="CarTypeCode" CssClass="type_01" Width="95"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="GoodsItemCode" CssClass="type_01" Width="95"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small Weight" placeholder="총중량" MaxLength="10"></asp:TextBox>kg
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small Volume" placeholder="총수량" MaxLength="10"></asp:TextBox>개
                            <asp:TextBox runat="server" ID="CBM" CssClass="type_small Weight" placeholder="총부피" MaxLength="10"></asp:TextBox>cbm
                            <asp:TextBox runat="server" ID="Length" CssClass="type_small Volume" placeholder="길이" MaxLength="10"></asp:TextBox>cm
                        </td>
                    </tr>
                    <tr class="TrGoods">
                        <td>
                            <asp:TextBox runat="server" CssClass="type_02" ID="GoodsName" placeholder="화물명"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_04" ID="GoodsNote" placeholder="화물비고"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>운송정보</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="FTLFlag"/>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="GoodsRunType"/>
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
                            <div id="FileReg">
                                <input type="file" class="type_02" id="FileUpload" style="vertical-align:middle;"/>
                                <span style="padding-left:10px; color:#808080;">드래그 & 드롭으로 파일 업로드(한번에 여러 파일 첨부가능)</span>
                                <!-- DISPLAY LIST START -->
                                <div style="width: 100%;">
                                    <ul id="UlFileList">
                                    </ul>
                                </div>
                                <!-- DISPLAY LIST END -->
                            </div>
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
                                <div id="DomesticPayListGrid" class="subGridWrap"></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
