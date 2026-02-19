<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CarDispatchCooperatorList.aspx.cs" Inherits="TMS.Car.CarDispatchCooperatorList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Car/Proc/CarDispatchCooperatorList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ListSearch").on("keydown", function(event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
       
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="data_list">
                    <div class="search">
                        <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                        <asp:DropDownList runat="server" ID="UseFlag" class="type_01" AutoPostBack="false" style="display:none;"></asp:DropDownList>
                        <asp:TextBox runat="server" ID="ComName" class="type_01" AutoPostBack="false" placeholder="업체명"/>
                        <button type="button" runat="server" ID="BtnListSearch" class="btn_01">조회</button>
                    </div>  
                </div>
                <div class="grid_list">
                    <ul class="grid_option">
                        <li class="left">
                            <strong id="GridResult" style="display: inline-block;"></strong>
                            <strong id="GridDataInfo" style=" line-height: 25px; font-weight: 500; color: #666666; "></strong>
                        </li>
                        <li class="right">
                            <ul class="drop_btn" style="float:right;">
						        <li>
							        <dl>
								        <dt>항목 설정</dt>
								        <dd>
                                            <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '협력업체등록현황', '협력업체등록현황');">엑셀다운로드</asp:LinkButton>
									        <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('CarDispatchCooperatorListGrid');">항목관리</asp:LinkButton>
									        <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('CarDispatchCooperatorListGrid');">항목순서 초기화</asp:LinkButton>
								        </dd>
							        </dl>
						        </li>
					        </ul>
                        </li>
                    </ul>

                    <div id="CarDispatchCooperatorListGrid"></div>
			        <div id="page"></div>
                </div>
            </div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('CarDispatchCooperatorListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('CarDispatchCooperatorListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('CarDispatchCooperatorListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
