<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="TransRateApplyIns.aspx.cs" Inherits="TMS.TransRate.TransRateApplyIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/TransRate/Proc/TransRateApplyIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }
    </script>
    <style>
        #DivOrderLocationCode {width:100%; margin-top:10px; display:none;}
        #DivOrderLocationCode .OrderLocationCodeWrap { position:relative;  display:inline-block;}
        #DivOrderLocationCode .NotAllowed {display: none; top: 0px; left: 0px; width: 100%; height: 100%; position: absolute; background: rgba(0, 0, 0, 0); z-index: 1;}
        #DivOrderLocationCode ul {}
        #DivOrderLocationCode ul li { float:left; padding:0 5px; margin: 3px 0;}

        table.popup_table tr th {padding: 10px 15px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="ApplySeqNo" />
    <asp:HiddenField runat="server" ID="GradeCode" />
    <asp:HiddenField runat="server" ID="HidTransRateApplyChk" />
    <asp:HiddenField runat="server" ID="HidTransRateFTLYChk" />
    <asp:HiddenField runat="server" ID="HidTransRateFTLNChk" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="popup_title">적용대상</h3>
                <table class="popup_table">
                    <colgroup>
                        <col style="width:190px"/> 
                        <col/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>고객사</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_01 find essential" placeholder="고객사"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="ClientCode"/>
                            <asp:TextBox runat="server" ID="ClientCorpNo" ReadOnly="True" placeholder="사업자번호" CssClass="type_01"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ConsignorName" CssClass="type_01 find" placeholder="화주"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="ConsignorCode"/>
                        </td>
                    </tr>
                    <tr>
                        <th>기타</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01" ID="OrderItemCode"/>
                            <div id="DivOrderLocationCode">
                                <div class="OrderLocationCodeWrap">
                                    <div class="NotAllowed"></div>
                                    <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <div id="DivTransRateApplyClient" style="text-align: center; margin-top: 10px;">
                    <button type="button" runat="server" id="BtnApplyCheck" class="btn_01" onclick="fnTransRateApplyCheck();">중복확인</button>
                    &nbsp;&nbsp;
                    <button type="button" class="btn_03" id="BtnReset" onclick="fnTransRateApplyReset();">다시입력</button>
                </div>
                
                <div id="DivTransRateApply" style="display: none;">
                    <h3 class="popup_title">적용내역</h3>
                    <table class="popup_table TblFtlY">
                        <colgroup>
                            <col style="width:190px"/> 
                            <col style="width:120px;"/> 
                            <col/> 
                            <col style="width:120px"/> 
                            <col/> 
                            <col style="width:120px;"/> 
                            <col style="width:570px;"/> 
                        </colgroup>
                        <tr>
                            <th>
                                기본요율-독차
                                <br/>
                                <br/>
                                <button type="button" runat="server" id="BtnTransRateApplyDetailYReset" class="btn_03" onclick="fnTransRateApplyDetailFtlYReset(); return false;">다시입력</button>
                            </th>
                            <th>
                                매출/입요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="FtlSPTransSeqNoM" CssClass="type_100p find" placeholder="매출/입요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="FtlSPTransSeqNo"/>
                            </td>
                            <th>
                                매출요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="FtlSTransSeqNoM" CssClass="type_100p find" placeholder="매출요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="FtlSTransSeqNo"/>
                            </td>
                            <th>
                                매입요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="FtlPTransSeqNoM" CssClass="type_02 find" placeholder="매입요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="FtlPTransSeqNo"/>
                                <div id="DivFTLFlagY" style="margin-top: 10px;">
                                    <asp:CheckBox runat="server" id="RatioChkY" Text="<span class='RatioChkY'></span> 비율적용" disabled/>
                                    <asp:TextBox runat="server" ID="FtlFixedPurchaseRate" CssClass="type_01 Weight" style="width: 100px;" placeholder="고정차비율" ReadOnly="True"></asp:TextBox>
                                    %
                                    <asp:TextBox runat="server" id="FtlPurchaseRate" CssClass="type_01 Weight" style="width: 100px;" placeholder="용차비율" ReadOnly="True"></asp:TextBox>
                                    %
                                    <asp:DropDownList runat="server" CssClass="type_01" style="width: 100px;" id="FtlRoundAmtKind"/>
                                    <asp:DropDownList runat="server" CssClass="type_01" style="width: 100px;" id="FtlRoundType"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table class="popup_table TblFtlN" style="margin-top: 10px;">
                        <colgroup>
                            <col style="width:190px"/> 
                            <col style="width:120px;"/> 
                            <col/> 
                            <col style="width:120px"/> 
                            <col/> 
                            <col style="width:120px;"/> 
                            <col style="width:570px;"/> 
                        </colgroup>
                        <tr>
                            <th>
                                기본요율-혼적
                                <br/>
                                <br/>
                                <button type="button" runat="server" id="BtnTransRateApplyDetailNReset" class="btn_03" onclick="fnTransRateApplyDetailFtlNReset(); return false;">다시입력</button>
                            </th>
                            <th>
                                매출/입요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="LtlSPTransSeqNoM" CssClass="type_100p find" placeholder="매출/입요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" id="LtlSPTransSeqNo"/>
                            </td>
                            <th>
                                매출요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="LtlSTransSeqNoM" CssClass="type_100p find" placeholder="매출요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" id="LtlSTransSeqNo"/>
                            </td>
                            <th>
                                매입요율
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="LtlPTransSeqNoM" CssClass="type_02 find" placeholder="매입요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="LtlPTransSeqNo"/>
                                <div id="DivFTLFlagN" style="margin-top: 10px;">
                                    <asp:CheckBox runat="server" id="RatioChkN" Text="<span class='RatioChkN'></span> 비율적용"/>
                                    <asp:TextBox runat="server" ID="LtlFixedPurchaseRate" CssClass="type_01 Weight" style="width: 100px;" placeholder="고정차비율" ReadOnly="True"></asp:TextBox>
                                    %
                                    <asp:TextBox runat="server" id="LtlPurchaseRate" CssClass="type_01 Weight" style="width: 100px;" placeholder="용차비율" ReadOnly="True"></asp:TextBox>
                                    %
                                    <asp:DropDownList runat="server" CssClass="type_01" style="width: 100px;" id="LtlRoundAmtKind" />
                                    <asp:DropDownList runat="server" CssClass="type_01" style="width: 100px;" id="LtlRoundType"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                    <table class="popup_table TblLayover" style="margin-top: 10px;">
                        <colgroup>
                            <col style="width:190px;"/> 
                            <col/>
                        </colgroup>
                        <tr>
                            <th>
                                추가요율-경유지
                                <br/>
                                <br/>
                                <button type="button" runat="server" id="BtnLayoverTransRateReset" class="btn_03" onclick="fnTransRateApplyDetailLayoverReset(); return false;">다시입력</button>
                            </th>
                            <td>
                                <asp:TextBox runat="server" id="LayoverTransSeqNoM" CssClass="type_02 find" placeholder="경유지요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="LayoverTransSeqNo"/>
                            </td>
                        </tr>
                    </table>
                    
                    <table class="popup_table TblOil" style="margin-top: 10px;">
                        <colgroup>
                            <col style="width:190px;"/> 
                            <col style="width:120px;"/> 
                            <col/> 
                        </colgroup>
                        <tr>
                            <th rowspan="4">
                                추가요율-유가연동
                                <br/>
                                <br/>
                                <button type="button" runat="server" id="BtnTransRateOilReset" class="btn_03" onclick="fnTransRateApplyDetailOilReset(); return false;">다시입력</button>
                            </th>
                        </tr>
                        <tr>
                            <th>적용유가설정</th>
                            <td>
                                기간 &nbsp;&nbsp;
                                <asp:RadioButton runat="server" ID="OilPeriodType1" GroupName="OilPeriodType" Text="<span></span> 전월" value="1" Checked="True"/>
                                &nbsp;
                                <asp:RadioButton runat="server" ID="OilPeriodType2" GroupName="OilPeriodType" Text="<span></span> 전분기" value="2"/>
                                &nbsp;
                                <asp:RadioButton runat="server" ID="OilPeriodType4" GroupName="OilPeriodType" Text="<span></span> 직접입력" value="4"/>
                                <asp:DropDownList runat="server" ID="OilSearchArea" CssClass="type_01" style="width: 120px;"/>
                                <button type="button" id="BtnOilPriceChk" class="btn_02" onclick="fnOilAvgPrioceGet();">확인</button>
                                <asp:TextBox runat="server" ID="OilPrice" CssClass="type_01 Weight"  placeholder="적용유가" ReadOnly="True"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="2">요율표설정</th>
                            <td>
                                <asp:TextBox runat="server" ID="OilTransSeqNoM" CssClass="type_02 find" placeholder="유가연동요율표명"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="OilTransSeqNo"/>
                                <span style="margin:0 10px;">적용지역설정</span>
                                <asp:DropDownList runat="server" ID="OilGetPlace1" CssClass="type_01" style="width: 120px;"/>
                                <asp:DropDownList runat="server" ID="OilGetPlace2" CssClass="type_01" style="width: 120px;"/>
                                <asp:DropDownList runat="server" ID="OilGetPlace3" CssClass="type_01" style="width: 120px;"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilSaleRoundAmtKind"/>
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilSaleRoundType"/>
                                &nbsp;&nbsp;
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilFixedRoundAmtKind"/>
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilFixedRoundType"/>
                                &nbsp;&nbsp;
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilPurchaseRoundAmtKind"/>
                                <asp:DropDownList runat="server" CssClass="type_02" width="170" id="OilPurchaseRoundType"/>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: center; margin-top: 20px;">
                        <button type="button" class="btn_03" onclick="fnLocalCloseCpLayer();">닫기</button>
                        &nbsp;&nbsp;
                        <button type="button" runat="server" id="BtnTransRateApplyIns" class="btn_01" onclick="fnTransRateApplyInsConfirm();">저장</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>