<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CMConnectionSetting.aspx.cs" Inherits="TMS.CallManager.CMConnectionSetting" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/CallManager/Proc/CMConnectionSetting.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    $("#BtnListSearch").click();
                    return false;
                }
            });

            fnMoveToPage(1);
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
        }
    </script>

    <style>
        .list_wrap {display: flex; flex-direction: column; height:100%; min-height:500px; }
        .list_grid_wrap {flex-grow: 1; display: flex; flex-direction: row; }
        .grid_wrap {width:53%; margin-right: 5px;}
        .grid_wrap:last-child {width:47%;margin-right: 0px;}
        .grid_list {display: flex; flex-direction: column; height: calc(100% - 10px); margin-top:10px !important;}
        .grid_list div.form {margin: 10px 0; text-align:right; padding: 0 5px;}
        .grid_list div.grid {flex-grow: 1;}

        /* 커스텀 셀 스타일 */
	    .my-cell-style {background: #5674c8;}
        .my-cell-style div { font-weight: 600; color: #fff;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PhoneCenterCode" />
    <asp:HiddenField runat="server" ID="PhoneAuthSeqNo" />
    <div id="contents">
        <div class="list_wrap">
            <div class="data_list">
                <div class="search">
                    <div class="search_line">
                        <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                        &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                    </div>
                </div>
            </div>
            <div class="list_grid_wrap">
                <div class="grid_wrap">
                    <div class="grid_list">
                        <ul class="grid_option">
                            <li class="left">
                                <h1>관리계정정보</h1>
                                <strong id="GridResult1" style="display: inline-block; margin-left:10px; line-height:29px;"></strong>
                            </li>
                            <li class="right">
                            </li>
                        </ul>
                        <div class="form">
                            <asp:DropDownList runat="server" ID="ChannelType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="AuthID" class="type_01" AutoPostBack="false" placeholder="계정 아이디" Width="200"/>
                            <asp:TextBox runat="server" ID="AuthPwd" TextMode="password" class="type_01" AutoPostBack="false" placeholder="계정 비밀번호"/>
                            <button type="button" class="btn_01" id="BtnInsAuthInfo">등록</button>
                            <button type="button" class="btn_03" id="BtnDelAuthInfo">삭제</button>
                        </div>
                        <div class="grid">
                            <div id="CMConnectionAccountGrid"></div>
                        </div>
                    </div>
                </div>
                <div class="grid_wrap">
                    <div class="grid_list">
                        <ul class="grid_option">
                            <li class="left">
                                <h1>관리전화번호</h1>
                                <strong id="GridResult2" style="display: inline-block; margin-left:10px; line-height:29px;"></strong>
                            </li>
                            <li class="right">
                            </li>
                        </ul>
                        <div class="form">
                            <asp:DropDownList runat="server" ID="PhoneChannelType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                            <asp:TextBox runat="server" ID="PhoneAuthID" class="type_01" AutoPostBack="false" placeholder="계정 아이디" ReadOnly="true" Width="200"/>
                            <button type="button" class="btn_01" id="BtnPhoneListSearch">번호받기</button>
                            <button type="button" class="btn_01" id="BtnUpdAuthPhone">변경</button>
                        </div>
                        <div class="grid">
                            <div id="CMConnectionTelGrid"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>