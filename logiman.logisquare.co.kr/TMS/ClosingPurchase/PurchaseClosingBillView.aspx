<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="PurchaseClosingBillView.aspx.cs" Inherits="TMS.ClosingPurchase.PurchaseClosingBillView" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingPurchase/Proc/PurchaseClosingBillView.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
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
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidMode"/>
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="PurchaseClosingSeqNo"/>
    <asp:HiddenField runat="server" ID="NtsConfirmNum"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="SendStatus"/>
    <asp:HiddenField runat="server" ID="BillStatus"/>
    <asp:HiddenField runat="server" ID="BillWrite"/>
    <asp:HiddenField runat="server" ID="ScanFileUrl"/>
    <asp:HiddenField runat="server" ID="ScanFileName"/>
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
                                <th class="al_c noborder_l tax_bg noborder_t" colspan="3" rowspan="6"><span class="lh_30 bold">공<br>급<br>자</span></th>
                                <th class="al_c tax_b_01_r noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 al_c noborder_t" colspan="39">
                                    <span runat="server" id="INVOICER_CORP_NUM"></span>
                                </td>
                                
                                <th class="al_c tax_bg noborder_t" colspan="3" rowspan="6"><span class="lh_16 bold">공<br>급<br>받<br>는<br>자</span></th>
                                <th class="al_c tax_b_01_r noborder_t" colspan="8">등록번호</th>
                                <td class="al_c letspc_0 noborder_t" colspan="39">
                                    <span runat="server" id="INVOICEE_CORP_NUM"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <span runat="server" id="INVOICER_CORP_NAME"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <span runat="server" id="INVOICER_CEO_NAME"></span>
                                </td>
                                <th class="al_c tax_b_01_rt pdb_5" colspan="8"><span>상</span><span class="mgl_20">호</span></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_rt" colspan="23">
                                    <span runat="server" id="INVOICEE_CORP_NAME"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14 pdb_5" colspan="4"><p><span>성</span><span>명</span></p></th>
                                <td class="al_l pdl_3 letspc_0 wbr tax_b_01_t" colspan="12">
                                    <span runat="server" id="INVOICEE_CEO_NAME"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="INVOICER_ADDR"></span>
                                </td>
                                <th class="al_c  wbr tax_b_01_t  wbr tax_b_01_r lh_14 pdt_3 pdb_5" colspan="8"><p><span>사</span><span class="mgl_4">업</span><span class="mgl_4">장</span></p><p><span>주</span><span class="mgl_20">소</span></p></th>
                                <td class="al_l pdl_3 wbr  wbr tax_b_01_t lh_16" colspan="39">
                                    <span runat="server" id="INVOICEE_ADDR"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <span runat="server" id="INVOICER_BIZ_TYPE"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <span runat="server" id="INVOICER_BIZ_CLASS"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>업</span><span class="mgl_20">태</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_rt lh_16" colspan="17">
                                    <span runat="server" id="INVOICEE_BIZ_TYPE"></span>
                                </td>
                                <th class="wbr al_c tax_b_01_rt lh_14" colspan="6"><span>종</span><span>목</span></th>
                                <td class="al_l pdl_3 pdr_3 letspc_0 wbr tax_b_01_t lh_16" colspan="16">
                                    <span runat="server" id="INVOICEE_BIZ_CLASS"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c  tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <span runat="server" id="INVOICER_CONTACT_NAME"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>연락처</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <span runat="server" id="INVOICER_TEL"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>담</span><span class="mgl_4">당</span><span class="mgl_4">자</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_rt" colspan="17">
                                    <span runat="server" id="INVOICEE_CONTACT_NAME1"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="6"><span>연락처</span></th>
                                <td class="al_l pdl_3 letspc_0 tax_b_01_t" colspan="16">
                                    <span runat="server" id="INVOICEE_TEL1"></span>
                                </td>
                            </tr>
                            <tr>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <span runat="server" id="INVOICER_EMAIL"></span>
                                </td>
                                <th class="al_c tax_b_01_rt" colspan="8"><span>이</span><span class="mgl_4">메</span><span class="mgl_4">일</span></th>
                                <td class="al_l pdl_3 tax_b_01_t letspc_0" colspan="39">
                                    <span runat="server" id="INVOICEE_EMAIL1"></span>
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
                                    <span runat="server" id="WRITE_DATE"></span>
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="50">
                                    <span runat="server" id="SUPPLY_COST_TOTAL"></span>
                                </td>
                                <td class="al_r pdr_7 letspc_0 tax_gb_01_t" colspan="39">
                                    <span runat="server" id="TAX_TOTAL"></span>
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
                                <th class="al_c tax_bg noborder_t" colspan="22"><span class="bold">비고</span></th>
                            </tr>
                        </tbody>
                        <tbody>
                            <tr>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                                <th class="splitline tax_b_02_t" colspan="50"></th>
                            </tr>
                            <tr>
                                <th class="al_c noborder_l tax_bg tax_gb_01_r noborder_t" colspan="22"><span class="bold">합계금액</span></th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="14">현금</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="14">수표</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="14">어음</th>
                                <th class="al_c tax_bg tax_gb_01_r noborder_t" colspan="14">외상미수금</th>
                                <td class="al_c noborder_t tax_gb_01_l" colspan="22" rowspan="2">
                                    이 금액을 <span  runat="server" ID="PURPOSE_TYPE" class="bold"></span>함
                                </td>
                            </tr>
                            <tr>
                                <td class="al_r pdr_5 letspc_0 noborder_l tax_gb_01_t tax_gb_01_r" colspan="22">
                                    <span runat="server" id="TOTAL_AMOUNT"></span>
                                </td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="14"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="14"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="14"></td>
                                <td class="al_r pdr_5 letspc_0 tax_gb_01_t tax_gb_01_r" colspan="14"></td>
                            </tr>
                            <tr>
                                <td class="al_c tax_bg noborder_l" colspan="100">
                                    비&nbsp;고
                                </td>
                            </tr>
                            <tr>
                                <td class="letspc_0 noborder_l tax_gb_01_t tax_gb_01_r" colspan="100">
                                    <span runat="server" id="REMARK1"></span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="no_print" style="text-align:center;margin-top:20px">
                <button type="button" class="btn_03" onclick="fnClosePopUpLayer();">닫기</button>
                <button type="button" class="btn_02" id="BrnViewOriginal" onclick="fnViewOriginal();" style="display: none;">원본보기</button>
                <button type="button" runat="server" class="btn_03" id="BtnCnlPreMatching" onclick="fnCnlPreMatching();" style="display: none;">연결해제</button>
                <button type="button" class="btn_01" onclick="window.print(); return false;">인쇄</button>
            </div>
        </div>
    </div>
</asp:Content>