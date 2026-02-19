<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderDispatchArrivalIns.aspx.cs" Inherits="TMS.Dispatch.OrderDispatchArrivalIns" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Dispatch/Proc/OrderDispatchArrivalIns.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#BtnListSearch").on("click", function () {
                fnMoveToPagePeriod(1, 60);
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
    <asp:HiddenField runat="server" ID="HidMode" />
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
                        <h1>도착보고 비용등록</h1>
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
                                    <asp:TextBox runat="server" ID="ClientName" class="type_small" AutoPostBack="false" placeholder="업체명"/>
                                    <button type="button" runat="server" ID="BtnListSearch" class="btn_01">검색</button>
                                </div>
                                <div>
                                    
                                </div>
                            </div>  

                            <div class="search_line" style="margin-top:10px;">
                                <asp:TextBox runat="server" ID="SupplyAmt" CssClass="type_01 Money" placeholder="비용입력"></asp:TextBox>
                                &nbsp;
                                <asp:TextBox runat="server" ID="TaxAmt" CssClass="type_01 Money" placeholder="부가세입력"></asp:TextBox>
                                &nbsp;
                                <button type="button" class="btn_02" onclick="fnArrivalPayInsConfirm(1);">비용등록</button>
                                &nbsp;
                                <button type="button" class="btn_03" onclick="fnArrivalPayInsConfirm(2);">비용삭제</button>
                                <ul class="drop_btn" style="margin-left:20px;">
						            <li>
							            <dl>
								            <dt>항목 설정</dt>
								            <dd>
									            <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('OrderDispatchArrivalCostGrid');">항목관리</asp:LinkButton>
									            <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('OrderDispatchArrivalCostGrid');">항목순서 초기화</asp:LinkButton>
								            </dd>
							            </dl>
						            </li>
					            </ul>
                            </div>

                            <div class="grid_list">
                                <div id="OrderDispatchArrivalCostGrid"></div>
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
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('OrderDispatchArrivalCostGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('OrderDispatchArrivalCostGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('OrderDispatchArrivalCostGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
