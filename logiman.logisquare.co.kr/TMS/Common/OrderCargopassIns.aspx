<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderCargopassIns.aspx.cs" Inherits="TMS.Common.OrderCargopassIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Common/Proc/OrderCargopassIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        #TblOrderList {margin-top: 10px; margin-bottom:20px;}
        #TblOrderList td{ text-align: center;}
        #TblOrderList td:nth-child(5){ text-align: left;}
        #TblOrderList td:nth-child(6){ text-align: left;}
        #SpanCargopassStatusM { font-weight: 700; padding: 5px 10px; line-height: 26px; border: 2px solid #5674C8; color: #ffffff; border-radius: 15px; color: #5674C8; display: none;}
        .TrCarInfo { display: none;}
        .TrCarInfo span { padding: 0 10px; line-height: 26px; border-right: 2px solid #ccc;}
        .TrCarInfo span:last-child { border-right: 0;}
        form { height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidDisplayMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="OrderNos"/>
    <asp:HiddenField runat="server" ID="CargopassStatus"/>
    <asp:HiddenField runat="server" ID="CargopassDomain"/>
    <asp:HiddenField runat="server" ID="InsCallback"/>
    
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div style="margin-top: 20px;">
                    <h3 class="H3Name" style="float: left; width: 150px;">카고패스 연동</h3>
                    <div style=" text-align:right;">
                        <span id="SpanCargopassStatusM"></span>&nbsp;
                        <asp:TextBox runat="server" CssClass="type_02" ID="CargopassOrderNo" placeholder="연동번호" readonly></asp:TextBox>&nbsp;
                        <button type="button" class="btn_01" id="BtnRegCargopass">저장 후 연동하기 (F2)</button>&nbsp;
                        <button type="button" class="btn_02" id="BtnViewCargopass" style="display: none;">연동보기</button>
                    </div>
                </div>
                <table class="popup_table" style="margin-top: 10px; margin-bottom:0px;">
                    <colgroup>
                        <col style="width:150px;"/> 
                        <col/> 
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>기본</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CenterCode"></asp:DropDownList>&nbsp;
                            <asp:DropDownList runat="server" CssClass="type_01" ID="DispatchType"></asp:DropDownList>&nbsp;
                            <asp:TextBox runat="server" CssClass="type_02" ID="ConsignorName" placeholder="화주명"></asp:TextBox>&nbsp;
                            <asp:TextBox runat="server" CssClass="type_01 OnlyNumber" ID="TelNo" placeholder="배차자 연락처"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            상차정보<br/>
                            <button type="button" class="btn_02" id="BtnResetPickupPlace">다시입력</button>
                        </th>
                        <td class="TdPickup">
                            <asp:TextBox runat="server" CssClass="type_01 date" ID="PickupYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="PickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="PickupSearch" placeholder="주소검색" Width="130"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_02" ID="PickupAddr" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02" ID="PickupAddrDtl" placeholder="상세주소"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="PickupWay" CssClass="type_01" width="100"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            하차정보<br/>
                            <button type="button" class="btn_02" id="BtnResetGetPlace">다시입력</button>
                        </th>
                        <td class="TdGet">
                            <asp:TextBox runat="server" CssClass="type_01 date" ID="GetYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber" ID="GetHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="GetSearch" placeholder="주소검색" Width="130"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_02" ID="GetAddr" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02" ID="GetAddrDtl" placeholder="상세주소"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_01" ID="GetTelNo" placeholder="전화번호"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="GetWay" CssClass="type_01" width="100"/>
                        </td>
                    </tr>
                    <tr>
                        <th>화물정보</th>
                        <td>
                            <asp:DropDownList runat="server" ID="CarTon" CssClass="type_01"/>
                            <asp:DropDownList runat="server" ID="CarTruck" CssClass="type_01"/>
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small ali_r Volume" placeholder="수량" MaxLength="10"></asp:TextBox>개
                            <asp:TextBox runat="server" ID="CBM" CssClass="type_small ali_r Weight" placeholder="부피" MaxLength="10"></asp:TextBox>CBM
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small ali_r Weight" placeholder="중량" MaxLength="10"></asp:TextBox>t
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="LayerFlag" Text="<span></span> 혼적"/>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="UrgentFlag" Text="<span></span> 긴급"/>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" ID="ShuttleFlag" Text="<span></span> 왕복"/>
                        </td>
                    </tr>
                    <tr>
                        <th>비용정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_01 ali_r Money" placeholder="운송료" MaxLength="11"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:RadioButton runat="server" ID="QuickType1" GroupName="QuickType" Text="<span></span> 일반지급" value="1" Checked="True"></asp:RadioButton>
                            &nbsp;&nbsp;
                            <asp:RadioButton runat="server" ID="QuickType2" GroupName="QuickType" Text="<span></span> 바로지급" value="2"></asp:RadioButton>
                            &nbsp;&nbsp;
                            <asp:RadioButton runat="server" ID="QuickType3" GroupName="QuickType" Text="<span></span> 14일지급" value="3"></asp:RadioButton>
                            &nbsp;&nbsp;
                            <button type="button" class="btn_help" id="BtnSearchConsignorInfo"></button>
                            &nbsp;&nbsp;
                            <asp:TextBox runat="server" ID="PayPlanYMD" CssClass="type_01" placeholder="송금예정일" ReadOnly="True" style="display: none;"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02" ID="Note" placeholder="화물상세정보"></asp:TextBox>
                        </td>
                    </tr>
                    <tr class="TrCarInfo">
                        <th>배차확정정보</th>
                        <td>
                            <span id="SpanCargopassNetworkKindM"></span>
                            <span id="SpanComName"></span>
                            <span id="SpanComCorpNo"></span>
                            <span id="SpanCarNo"></span>
                            <span id="SpanDriverName"></span>
                            <span id="SpanDriverCell"></span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <br/>
                <br/>
                <h3 class="H3Name">오더 상하차 정보</h3>
                <table class="popup_table" id="TblOrderList">
                    <colgroup>
                        <col style="width:80px;"/> 
                        <col style="width:100px;"/> 
                        <col style="width:70px;"/> 
                        <col/> 
                        <col/> 
                        <col/> 
                        <col style="width:150px;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:260px;"/> 
                    </colgroup>
                    <thead>
                    <tr>
                        <th>구분</th>
                        <th>일자</th>
                        <th>시간</th>
                        <th>화주명</th>
                        <th>주소</th>
                        <th>상세주소</th>
                        <th>담당자연락처</th>
                        <th>상하차방법</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
