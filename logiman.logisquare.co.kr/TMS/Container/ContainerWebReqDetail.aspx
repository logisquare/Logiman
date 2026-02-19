<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="ContainerWebReqDetail.aspx.cs" Inherits="TMS.Container.ContainerWebReqDetail" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Container/Proc/ContainerWebReqList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <div class="search_line">
                            <asp:CheckBox runat="server" id="CheckBox1" Text="<span></span>도착보고"/>
                            &nbsp;&nbsp;
                            <asp:CheckBox runat="server" id="CheckBox2" Text="<span></span>보세"/>
                            &nbsp;&nbsp;
                            <asp:DropDownList runat="server" ID="DropDownList4" class="type_small" AutoPostBack="false"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="DropDownList2" class="type_small" AutoPostBack="false"></asp:DropDownList>
                            &nbsp;&nbsp;
                            상태 : <asp:Label runat="server" ID="label1">접수</asp:Label>(<asp:Label runat="server" ID="label2">홍길동</asp:Label>)
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">오더보기</button>
                        </div>
                    </div>
                    <!--여기서부터 작업-->
                    <table class="popup_table">
                        <colgroup>
                            <col style="width:180px;"/>
                            <col style="width:auto;"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="2">고객사 정보</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>청구처</th>
                                <td></td>
                            </tr>
                            <tr>
                                <th>화주</th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="popup_table" style="margin-top:20px;">
                        <colgroup>
                            <col style="width:180px;"/>
                            <col style="width:auto;"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="2">상하차지 정보</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>상차</th>
                                <td></td>
                            </tr>
                            <tr>
                                <th>하차</th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="popup_table" style="margin-top:20px;">
                        <colgroup>
                            <col style="width:180px;"/>
                            <col style="width:auto;"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="2">화물 정보</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>화물</th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="popup_table" style="margin-top:20px;">
                        <colgroup>
                            <col style="width:180px;"/>
                            <col style="width:auto;"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th colspan="2">기타 정보</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <th>비고</th>
                                <td></td>
                            </tr>
                            <tr>
                                <th>첨부파일</th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
