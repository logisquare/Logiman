<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemList.aspx.cs" Inherits="SSO.Item.ItemList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/SSO/Item/Proc/ItemList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#GroupCode").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#GroupName").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCallGridData(GridID);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCallGridData(GridID);
                return;
            });

            $("#BtnSave").on("click", function () {
                fnItemCenterIns();
                return;
            });

            $("#BtnMakeItemJson").on("click", function () {
                fnMakeItemJson();
                return;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
        }

        function fnClosePopUpLayer() {
            fnCloseCpLayer();
            fnCallGridItemListData(GridItemListID);
        }

    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="hidGroupCode" />
    <asp:HiddenField runat="server" ID="hidItemFullCode" />

    <div id="contents">
        <div class="data_list">
            <div class="search">
                <div class="search_line">
                    <asp:TextBox runat="server" ID="GroupCode" class="type_01" AutoPostBack="false" placeholder="그룹코드"/>
                    <asp:TextBox runat="server" ID="GroupName" class="type_01" AutoPostBack="false" placeholder="그룹명"/>
                    &nbsp;&nbsp;<button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
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
                <li style="width: 40%; float: left; text-align: left;">
                    <h1>항목</h1>&nbsp;
                    <strong id="GridResult2" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo2" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                </li>
                <li style="width: 30%; float: left; text-align: left;">
                    <h1>회원사</h1>&nbsp;
                    <strong id="GridResult3" style="display: inline-block;"></strong>
                    <strong id="GridDataInfo3" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                    <span style="float: right;">
                        <button type="button" runat="server" ID="BtnSave" class="btn_01">저장</button>
                    </span>
                </li>
            </ul>
            <div style="position: relative; width: 100%;">
                <div style="width: 30%; float: left;">
                    <div id="ItemGroupListGrid"></div>
                </div>
                <div style="width: 40%; float: left;">
                    <div id="ItemListGrid"></div>
                </div>
                <div style="width: 30%; float: left;">
                    <div id="ItemCenterListGrid"></div>
                </div>
            </div>
			<div id="page" style="clear: both;"></div>
        </div>
	</div>
</asp:Content>
