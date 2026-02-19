<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SaleClosingTaxBillView.aspx.cs" Inherits="TMS.ClosingSale.SaleClosingTaxBillView" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSale/Proc/SaleClosingTaxBillView.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
        });

        function fnClosePopUpLayer() {
            window.close();
        }
    </script>
    <style>
        @media print {
            .no_print { display: none;}
        }

        #InvoiceDetail tr {height:29px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="IssuSeqNo"/>
    <asp:HiddenField runat="server" ID="IssuID"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="ERR_CD"/>
    <asp:HiddenField runat="server" ID="POPS_CODE"/>
    <asp:HiddenField runat="server" ID="NOTE3"/>
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
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
                                <th class="al_c tax_b_01_r noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 al_c noborder_t" colspan="39">
                                    <span runat="server" id="SELR_CORP_NO"></span>
                                </td>
                                
                                <th class="al_c tax_bg noborder_t" colspan="3" rowspan="7"><span class="lh_16 bold">공<br>급<br>받<br>는<br>자</span></th>
                                <th class="al_c tax_b_01_r noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 noborder_t" colspan="39">
                                    <span runat="server" id="BUYR_CORP_NO"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <span runat="server" id="SELR_CORP_NM"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <span runat="server" id="SELR_CEO"></span>
                                </td>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <span runat="server" id="BUYR_CORP_NM"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <span runat="server" id="BUYR_CEO"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="SELR_ADDR"></span>
                                </td>
                                <th class="al_c  wbr tax_b_01_t  wbr tax_b_01_r lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr  wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="BUYR_ADDR"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <span runat="server" id="SELR_BUSS_CONS"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <span runat="server" id="SELR_BUSS_TYPE"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <span runat="server" id="BUYR_BUSS_CONS"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <span runat="server" id="BUYR_BUSS_TYPE"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt lh_14 pdt_3 pdb_5" colspan="8"><p><span>연락처</span></p></th>
                                <td class="al_l pdl_3 wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="SELR_TEL"></span>
                                </td>
                                <th class="al_c tax_b_01_rt lh_14 pdt_3 pdb_5" colspan="8"><p><span>연락처</span></p></th>
                                <td class="al_l pdl_3 wbr  wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="BUYR_TEL"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c  tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <span runat="server" id="SELR_CHRG_NM"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>휴대폰</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <span runat="server" id="SELR_CHRG_MOBL"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <span runat="server" id="BUYR_CHRG_NM"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>휴대폰</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <span runat="server" id="BUYR_CHRG_MOBL"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <span runat="server" id="SELR_CHRG_EMAIL"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <span runat="server" id="BUYR_CHRG_EMAIL"></span>
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
                                    <span runat="server" id="BUY_DATE"></span>
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="50">
                                    <span runat="server" id="CHRG_AMT"></span>
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t" colspan="39">
                                    <span runat="server" id="TAX_AMT"></span>
                                </td>
                            </tr>
                        </tbody>
                        <tbody id="InvoiceDetail">
                            <tr style="height:0;">
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
                                <th class="al_c tax_bg noborder_t" colspan="22"><span class="bold">비고</span></th>
                            </tr>
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
                                <td class="al_c noborder_t tax_gb_01_l" colspan="22" rowspan="2">
                                    이 금액을 <span  runat="server" ID="POPS_CODEM" class="bold"></span>함
                                </td>
                            </tr>
                            <tr>
                                <td class="al_r pdr_5 letspc_0 noborder_l tax_gb_01_t tax_gb_01_r" colspan="26">
                                    <span runat="server" id="TOTAL_AMT"></span>
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
                                <td class="letspc_0 noborder_l tax_gb_01_t tax_gb_01_r" colspan="100" style="height:29px;">
                                    <span runat="server" id="NOTE1"></span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <p runat="server" id="PModTaxBill" class="no_print" style="line-height:2; display: none;">* 수정 발행 시 동일한 작성일자, 공급가액으로 마이너스(-) 처리됩니다.</p>
            <div class="no_print" style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnClosePopUpLayer();">닫기</button>
                <button type="button" class="btn_03" id="BtnCnlTaxBill" onclick="fnCnlTaxBill();" style="display: none;">발행취소</button>
                <button type="button" class="btn_02" runat="server" id="BtnModTaxBill" onclick="fnModTaxBill()" style="display: none;">수정발행</button>
                <button type="button" class="btn_01" onclick="window.print(); return false;">인쇄</button>
                <!--<button type="button" class="btn_02" onclick="alert('준비중입니다.');">이메일전송</button>-->
            </div>
        </div>
    </div>
</asp:Content>