<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="WebInoutOrgDetail.aspx.cs" Inherits="WEB.Inout.WebInoutOrgDetail" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script>
        $(document).ready(function () {
            if ($("#DisplayMode").val() === "Y") {
                //fnDefaultAlert($("#ErrMsg").val(), "warning", "parent.fnCloseCpLayer();");
                return;
            }
        });

        //파일 다운로드
        function fnDetailDownloadFile(obj) {
            var seq = "";
            var foname = "";
            var fnname = "";
            var flag = "";

            seq = $(obj).parent("li").attr("seq");
            foname = $(obj).text();
            fnname = $(obj).parent("li").attr("fname");
            flag = $(obj).parent("li").attr("flag");
            if (seq == "" || seq == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (foname == "" || foname == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (fnname == "" || fnname == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }

            if (flag == "" || flag == null) {
                fnDefaultAlert("필요한 값이 없습니다.", "warning");
                return;
            }
            var $form = null;

            if ($("form[name=dlFrm]").length == 0) {
                $form = $('<form name="dlFrm"></form>');
                $form.appendTo('body');
            } else {
                $form = $("form[name=dlFrm]");
            }
            
            $form.attr('action', '/WEB/Domestic/Proc/WebDomesticFileHandler.ashx');
            $form.attr('method', 'post');
            $form.attr('target', 'ifrmFiledown');

            var f1 = $('<input type="hidden" name="CallType" value="OrderFileDownload">');
            var f2 = $('<input type="hidden" name="FileSeqNo" value="' + seq + '">');
            var f3 = $('<input type="hidden" name="FileName" value="' + encodeURI(foname) + '">');
            var f4 = $('<input type="hidden" name="FileNameNew" value="' + fnname + '">');
            var f5 = $('<input type="hidden" name="TempFlag" value="' + flag + '">');
            var f6 = $('<input type="hidden" name="CenterCode" value="' + $("#CenterCode").val() + '">');
            var f7 = $('<input type="hidden" name="OrderNo" value="' + $("#OrderNo").val() + '">');

            $form.append(f1).append(f2).append(f3).append(f4).append(f5).append(f6).append(f7);
            $form.submit();
            $form.remove();
        }

        function fnCloseLayer() {
            self.close();
        }
    </script>
    <script src="/js/lib/jquery/jquery.iframe-transport.js" type="text/javascript"></script>
    <script src="/js/lib/jquery/jquery.fileupload.js" type="text/javascript"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="DisplayMode"/>
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderNo"/>
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <p style="margin-bottom:10px;">* 최초 등록한 오더의 내용</p>
                        <table class="popup_table">
                            <colgroup>
                                <col style="width:180px"/> 
                                <col style="width:auto;"/> 
                            </colgroup>
                            <tr>
                                <th>요청정보</th>
                                <td>
                                    <strong>요청자</strong>
                                    <asp:Label runat="server" ID="ReqChargeName"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>요청팀</strong>
                                    <asp:Label runat="server" ID="ReqChargeTeam"></asp:Label>
                                    <strong>요청자연락처</strong>
                                    <asp:Label runat="server" ID="ReqChargeTel"></asp:Label>
                                    <strong>요청자휴대폰</strong>
                                    <asp:Label runat="server" ID="ReqChargeCell"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>요청일</strong>
                                    <asp:Label runat="server" ID="ReqRegDate"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>상품정보</th>
                                <td>
                                    <strong>상품</strong>
                                    <asp:Label runat="server" ID="OrderItemCodeM"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>화주정보</th>
                                <td>
                                    <strong>화주명</strong>
                                    <asp:Label runat="server" ID="ConsignorName"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>상차정보</th>
                                <td class="change_td">
                                    <strong>상차일시</strong>
                                    <asp:Label runat="server" ID="PickupYMD"></asp:Label>
                                    &nbsp;
                                    <asp:Label runat="server" ID="PickupHM"></asp:Label>
                                    <br />
                                    <strong>상차지명</strong>
                                    <asp:Label runat="server" ID="PickupPlace"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>담당자</strong>
                                    <asp:Label runat="server" ID="PickupPlaceChargeName"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>직급</strong>
                                    <asp:Label runat="server" ID="PickupPlaceChargePosition"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>내선</strong>
                                    <asp:Label runat="server" ID="PickupPlaceChargeTelExtNo"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>연락처</strong>
                                    <asp:Label runat="server" ID="PickupPlaceChargeTelNo"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>휴대폰 번호</strong>
                                    <asp:Label runat="server" ID="PickupPlaceChargeCell"></asp:Label>
                                    <br />
                                    <strong>상차주소</strong>
                                    <asp:Label runat="server" ID="PickupPlaceAddr"></asp:Label>
                                    <asp:Label runat="server" ID="PickupPlaceAddrDtl"></asp:Label>
                                    <br />
                                    <strong>상차지 비고</strong>
                                    <asp:Label runat="server" ID="PickupPlaceNote"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>하차정보</th>
                                <td class="change_td">
                                    <strong>하차일시</strong>
                                    <asp:Label runat="server" ID="GetYMD"></asp:Label>
                                    &nbsp;
                                    <asp:Label runat="server" ID="GetHM"></asp:Label>
                                    <br />
                                    <strong>하차지명</strong>
                                    <asp:Label runat="server" ID="GetPlace"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>담당자</strong>
                                    <asp:Label runat="server" ID="GetPlaceChargeName"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>직급</strong>
                                    <asp:Label runat="server" ID="GetPlaceChargePosition"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>내선</strong>
                                    <asp:Label runat="server" ID="GetPlaceChargeTelExtNo"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>연락처</strong>
                                    <asp:Label runat="server" ID="GetPlaceChargeTelNo"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <strong>휴대폰 번호</strong>
                                    <asp:Label runat="server" ID="GetPlaceChargeCell"></asp:Label>
                                    <br />
                                    <strong>하차주소</strong>
                                    <asp:Label runat="server" ID="GetPlaceAddr"></asp:Label>
                                    <asp:Label runat="server" ID="GetPlaceAddrDtl"></asp:Label>
                                    <br />
                                    <strong>하차지 비고</strong>
                                    <asp:Label runat="server" ID="GetPlaceNote"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>운송정보</th>
                                <td class="change_td">
                                    <strong>목적국</strong>
                                    <asp:Label runat="server" ID="Nation"></asp:Label>
                                    <strong>H/AWB</strong>
                                    <asp:Label runat="server" ID="Hawb"></asp:Label>
                                    <strong>M/AWB</strong>
                                    <asp:Label runat="server" ID="Mawb"></asp:Label>
                                    <strong>Invoice No</strong>
                                    <asp:Label runat="server" ID="InvoiceNo"></asp:Label>
                                    <strong>부킹 No</strong>
                                    <asp:Label runat="server" ID="BookingNo"></asp:Label>
                                    <strong>입고 No</strong>
                                    <asp:Label runat="server" ID="StockNo"></asp:Label>
                                    <br /><br />
                                    <strong>도착보고</strong>
                                    <asp:Label runat="server" ID="ArrivalReportFlag"></asp:Label>
                                    <strong>보세</strong>
                                    <asp:Label runat="server" ID="BondedFlag"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>화물정보</th>
                                <td class="change_td">
                                    <strong>총수량</strong>
                                    <asp:Label runat="server" ID="Volume"></asp:Label>
                                    <strong>총부피</strong>
                                    <asp:Label runat="server" ID="CBM"></asp:Label>
                                    <strong>총중량</strong>
                                    <asp:Label runat="server" ID="Weight"></asp:Label>
                                    <strong>화물상세정보</strong>
                                    <asp:Label runat="server" ID="Quantity"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>기타정보</th>
                                <td class="change_td">
                                    <strong>요청사항</strong>
                                    <asp:Label runat="server" ID="NoteClient"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <th>파일첨부</th>
                                <td class="change_td">
                                    <ul runat="server" id="UlFileList">
                                    </ul>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="text-align:center; margin-top:20px;">
                    <button type="button" class="btn_03" onclick="fnCloseLayer();">닫기</button>
                </div>
            </div>
        </div>
    </div>
    <iframe id="ifrmFiledown" name="ifrmFiledown" scrolling="no" style="display:none;"></iframe>
</asp:Content>
