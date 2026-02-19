<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemAdminList.aspx.cs" Inherits="SSO.Item.ItemAdminList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Item/Proc/ItemAdminList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnSave").on("click", function () {
                fnItemAdminIns();
                return;
            });

            $("#BtnMakeItemJson").on("click", function () {
                fnMakeItemJson();
                return;
            });
        });
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="hidGroupCode" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnMakeItemJson" class="btn_01">항목적용</button>
                </div>
            </div>  
        </div>
        <div class="grid_list">
            <ul class="grid_option">
                <li style="width: 30%; float: left; text-align: left;">
                    <h1>항목 그룹</h1>&nbsp;
                    <strong id="GridResult" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li style="width: 70%; float: left; text-align: left;">
                    <h1>즐겨찾기 항목</h1>&nbsp;
                    <strong id="GridResult2" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    <span style="float: right;">
                        <button type="button" runat="server" ID="BtnSave" class="btn_01">저장</button>
                    </span>
                </li>
            </ul>
            <div style="position: relative; width: 100%;">
                <div style="width: 30%; float: left;">
                    <div id="ItemGroupListGrid"></div>
                </div>
                <div style="width: 70%; float: left;">
                    <div id="ItemAdminListGrid"></div>
                </div>
            </div>
			<div id="page" style="clear: both;"></div>
        </div>
	</div>
</asp:Content>
