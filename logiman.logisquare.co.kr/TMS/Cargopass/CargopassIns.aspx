<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CargopassIns.aspx.cs" Inherits="TMS.Cargopass.CargopassIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Cargopass/Proc/CargopassIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
                    <h3 class="H3Name" style="float: left; width: 150px;">카고패스 등록</h3>
                    <div style=" text-align:right;">
                        <span id="SpanCargopassStatusM"></span>&nbsp;
                        <asp:TextBox runat="server" CssClass="type_02" ID="CargopassOrderNo" placeholder="등록번호" readonly></asp:TextBox>&nbsp;
                        <button type="button" class="btn_01" id="BtnRegCargopass">저장 후 등록하기 (F2)</button>&nbsp;
                        <button type="button" class="btn_02" id="BtnViewCargopass" style="display: none;">정보망 연동보기</button>
                    </div>
                </div>
                <table class="popup_table" style="margin-top: 10px; margin-bottom:0px;">
                    <colgroup>
                        <col style="width:130px;"/> 
                        <col/> 
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>기본</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="CenterCode"></asp:DropDownList>&nbsp;
                            <asp:DropDownList runat="server" CssClass="type_01" ID="DispatchType"></asp:DropDownList>&nbsp;
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="ConsignorName" placeholder="화주명"></asp:TextBox>&nbsp;
                            <asp:TextBox runat="server" CssClass="type_01 OnlyNumber essential" ID="TelNo" placeholder="배차자 연락처"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            상차정보<br/>
                            <button type="button" class="btn_02" id="BtnResetPickupPlace">다시입력</button>
                        </th>
                        <td class="TdPickup">
                            <asp:TextBox runat="server" CssClass="type_01 date" ID="PickupYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber essential" ID="PickupHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="PickupSearch" placeholder="주소검색" Width="130"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrPickupPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="PickupAddr" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="PickupAddrDtl" placeholder="상세주소"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="PickupWay" CssClass="type_01 essential" width="100"/>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            하차정보<br/>
                            <button type="button" class="btn_02" id="BtnResetGetPlace">다시입력</button>
                        </th>
                        <td class="TdGet">
                            <asp:TextBox runat="server" CssClass="type_01 date" ID="GetYMD" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_xsmall OnlyNumber essential" ID="GetHM" placeholder="시간" MaxLength="4"></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_03 find" ID="GetSearch" placeholder="주소검색" Width="130"></asp:TextBox>
                            <button type="button" class="btn_02" id="BtnSearchAddrGetPlace">우편번호 검색</button>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="GetAddr" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="GetAddrDtl" placeholder="상세주소"></asp:TextBox>
                            <asp:DropDownList runat="server" ID="GetWay" CssClass="type_01 essential" width="100"/>
                            <asp:TextBox runat="server" CssClass="type_01 essential" ID="GetTelNo" placeholder="전화번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>화물정보</th>
                        <td>
                            <asp:DropDownList runat="server" ID="CarTon" CssClass="type_01 essential"/>
                            <asp:DropDownList runat="server" ID="CarTruck" CssClass="type_01 essential"/>
                            <asp:TextBox runat="server" ID="Volume" CssClass="type_small ali_r Volume essential" placeholder="수량" MaxLength="10"></asp:TextBox> <strong>개</strong>
                            <asp:TextBox runat="server" ID="CBM" CssClass="type_small ali_r Weight essential" placeholder="부피" MaxLength="10"></asp:TextBox> <strong>CBM</strong>
                            <asp:TextBox runat="server" ID="Weight" CssClass="type_small ali_r Weight essential" placeholder="중량" MaxLength="10"></asp:TextBox> <strong>t</strong>
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
                            <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_01 ali_r Money essential" placeholder="운송료" MaxLength="11"></asp:TextBox>
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
                            <asp:TextBox runat="server" CssClass="type_02 essential" ID="Note" placeholder="화물상세정보"></asp:TextBox>
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
                <div class="tb_div"  style="overflow-y:auto; height:135px; margin-top:10px;">
                    <table class="popup_table" id="TblOrderList" style="margin:0;">
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
                            <th style="position : sticky; top: 0;">구분</th>
                            <th style="position : sticky; top: 0;">일자</th>
                            <th style="position : sticky; top: 0;">시간</th>
                            <th style="position : sticky; top: 0;">화주명</th>
                            <th style="position : sticky; top: 0;">주소</th>
                            <th style="position : sticky; top: 0;">상세주소</th>
                            <th style="position : sticky; top: 0;">담당자연락처</th>
                            <th style="position : sticky; top: 0;">상하차방법</th>
                            <th style="position : sticky; top: 0;"></th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
