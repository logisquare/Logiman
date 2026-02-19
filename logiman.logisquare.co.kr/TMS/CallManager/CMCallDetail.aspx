<%@ Page Language="C#" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="CMCallDetail.aspx.cs" Inherits="TMS.CallManager.CMCallDetail" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/CallManager/Proc/CMCallDetail.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <style>
    	.exception {margin:0 !important;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="CMJsonParam"/>
	<div id="wrap">
		<div id="container">
			<!-- board_container -->
			<div class="board_container">
				<!-- cont_lnb -->
				<div class="cont_lnb">
					<!-- info_con -->
					<div class="info_con">
                        <div class="more">
							<ul>
                                <li class=""></li>
                                <li class="class2" onclick="fnChangeClassType(2); return false;"></li>
                                <li class="class3" onclick="fnChangeClassType(3); return false;"></li>
                                <li class="class4" onclick="fnChangeClassType(4); return false;"></li>
                                <li class="class5" onclick="fnChangeClassType(5); return false;"></li>
                                <li class="class6" onclick="fnChangeClassType(6); return false;"></li>
                                <li class="class7" onclick="fnChangeClassType(7); return false;"></li>
                            </ul>
                        </div>
						<div class="info_tit">
							<h6></h6>
						</div>
						<div class="info_group">
							<span class="ojspan"></span>
							<p></p>
						</div>
						<div class="info_btn">
							<a href="#" onclick="fnCallToCaller(); return false;" class="icon_call">전화</a>
							<a href="#" onclick="fnSmsToCaller(); return false;" class="icon_mms">문자</a>
							<a href="#" onclick="fnOpenLastLocation(); return false;" class="icon_local">위치</a>
						</div>
					</div>
					<!-- //info_con -->
					<!-- lnb_card -->
					<div class="lnb_card">
                        <div id="DivCardRefresh" runat="server" class="btn_reflash">
                            <a href="#" onclick="fnCallInfo(); return false;">다시 조회하기</a>
                        </div>
						<div id="DivCardList" runat="server" class="inner_scroll">
						</div>
					</div>
					<!-- //lnb_card -->
						
                    <div class="memo_chck">
                        <select class="select" id="CMAdminPhoneList" style="display:none;"></select>
                    </div>
				</div>
				<!-- //cont_lnb -->
				<!-- content -->
				<div class="content">
					<!-- DivAreaType01 Start -->
					<div id="DivAreaType01" runat="server" class="content_inner">
						<!-- -->
						<div class="section_inner">
							<div class="cont_tit">
								<div>메시지 전송 내역</div>
								<a href="#" title="메시지전송내역" onclick="fnGoMenuNewTab(event, 2); return false;" class="memu_more">메시지전송내역 메뉴 바로가기</a>
                                <a href="#" title="콜수발신내역" onclick="fnGoMenuNewTab(event, 1); return false;" class="memu_more">콜수발신내역 메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
										<colgroup>
                                            <col width="8%" />
                                            <col width="12%"/>
                                            <col width="16%">
                                            <col width=""/>
										</colgroup>
										<thead>
											<tr>
												<th>알림유형</th>
												<th class="check">발신번호</th>
												<th>발송일시</th>
												<th>본문</th>
											</tr>
										</thead>
										<tbody id="TbodyMessageSendLogList"></tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner mt32 only_car">
							<div class="cont_tit">
								<div>차량업체 - 기사 비고</div>
								<a href="#" onclick="fnEditInfo(event, 'Car'); return false;" class="memu_mody">조회/수정하기</a>
							</div>
							<div class="cont_box">
								<div class="nodata" id="RefNote"></div>
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner mt32">
							<div class="cont_tit">
								<div>오더현황</div>
								<a href="#" title="내수오더현황" onclick="fnGoMenuNewTab(event, 3); return false;" class="memu_more">내수 메뉴 바로가기</a>
                                <a href="#" title="수출입오더현황" onclick="fnGoMenuNewTab(event, 4); return false;" class="memu_more">수출입 메뉴 바로가기</a>
                                <a href="#" title="배차현황" onclick="fnGoMenuNewTab(event, 6); return false;" class="memu_more">배차현황 메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
										<colgroup>
											<col width="10%">
                                            <col width="">
                                            <col width="8%">
                                            <col width="">
                                            <col width="">
                                            <col width="10%" class="carinfo">
                                            <col width="8%">
                                            <col width="8%">
                                            <col width="8%">
                                            <col width="8%">
											<col width="64px">
										</colgroup>
										<thead>
											<tr>
												<th class="check">오더번호<br/>구분 / 상태 / 상품</th>
                                                <th>발주처<br/>화주</th>
                                                <th class="check">발주처담당자</th>
                                                <th>상차지명</th>
												<th>하차지명</th>
                                                <th class="carinfo">차량정보</th>
												<th>매입</th>
                                                <th class="check">접수자</th>
                                                <th class="check">최종수정자</th>
                                                <th class="check">배차자</th>
												<th>오더 전송</th>
											</tr>
										</thead>
										<tbody id="TbodyOrderDispatchList"></tbody>
									</table>
								</div>								
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner mt32">
							<div class="cont_tit">
								<div>매입마감현황</div>
								<a href="#" title="매입마감현황" onclick="fnGoMenuNewTab(event, 8); return false;" class="memu_more">메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
										<colgroup>
                                            <col width="8%">
                                            <col width="16%">
                                            <col width="17%">
                                            <col width="14%">
                                            <col width="6%">
                                            <col width="6%">
                                            <col width="8%">
                                            <col />
                                            <col width="8%">
										</colgroup>
										<thead>
											<tr>
												<th class="check">전표번호</th>
												<th>결제방식 / 송금상태</th>
												<th>마감 / 예정 / 입금</th>
                                                <th>공급가액 / 부가세</th>
                                                <th>공제금액</th>
                                                <th>산재보험료</th>
                                                <th>송금(예정)금액</th>
												<th>송금은행 / 계좌번호 / 예금주</th>
												<th class="check">마감자</th>
											</tr>
										</thead>
                                        <tbody id="TbodyOrderPurchaseClosingList"></tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- // -->
					
                        <!-- -->
                        <div class="section_inner mt32 only_company">
                            <div class="cont_tit">
                                <div>차량현황</div>
                                <a href="#" title="차량현황" onclick="fnGoMenuNewTab(event, 10); return false;" class="memu_more">메뉴 바로가기</a>
                            </div>
                            <div class="cont_box">
                                <div class="list_table">
                                    <table>
                                        <colgroup>
                                            <col width="12%">
                                            <col width="14%">
                                            <col width="16%">
                                            <col width="12%">
                                            <col width="18%">
                                            <col width="">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th>차량구분</th>
                                                <th class="check">차량번호</th>
                                                <th>차종</th>
                                                <th>톤수</th>
                                                <th>기사명</th>
                                                <th class="check">휴대폰</th>
                                            </tr>
                                        </thead>
                                        <tbody id="TbodyCarDispatchRefList"></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- // -->
					</div>
					<!-- DivAreaType01 End // -->
                
					<!-- DivAreaType02 Start -->
					<div id="DivAreaType02" runat="server" class="content_inner">
						<!-- -->
						<div class="section_inner only_client">
							<div class="cont_tit">
								<div>고객사 비고</div>
								<a href="#" onclick="fnEditInfo(event, 'Client'); return false;" class="memu_mody">조회/수정하기</a>
							</div>
							<div class="cont_box">
								<div class="nodata">
                                    <p id="PClientNote1"></p>
                                    <p id="PClientNote2"></p>
                                    <p id="PClientNote3"></p>
                                    <p id="PClientNote4"></p>
                                </div>
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner only_place">
							<div class="cont_tit">
								<div>오더현황</div>
                                <a href="#" title="내수오더현황" onclick="fnGoMenuNewTab(event, 3); return false;" class="memu_more">내수 메뉴 바로가기</a>
                                <a href="#" title="수출입오더현황" onclick="fnGoMenuNewTab(event, 4); return false;" class="memu_more">수출입 메뉴 바로가기</a>
                                <a href="#" title="배차현황" onclick="fnGoMenuNewTab(event, 6); return false;" class="memu_more">배차현황 메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
                                        <colgroup>
                                            <col width="10%">
                                            <col width="">
                                            <col width="8%">
                                            <col width="">
                                            <col width="">
                                            <col width="10%">
                                            <col width="10%">
                                            <col width="8%">
                                            <col width="8%">
                                            <col width="64px">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th class="check">오더번호<br/>상태 / 상품 / 사업장</th>
                                            <th>발주처<br/>청구처<br/>화주</th>
                                            <th class="check">발주처담당자</th>
                                            <th>상차지명</th>
                                            <th>하차지명</th>
                                            <th class="check">직송/집하</th>
                                            <th class="check">간선</th>
                                            <th class="check">접수자</th>
                                            <th class="check">최종수정자</th>
                                            <th>배차정보<br/>전송</th>
                                        </tr>
                                        </thead>
                                        <tbody id="TbodyOrderListForPlace"></tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner mt32 only_client">
							<div class="cont_tit">
								<div>오더현황</div>
                                <a href="#" title="내수오더현황" onclick="fnGoMenuNewTab(event, 3); return false;" class="memu_more">내수 메뉴 바로가기</a>
                                <a href="#" title="수출입오더현황" onclick="fnGoMenuNewTab(event, 4); return false;" class="memu_more">수출입 메뉴 바로가기</a>
                                <a href="#" title="배차현황" onclick="fnGoMenuNewTab(event, 6); return false;" class="memu_more">배차현황 메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
                                        <colgroup>
                                            <col width="10%">
                                            <col width="">
                                            <col width="8%">
                                            <col width="">
                                            <col width="">
                                            <col width="8%">
                                            <col width="10%">
                                            <col width="10%">
                                            <col width="8%">
                                            <col width="8%">
                                            <col width="64px">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th class="check">오더번호<br/>상태 / 상품 / 사업장</th>
                                            <th>발주처<br/>청구처<br/>화주</th>
                                            <th class="check">발주처담당자</th>
                                            <th>상차지명</th>
                                            <th>하차지명</th>
                                            <th>매출</th>
                                            <th class="check">직송/집하</th>
                                            <th class="check">간선</th>
                                            <th class="check">접수자</th>
                                            <th class="check">최종수정자</th>
                                            <th>배차정보<br/>전송</th>
                                        </tr>
                                        </thead>
										<tbody id="TbodyOrderListForClient"></tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- // -->
						<!-- -->
						<div class="section_inner mt32 only_client">
							<div class="cont_tit">
								<div>매출마감현황</div>
                                <a href="#" title="매출마감현황" onclick="fnGoMenuNewTab(event, 7); return false;" class="memu_more">메뉴 바로가기</a>
							</div>
							<div class="cont_box">
								<div class="list_table">
									<table>
										<colgroup>
											<col width="8%">
                                            <col width="">
                                            <col width="">
                                            <col width="">
											<col width="8%">
                                            <col width="8%">
                                            <col width="">
											<col width="10%">
                                            <col width="8%">
										</colgroup>
										<thead>
											<tr>
												<th class="check">전표번호</th>
                                                <th>청구방식 / 발행구분 / 발행상태</th>
                                                <th>작성일 / 발행일</th>
                                                <th>계산서수취이메일</th>
												<th>공급가액</th>
												<th>부가세</th>
                                                <th>업무담당</th>
                                                <th>메모</th>
												<th class="check">마감자</th>
											</tr>
										</thead>
										<tbody id="TbodyOrderSaleClosingList"></tbody>
									</table>
								</div>
							</div>
						</div>
                        
                        <div class="section_inner mt32 only_client" id="DivClientClosing">
                            <div class="cont_tit">
                                <div>업체매입마감</div>
                                <a href="#" title="업체매입마감" onclick="fnGoMenuNewTab(event, 11); return false;" class="memu_more">메뉴 바로가기</a>
                            </div>
                        </div>
						<!-- // -->
					</div>
					<!-- DivAreaType02 End // -->
                
					<!-- DivAreaType03 Start -->
					<div id="DivAreaType03" runat="server" class="content_inner" style="background: url(/images/main_img_01.png) no-repeat bottom; height:100%;">
					</div>
					<!-- DivAreaType03 End // -->
                
					<!-- DivAreaType04 Start -->
					<div id="DivAreaType04" runat="server" class="content_inner" style=" height:100%;">
                        <div class="data_not">
                            <div class="info_data">
                                <div class="data_secter">
                                    <div class="se_tit">차량 정보</div>
                                    <div class="se_btn">
                                        <a href="#" title="차량조회" onclick="fnGoMenuNewTab(event, 10); return false;">
                                            <span>차량 조회하기</span>
                                            <span>
                                                등록된 차량 목록을 확인하고,<br>
                                                운행 이력 및 관련 정보를 신속하게<br>
                                                조회할 수 있습니다.
                                            </span>
                                        </a>
                                        <a href="#" onclick="fnEditInfo(event, 'Car', '0'); return false;">
                                            <span>차량 등록하기</span>
                                            <span>
                                                운송관리 시스템에 차량을<br>
                                                등록하면 데이터 기반으로 효율적인<br>
                                                차량 운용이 가능합니다.
                                            </span>
                                        </a>
                                    </div>
                                </div>
                                <div class="data_secter user mt40">
                                    <div class="se_tit">고객사정보</div>
                                    <div class="se_btn">
                                        <a href="#" title="고객사조회" onclick="fnGoMenuNewTab(event, 9); return false;">
                                            <span>고객사 조회하기</span>
                                            <span>
                                                시스템에 등록된<br>
                                                고객사 목록과 상세 정보를 빠르게<br>
                                                조회할 수 있습니다.
                                            </span>
                                        </a>
                                        <a href="#" onclick="fnEditInfo(event, 'Client', '0'); return false;">
                                            <span>고객사 등록하기</span>
                                            <span>
                                                고객사 등록을 통해<br>
                                                보다 정확한 운송 및 거래 관리를<br>
                                                할 수 있습니다.
                                            </span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
					</div>
					<!-- DivAreaType04 End // -->

				</div>
				<!-- //content -->
				<!-- cont_memo -->
				<div class="cont_memo">
					<!-- memo_head -->
					<div class="memo_head">
						<div><span>MEMO</span></div>
						<a href="#" title="메모내역" onclick="fnGoMenuNewTab(event, 12); return false"></a>
					</div>
					<!-- //memo_head -->
					<!-- memo_list -->
					<div class="memo_list">
                        <asp:HiddenField runat="server" ID="CallTotalCnt"/>
                        <asp:HiddenField runat="server" ID="CallPageSize" Value="20"/>
                        <asp:HiddenField runat="server" ID="CallPageNo" Value="1"/>
						<div class="memo_scroll" id="DivCallList"></div>
					</div>
					<!-- //memo_list -->
					<!-- memo_input -->
					<div class="memo_input">
						<div class="memo_chck">
							<div class="section_chk">
								<span class="check_agree">
									<input type="checkbox" id="ChkCallViewFlag" checked="checked"/>
									<label for="ChkCallViewFlag">수발신 내역 표시</label>											
								</span>							
							</div>
						</div>
						<div class="memo_txt">
							<textarea rows="" cols="" id="CompanyMemo" placeholder="메모를 입력하세요"></textarea>
							<a href="#" onclick="fnSetInsMemo(); return false;">등록</a>
						</div>
					</div>
					<!-- //memo_input -->
				</div>
				<!-- //cont_memo -->
			</div>
			<!-- //board_container -->
		</div>
	</div>

	
</asp:Content>
        
<asp:Content ID="Content1" ContentPlaceHolderID="SubContent" runat="server">
<script type="text/javascript">
    function fnOpenRightSubLayer(title, url, popWidth, popHeight, layerWidth) {       // layerWidth : 값 미지정시, 디펄트는 50%
        $("#iframePopupLoading").show();
        $("#hid_LAYER_TITLE").val(title);
        $("#hid_LAYER_WIDTH").val(popWidth);
        $("#hid_LAYER_HEIGHT").val(popHeight);
        if (layerWidth !== "") {
            $("#cp_layer").css("width", layerWidth);
        }

        $("#lbl_LAYER_TITLE").html($("#hid_LAYER_TITLE").val());

        if (url.split('?').length > 1) {
            $("#hid_LAYER_URL").val(url + "&title=" + encodeURI(title));
        }
        else {
            $("#hid_LAYER_URL").val(url + "?title=" + encodeURI(title));
        }

        var $form = null;
        if ($("form[name=layerIframeForm]").length > 0) {
            $form = $("form[name=layerIframeForm]");
            $form.remove();
            $form = null;
        }
        //$("div.popup_loading").show();
        $form = $("<form name='layerIframeForm'></form>");
        $form.attr("action", $("#hid_LAYER_URL").val());
        $form.attr("method", "post");
        $form.attr("target", "ifrm_layer");

        var formData = $("#mainform").serializeObject();
        $form.addHidden(formData);

        $form.appendTo("body");
        $form.submit();
        $form.remove();

        fnOpenCpLayer();
    }

    $(function () {
        $('#ifrm_layer').on("load", function () {
            $("#iframePopupLoading").hide();
        });
    });
</script>

<asp:HiddenField runat="server" ID="hid_LAYER_TITLE" Value="로지스퀘어 매니저" />
<asp:HiddenField runat="server" ID="hid_LAYER_WIDTH" Value="" />
<asp:HiddenField runat="server" ID="hid_LAYER_HEIGHT" Value="" />
<asp:HiddenField runat="server" ID="hid_LAYER_URL" Value="Default.html" />
<!--우측상세 레이어 시작-->
<div id="cp_layer">
    <div class="cp_layer_top">
        <h1><asp:Label runat="server" ID="lbl_LAYER_TITLE" style="font-size:18px;font-weight:400"></asp:Label></h1>
        <ul class="cp_layer_controll">
            <li id="cp_layer_smallLayer" style="display:none"><a href="javascript:fnSmallLayer();" title="기본화면"></a></li>
            <li id="cp_layer_bigLayer"><a href="javascript:fnBigLayer();" title="최대화면"></a></li>
            <li><a href="javascript:fnCloseCpLayer();" title="닫기"></a></li>
        </ul>
    </div>
    <div class="cp_layer_body">
        <iframe src="" id="ifrm_layer" name="ifrm_layer" scrolling="no" frameborder="0"></iframe>
        <div id="iframePopupLoading"><img src="/images/common/loader.gif" alt="Loading..." /></div>
    </div>
</div>
<!--우측상세 레이어 끝-->
</asp:Content>
