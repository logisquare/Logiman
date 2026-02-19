<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ClientIns.aspx.cs" Inherits="TMS.Client.ClientIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Client/Proc/ClientIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        var strCenterCode = "";

        $(document).ready(function() {
            $("#CenterCode").on("focus", function () {
                strCenterCode = $(this).val();
            }).on("change", function () {
                if ($(this).val()) {
                    //회원사가 다른 경우
                    if ($(this).val() !== strCenterCode) {
                        fnChkCenter();
                    }
                }

                if ($("#HidCorpNoChk").val("") === "Y") {
                    $("#BtnCorpNoReChk").click();
                }
            });

            $("#BtnCorpNoChk").on("click",
                function () {
                    fnChkCorpNo();
                    return false;
                });

            $("#BtnCorpNoReChk").on("click",
                function () {
                    $("#ClientCorpNo").val("");
                    $("#ClientCorpNo").removeAttr("readonly");
                    $("#HidCorpNoChk").val("N");
                    $("#BtnCorpNoChk").show();
                    $("#BtnCorpNoReChk").hide();
                    $("#ClientStatus").val("");
                    $("#ClientCloseYMD").val("");
                    $("#ClientUpdYMD").val("");
                    $("#ClientTaxKind").val("");
                    $("#ClientTaxKind option").prop("disabled", false);
                    $("#ClientTaxMsg").val("");
                    return false;
                });

            $("#BtnAcctNoChk").on("click",
                function () {
                    fnChkAcctNo();
                    return;
                });

            $("#BtnAcctNoReChk").on("click",
                function () {
                    $("#HidAcctNoChk").val("N");
                    $("#ClientBankCode").val("");
                    $("#ClientBankCode option").prop("disabled", false);
                    $("#ClientAcctNo").val("");
                    $("#ClientAcctNo").removeAttr("readonly");
                    $("#ClientAcctName").val("");
                    $("#BtnAcctNoChk").show();
                    $("#BtnAcctNoReChk").hide();
                    return false;
                });

            $("#BtnSearchAddrClient").on("click",
                function () {
                    fnOpenAddress('Client');
                    return;
                });

            $("#BtnSearchAddrClientDM").on("click",
                function () {
                    fnOpenAddress('ClientDM');
                    return;
                });

            $("#BtnChargeIns").on("click",
                function () {
                    fnInsCharge();
                    return;
                });

            $("#BtnChargeDel").on("click",
                function () {
                    fnDelCharge();
                    return;
                });

            $("#BtnChargeReset").on("click",
                function () {
                    fnResetCharge();
                    return;
                });

            $("#BtnChargeListSearch").on("click",
                function () {
                    fnCallChargeGridData(GridChargeID);
                    return;
                });
        });

        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }
    </script>
    <style>
        .btnWrap {margin:5px 0 5px 0;}
        .subGridWrap {margin:5px 0 0 0;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="HidCorpNoChk" Value="N"/>
    <asp:HiddenField runat="server" ID="HidAcctNoChk" Value="N"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <asp:HiddenField runat="server" ID="ClientStatus"/>
    <asp:HiddenField runat="server" ID="ClientCloseYMD"/>
    <asp:HiddenField runat="server" ID="ClientUpdYMD"/>
    <asp:HiddenField runat="server" ID="ChargeSeqNo"/>

    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>회원사</th>
                        <td>
                            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="CenterCode"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <br />
                <table class="popup_table">
                    <colgroup>
                        <col style="width:180px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="4">업체정보</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientCorpNo" CssClass="type_01 OnlyNumber essential" placeholder="사업자번호" MaxLength="10"></asp:TextBox>
                            <button type="button" runat="server" ID="BtnCorpNoChk" class="btn_02">중복확인</button>
                            <button type="button" runat="server" ID="BtnCorpNoReChk" class="btn_02" style = "display:none;">다시입력</button>
                            <asp:TextBox runat="server" ID="ClientName" CssClass="type_02 essential" placeholder="업체명" MaxLength="50"></asp:TextBox>
                            
                            <asp:TextBox runat="server" ID="ClientCeoName" CssClass="type_small essential" placeholder="대표자명" MaxLength="50"></asp:TextBox>
                            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="ClientTaxKind"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="ClientTaxMsg" CssClass="type_01" readonly></asp:TextBox>
                            <asp:DropDownList runat="server" CssClass="type_01 essential" ID="ClientType"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ClientBizType" CssClass="type_02" placeholder="업태" MaxLength="100"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientBizClass" CssClass="type_02" placeholder="종목" MaxLength="100"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientTelNo" CssClass="type_01 OnlyNumber essential" placeholder="전화번호" MaxLength="10"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientFaxNo" CssClass="type_01 OnlyNumber" placeholder="팩스번호" MaxLength="10"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientEmail" CssClass="type_02 OnlyEmail" placeholder="이메일" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ClientPost" CssClass="type_small" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientAddr" CssClass="type_02" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientAddrDtl" CssClass="type_02" placeholder="주소 상세" MaxLength="100"></asp:TextBox>
                            <button type="button" ID="BtnSearchAddrClient" class="btn_02">우편번호 검색</button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList runat="server" ID="ClientBankCode" CssClass="type_01"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="ClientAcctNo" CssClass="type_02 OnlyNumber" placeholder="계좌번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientAcctName" CssClass="type_01" placeholder="예금주" MaxLength="50" readonly></asp:TextBox>
                            <button type="button" runat="server" ID="BtnAcctNoChk" class="btn_02">확인</button>
                            <button type="button" runat="server" ID="BtnAcctNoReChk" class="btn_02" style = "display:none;">다시입력</button>
                            <asp:TextBox runat="server" ID="DouzoneCode" CssClass="type_01 onlyAlphabetNum" placeholder="더존코드" MaxLength="50"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>매출한도 제한 설정</th>
                        <td>
                            매출한도금액 : <asp:TextBox runat="server" ID="SaleLimitAmt" CssClass="type_01 OnlyNumber" placeholder="매출한도금액"></asp:TextBox>&nbsp;&nbsp;&nbsp;&nbsp;
                            매출원가율(%) : <asp:TextBox runat="server" ID="RevenueLimitPer" CssClass="type_01 OnlyNumberPoint" placeholder="매출원가율(%)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>DM 주소</th>
                        <td>
                            <asp:TextBox runat="server" ID="ClientDMPost" CssClass="type_small" placeholder="우편번호" readonly></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientDMAddr" CssClass="type_02" placeholder="주소" readonly></asp:TextBox>
                            <asp:TextBox runat="server" ID="ClientDMAddrDtl" CssClass="type_02" placeholder="주소 상세" MaxLength="100"></asp:TextBox>
                            <button type="button" ID="BtnSearchAddrClientDM" class="btn_02" onclick="">우편번호 검색</button>
                        </td>
                    </tr>
                    <tr>
                        <th>거래정보</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ClientClosingType" CssClass="type_01"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="ClientPayDay" CssClass="type_01 essential"></asp:DropDownList>
                            <button type="button" class="btn_help" id="BtnClientPayDayHelp"></button>
                            <asp:DropDownList runat="server" ID="ClientBusinessStatus" CssClass="type_small"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th rowspan="3" runat="server" ID="TdChargeTitle">업체담당</th>
                        <td>
                            <input type="checkbox" name="ChargeOrderFlag" id="ChargeOrderFlag" value="Y"/><label for="ChargeOrderFlag"><span></span> 업무</label>
                            &nbsp;&nbsp;
                            <input type="checkbox" name="ChargePayFlag" id="ChargePayFlag" value="Y"/><label for="ChargePayFlag"><span></span> 청구</label>
                            &nbsp;&nbsp;
                            <input type="checkbox" name="ChargeArrivalFlag" id="ChargeArrivalFlag" value="Y"/><label for="ChargeArrivalFlag"><span></span> 도착보고</label>
                            &nbsp;&nbsp;
                            <input type="checkbox" name="ChargeBillFlag" id="ChargeBillFlag" value="Y"/><label for="ChargeBillFlag"><span></span> 계산서</label>
                            <asp:TextBox runat="server" ID="ChargeName" CssClass="type_small" placeholder="담당자명"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeLocation" CssClass="type_01" placeholder="청구사업장"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeTelExtNo" CssClass="type_small" placeholder="내선"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeTelNo" CssClass="type_01 OnlyNumber" placeholder="전화번호"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeCell" CssClass="type_01 OnlyNumber" placeholder="휴대폰 번호"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox runat="server" ID="ChargeFaxNo" CssClass="type_01 OnlyNumber" placeholder="팩스"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeEmail" CssClass="type_02 OnlyEmail" placeholder="이메일"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargePosition" CssClass="type_small" placeholder="직급"></asp:TextBox>
                            <asp:TextBox runat="server" ID="ChargeDepartment" CssClass="type_01" placeholder="부서"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <span runat="server" id="SpanChargeUseFlag">
                                <asp:RadioButton ID="ChargeUseFlagY" runat="server" GroupName="ChargeUseFlag" value="Y" Checked="true" />
                                <label for="ChargeUseFlagY"><span></span>사용중</label>
                                <asp:RadioButton ID="ChargeUseFlagN" runat="server" GroupName="ChargeUseFlag" value="N" />
                                <label for="ChargeUseFlagN"><span></span>사용중지</label>
                            </span>
                            <button type="button" runat="server" id="BtnChargeIns" class="btn_01" >저장</button>
                            <button type="button" runat="server" id="BtnChargeDel" class="btn_03" style="display: none;" >삭제</button>
                            <button type="button" runat="server" id="BtnChargeReset" class="btn_02" >다시입력</button>
                        </td>
                    </tr>
                    <tr runat="server" ID="TrChargeGrid">
                        <td>
                            <div class="btnWrap">
                                <input type="text" id="SchChargeName" name="SchChargeName" value="" class="type_02" placeholder="담당자명" />
                                <button type="button" runat="server" id="BtnChargeListSearch" class="btn_01">조회</button>
                                <span style="float: right; display: none;">
                                    <input type="text" id="SchChargeGridTxt" name="SchChargeGridTxt" value="" class="type_02"/>
                                    <button type="button" id="BtnSchChargeGrid" class="btn_01">결과내 검색</button>
                                </span>
                            </div>
                            <div id="ClientChargeListGrid" class="subGridWrap"></div>
                        </td>
                    </tr>
                    <tr runat="server" ID="TrTrans" style="display: none;">
                        <th>웹오더자동이관계열사(내수)</th>
                        <td><asp:DropDownList runat="server" CssClass="type_01" ID="TransCenterCode"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td>
                            <div>
                                <div style="width: 50%; float: left;">
                                    <h2>거래정지사유</h2>
                                    <asp:TextBox runat="server" ID="ClientNote1" CssClass="special_note" placeholder="" TextMode="MultiLine" Height="50"></asp:TextBox>
                                </div>
                                <div style="width: 50%; float: left;">
                                    <h2>업무특이사항</h2>
                                    <asp:TextBox runat="server" ID="ClientNote2" CssClass="special_note" placeholder="" TextMode="MultiLine" Height="50"></asp:TextBox>
                                </div>
                            </div>
                            <div>
                                <div style="width: 50%; float: left;">
                                    <h2>영업특이사항</h2>
                                    <asp:TextBox runat="server" ID="ClientNote3" CssClass="special_note" placeholder="" TextMode="MultiLine" Height="50"></asp:TextBox>
                                </div>
                                <div style="width: 50%; float: left;">
                                    <h2>청구특이사항</h2>
                                    <asp:TextBox runat="server" ID="ClientNote4" CssClass="special_note" placeholder="" TextMode="MultiLine" Height="50"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>화물실적신고대상</th>
                        <td>
                            <asp:RadioButton ID="ClientFPISFlagY" runat="server" GroupName="ClientFPISFlag" value="Y" Checked="true" />
                            <label for="ClientFPISFlagY"><span></span>대상</label>
                            <asp:RadioButton ID="ClientFPISFlagN" runat="server" GroupName="ClientFPISFlag" value="N" />
                            <label for="ClientFPISFlagN"><span></span>대상아님</label>
                        </td>
                    </tr>
                    <tr runat="server" ID="TrUseFlag">
                        <th>사용여부</th>
                        <td>
                            <asp:RadioButton ID="UseFlagY" runat="server" GroupName="UseFlag" value="Y" Checked="true" />
                            <label for="UseFlagY"><span></span>사용중</label>
                            <asp:RadioButton ID="UseFlagN" runat="server" GroupName="UseFlag" value="N" />
                            <label for="UseFlagN"><span></span>사용중지</label>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnLocalCloseCpLayer();">닫기</button>
                &nbsp;&nbsp;
                <button type="button" class="btn_01" onclick="fnInsClient();">저장</button>
            </div>
        </div>
    </div>
</asp:Content>
