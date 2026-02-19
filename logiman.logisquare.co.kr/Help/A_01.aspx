<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="A_01.aspx.cs" Inherits="Help.A_01" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>문자메시지</title>
</head>
<style>
    html {
	-webkit-print-color-adjust: exact;
}
* {
	box-sizing: border-box;
	-webkit-print-color-adjust: exact;
}

html,
body {
	margin: 0;
	padding: 0;
}
@media only screen {
	body {
		margin: 2em auto;
		max-width: 900px;
		color: rgb(55, 53, 47);
	}
}

body {
	line-height: 1.5;
	white-space: pre-wrap;
}

a,
a.visited {
	color: inherit;
	text-decoration: underline;
}

.pdf-relative-link-path {
	font-size: 80%;
	color: #444;
}

h1,
h2,
h3 {
	letter-spacing: -0.01em;
	line-height: 1.2;
	font-weight: 600;
	margin-bottom: 0;
}

.page-title {
	font-size: 2.5rem;
	font-weight: 700;
	margin-top: 0;
	margin-bottom: 0.75em;
}

h1 {
	font-size: 1.875rem;
	margin-top: 1.875rem;
}

h2 {
	font-size: 1.5rem;
	margin-top: 1.5rem;
}

h3 {
	font-size: 1.25rem;
	margin-top: 1.25rem;
}

.source {
	border: 1px solid #ddd;
	border-radius: 3px;
	padding: 1.5em;
	word-break: break-all;
}

.callout {
	border-radius: 3px;
	padding: 1rem;
}

figure {
	margin: 1.25em 0;
	page-break-inside: avoid;
}

figcaption {
	opacity: 0.5;
	font-size: 85%;
	margin-top: 0.5em;
}

mark {
	background-color: transparent;
}

.indented {
	padding-left: 1.5em;
}

hr {
	background: transparent;
	display: block;
	width: 100%;
	height: 1px;
	visibility: visible;
	border: none;
	border-bottom: 1px solid rgba(55, 53, 47, 0.09);
}

img {
	max-width: 100%;
}

@media only print {
	img {
		max-height: 100vh;
		object-fit: contain;
	}
}

@page {
	margin: 1in;
}

.collection-content {
	font-size: 0.875rem;
}

.column-list {
	display: flex;
	justify-content: space-between;
}

.column {
	padding: 0 1em;
}

.column:first-child {
	padding-left: 0;
}

.column:last-child {
	padding-right: 0;
}

.table_of_contents-item {
	display: block;
	font-size: 0.875rem;
	line-height: 1.3;
	padding: 0.125rem;
}

.table_of_contents-indent-1 {
	margin-left: 1.5rem;
}

.table_of_contents-indent-2 {
	margin-left: 3rem;
}

.table_of_contents-indent-3 {
	margin-left: 4.5rem;
}

.table_of_contents-link {
	text-decoration: none;
	opacity: 0.7;
	border-bottom: 1px solid rgba(55, 53, 47, 0.18);
}

table,
th,
td {
	border: 1px solid rgba(55, 53, 47, 0.09);
	border-collapse: collapse;
}

table {
	border-left: none;
	border-right: none;
}

th,
td {
	font-weight: normal;
	padding: 0.25em 0.5em;
	line-height: 1.5;
	min-height: 1.5em;
	text-align: left;
}

th {
	color: rgba(55, 53, 47, 0.6);
}

ol,
ul {
	margin: 0;
	margin-block-start: 0.6em;
	margin-block-end: 0.6em;
}

li > ol:first-child,
li > ul:first-child {
	margin-block-start: 0.6em;
}

ul > li {
	list-style: disc;
}

ul.to-do-list {
	padding-inline-start: 0;
}

ul.to-do-list > li {
	list-style: none;
}

.to-do-children-checked {
	text-decoration: line-through;
	opacity: 0.375;
}

ul.toggle > li {
	list-style: none;
}

ul {
	padding-inline-start: 1.7em;
}

ul > li {
	padding-left: 0.1em;
}

ol {
	padding-inline-start: 1.6em;
}

ol > li {
	padding-left: 0.2em;
}

.mono ol {
	padding-inline-start: 2em;
}

.mono ol > li {
	text-indent: -0.4em;
}

.toggle {
	padding-inline-start: 0em;
	list-style-type: none;
}

/* Indent toggle children */
.toggle > li > details {
	padding-left: 1.7em;
}

.toggle > li > details > summary {
	margin-left: -1.1em;
}

.selected-value {
	display: inline-block;
	padding: 0 0.5em;
	background: rgba(206, 205, 202, 0.5);
	border-radius: 3px;
	margin-right: 0.5em;
	margin-top: 0.3em;
	margin-bottom: 0.3em;
	white-space: nowrap;
}

.collection-title {
	display: inline-block;
	margin-right: 1em;
}

.simple-table {
	margin-top: 1em;
	font-size: 0.875rem;
	empty-cells: show;
}
.simple-table td {
	height: 29px;
	min-width: 120px;
}

.simple-table th {
	height: 29px;
	min-width: 120px;
}

.simple-table-header-color {
	background: rgb(247, 246, 243);
	color: black;
}
.simple-table-header {
	font-weight: 500;
}

time {
	opacity: 0.5;
}

.icon {
	display: inline-block;
	max-width: 1.2em;
	max-height: 1.2em;
	text-decoration: none;
	vertical-align: text-bottom;
	margin-right: 0.5em;
}

img.icon {
	border-radius: 3px;
}

.user-icon {
	width: 1.5em;
	height: 1.5em;
	border-radius: 100%;
	margin-right: 0.5rem;
}

.user-icon-inner {
	font-size: 0.8em;
}

.text-icon {
	border: 1px solid #000;
	text-align: center;
}

.page-cover-image {
	display: block;
	object-fit: cover;
	width: 100%;
	max-height: 30vh;
}

.page-header-icon {
	font-size: 3rem;
	margin-bottom: 1rem;
}

.page-header-icon-with-cover {
	margin-top: -0.72em;
	margin-left: 0.07em;
}

.page-header-icon img {
	border-radius: 3px;
}

.link-to-page {
	margin: 1em 0;
	padding: 0;
	border: none;
	font-weight: 500;
}

p > .user {
	opacity: 0.5;
}

td > .user,
td > time {
	white-space: nowrap;
}

input[type="checkbox"] {
	transform: scale(1.5);
	margin-right: 0.6em;
	vertical-align: middle;
}

p {
	margin-top: 0.5em;
	margin-bottom: 0.5em;
}

.image {
	border: none;
	margin: 1.5em 0;
	padding: 0;
	border-radius: 0;
	text-align: center;
}

.code,
code {
	background: rgba(135, 131, 120, 0.15);
	border-radius: 3px;
	padding: 0.2em 0.4em;
	border-radius: 3px;
	font-size: 85%;
	tab-size: 2;
}

code {
	color: #eb5757;
}

.code {
	padding: 1.5em 1em;
}

.code-wrap {
	white-space: pre-wrap;
	word-break: break-all;
}

.code > code {
	background: none;
	padding: 0;
	font-size: 100%;
	color: inherit;
}

blockquote {
	font-size: 1.25em;
	margin: 1em 0;
	padding-left: 1em;
	border-left: 3px solid rgb(55, 53, 47);
}

.bookmark {
	text-decoration: none;
	max-height: 8em;
	padding: 0;
	display: flex;
	width: 100%;
	align-items: stretch;
}

.bookmark-title {
	font-size: 0.85em;
	overflow: hidden;
	text-overflow: ellipsis;
	height: 1.75em;
	white-space: nowrap;
}

.bookmark-text {
	display: flex;
	flex-direction: column;
}

.bookmark-info {
	flex: 4 1 180px;
	padding: 12px 14px 14px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.bookmark-image {
	width: 33%;
	flex: 1 1 180px;
	display: block;
	position: relative;
	object-fit: cover;
	border-radius: 1px;
}

.bookmark-description {
	color: rgba(55, 53, 47, 0.6);
	font-size: 0.75em;
	overflow: hidden;
	max-height: 4.5em;
	word-break: break-word;
}

.bookmark-href {
	font-size: 0.75em;
	margin-top: 0.25em;
}

.sans { font-family: ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif, "Segoe UI Emoji", "Segoe UI Symbol"; }
.code { font-family: "SFMono-Regular", Menlo, Consolas, "PT Mono", "Liberation Mono", Courier, monospace; }
.serif { font-family: Lyon-Text, Georgia, ui-serif, serif; }
.mono { font-family: iawriter-mono, Nitti, Menlo, Courier, monospace; }
.pdf .sans { font-family: Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif, "Segoe UI Emoji", "Segoe UI Symbol", 'Twemoji', 'Noto Color Emoji', 'Noto Sans CJK JP'; }
.pdf:lang(zh-CN) .sans { font-family: Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif, "Segoe UI Emoji", "Segoe UI Symbol", 'Twemoji', 'Noto Color Emoji', 'Noto Sans CJK SC'; }
.pdf:lang(zh-TW) .sans { font-family: Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif, "Segoe UI Emoji", "Segoe UI Symbol", 'Twemoji', 'Noto Color Emoji', 'Noto Sans CJK TC'; }
.pdf:lang(ko-KR) .sans { font-family: Inter, ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, "Apple Color Emoji", Arial, sans-serif, "Segoe UI Emoji", "Segoe UI Symbol", 'Twemoji', 'Noto Color Emoji', 'Noto Sans CJK KR'; }
.pdf .code { font-family: Source Code Pro, "SFMono-Regular", Menlo, Consolas, "PT Mono", "Liberation Mono", Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK JP'; }
.pdf:lang(zh-CN) .code { font-family: Source Code Pro, "SFMono-Regular", Menlo, Consolas, "PT Mono", "Liberation Mono", Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK SC'; }
.pdf:lang(zh-TW) .code { font-family: Source Code Pro, "SFMono-Regular", Menlo, Consolas, "PT Mono", "Liberation Mono", Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK TC'; }
.pdf:lang(ko-KR) .code { font-family: Source Code Pro, "SFMono-Regular", Menlo, Consolas, "PT Mono", "Liberation Mono", Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK KR'; }
.pdf .serif { font-family: PT Serif, Lyon-Text, Georgia, ui-serif, serif, 'Twemoji', 'Noto Color Emoji', 'Noto Serif CJK JP'; }
.pdf:lang(zh-CN) .serif { font-family: PT Serif, Lyon-Text, Georgia, ui-serif, serif, 'Twemoji', 'Noto Color Emoji', 'Noto Serif CJK SC'; }
.pdf:lang(zh-TW) .serif { font-family: PT Serif, Lyon-Text, Georgia, ui-serif, serif, 'Twemoji', 'Noto Color Emoji', 'Noto Serif CJK TC'; }
.pdf:lang(ko-KR) .serif { font-family: PT Serif, Lyon-Text, Georgia, ui-serif, serif, 'Twemoji', 'Noto Color Emoji', 'Noto Serif CJK KR'; }
.pdf .mono { font-family: PT Mono, iawriter-mono, Nitti, Menlo, Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK JP'; }
.pdf:lang(zh-CN) .mono { font-family: PT Mono, iawriter-mono, Nitti, Menlo, Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK SC'; }
.pdf:lang(zh-TW) .mono { font-family: PT Mono, iawriter-mono, Nitti, Menlo, Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK TC'; }
.pdf:lang(ko-KR) .mono { font-family: PT Mono, iawriter-mono, Nitti, Menlo, Courier, monospace, 'Twemoji', 'Noto Color Emoji', 'Noto Sans Mono CJK KR'; }
.highlight-default {
	color: rgba(55, 53, 47, 1);
}
.highlight-gray {
	color: rgba(120, 119, 116, 1);
	fill: rgba(120, 119, 116, 1);
}
.highlight-brown {
	color: rgba(159, 107, 83, 1);
	fill: rgba(159, 107, 83, 1);
}
.highlight-orange {
	color: rgba(217, 115, 13, 1);
	fill: rgba(217, 115, 13, 1);
}
.highlight-yellow {
	color: rgba(203, 145, 47, 1);
	fill: rgba(203, 145, 47, 1);
}
.highlight-teal {
	color: rgba(68, 131, 97, 1);
	fill: rgba(68, 131, 97, 1);
}
.highlight-blue {
	color: rgba(51, 126, 169, 1);
	fill: rgba(51, 126, 169, 1);
}
.highlight-purple {
	color: rgba(144, 101, 176, 1);
	fill: rgba(144, 101, 176, 1);
}
.highlight-pink {
	color: rgba(193, 76, 138, 1);
	fill: rgba(193, 76, 138, 1);
}
.highlight-red {
	color: rgba(212, 76, 71, 1);
	fill: rgba(212, 76, 71, 1);
}
.highlight-gray_background {
	background: rgba(241, 241, 239, 1);
}
.highlight-brown_background {
	background: rgba(244, 238, 238, 1);
}
.highlight-orange_background {
	background: rgba(251, 236, 221, 1);
}
.highlight-yellow_background {
	background: rgba(251, 243, 219, 1);
}
.highlight-teal_background {
	background: rgba(237, 243, 236, 1);
}
.highlight-blue_background {
	background: rgba(231, 243, 248, 1);
}
.highlight-purple_background {
	background: rgba(244, 240, 247, 0.8);
}
.highlight-pink_background {
	background: rgba(249, 238, 243, 0.8);
}
.highlight-red_background {
	background: rgba(253, 235, 236, 1);
}
.block-color-default {
	color: inherit;
	fill: inherit;
}
.block-color-gray {
	color: rgba(120, 119, 116, 1);
	fill: rgba(120, 119, 116, 1);
}
.block-color-brown {
	color: rgba(159, 107, 83, 1);
	fill: rgba(159, 107, 83, 1);
}
.block-color-orange {
	color: rgba(217, 115, 13, 1);
	fill: rgba(217, 115, 13, 1);
}
.block-color-yellow {
	color: rgba(203, 145, 47, 1);
	fill: rgba(203, 145, 47, 1);
}
.block-color-teal {
	color: rgba(68, 131, 97, 1);
	fill: rgba(68, 131, 97, 1);
}
.block-color-blue {
	color: rgba(51, 126, 169, 1);
	fill: rgba(51, 126, 169, 1);
}
.block-color-purple {
	color: rgba(144, 101, 176, 1);
	fill: rgba(144, 101, 176, 1);
}
.block-color-pink {
	color: rgba(193, 76, 138, 1);
	fill: rgba(193, 76, 138, 1);
}
.block-color-red {
	color: rgba(212, 76, 71, 1);
	fill: rgba(212, 76, 71, 1);
}
.block-color-gray_background {
	background: rgba(241, 241, 239, 1);
}
.block-color-brown_background {
	background: rgba(244, 238, 238, 1);
}
.block-color-orange_background {
	background: rgba(251, 236, 221, 1);
}
.block-color-yellow_background {
	background: rgba(251, 243, 219, 1);
}
.block-color-teal_background {
	background: rgba(237, 243, 236, 1);
}
.block-color-blue_background {
	background: rgba(231, 243, 248, 1);
}
.block-color-purple_background {
	background: rgba(244, 240, 247, 0.8);
}
.block-color-pink_background {
	background: rgba(249, 238, 243, 0.8);
}
.block-color-red_background {
	background: rgba(253, 235, 236, 1);
}
.select-value-color-pink { background-color: rgba(245, 224, 233, 1); }
.select-value-color-purple { background-color: rgba(232, 222, 238, 1); }
.select-value-color-green { background-color: rgba(219, 237, 219, 1); }
.select-value-color-gray { background-color: rgba(227, 226, 224, 1); }
.select-value-color-opaquegray { background-color: rgba(255, 255, 255, 0.0375); }
.select-value-color-orange { background-color: rgba(250, 222, 201, 1); }
.select-value-color-brown { background-color: rgba(238, 224, 218, 1); }
.select-value-color-red { background-color: rgba(255, 226, 221, 1); }
.select-value-color-yellow { background-color: rgba(253, 236, 200, 1); }
.select-value-color-blue { background-color: rgba(211, 229, 239, 1); }

.checkbox {
	display: inline-flex;
	vertical-align: text-bottom;
	width: 16px;
	height: 16px;
	background-size: 16px;
	margin-left: 2px;
	margin-right: 5px;
}

.checkbox-on {
	background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%2216%22%20height%3D%2216%22%20viewBox%3D%220%200%2016%2016%22%20fill%3D%22none%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%0A%3Crect%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22%2358A9D7%22%2F%3E%0A%3Cpath%20d%3D%22M6.71429%2012.2852L14%204.9995L12.7143%203.71436L6.71429%209.71378L3.28571%206.2831L2%207.57092L6.71429%2012.2852Z%22%20fill%3D%22white%22%2F%3E%0A%3C%2Fsvg%3E");
}

.checkbox-off {
	background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%2216%22%20height%3D%2216%22%20viewBox%3D%220%200%2016%2016%22%20fill%3D%22none%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%0A%3Crect%20x%3D%220.75%22%20y%3D%220.75%22%20width%3D%2214.5%22%20height%3D%2214.5%22%20fill%3D%22white%22%20stroke%3D%22%2336352F%22%20stroke-width%3D%221.5%22%2F%3E%0A%3C%2Fsvg%3E");
}
	
</style>
<body>
        <article id="6eb2cef6-a229-41af-99dc-03b04a4e85c4" class="page sans"><header><div class="page-header-icon undefined"><span class="icon">💬</span></div><h1 class="page-title">문자메시지</h1></header><div class="page-body"><p id="90e4f9f1-0a99-49ef-a45a-901107536d63" class="block-color-yellow_background">* 사전에 발신번호 등록이 진행되어야 문자메시지 발송이 가능합니다.</p><p id="e2169065-56d7-45ba-b446-0be5ce57c6ff" class="">
</p><p id="92b91826-63b2-4bfb-91c6-cd4e19599cd4" class="block-color-red">[아래 버튼을 누르면 해당 설명으로 이동합니다]</p><nav id="fbaf3000-1b6c-43e7-9dc0-5a4266803c31" class="block-color-gray table_of_contents"><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#A_01">발신번호 사전등록</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#A_02">요청방법</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#A_03">설정방법</a></div><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#A_04">문자발송</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#3099d933-d3df-45d5-a218-3d518a1a684c">문자발송</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#A_05">문자발송 즐겨찾기 등록</a></div><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#A_06">포인트 충전</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#A_07">포인트 충전 요청</a></div></nav><p id="b222ea9f-9e67-4a89-b791-cbe39fe743b2" class="">
</p><p id="bd5f0510-d43f-4c0d-98e7-6fcf0a14f532" class="">
</p><p id="c6611b32-08f1-4aab-ab37-86d243ea98c1" class="">
</p><p id="5d93811c-026d-45dc-b9a9-1a41b26a7dd2" class="">
</p><p id="437d3f19-9a44-4824-87ed-f731a9cad1af" class="">
</p><h1 id="A_01" class="">발신번호 사전등록</h1><h3 id="A_02" class="">요청방법</h3><ul id="df8dffe7-7bf8-4a1f-8520-fe422c57165c" class="bulleted-list"><li style="list-style-type:disc">문자발신번호 사전등록 시 걸리는 시간은 팝빌(POPBill) 서비스 운영에 따라 달라질 수 있습니다.
<ol type="1" id="525d2e3d-674c-4e55-9e9e-c24502bbe374" class="numbered-list" start="1"><li>발신번호 등록에 필요한 서류를 다운로드 합니다.
</li></ol><ol type="1" id="11b4373d-696d-4e4f-a5a9-1ca8b55ce4c0" class="numbered-list" start="2"><li>작성한 서류를 취합하여 경영지원팀에 요청합니다.<figure id="e52c51ed-b179-4b9a-88f5-0fee25f88dde" class="image"><a href="./Help/A/A_01.png" target="_blank"><img style="width:793px" src="./Help/A/A_01.png"/></a></figure></li></ol></li></ul><p id="67146a58-3318-4f67-8f4e-555437994b44" class="">
</p><p id="597b456f-b406-4f8b-b15c-11eacf0b6d6e" class="">
</p><p id="e3f43688-d999-4e4d-abed-4e39473a4654" class="">
</p><h3 id="A_03" class="">설정방법</h3><ol type="1" id="8cab6e6a-aaac-4f77-96c0-b63766ddb528" class="numbered-list" start="1"><li>내정보 화면에 접속합니다.
</li></ol><ol type="1" id="4fe00436-445f-46df-9da9-d78bbec2d0e4" class="numbered-list" start="2"><li>휴대폰번호와 전화번호를 등록하세요. (등록된 번호 문자발송이 가능합니다.)<figure id="04ad6388-5ddc-464c-81b7-ccec49369f08" class="image"><a href="./Help/A/A_02.png"><img style="width:1920px" src="./Help/A/A_02.png"/></a></figure></li></ol><p id="5364b2ab-c3a1-4536-ad5e-ad1810868090" class="">
</p><p id="0b28afb0-4c67-4c3d-b3ad-e7dcb6965383" class="">
</p><p id="3bde211f-57b4-4191-a1fc-f30cf1d397f7" class="">
</p><p id="cae55131-0b60-4690-85f0-b4ecc315e553" class="">
</p><p id="b17f383b-fcd1-4a5e-bba3-03570b145352" class="">
</p><h1 id="A_04" class="">문자발송</h1><h3 id="3099d933-d3df-45d5-a218-3d518a1a684c" class="">문자발송</h3><ul id="3fb08cfd-bd75-4298-b1ab-04d8fa31c4d7" class="bulleted-list"><li style="list-style-type:disc">내정보에 등록된 휴대폰번호, 전화번호가 기본 노출됩니다.<figure id="d9da0829-49d7-4ff6-bcad-12545032d07d" class="image"><a href="./Help/A/A_03.png"><img style="width:1920px" src="./Help/A/A_03.png"/></a><figcaption> </figcaption></figure></li></ul><ul id="5e5e7cfb-8ef4-4af4-9bde-ac2f406096f8" class="bulleted-list"><li style="list-style-type:disc">사전등록된 발신번호로만 문자발송이 가능합니다.<ol type="1" id="c619af3d-e90f-42a8-b53c-009ca73a28d2" class="numbered-list" start="1"><li>발송 -&gt; SMS 버튼을 클릭합니다.</li></ol><ol type="1" id="431790e4-559d-4088-9e43-06e8d2e52d30" class="numbered-list" start="2"><li>발신번호와 수신자를 확인하고 SMS 내용을 작성하세요.</li></ol><ol type="1" id="bad74a8c-43bd-4b1c-a59e-f089028f828f" class="numbered-list" start="3"><li>전송 버튼을 클릭하여 SMS를 전송</li></ol></li></ul><p id="79c32e8f-6b24-4b58-819c-50aa1d3d32ac" class="">
</p><p id="93a3d317-0066-476d-85d0-28f937f7fe56" class="">
</p><p id="a021bd0d-5cb8-465d-904b-f7829d262983" class="">
</p><h3 id="A_05" class="">문자발송 즐겨찾기 등록</h3><ol type="1" id="427799e9-3381-4aab-80f0-1df538f33bd1" class="numbered-list" start="1"><li>SMS 내용을 작성합니다.
</li></ol><ol type="1" id="746a88c7-4548-4cdc-9def-3b4ffd3cb8d6" class="numbered-list" start="2"><li>“즐겨찾기 등록 ⭐” 버튼을 선택하면 즐겨찾기 목록에 해당 내용이 추가됩니다.<figure id="7d74659d-c830-45a7-986f-fc163f3a8a51" class="image"><a href="./Help/A/A_04.png"><img style="width:1920px" src="./Help/A/A_04.png"/></a></figure></li></ol><p id="f5b14c58-9f94-40db-bf7b-f91ea51a149b" class="">
</p><p id="dd3f5acf-b84d-42cb-94b2-a13a05319fd9" class="">
</p><p id="73b3d1a2-307e-4ada-ba6c-3951321bbd61" class="">
</p><p id="5a1ff787-0c08-4dfe-8fad-b4ebf8ade0fd" class="">
</p><p id="83f0e137-ef48-4b3f-b4ee-a62847de43f5" class="">
</p><h1 id="A_06" class="">포인트 충전</h1><h3 id="A_07" class="">포인트 충전 요청</h3><p id="5fd38873-469f-4970-bef8-1ebd939387a8" class="">내정보 화면에서 현재 보유하고 있는 포인트를 확인할 수 있습니다. 보유 포인트가 1,000P 이하인 경우, 문자발송 포인트 충전을 요청해야 합니다.</p><ul id="787a7111-1805-4964-8303-175ce98d67aa" class="bulleted-list"><li style="list-style-type:disc">보유 포인트 확인은 추후 서비스 예정입니다.</li></ul><p id="ea741b9c-6086-4481-a675-b82b6830f4f9" class="">
</p></div></article>
</body>
</html>
