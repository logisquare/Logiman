<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderDispatchCostIns.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchCostIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchCostIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".search_line > input[type=text]").on("keydown", function (event) {
                if (event.keyCode === 13) {
                    fnCheckPeriodAndSearch(event);
                    return false;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnCheckPeriodAndSearch(event);
                return false;
            });

            $("#ItemCode").on("change", function (event) {
                fnCheckPeriodAndSearch(event);
                return false;
            });
        });

        function fnReloadPageNotice(strMsg) {
            fnClosePopUpLayer();
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
            return false;
        }

        function fnCheckPeriodAndSearch(event) {
            if (!$("#CenterCode").val()) {
                fnDefaultAlertFocus("회원사를 선택해주세요.", "CenterCode", "warning");
                return false;
            }

            if (!$("#ItemCode").val()) {
                fnDefaultAlertFocus("비용항목 구분을 선택해주세요.", "ItemCode", "warning");
                return false;
            }

            fnMoveToPagePeriod(1, 60);
            return false;
        }
    </script>
    <style>
        form {height: auto;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="RecordCnt" />
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="HidDispatchType" />
    <asp:HiddenField runat="server" ID="HidCenterCode" />
    <asp:HiddenField runat="server" ID="HidOrderNo" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control">
                <div class="const_body">
                    <div class="left">
                        <h1>오더정보</h1>
                        <dl id="Info1">
                            <dt>기본정보</dt>
                            <dd class="default_info"></dd>
                        </dl>
                        <dl id="Info2">
                            <dt>체크사항</dt>
                            <dd class="check_info"></dd>
                        </dl>
                        <dl id="Info3">
                            <dt>오더비고</dt>
                            <dd class="order_note"></dd>
                        </dl>
                        <dl id="Info4">
                            <dt>청구처 특이사항</dt>
                            <dd class="client_note"></dd>
                        </dl>
                    </div>
                    <div class="right">
                        <h1>차량 비용등록</h1>
                        <div class="data_list">
                            <div class="search">
                                <div class="search_line">
                                    <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="false"></asp:DropDownList>
                                    <asp:DropDownList runat="server" ID="DateType" class="type_small" AutoPostBack="false"></asp:DropDownList>
                                    <asp:DropDownList runat="server" ID="DateChoice" class="type_small" AutoPostBack="false"></asp:DropDownList>
                                    <asp:TextBox runat="server" ID="DateFrom" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                                    <asp:TextBox runat="server" ID="DateTo" class="type_01 date" ReadOnly="true" AutoPostBack="false"/>
                                    <asp:TextBox runat="server" id="ViewOrderLocationCode" ToolTip="사업장" CssClass="type_01 SearchConditions" placeholder="사업장" readonly></asp:TextBox>
                                    <div id="DivOrderLocationCode" class="DivSearchConditions">
                                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                                        <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                                    </div>
                                    <asp:TextBox runat="server" id="ViewOrderItemCode" ToolTip="상품 구분" CssClass="type_01 SearchConditions" placeholder="상품 구분" readonly></asp:TextBox>
                                    <div id="DivOrderItemCode" class="DivSearchConditions">
                                        <a href="#" class="CloseSearchConditions" title="닫기"></a>
                                        <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                                    </div>
                                    <asp:TextBox runat="server" ID="ComName" class="type_small" AutoPostBack="false" placeholder="업체명"/>
                                    <asp:TextBox runat="server" ID="CarNo" class="type_small" AutoPostBack="false" placeholder="차량번호"/>
                                    <asp:DropDownList runat="server" ID="ItemCode" class="type_small" AutoPostBack="false"></asp:DropDownList>
                                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                                </div>
                            </div>
                            <div class="grid_list">
                                <ul class="grid_option">
                                    <li class="left">
                                    </li>
                                    <li class="right">
                                        <ul class="drop_btn" style="margin-left:10px;">
                                            <li>
                                                <dl>
                                                    <dt>항목 설정</dt>
                                                    <dd>
                                                        <asp:LinkButton runat="server" title="엑셀다운로드" href="javascript:fnGridExportAs(GridID, 'xlsx', '차량비용등록', '차량비용등록');">엑셀다운로드</asp:LinkButton>
                                                        <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchCostGrid');">항목관리</asp:LinkButton>
                                                        <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchCostGrid');">항목순서 초기화</asp:LinkButton>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                                <div id="OrderDispatchCostGrid"></div>
			                    <div id="page"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchCostGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchCostGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchCostGrid');">취소</button>
            </div>
        </div>
    </div>
    
    
    <div id="DivTransRateAmtRequest">
        <div>
            <h1>자동운임 수정요청</h1>
            <a href="#" onclick="fnCloseTransRateAmtRequest(); return false;" class="close_btn">x</a>
            <div class="req_grid_list" style="margin-top:30px;">
                <div id="OrderTransRateAmtRequestGrid"></div>
            </div>
        </div>
    </div>
</asp:Content>
