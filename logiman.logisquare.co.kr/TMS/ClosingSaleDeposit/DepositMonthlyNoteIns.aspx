<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="DepositMonthlyNoteIns.aspx.cs" Inherits="TMS.ClosingSaleDeposit.DepositMonthlyNoteIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/ClosingSaleDeposit/Proc/DepositMonthlyNoteIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });

            //확인내용 등록
            $("#BtnInsNote").on("click", function (e) {
                fnInsNote();
                return false;
            });

            //확인내용 수정
            $("#BtnUpdNote").on("click", function (e) {
                fnUpdNote();
                return false;
            });

            //확인내용 삭제
            $("#BtnDelNote").on("click", function (e) {
                fnDelNote();
                return false;
            });

            //확인내용 다시입력
            $("#BtnResetNote").on("click", function (e) {
                fnResetNote();
                return false;
            });

        });
    </script>
    <style>
        .popup_table tr td { min-width: 100px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidClientCode" />
    <asp:HiddenField runat="server" ID="NoteSeqNo"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>거래처명</th>
                        <td colspan="3">
                            <span id="ClientName"></span>
                        </td>
                        <th>사업자번호</th>
                        <td><span id="ClientCorpNo"></span></td>
                        <th>대표자명</th>
                        <td><span id="ClientCeoName"></span></td>
                    </tr>
                    <tr>
                        <th>업태</th>
                        <td><span id="ClientBizType"></span></td>
                        <th>종목</th>
                        <td><span id="ClientBizClass"></span></td>
                        <th>전화번호</th>
                        <td><span id="ClientTelNo"></span></td>
                        <th>팩스번호</th>
                        <td><span id="ClientFaxNo"></span></td>
                    </tr>
                    <tr>
                        <th>주소</th>
                        <td colspan="3">
                            <span id="ClientPost"></span>&nbsp;
                            <span id="ClientAddr"></span>&nbsp;
                            <span id="ClientAddrDtl"></span>
                        </td>
                        <th>여신일</th>
                        <td><span id="ClientPayDayM"></span></td>
                        <th>거래상태</th>
                        <td><span id="ClientBusinessStatusM"></span></td>
                    </tr>
                    <tr>
                        <th>계좌정보</th>
                        <td colspan="7">
                            <span id="ClientBankName"></span>&nbsp;
                            <span id="ClientAcctNo"></span>&nbsp;
                            <span id="ClientAcctName"></span>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="popup_table">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>확인일</th>
                        <td style="border-right: 0px;">
                            <asp:TextBox runat="server" ID="NoteYMD" class="type_01 date" AutoPostBack="false" placeholder=""/>
                        </td>
                        <td style="text-align: right; border-left: 0px;">
                            <button type="button" class="btn_01" id="BtnInsNote">등록</button>
                            <button type="button" class="btn_01" id="BtnUpdNote" style="display:none;">수정</button>
                            <button type="button" class="btn_02" id="BtnDelNote" style="display:none;">삭제</button>
                            <button type="button" class="btn_03" id="BtnResetNote">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th>확인내용</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" ID="Note" CssClass="special_note" placeholder="" TextMode="MultiLine" Height="50"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div class="grid_list">
                    <ul class="grid_option">
                        <li class="left">
                        </li>
                        <li class="right">
                            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                        </li>
                    </ul>
                    <div id="DepositMonthlyNoteListGrid"></div>
                </div>
	        </div>
        </div>
    </div>
</asp:Content>
