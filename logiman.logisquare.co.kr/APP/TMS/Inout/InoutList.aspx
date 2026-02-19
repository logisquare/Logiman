<%@ Page Language="C#" MasterPageFile="~/APP/MasterPage/AppSite.Master" AutoEventWireup="true" CodeBehind="InoutList.aspx.cs" Inherits="APP.TMS.Inout.InoutList" %>

<asp:Content ID="Scriptcontent" ContentPlaceHolderID="headscript" Runat="Server">
    <script type="text/javascript" src="/APP/TMS/Inout/Proc/InoutList.js?ver=<%=DateTime.Now.ToString("yyyyMMddHHmmss")%>"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#SearchClientText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#SearchPlaceText").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#ComCorpNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#CarNo").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#DriverName").on("keyup", function (event) {
                if (event.keyCode === 13) {
                    fnMoveToPage(1);
                    return;
                }
            });

            $("#BtnListSearch").on("click", function () {
                fnMoveToPage(1);
                return;
            });

            $("#ChkMyOrder").click(function () {
                ChkMyOrderFlag("N");
            });
        });

        function ChkMyOrderFlag(strResetflag) {
            if ($("#HidMyOrderFlag").val() == "Y") {
                $("#ChkMyOrder").prop("checked", true);
                if (strResetflag != "Y") {
                    fnDefaultAlert("접속하신 아이디는 내오더만 조회하실 수 있습니다.");
                }
                return false;
            }
            else {
                if (strResetflag == "Y") {
                    $("#ChkMyOrder").prop("checked", false);
                }
                return false;
            }
        }

    </script>
</asp:Content>

<asp:Content ID="Header" ContentPlaceHolderID="HeaderContent" runat="server">
    <div class="header">
        <h1>수출입 오더현황</h1>
        <button type="button" onclick="fnDataIns();">오더등록</button>
    </div>
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<asp:HiddenField runat="server" ID="RecordCnt" />
<asp:HiddenField runat="server" ID="TotalPageCnt" />
<asp:HiddenField runat="server" ID="PageNo" />
<asp:HiddenField runat="server" ID="PageSize" />
<asp:HiddenField runat="server" ID="SortType"/>
<asp:HiddenField runat="server" ID="HidMyOrderFlag" />
<!--백버튼에 필요한 값-->
<asp:HiddenField runat="server" ID="HidParam"/>
<asp:HiddenField runat="server" ID="HidCallType"/>
<asp:HiddenField runat="server" ID="HidLocationCode"/>
<asp:HiddenField runat="server" ID="HidOrderItemCode"/>
<asp:HiddenField runat="server" ID="HidDateSel"/>
    <div id="DataList">
        <!--검색영역 시작-->
        <div class="search_body">
            <div class="search_area">
                <ul class="ul_type_02">
                    <li>
                        <asp:DropDownList runat="server" ID="CenterCode"></asp:DropDownList>
                    </li>
                    <li>
                        <asp:DropDownList runat="server" ID="DateType"></asp:DropDownList>
                    </li>
                </ul>
                <ul id="DateChoice" class="ul_type_chk_03">
                    <li onclick="fnDateChoice(1);" class="check">오늘</li>
                    <li onclick="fnDateChoice(2);">내일</li>
                    <li onclick="fnDateChoice(3);">날짜</li>
                </ul>
                <table id="DateTable" class="tb_type_date" style="display:none;">
                    <tr>
                        <td><asp:TextBox TextMode="Date" runat="server" ID="DateYMD"></asp:TextBox></td>
                    </tr>
                </table>
                <ul class="ul_type_01">
                    <li>
                        <asp:TextBox runat="server" CssClass="type_plus" ID="ViewOrderLocationCode" ReadOnly="true" placeholder="사업장 선택하기"></asp:TextBox>
                    </li>
                </ul>
                <ul class="ul_type_01">
                    <li>
                        <asp:TextBox runat="server" CssClass="type_plus" ID="ViewOrderItemCode" ReadOnly="true" placeholder="상품 선택하기"></asp:TextBox>
                    </li>
                </ul>
                <ul class="ul_type_chk_multi">
                    <li>
                        <asp:CheckBox runat="server" id="ChkMyCharge" Text="내담당<span></span>"/>
                    </li>
                    <li>
                        <asp:CheckBox runat="server" id="ChkMyOrder" Text="내오더<span></span>"/>
                    </li>
                    <li>
                        <asp:CheckBox runat="server" id="ChkCnl" Text="취소오더<span></span>"/>
                    </li>
                </ul>
                <table class="tb_type_date">
                    <colgroup>
                        <col style="width:39%"/>
                        <col style="width:2%"/>
                        <col style="width:59%"/>
                    </colgroup>
                    <tr>
                        <td><asp:DropDownList runat="server" CssClass="type_01" ID="SearchClientType"></asp:DropDownList></td>
                        <td></td>
                        <td><asp:TextBox runat="server" ID="SearchClientText" placeholder="검색어를 입력하세요."></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td><asp:DropDownList runat="server" CssClass="type_01" ID="SearchPlaceType"></asp:DropDownList></td>
                        <td></td>
                        <td><asp:TextBox runat="server" ID="SearchPlaceText" placeholder="검색어를 입력하세요."></asp:TextBox></td>
                    </tr>
                </table>
                <ul class="ul_type_01">
                    <li>
                        <asp:TextBox runat="server" CssClass="type_01" ID="ComCorpNo" placeholder="차량사업자번호" MaxLength ="10"></asp:TextBox>
                    </li>
                </ul>
                <ul class="ul_type_02">
                    <li>
                        <asp:TextBox runat="server" CssClass="type_01" ID="CarNo" placeholder="차량번호" MaxLength ="9"></asp:TextBox>
                    </li>
                    <li>
                        <asp:TextBox runat="server" CssClass="type_01" ID="DriverName" placeholder="기사명"></asp:TextBox>
                    </li>
                </ul>
                <ul class="ul_type_01">
                    <li>
                        <button type="button" runat="server" ID="BtnListSearch" class="search_btn">검색</button>
                    </li>
                </ul>
            </div>
            <div class="search_up">
                <button type="button" class="search_up" onclick="fnSlideSearch();"></button>
            </div>
        </div>
        <!--검색영역 끝-->
        
        <!--리스트 영역 시작-->
        <div class="list_area">
            <p class="list_count">총 <asp:Label runat="server" ID="TotalCount">0</asp:Label> 건</p>
            <ul class="domestic">
            </ul>
            <div class="more_list">
                <button type="button" onclick="fnCallDataMore(); return false;">더보기</button>
            </div>
        </div>
        <!--리스트 영역 끝-->
    </div>

    <!--사업장 선택 팝업 시작-->
    <div id="OrderLocationMulti" class="DivSearchConditions">
        <div class="location_area">
            <dl>
                <dt>
                    <strong>사업장 선택 <span>(다중선택가능)</span></strong>
                    <button type="button" onclick="fnLocationView();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd class="DDSearchConditions">
                    <asp:CheckBoxList runat="server" ID="OrderLocationCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                </dd>
            </dl>
            <button type="button" class="confirm_btn" onclick="fnLocationView();">확인</button>
        </div>
    </div>
    <!--사업장 선택 팝업 끝-->

    <!--상품 선택 팝업 시작-->
    <div id="OrderItemMulti" class="DivSearchConditions">
        <div class="item_area">
            <dl>
                <dt>
                    <strong>상품 선택 <span>(다중선택가능)</span></strong>
                    <button type="button" onclick="fnItemView();"><img src="/APP/images/layer_close.png"/></button>
                </dt>  
                <dd class="DDSearchConditions">
                    <asp:CheckBoxList runat="server" ID="OrderItemCode" RepeatDirection="Vertical" RepeatLayout="UnOrderedList"></asp:CheckBoxList>
                </dd>
            </dl>
            <button type="button" class="confirm_btn" onclick="fnItemView();">확인</button>
        </div>
    </div>
    <!--상품 선택 팝업 끝-->
</asp:Content>