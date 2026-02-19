<%@ Page Language="C#" EnableEventValidation="false" MasterPageFile="~/Popup.Master" AutoEventWireup="true" CodeBehind="UnipassDetailList.aspx.cs" Inherits="TMS.Unipass.UnipassDetailList" %>
<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script src="/TMS/Unipass/Proc/UnipassDetailList.js?var=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script>
        $(document).ready(function () {
            if ($("#SearchType").val() === "") {
                $("#SearchText").attr("readonly", true);
            }

            $("#SearchType").on("change", function () {
                if ($(this).val() === "") {
                    $("#SearchText").attr("readonly", true);
                    $("#SearchText").val("");
                } else {
                    $("#SearchText").attr("readonly", false);
                    $("#SearchText").focus();
                }

                if ($(this).val() !== "cargMtNo") {
                    $("#SearchYear").show();
                } else {
                    $("#SearchYear").hide();
                }
            });
        });
        function fnLocalCloseCpLayer() {
            parent.$("#cp_layer").css("left", "");
            parent.$("#cp_layer").toggle();
            parent.fnMoveToPage(1);
        }
    
    </script>
    <style>
        .my-cell-style-color { text-decoration: underline; cursor: pointer; color: #0000ff;}
        table.popup_table tr th { padding: 5px 10px; font-size: 12px;}
        table.popup_table tr td { padding: 5px 10px;}
        table.popup_table tr td span {font-size: 12px;}
    </style>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="PageNo" />
    <asp:HiddenField runat="server" ID="PageSize" />
    <asp:HiddenField runat="server" ID="HidMode" />
    <asp:HiddenField runat="server" ID="Hawb" />
    <asp:HiddenField runat="server" ID="BLNo" />
    <asp:HiddenField runat="server" ID="PickupYMD" />
    <asp:HiddenField runat="server" ID="HidcargMtNo" />
    <div id="iframe_wrap">
        <div runat="server" id="POPUP_VIEW">
            <div class="popup_control" style="padding-bottom: 30px;">
                <h1 class="title">화물통관 진행정보</h1>
                <div class="search">
                    <asp:DropDownList runat="server" ID="SearchType" class="type_01" AutoPostBack="false"></asp:DropDownList>
                    <asp:TextBox runat="server" ID="SearchText" class="type_01" AutoPostBack="false" placeholder="검색어"/>
                    <asp:DropDownList runat="server" ID="SearchYear" class="type_01" AutoPostBack="false" style="display: none;"></asp:DropDownList>
                    <button type="button" runat="server" ID="BtnListSearch" onclick="fnSearchData();" class="btn_01">조회</button>
                </div> 
                <table class="popup_table" style="margin-top:20px;">
                    <colgroup>
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                        <col style="width:120px"/> 
                        <col style="width:auto;"/> 
                    </colgroup>
                    <tr>
                        <th>화물관리번호</th>
                        <td>
                            <asp:Label runat="server" ID="cargMtNo"></asp:Label>
                        </td>
                        <th>진행상태</th>
                        <td>
                            <asp:Label runat="server" ID="prgsStts"></asp:Label>
                        </td>
                        <th>선사/항공사</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="shcoFlco"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>M B/L – H B/L</th>
                        <td>
                            <asp:Label runat="server" ID="mblNo"></asp:Label>
                            -
                            <asp:Label runat="server" ID="hblNo"></asp:Label>
                        </td>
                        <th>화물구분</th>
                        <td>
                            <asp:Label runat="server" ID="cargTp"></asp:Label>
                        </td>
                        <th>선박/항공편명</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="shipNm"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>통관진행상태</th>
                        <td>
                            <asp:Label runat="server" ID="csclPrgsStts"></asp:Label>
                        </td>
                        <th>처리일시</th>
                        <td>
                            <asp:Label runat="server" ID="prcsDttm"></asp:Label>
                        </td>
                        <th>선박국적</th>
                        <td>
                            <asp:Label runat="server" ID="shipNatNm"></asp:Label>
                        </td>
                        <th>선박대리점</th>
                        <td>
                            <asp:Label runat="server" ID="agnc"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>품명</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="prnm"></asp:Label>
                        </td>
                        <th>적재항</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="ldprCd"></asp:Label>,
                            <asp:Label runat="server" ID="ldprNm"></asp:Label>,
                            <asp:Label runat="server" ID="lodCntyCd"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>포장개수</th>
                        <td>
                            <asp:Label runat="server" ID="pckGcnt"></asp:Label>
                            <asp:Label runat="server" ID="pckUt"></asp:Label>
                        </td>
                        <th>총 중량</th>
                        <td>
                            <asp:Label runat="server" ID="ttwg"></asp:Label>
                            <asp:Label runat="server" ID="wghtUt"></asp:Label>
                        </td>
                        <th>양륙항</th>
                        <td>
                            <asp:Label runat="server" ID="dsprCd"></asp:Label>,
                            <asp:Label runat="server" ID="dsprNm"></asp:Label>
                        </td>
                        <th>입항세관</th>
                        <td>
                            <asp:Label runat="server" ID="etprCstm"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>용적</th>
                        <td>
                            <asp:Label runat="server" ID="msrm"></asp:Label>
                        </td>
                        <th>B/L유형</th>
                        <td>
                            <asp:Label runat="server" ID="blPtNm"></asp:Label>
                        </td>
                        <th>입항일</th>
                        <td>
                            <asp:Label runat="server" ID="etprDt"></asp:Label>
                        </td>
                        <th>항차</th>
                        <td>
                            <asp:Label runat="server" ID="vydf"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>관리대상검사여부</th>
                        <td>
                            <asp:Label runat="server" ID="mtTrgtCargYnNm"></asp:Label>
                        </td>
                        <th>컨테이너개수</th>
                        <td>
                            <asp:Label runat="server" ID="cntrGcnt"></asp:Label>
                        </td>
                        <th>반출의무과태료</th>
                        <td>
                            <asp:Label runat="server" ID="rlseDtyPridPassTpcd"></asp:Label>
                        </td>
                        <th>신고지연가산세</th>
                        <td>
                            <asp:Label runat="server" ID="dclrDelyAdtxYn"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th>특수화물코드</th>
                        <td>
                            <asp:Label runat="server" ID="spcnCargCd"></asp:Label>
                        </td>
                        <th>컨테이너번호</th>
                        <td>
                            <asp:Label runat="server" ID="cntrNo"></asp:Label>
                        </td>
                        <th>특송업체</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="frwrEntsConm"></asp:Label>
                        </td>
                    </tr>
                </table>
                <div style="text-align: right; padding-top: 20px;">
                    <button type="button" class="btn_01" id="ContainerBtn" style="display: none;" onclick="fnContainerList();">컨테이너 내역</button>
                    &nbsp;
                    <ul class="drop_btn" style="float:right;">
                        <li>
                            <dl>
                                <dt>항목 설정</dt>
                                <dd>
                                    <asp:LinkButton runat="server" title="항목관리" href="javascript:fnGridColumnManage('UnipassListGrid');">항목관리</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 저장" href="javascript:fnSaveColumnCustomLayout('UnipassListGrid');">항목순서 저장</asp:LinkButton>
                                    <asp:LinkButton runat="server" title="항목순서 초기화" href="javascript:fnResetColumnLayout('UnipassListGrid');">항목순서 초기화</asp:LinkButton>
                                </dd>
                            </dl>
                        </li>
                    </ul>
                </div>
                <div class="grid_list">
                    <div id="UnipassListGrid"></div>
                </div>
            </div>
        </div>
    </div>
    <!--그리드 칼럼관리 팝업-->
    <div id="GRID_COLUMN_LAYER">
        <div class="grid_manage">
            <h1><input id="AllGridColumnCheck" type="checkbox" onclick="fnColumnChkAll('UnipassListGrid');" /><label for="AllGridColumnCheck"><span></span></label> 항목관리</h1>
            <div id="GridColumn"></div>
            <div class="gird_button">
                <button type="button" class="save" onclick="fnSaveColumnCustomLayout('UnipassListGrid');">저장</button>
                &nbsp;&nbsp;
                <button type="button" class="cancel" onclick="fnCloseColumnLayout('UnipassListGrid');">취소</button>
            </div>
        </div>
    </div>
</asp:Content>
