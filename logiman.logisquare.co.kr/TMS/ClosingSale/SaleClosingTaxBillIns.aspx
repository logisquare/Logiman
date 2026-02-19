<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SaleClosingTaxBillIns.aspx.cs" Inherits="TMS.ClosingSale.SaleClosingTaxBillIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSale/Proc/SaleClosingTaxBillIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        function fnClosePopUpLayer() {
            window.close();
        }
    </script>
    <style>
        body {overflow-y: scroll !important;}
        form { height:auto;}
        #etax_area_item {margin: 10px 0;}
        #etax_area_item strong {margin: 0 5px; font-weight: 600;}
        #etax_area_item span.info {height:20px; line-height:20px; font-size:14px; margin: 0 5px; padding:2px 10px; background: #5674c8; color: #fff; font-weight:600; border-radius: 5px;}

        #InvoiceDetail a {display:none; width:16px; background-repeat: no-repeat; float:right; }
        #InvoiceDetail a.plus {background-image: url("/images/icon/more_icon.png"); background-size: 16px; background-position: center; height:16px;}
        #InvoiceDetail a.minus {background-image: url("/images/icon/minus_icon.png"); background-size: 16px;  background-position: 0% 63%;  height:22px;}

        input[type='text'].notAvail {color:red;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="SaleClosingSeqNo"/>
    <asp:HiddenField runat="server" ID="IssuSeqNo"/>
    <asp:HiddenField runat="server" ID="IssuID"/>
    <asp:HiddenField runat="server" ID="ClientStatus"/>
    <asp:HiddenField runat="server" ID="ClientCloseYMD"/>
    <asp:HiddenField runat="server" ID="ClientCode"/>
    <asp:HiddenField runat="server" ID="MinBillWrite"/>
    <asp:HiddenField runat="server" ID="OrderCnt"/>
    <asp:HiddenField runat="server" ID="OrgAmt"/>
    <asp:HiddenField runat="server" ID="SupplyAmt"/>
    <asp:HiddenField runat="server" ID="TaxAmt"/>
    <asp:HiddenField runat="server" ID="MinTaxAmt"/>
    <asp:HiddenField runat="server" ID="MaxTaxAmt"/>
    <asp:HiddenField runat="server" ID="TaxKind" Value="1"/>
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div id="etax_area_item">
                    &nbsp;
                    <input type="radio" id="ItemDependFlag1" name="ItemDependFlag" value="Y" checked /><label for="ItemDependFlag1"><span></span> 품목연동</label>&nbsp;
                    <input type="radio" id="ItemDependFlag2" name="ItemDependFlag" value="N" /><label for="ItemDependFlag2"><span></span> 품목미연동</label>
                    <div style="float:right;">
                        <strong>마감공급가액</strong><span id="SpanSupplyAmt" class="info"></span>
                        <strong>마감부가세</strong><span id="SpanTaxAmt" class="info"></span>
                        <strong>오더수</strong><span id="SpanOrderCnt" class="info"></span>
                        <strong>부가세 입력 범위</strong><span id="SpanTaxAmtInfo" class="info"></span>
                    </div>
                </div>
                <div id="etax_area_form">
                    <table class="etax_table  table_border_red" summary="세금계산서" style="table-layout:fixed;">
                        <thead>
                            <tr>
                                <th class="al_c tax_bg ft_24 bold" style="padding:10px;" colspan="100">
                                    세&nbsp;금&nbsp;계&nbsp;산&nbsp;서
                                </th>
                            </tr>
                        </thead>
                        <tbody id="InvoiceList">
                            <tr>
                                <th class="splitline tax_b_03_t" colspan="50"></th>
                                <th class="splitline tax_b_03_t" colspan="50"></th>
                            </tr>
                            <tr>
                                <th class="al_c noborder_l tax_bg noborder_t" colspan="3" rowspan="7"><span class="lh_30 bold">공<br>급<br>자</span></th>
                                <th class="al_c noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 al_c tax_b_01_r noborder_t" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CORP_NO" value="" readonly />
                                </td>
                                
                                <th class="al_c tax_bg noborder_t" colspan="3" rowspan="7"><span class="lh_16 bold">공<br>급<br>받<br>는<br>자</span></th>
                                <th class="al_c tax_b_01_r noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 noborder_t" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_CORP_NO" value="" readonly />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CORP_NM" value="" readonly />
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CEO" value="" readonly />
                                </td>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_CORP_NM" value="" readonly />
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_CEO" value="" readonly />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr tax_b_01_t lh_16" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="SELR_ADDR" value="" />
                                </td>
                                <th class="al_c  wbr tax_b_01_t  wbr tax_b_01_r lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr  wbr tax_b_01_t lh_16" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_ADDR" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <input type="text" class="type_100p" runat="server" id="SELR_BUSS_CONS" value="" />
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <input type="text" class="type_100p" runat="server" id="SELR_BUSS_TYPE" value="" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_BUSS_CONS" value="" />
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_BUSS_TYPE" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>연락처</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="SELR_TEL" value="" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>연락처</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_TEL" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c  tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CHRG_NM" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>휴대폰</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CHRG_MOBL" value="" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <input type="text" class="type_100p find" runat="server" id="BUYR_CHRG_NM" value="" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>휴대폰</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_CHRG_MOBL" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="SELR_CHRG_EMAIL" value="" />
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <input type="text" class="type_100p" runat="server" id="BUYR_CHRG_EMAIL" value="" />
                                </td>
                            </tr>
                        </tbody>
                        <tbody>
                            <tr>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                            </tr>
                            <tr>
                                <th class="al_c noborder_l tax_bg tax_gb_01_r noborder_t" colspan="11"><span class="bold">작성일자</span></th>
                                <th class="al_c tax_bg noborder_t tax_gb_01_r" colspan="50"><span class="bold">공급가액</span></th>
                                <th class="al_c tax_bg noborder_t" colspan="39"><span class="bold"><span>세</span><span class="mgl_20">액</span></span></th>
                            </tr>
                            <tr>
                                <td class="al_c letspc_0 al_c noborder_l tax_gb_01_t tax_gb_01_r" colspan="11">
                                    <input type="text" class="type_100p date" runat="server" id="BUY_DATE" value="" style="width: 110px;"/>
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="50">
                                    <input type="text" class="type_100p Money" runat="server" id="ITEM_AMT" value="" readonly />
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t" colspan="39">
                                    <input type="text" class="type_100p Money" runat="server" id="ITEM_TAX" value="" readonly />
                                </td>
                            </tr>
                        </tbody>
                        <tbody id="InvoiceDetail">
                            <tr>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                            </tr>
                            <tr>
                                <th class="al_c noborder_l noborder_t tax_bg tax_gb_01_r" colspan="3"><span class="bold">월</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="3"><span class="bold">일</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="20"><span class="bold">품&nbsp;&nbsp;목</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="7"><span class="bold">규&nbsp;&nbsp;격</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="7"><span class="bold">수&nbsp;&nbsp;량</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="7"><span class="bold">단&nbsp;&nbsp;가</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="18"><span class="bold">공급가액</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="13"><span class="bold">세&nbsp;&nbsp;액</span></th>
                                <th class="al_c tax_bg noborder_t" colspan="22">
                                    <span class="bold">비&nbsp;고</span>
                                    <a href="#" onclick="fnItemAdd(); return false" class="plus" title="항목추가"></a>
                                </th>
                            </tr>
                            <%
                                for (int i = 1; i <= 15; i++)
                                {
                            %>
                            <tr id="ITEM<%=i%>" <%=i > 1 ? "style=\"display: none;\"" : string.Empty%>>
                                <td class="al_c noborder_l tax_gb_01_t tax_gb_01_r" colspan="6">
                                    <input type="text" class="type_100p" id="DTL_BUY_DATE<%=i%>" value="" readonly />
                                </td>
                                <td class="al_l pdl_3 tax_gb_01_t tax_gb_01_r" colspan="20">
                                    <input type="text" class="type_100p nm" id="DTL_ITEM_NM<%=i%>" value="" readonly />
                                </td>
                                <td class="al_c pdl_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="7"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="7"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="7"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="18">
                                    <input type="text" class="type_100p Money amt" id="DTL_ITEM_AMT<%=i%>" value="" readonly />
                                </td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="13">
                                    <input type="text" class="type_100p Money tax" id="DTL_ITEM_TAX<%=i%>" value="" readonly />
                                </td>
                                <td class="al_l pdl_3 tax_gb_01_t" colspan="22">
                                    <input type="text" class="type_100p desp" id="DTL_ITEM_DESP<%=i%>" value="" maxlength="100"/>
                                    <a href="#" onclick="fnItemDel(<%=i%>); return false" class="minus" title="항목삭제"></a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            
                        </tbody>
                        <tbody>
                            <tr>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                            </tr>
                            <tr>
                                <th class="al_c noborder_l tax_bg tax_gb_01_r noborder_t" colspan="26"><span class="bold">합계금액</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="13">현금</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="13">수표</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="13">어음</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="13">외상미수금</th>
                                <td class="al_c noborder_t tax_gb_01_l" colspan="22" rowspan="2">이 금액을 <span class="pdr_2 bold">[
                                    <asp:RadioButton runat="server" ID="POPS_CODE1" GroupName="POPS_CODE" Text="<span></span> 영수" value="01"></asp:RadioButton>
                                    &nbsp;
                                    <asp:RadioButton runat="server" ID="POPS_CODE2" GroupName="POPS_CODE" Text="<span></span> 청구" value="02" Checked="True"></asp:RadioButton>
                                    ]</span>함</td>
                            </tr>
                            <tr>
                                <td class="al_r pdr_5 letspc_0 noborder_l tax_gb_01_t tax_gb_01_r" colspan="26">
                                    <input type="text" class="type_100p " runat="server" id="TOTAL_AMT" value="" readonly />
                                </td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="13"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="13"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="13"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="13"></td>
                            </tr>
                            <tr>
                                <td class="al_c tax_bg noborder_l" colspan="100">
                                    비&nbsp;고
                                </td>
                            </tr>
                            <tr>
                                <td class="al_c letspc_0 al_c noborder_l tax_gb_01_t tax_gb_01_r" colspan="100">
                                    <input type="text" class="type_100p" runat="server" id="NOTE1" value="" maxlength="500"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnClosePopUpLayer();">취소</button>
                &nbsp;&nbsp;
                <button type="button" class="btn_01" onclick="fnInsTaxBill();">발행</button>
            </div>
        </div>
    </div>
</asp:Content>