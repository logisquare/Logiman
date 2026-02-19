<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CarManageIns.aspx.cs" Inherits="TMS.CarManage.CarManageIns" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/CarManage/Proc/CarManageIns.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="HidParam"/>
<asp:HiddenField runat="server" ID="ManageSeqNo"/>
<asp:HiddenField runat="server" ID="ComCode"/>
<asp:HiddenField runat="server" ID="CarSeqNo"/>
<asp:HiddenField runat="server" ID="CarTonCode"/>
<asp:HiddenField runat="server" ID="CarTypeCode"/>
<asp:HiddenField runat="server" ID="DriverSeqNo"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <table class="popup_table">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:120px;"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th rowspan="3">차량정보</th>
                        <th>차량업체명</th>
                        <td><asp:TextBox runat="server" CssClass="type_01" id="ComName"></asp:TextBox></td>
                        <th>사업자번호</th>
                        <td colspan="3"><asp:TextBox runat="server" CssClass="type_01" id="ComCorpNo"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>차량번호</th>
                        <td><asp:TextBox runat="server" CssClass="type_01" id="CarNo"></asp:TextBox></td>
                        <th>톤급</th>
                        <td><asp:TextBox runat="server" CssClass="type_01" id="CarTonCodeM"></asp:TextBox></td>
                        <th>차종</th>
                        <td><asp:TextBox runat="server" CssClass="type_01" id="CarTypeCodeM"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>기사명</th>
                        <td><asp:TextBox runat="server" CssClass="type_01" id="DriverName"></asp:TextBox></td>
                        <th>기사연락처</th>
                        <td colspan="3"><asp:TextBox runat="server" CssClass="type_01" id="DriverCell"></asp:TextBox></td>
                    </tr>
                </table>
                
                <table class="popup_table" style="margin-top: 20px;">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px;"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>상차지주소1</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="PickupFullAddr1" placeholder="상차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('PickupFullAddr1')">다시입력</button>
                        </td>
                        <th>하차지주소1</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="GetFullAddr1" placeholder="하차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('GetFullAddr1')">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th>상차지주소2</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="PickupFullAddr2" placeholder="상차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('PickupFullAddr2')">다시입력</button>
                        </td>
                        <th>하차지주소2</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="GetFullAddr2" placeholder="하차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('GetFullAddr2')">다시입력</button>
                        </td>
                    </tr>
                    <tr>
                        <th>상차지주소3</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="PickupFullAddr3" placeholder="상차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('PickupFullAddr3')">다시입력</button>
                        </td>
                        <th>하차지주소3</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="type_01 find" Width="250" ID="GetFullAddr3" placeholder="하차지주소"></asp:TextBox>
                            <button type="button" class="btn_03" onclick="fnResetAddr('GetFullAddr3')">다시입력</button>
                        </td>
                    </tr>
                </table>
                
                <table class="popup_table" style="margin-top: 20px;">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>
                            요일선택
                        </th>
                        <td>
                            <input type="checkbox" id="AllCheck"/><label for="AllCheck"><span></span>전체</label>
                            &nbsp;&nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo1" value="월"/><label for="DayInfo1"><span></span>월</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo2" value="화"/><label for="DayInfo2"><span></span>화</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo3" value="수"/><label for="DayInfo3"><span></span>수</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo4" value="목"/><label for="DayInfo4"><span></span>목</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo5" value="금"/><label for="DayInfo5"><span></span>금</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo6" value="토"/><label for="DayInfo6"><span></span>토</label>
                            &nbsp;
                            <input type="checkbox" name="DayInfo" id="DayInfo7" value="일"/><label for="DayInfo7"><span></span>일</label>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <input type="checkbox" id="EndYMDFlag" /> <label for="EndYMDFlag"><span></span><br/>종료일 선택</label>
                        </th>
                        <td>
                            <asp:TextBox runat="server" ID="EndYMD" CssClass="type_01 date"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            선택한 요일로 종료일까지 관리차량을 선택하여 배차 할 수 있습니다.
                        </td>
                    </tr>
                    <tr>
                        <th>
                            차량공유
                        </th>
                        <td>
                            <input type="checkbox" id="ShareFlag"/><label for="ShareFlag"><span></span> 차량 공유 제외</label>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="text-align:center;margin-top:20px">
                <button type="button" class="btn_01" id="InsBtn" onclick="fnCarManagerInsConfirm();">등록</button>
            </div>
        </div>
    </div>
</asp:Content>
