<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppSite.Master" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="APP.Main" %>
<%@ Import Namespace="CommonLibrary.CommonUtils" %>
<%@ Import Namespace="CommonLibrary.Extensions" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/Main/Proc/MainList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
        div#MainWrap div.main_total_area table tbody td {font-size:3vw !important;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div id="MainWrap">
        <h1 class="user_title"><strong><asp:Literal runat="server" ID="AdminName"></asp:Literal></strong> 님, <br />반갑습니다.</h1>
        <ul class="main_count">
            <li>
                <dl>
                    <dt><strong id="AcceptOrderCnt">0</strong>건</dt>
                    <dd>오더 접수</dd>
                </dl>
            </li>
            <li>
                <dl>
                    <dt><strong id="DispatchOrderCnt">0</strong>건</dt>
                    <dd>오더 배차</dd>
                </dl>
            </li>
        </ul>
        <div class="main_total_area">
            <ul>
                <li>
                    <asp:DropDownList runat="server" ID="CenterCode"></asp:DropDownList>
                </li>
                <li>
                    <button type="button" class="type_02" onclick="fnCallResultData();">검색</button>
                </li>
            </ul>
            <p style="text-align:right; padding-bottom:10px;">(상차일 기준 최근 2일)</p>
            <h2>배차 수익율 <span>단위: 원</span></h2>
            <table>
                <colgroup>
                    <col style="width:15%;"/>
                    <col style="width:22%;"/>
                    <col style="width:21%;"/>
                    <col style="width:21%;"/>
                    <col style="width:21%;"/>
                </colgroup>
                <thead>
                    <tr>
                        <th>날짜</th>
                        <th>매출</th>
                        <th>매입</th>
                        <th>수익</th>
                        <th>수익률</th>
                    </tr>
                </thead>
                <tbody id="OrderDispatchData">
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>