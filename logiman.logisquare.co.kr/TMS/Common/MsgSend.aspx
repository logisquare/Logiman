<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="MsgSend.aspx.cs" Inherits="TMS.Common.MsgSend" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Common/Proc/MsgSend.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            
        });

        function fnReloadPageNotice(strMsg) {
            fnDefaultAlert(strMsg, "info");
            $("#PageNo").val("1");
        }
       
    </script>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
	<asp:HiddenField runat="server" ID="OrderNo"/>
	<asp:HiddenField runat="server" ID="OrderType"/>
    <asp:HiddenField runat="server" ID="SndTelNo"/>
    <asp:HiddenField runat="server" ID="RcvTelNo"/>
    <div id="iframe_wrap">
        <div id="POPUP_VIEW">
            <div class="popup_control">
                <div class="sms_layer">
					<div class="sms_container">
						<div class="left">
						    <dl>
						        <dt>회원사 선택</dt>
						        <dd>
						            <asp:DropDownList runat="server" ID="CenterCode" class="type_01" AutoPostBack="False"></asp:DropDownList>
						        </dd>
						    </dl>
						    <dl>
								<dt>발신자 번호</dt>
								<dd>
								    <asp:DropDownList runat="server" ID="SmsSendCell" class="type_01" AutoPostBack="false" title="발신번호 선택" placeholder="발신번호 선택" Width="160"></asp:DropDownList>  
                                    <p style="color:#ff0000; font-size:12px; margin:5px 0 0 3px;">[C] : 콜매니저, [L] : 링크허브</p>
                                    <p style="color:#ff0000; font-size:12px; margin:5px 0 0 3px;">문자 전송전 링크허브(택스빌) 등록 발신번호인지 확인하셔야합니다.</p>
								</dd>
							</dl>
						    <dl>
                                <dt>수신자 선택</dt>
                                <dd>
                                    <asp:TextBox runat="server" class="type_01 ml_0 find" id="CarNo" name="CarNo" MaxLength="9" style="width:270px;" placeholder="차량번호 검색" title="차량번호 검색"></asp:TextBox>
                                </dd>
                                <dd>
                                    <span class="etc_type_reg">
                                        <asp:TextBox MaxLength="11" runat="server" CssClass="type_01 ml_0 OnlyNumber" ID="RcvCell" title="휴대폰 번호 직접 입력" placeholder="휴대폰 번호 직접 입력" onkeypress="if(event.keyCode==13) {fnCellAddIns(); return false;}"/>
                                        <button type="button" class="btn_02" onclick="fnCellAddIns();">추가</button>
                                    </span>
                                    <ul class="sms_list_layer_02" id="CellList"></ul>
                                </dd>
							</dl>
							<dl>
                                <dt><img src="/images/icon/bookmark_icon.png" alt="" style="vertical-align:middle; margin-bottom:2px;"> 즐겨찾기</dt>
                                <dt>
                                    <asp:TextBox runat="server" class="type_01 ml_0" id="SearchSmsTitle" MaxLength="50" style="width:200px;" placeholder="제목 검색" title="제목 검색"></asp:TextBox><button type="button" class="btn_02" style="width:70px;" onclick="fnGetSmsContentList();">검색</button>	
                                </dt>
                                <dd>
                                    <ul class="sms_list_layer_02" id="SmsContentList"></ul>
                                </dd>
							</dl>
						</div>
						<div class="right">
							<div class="phone_area">
								<div class="phone_item">
									<%=DateTime.Now.ToString("HH:mm")%>
								</div>
								<h1>SMS</h1>
								<table>
									<colgroup>
										<col style="width:100%;">
									</colgroup>
									<thead>
										<tr>
											<th>제목 : <asp:TextBox runat="server" ID="SmsTitle" class="text_150" style="border:0px;" title="제목입력" placeholder="제목입력" MaxLength="50"/></th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>내용작성</td>
										</tr>
										<tr>
											<td>
											    <asp:textbox id="SmsContents" TextMode="MultiLine" cols="30" rows="10" runat="server" placeholder="메시지 내용을 입력해주세요." title="메시지 내용을 입력해주세요  ." MaxLength="4000"/>    
											</td>
										</tr>
									</tbody>
								</table>
								<div style="text-align:center; padding-top:100px;"> 
									<button type="button" class="btn_01" onclick="fnSendSms();">전송</button>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<button type="button" class="btn_02 bookmark" onclick="fnSmsContentConfirm();">즐겨찾기 등록</button>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
        </div>
    </div>
</asp:Content>