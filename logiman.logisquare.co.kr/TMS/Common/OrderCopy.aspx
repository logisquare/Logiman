<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="OrderCopy.aspx.cs" Inherits="TMS.Common.OrderCopy" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/TMS/Common/Proc/OrderCopy.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            $("#ChkAll").on("change", function () {
                $("input:checkbox[id$=Flag]").prop("checked", $(this).is(":checked"));
            });

            $("input:checkbox[id$=Flag]").on("change", function () {
                $("#ChkAll").prop("checked", $("input[id$=Flag]:checked").length === $("input:checkbox[id$=Flag]").length);
            });

            $("#BtnInsOrderCopy").on("click", function () {
                fnInsOrderCopy();
                return;
            });

            $("#BtnCancelOrderCopy").on("click", function () {
                fnWindowClose();
                return;
            });
        });

        function fnWindowClose() {
            window.close();
        }
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="HidMode"/>
<asp:HiddenField runat="server" ID="HidErrMsg"/>
<asp:HiddenField runat="server" ID="OrderType"/>
<asp:HiddenField runat="server" ID="CenterCode"/>
<asp:HiddenField runat="server" ID="OrderNos"/>
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div id="registration_area">
				<div class="copy_layer">
					<h1>총 <strong class="title_cnt">1</strong>건의 오더를 선택하셨습니다.</h1>
					<div class="copy_01">
						<p>복사할 건수를 입력해 주세요.</p>
                        <asp:DropDownList runat="server" class="type_01" id="OrderCnt"/>
						<span>*1건의 오더를 선택한 경우에만 건수를 입력할 수 있습니다.</span>
					</div>
					<div class="copy_02">
						<p>
							상차일을 선택해주세요. (최대 50일)
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" id="selectDateAll" onchange="fnChkAllBizDay(this);"><label for="selectDateAll"><span></span> 영업일 전체 선택</label>
						</p>
						<ul id="UlCalandar">       
						</ul>
                        <span runat="server" id="SpanGetYMD">
						    <p>하차일을 선택해주세요.</p>
                            <asp:DropDownList runat="server" id="GetYMDType" class="type_01"/>
                        </span>
					</div>
					<div class="copy_02">
						<p>복사할 항목을 선택해주세요.<span runat="server" id="SpanHelp" style="width: 100%;"></span></p>
					    <asp:CheckBox runat="server" id="ChkAll"/><label for="ChkAll"><span></span> 전체</label>
                        <span runat="server" id="SpanNoteFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="NoteFlag"/><label for="NoteFlag"><span></span> 비고</label></span>
                        <span runat="server" id="SpanNoteClientFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="NoteClientFlag"/><label for="NoteClientFlag"><span></span> 고객전달사항</label></span>
                        <span runat="server" id="SpanDispatchFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="DispatchFlag"/><label for="DispatchFlag"><span></span> 배차차량</label></span>
                        <span runat="server" id="SpanGoodsFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="GoodsFlag"/><label for="GoodsFlag"><span></span> 화물</label></span>
                        <span runat="server" id="SpanArrivalReportFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="ArrivalReportFlag"/><label for="ArrivalReportFlag"><span></span> 도착보고</label></span>
                        <span runat="server" id="SpanCustomFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="CustomFlag"/><label for="CustomFlag"><span></span> 통관</label></span>
                        <span runat="server" id="SpanBondedFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="BondedFlag"/><label for="BondedFlag"><span></span> 보세</label></span>
                        <span runat="server" id="SpanInTimeFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="InTimeFlag"/><label for="InTimeFlag"><span></span> 시간엄수</label></span>
                        <span runat="server" id="SpanQuickGetFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="QuickGetFlag"/><label for="QuickGetFlag"><span></span> 하차긴급</label></span>
                        <span runat="server" id="SpanTaxChargeFlag" Visible="False">&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox runat="server" id="TaxChargeFlag"/><label for="TaxChargeFlag"><span></span> 계산서</label></span>
                        
                    </div>
				</div>
                <div style="text-align:center; margin-top: 20px; padding-bottom: 20px;">
					<button type="button" class="btn_01" id="BtnInsOrderCopy">등록</button>	
					&nbsp;&nbsp;
					<button type="button" class="btn_03" id="BtnCancelOrderCopy">취소</button>	
				</div>
			</div>
        </div>
    </div>
</asp:Content>
