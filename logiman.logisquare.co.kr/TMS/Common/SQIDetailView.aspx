<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="SQIDetailView.aspx.cs" Inherits="TMS.Common.SQIDetailView" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/SQIDetailView.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            $(".special_note").focus();

            $("#BtnEditSQI").on("click", function () {
                fnUpdNote();
                return;
            });
        });

        function fnWindowClose() {
            window.close();
        }
    </script>
    <style>
        form { height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="HidErrMsg"/>
    <asp:HiddenField runat="server" ID="SQISeqNo"/>
    <asp:HiddenField runat="server" ID="OrderType"/>
    <asp:HiddenField runat="server" ID="CenterCode"/>
    <asp:HiddenField runat="server" ID="OrderNo"/>
    <asp:HiddenField runat="server" ID="OrderItemCode"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <h3 class="H3Name"> 오더 서비스 이슈 상세</h3>
                
                <table class="popup_table" style="margin-bottom:0px;">
                    <colgroup>
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>오더번호</th>
                        <td><span runat="server" id="OrderNoView"></span></td>
                        <th>상차일(작업일)</th>
                        <td><span id="PickupYMD"></span></td>
                    </tr>
                    <tr>
                        <th>고객사</th>
                        <td><span id="PayClientName"></span></td>
                        <th>화주</th>
                        <td><span id="ConsignorName"></span></td>
                    </tr>
                    <tr>
                        <th>상품</th>
                        <td><span id="OrderItemCodeM"></span></td>
                        <th>고객담당 / 접수자</th>
                        <td><span id="CsAdminName"></span> / <span id="AcceptAdminName"></span></td>
                    </tr>
                    </tbody>
                </table>

                <table class="popup_table" style="margin:10px 0;">
                    <colgroup>
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                        <col style="width:20%;"/> 
                        <col style="width:30%;"/> 
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>이슈유형</th>
                        <td>
                            <span id="ItemName"></span>
                        </td>
                        <th>발생일</th>
                        <td>
                            <span id="YMD"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>이슈유형 비고</th>
                        <td colspan="3">
                            <span id="Detail"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">1. 담당팀 / 성명</th>
                        <td colspan="3">
                            <span id="Team"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">2. 이슈 내용</th>
                        <td colspan="3">
                            <span id="Contents"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">3. 응급 조치</th>
                        <td colspan="3">
                            <span id="Action"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">4. 원인</th>
                        <td colspan="3">
                            <span id="Cause"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">5. 사후 조치</th>
                        <td colspan="3">
                            <span id="FollowUp"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">6. 비용 처리</th>
                        <td colspan="3">
                            <span id="Cost"></span>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: left;">7. 재발방지 대책</th>
                        <td colspan="3">
                            <span id="Measure"></span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                
                <div style="text-align:center; margin: 20px 0;">
                    <button type="button" class="btn_03" onclick="fnWindowClose();">닫기</button>
                    &nbsp;&nbsp;
                    <button type="button" class="btn_02" onclick="fnGoSQIList();">목록</button>
                    &nbsp;&nbsp;
                    <button type="button" class="btn_01" onclick="fnGoSQIEdit();">수정</button>
                    &nbsp;&nbsp;
                    <button type="button" class="btn_03" id="BtnDelSQI">삭제</button>
                </div>
                
                
                <h3 class="H3Name"> 댓글</h3>
                <div style="text-align:center; margin-top: 10px; position: relative; height: 60px;">
                    <div style="width: 90%; float: left;">
                        <asp:TextBox runat="server" ID="CommentContents"  CssClass="type_100p" TextMode="MultiLine" Height="60"/>
                    </div>
                    <div style="width: 10%; float: left;">
                        <button type="button" class="btn_01" id="BtnRegComment" style="height: 60px;">등록</button>
                    </div>
                </div>
                <table class="popup_table" style="margin:10px 0;">
                    <colgroup>
                        <col/> 
                        <col style="width:80px;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:80px;"/> 
                    </colgroup>
                    <thead>
                    <tr>
                        <th>내용</th>
                        <th>등록자</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="SQICommentList"></tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
