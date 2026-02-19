<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Certificate.aspx.cs" Inherits="SMS.Certificate" %>
<%@ Import Namespace="CommonLibrary.CommonModule" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>화물위탁증</title>
    <link rel="stylesheet" href="css/reset.css">
    <style>
        /*공통스타일*/
        .wrap{padding:10px; width: 1200px; margin: auto; font-size: 20px;}
        table{ border-collapse: collapse; width:100%; border:2px solid #000;}
        tbody td, tbody th{border:1px solid #666; vertical-align: middle; padding: 10px; line-height: 1.3;}
        tbody th{font-weight: 600;}
        tbody th span{font-weight: 400;}
        tr th:nth-of-type(1){border-left: none;}
        tr th:nth-of-type(4){border-right: none;}
        tr td:nth-of-type(3){border-right: none;}
        tr td:nth-of-type(1){border-right: none;}
        tr td:nth-of-type(6){border-right: none;}
        .cross{background:url("images/ico_cross.png") left top no-repeat; background-size:100% 100%;}

        /*상단 테이블*/
        .top_section tbody tr{height: 80px;}
        .top_section .top_table thead th{font-size: 30px; font-weight:600; padding:10px 0}
        .top_section .top_table thead tr th{padding-bottom: 20px; letter-spacing: 0.5em;}
        .top_section .top_table tbody tr:nth-of-type(1) th{text-align: center;}
        .top_section .top_table tbody tr th{text-align: left;}

        /*서명영역*/
        .top_section .signature > p{text-align: center; padding:20px 0 50px 0}
        .top_section .signature .date{text-align: right; margin-bottom: 50px}
        .top_section .signature ul{border-bottom: 3px solid #999;}
        .top_section .signature ul li{margin-bottom: 50px; list-style-type:none;}
        .top_section .signature ul li div{margin-left: 400px;}
        .top_section .signature ul li div:after{content: ""; display: block; clear:both}
        .top_section .signature ul li div span:nth-child(1){float: left; font-weight: 600; margin-right: 20px}
        .top_section .signature ul li div span:nth-child(2){float: right; color:#666}
        .top_section .signature ul li p{margin:20px 0 0 400px}
        
        /*유의사항 및 작성방법*/
        .precaution_write{margin-top: 20px;}
        .precaution_table{margin-bottom: 20px; }
        .precaution_table th, .precaution_table td, .write_table th, .write_table td {border-left:none; border-right:none;}
        .precaution_table th, .write_table th{border-top:3px solid #999}
        .write_table td{border-bottom:none; border-top:none;line-height: 1.2;}
        .text_height td{line-height: 2;}
        .text_height td div{text-align: right;}

        /*테이블 스타일*/
        .border_none{border:none}
        .text_right{float: right;}
        .color_c4{background: #c4c4c4; font-weight: 400;}
        .letter_spacing2{letter-spacing: 2em;}
        .letter_spacing05{letter-spacing: 0.5em;}
    </style>

    <% if(!string.IsNullOrWhiteSpace(SiteGlobal.GA_CODE_SMS)) {%>
        <!-- Google tag (gtag.js) -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=<%=SiteGlobal.GA_CODE_SMS%>"></script>
        <script> window.dataLayer = window.dataLayer || []; function gtag() { dataLayer.push(arguments); } gtag('js', new Date()); gtag('config', '<%=SiteGlobal.GA_CODE_SMS%>');</script>
    <%}%>
</head>
<body>
    <form runat="server" id="MainForm">
    <asp:HiddenField runat="server" ID="ErrMsg"/>
    <asp:HiddenField runat="server" ID="DisplayMode"/>
        <div class="wrap">
            <!--상단 테이블 및 서명 부분-->
            <div class="top_section">
                <!--상단 테이블-->
                <table class="top_table">
                    <colgroup>
                        <col style="width:auto">
                        <col style="width:10%">
                        <col style="width:15%">
                        <col style="width:10%">
                        <col style="width:15%">
                        <col style="width:10%">
                        <col style="width:15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="7" class="border_none">화물위탁증</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th class="letter_spacing05">구분</th>
                            <th colspan="2" class="letter_spacing05">화주</th>
                            <th colspan="2">다른 운송사업자, 주선사업자 또는 운송가맹사업자</th>
                            <th colspan="2" class="letter_spacing05">위탁자</th>
                        </tr>
                        <tr>
                            <th>성명<span>(법인의 경우는 그명칭 및 대표자 성명)</span></th>
                            <td colspan="2"><asp:Label runat="server" ID="ClientName"></asp:Label></td>
                            <td colspan="2"></td>
                            <td colspan="2"><asp:Label runat="server" ID="CenterName"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>주사무소<span>(개인인 경우는 주소)</span></th>
                            <td colspan="2"></td>
                            <td colspan="2"></td>
                            <td colspan="2"><asp:Label runat="server" ID="Addr"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>사업자등록번호<span>(개인인 경우는 생년월일)</span></th>
                            <td colspan="2" class="cross"></td>
                            <td colspan="2"class="cross"></td>
                            <td colspan="2"><asp:Label runat="server" ID="CorpNo"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>전화번호</th>
                            <td colspan="2"></td>
                            <td colspan="2"></td>
                            <td colspan="2"><asp:Label runat="server" ID="TelNo"></asp:Label></td>
                        </tr>
                        <tr>
                            <th>화물종류</th>
                            <td colspan="2"></td>
                            <td colspan="2"></td>
                            <td colspan="2"></td>
                        </tr>
                        <tr>
                            <th class="letter_spacing2">중량</th>
                            <td colspan="2"><span class="text_right">ton</span></td>
                            <td colspan="2"><span class="text_right">ton</span></td>
                            <td colspan="2"><span class="text_right">ton</span></td>
                        </tr>
                        <tr class="text_height">
                            <th class="letter_spacing2">부피</th>
                            <td colspan="2">
                                <span>(길이*폭*높이)</span>
                                <div>m ⅹ m ⅹ m</div>
                            </td>
                            <td colspan="2">
                                <span>(길이*폭*높이)</span>
                                <div>m ⅹ m ⅹ m</div>
                            </td>
                            <td colspan="2">
                                <span>(길이*폭*높이)</span>
                                <div>m ⅹ m ⅹ m</div>
                            </td>
                        </tr>
                        <tr class="text_height">
                            <th class="letter_spacing05">수탁자</th>
                            <td colspan="6">
                                <span>성명(법인의 경우는 그 명칭 및 대표자 성명)</span>
                                <div style="padding-right:50px">전화번호&nbsp;&nbsp;&nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <th>차량현황</th>
                            <td>등록번호</td>
                            <td></td>
                            <td>최대적재량</td>
                            <td><span class="text_right">ton</span></td>
                            <td class="letter_spacing05">유형</td>
                            <td></td>
                        </tr>
                        <tr>
                            <th>운송현황</th>
                            <td class="letter_spacing05">출발지</td>
                            <td></td>
                            <td class="letter_spacing05">도착지</td>
                            <td></td>
                            <td class="letter_spacing05">운송</td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
                <!--상단 테이블 끝-->
            
                <!--서명영역-->
                <div class="signature">
                    <p>화물자동차 운수사업법 제11조제12항, 제28조 및 제33조와 같은 법 시행규칙 제39조에 따라 화물위탁증을 교부합니다.</p>
                    <div class="date"><asp:Label runat="server" ID="PickupYMD"></asp:Label></div>
                    <ul>
                        <li>
                            <div><span class="letter_spacing05">위탁자</span><span>(서명 또는 인)</span></div>
                            <p>(운송사업자, 운송주선사업자 또는 운송가맹사업자)</p>
                        </li>
                        <li>
                            <div><span class="letter_spacing05">수탁자</span><span>(서명 또는 인)</span></div>
                            <p>(1대 사업자 또는 위·수탁차주)</p>
                        </li>
                    </ul>
                </div>
                <!--서명영역 끝-->
            </div>
            <!--상단 테이블 및 서명 부분 끝-->
        
            <!--유의사항 및 작성방법-->
            <div class="precaution_write">
                <!--유의사항-->
                <table class="precaution_table">
                    <tbody>
                        <tr>
                            <th class="color_c4">유의사항</th>
                        </tr>
                        <tr>
                            <td>1. 위 기재 내용이 사실과 다른 경우 관련 법령에 의해 처벌받을 수 있습니다.</td>
                        </tr> 
                    </tbody>
                </table>
                <!--유의사항 끝-->
                <!--작성방법-->
                <table class="write_table">
                    <tbody>
                        <tr>
                            <th class="color_c4">작성방법</th>
                        </tr>
                        <tr>
                            <td>1. 중량, 부피란에는 해당자가 각 화물자동차의 1회 운송 시에 적재할 것을 요구하거나 지시한 중량과 부피를 기재한다.</td>
                        </tr>
                        <tr>
                            <td>2. "화주" 또는 "다른 운송사업자, 주선사업자 또는 운송가맹사업자" 가 "화물의 부피" 를 알 수 없는 경우에는 기재하지 아니하여도 된다.</td>
                        </tr>
                        <tr>
                            <td>3. "유형" 은 「자동차관리법 시행규칙」 별표 1 제2호에 따른 유형을 말한다.</td>
                        </tr>
                    </tbody>
                </table>
                <!--작성방법 끝-->
            </div>
            <!--유의사항 및 작성방법 끝-->
        </div>
        <!--end wrap-->
    </form>
</body>
</html>