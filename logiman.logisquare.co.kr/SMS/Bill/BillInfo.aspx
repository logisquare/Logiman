<%@ Page Language="C#" MasterPageFile="~/Sms.Master"  AutoEventWireup="true" CodeBehind="BillInfo.aspx.cs" Inherits="SMS.Bill.BillInfo" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SMS/Bill/Proc/BillInfo.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
        });

    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="No"/>
    
    <div id="wrap">
        <div class="fast_area">
            <div class="top">
                <h2 class="bill_title">전자세금계산서 발행</h2>
            </div>
            <div class="bill">
                <h2>공급자</h2>
                <table class="red_tb">
                    <colgroup>
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                    </colgroup>
                    <tr>
                        <th>사업자번호</th>
                        <td colspan="3">
                            <span id="SELR_CORP_NO"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>업체명</th>
                        <td colspan="3"><span id="SELR_CORP_NM"></span></td>
                    </tr>
                    <tr>
                        <th>대표자명</th>
                        <td colspan="3"><span id="SELR_CEO"></span></td>
                    </tr>
                    <tr>
                        <th>업태</th>
                        <td><span id="SELR_BUSS_CONS"></span></td>
                        <th>종목</th>
                        <td><span id="SELR_BUSS_TYPE"></span></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td colspan="3" class="txtl"><span id="SELR_ADDR"></span></td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td><span id="SELR_TEL"></span></td>
                        <th>팩스</th>
                        <td><span id="SELR_FAX"></span></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td colspan="3" class="txtl"><span id="SELR_EMAIL"></span></td>
                    </tr>
                </table>
                <!--회원사-->
                
                <!--회원사-->
                <h2>공급받는자</h2>
                <table class="blue_tb">
                    <colgroup>
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                    </colgroup>
                    <tr>
                        <th>사업자번호</th>
                        <td colspan="3"><span id="BUYR_CORP_NO"></span></td>
                    </tr>
                    <tr>
                        <th>업체명</th>
                        <td colspan="3"><span id="BUYR_CORP_NM"></span></td>
                    </tr>
                    <tr>
                        <th>대표자명</th>
                        <td colspan="3"><span id="BUYR_CEO"></span></td>
                    </tr>
                    <tr>
                        <th>업태</th>
                        <td><span id="BUYR_BUSS_CONS"></span></td>
                        <th>종목</th>
                        <td><span id="BUYR_BUSS_TYPE"></span></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td colspan="3" class="txtl"><span id="BUYR_ADDR"></span></td>
                    </tr>
                </table>
                <h2>발행정보</h2>
                <table class="gray_tb">
                    <colgroup>
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                        <col style="width: 22%" />
                        <col style="width: 28%" />
                    </colgroup>
                    <tr>
                        <th>작성일자</th>
                        <td colspan="3"><span id="BILL_YMD"></span></td>
                    </tr>
                    <tr>
                        <th>공급가액</th>
                        <td class="txtr"><span id="CHRG_AMT"></span></td>
                        <th>세액</th>
                        <td class="txtr"><span id="TAX_AMT"></span></td>
                    </tr>
                    <tr>
                        <th>합계금액</th>
                        <td colspan="3" class="txtr"><span id="TOTL_AMT"></span></td>
                    </tr>
                </table>

                <p class="help">
                    위 정보로 전자세금계산서가 발행됩니다. <br/>
                    확인을 눌러 발행해주세요.<br/>
                    <span>*종이계산서는 작성하지 않으셔도 됩니다.<br/>(중복발행 방지)</span>
                </p>
            </div>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
            <div class="btn_type2">
                <ul>
                    <li><button type="button" class="blue" id="BtnTaxBill" onclick="return false;">확인</button></li>
                    <li><button type="button" class="gray" onclick="fnPopupClose(); return false;">닫기</button></li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>