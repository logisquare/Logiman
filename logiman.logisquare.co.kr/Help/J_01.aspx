<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="J_01.aspx.cs" Inherits="Help.J_01" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>수출입 오더</title><style>
/* cspell:disable-file */
/* webkit printing magic: print all background colors */
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
	width: 16;
	height: 16;
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
	
</style></head><body><article id="934f3150-29af-4c6f-a5ff-fd833cda29f5" class="page sans"><header><div class="page-header-icon undefined"><img class="icon" src="https://www.notion.so/icons/airplane_blue.svg"/></div><h1 class="page-title">수출입 오더</h1></header><div class="page-body"><p id="6b472501-3f1d-4930-bd76-52a029300deb" class="block-color-yellow_background">* 수출입 오더는 배차구분을 직송 또는 집하/간선으로 구분한 뒤, 위탁할 수 있습니다.</p><p id="6d397e77-0b72-4138-b3d2-e52add7c00f4" class="">
</p><p id="15dbb5df-f4e3-40bf-9b55-b46c2ca1c520" class=""><mark class="highlight-red">[아래 버튼을 누르면 해당 설명으로 이동합니다]</mark></p><nav id="2966d9ca-69c3-41d6-81aa-66a4f81c26ec" class="block-color-gray table_of_contents"><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#J_01">수출입 오더</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#J_02">* 비용등록(매출)</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#J_03">* 대량복사</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#J_04">* 서비스 이슈 등록하기</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#J_05">* 서비스 이슈 현황</a></div></nav><p id="cec1784b-ddf0-4cc2-8008-c19f7e386632" class="">
</p><p id="69c40410-7980-4a25-b46b-4ab5033e32d9" class="">
</p><p id="7699f9a6-44d0-40db-9bfe-d39b77f35d91" class="">
</p><p id="cd4a04fb-8161-422f-b315-eb1781e10a77" class="">
</p><p id="8b0bff3f-f1c4-4003-91d8-402aaff1bdc0" class="">
</p><h1 id="J_01" class="">수출입 오더</h1><h3 id="J_02" class="">* 비용등록(매출)</h3><ol type="1" id="1119f612-104a-49ce-9594-2bbe68b5148a" class="numbered-list" start="1"><li>수출입 오더현황 화면에서 비용등록 버튼을 클릭합니다.<figure id="b53d4a6f-4387-4952-a44b-ecddc14ac9ee" class="image"><a href="./Help/J/J_01.png"><img style="width:1920px" src="./Help/J/J_01.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="74d09694-0d3a-46fd-8d84-1dcd75f21713" class="numbered-list" start="2"><li>비용등록할 오더를 조회한 뒤, 오더를 클릭합니다.<figure id="18cb4f3a-c73d-45ff-92db-b632d823a46b" class="image"><a href="./Help/J/J_02.png"><img style="width:1920px" src="./Help/J/J_02.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="e26b5e60-da0b-482e-b462-bc726e7fd4ef" class="numbered-list" start="3"><li>하단에 표시되는 비용정보에서 비용을 입력하여 추가 버튼을 클릭하여 비용정보를 1행 추가합니다.
</li></ol><ol type="1" id="d71deb1c-ae56-4cfc-9ec2-9c898533ad05" class="numbered-list" start="4"><li>등록(F2) 버튼을 클릭하여 오더에 비용정보를 저장합니다.</li></ol><p id="3e093274-f8e4-4e81-94b6-620d978e26f0" class="">
</p><p id="11676e41-829f-4b0e-bb59-baa71f8fe054" class="">
</p><p id="5a569acc-c735-427c-a064-7194713955fa" class="">
</p><h3 id="J_03" class="">* 대량복사</h3><ol type="1" id="1a07dc77-f46b-4f85-91a7-2b34747ae2b5" class="numbered-list" start="1"><li>대량복사할 오더를 선택합니다.(2건 이상의 오더 선택 가능)<ul id="3f6f98d0-b3bd-4963-8938-df043dba0b20" class="bulleted-list"><li style="list-style-type:disc">2건의 오더를 선택한 경우, 선택한 일자마다 2건씩 복사됩니다.<figure id="2d622ac7-d537-4512-a5bb-1bed39490242" class="image"><a href="./Help/J/J_03.png"><img style="width:1920px" src="./Help/J/J_03.png"/></a><figcaption> </figcaption></figure></li></ul></li></ol><ol type="1" id="579f0442-02f8-47fa-963a-74f856115b44" class="numbered-list" start="2"><li>오더대량복사 버튼을 선택합니다. (신규 팝업)<figure id="1bc5e2b4-7b8d-4853-afd1-8d84c941bc7c" class="image"><a href="./Help/J/J_04.png"><img style="width:1919px" src="./Help/J/J_04.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="5d57f5f7-2762-4af3-83d7-9b7f38da8ffc" class="numbered-list" start="3"><li>복사할 건수를 선택<ul id="f963dfcd-e6ed-44d4-98b6-e4c0389ba301" class="bulleted-list"><li style="list-style-type:disc">2건의 오더를 3개씩 복사하는 경우, 선택한 일자마다 6건씩 복사됩니다.
(A오더 3건, B오더 3건)
</li></ul></li></ol><ol type="1" id="1d777bd8-3f4f-4acd-9e6b-53fdb71a447a" class="numbered-list" start="4"><li>복사할 날짜를 선택합니다.<ul id="2f41c83a-109f-4d4e-a08b-0fdfd15312c0" class="bulleted-list"><li style="list-style-type:disc">선택 일자가 복사된 오더의 상차일이 됩니다.
</li></ul></li></ol><ol type="1" id="edc2b722-f4ff-425a-85d9-96a02d0cac5f" class="numbered-list" start="5"><li>하차일을 선택합니다.<ul id="151742f1-c762-4eb2-a020-2077c0edefa6" class="bulleted-list"><li style="list-style-type:disc">당착 = 상차일과 동일, 익착 = 하차일이 상차일+1일로 등록됩니다.
</li></ul></li></ol><ol type="1" id="82989b30-8d8d-4057-9de4-2cfb419db8ef" class="numbered-list" start="6"><li>복사할 항목을 선택합니다.<ul id="0dabb6c6-b90c-4713-a5c9-3e92c975bb4c" class="bulleted-list"><li style="list-style-type:disc">고객전달사항, 화물정보, 도착보고 여부, 통관여부, 보세여부, 계산서 정보, 전체
</li></ul></li></ol><ol type="1" id="9a4ea297-9d0b-45e2-bf49-2aaeb822271e" class="numbered-list" start="7"><li>등록 버튼을 클릭하면, 위에 설정한 기준대로 오더가 대량으로 복사됩니다.<figure id="2f42ab37-5609-4ab9-826c-05c57d7dba76" class="image"><a href="./Help/J/J_05.png"><img style="width:1124px" src="./Help/J/J_05.png"/></a><figcaption> </figcaption></figure></li></ol><p id="1ba04fc8-ff08-4940-9ee7-89b8092cd96b" class="">
</p><p id="1858bfd9-4f76-4cf0-9f30-3f05ee4b5a6b" class="">
</p><p id="753dc093-08ca-4f29-b605-4469f1290927" class="">
</p><h3 id="J_04" class="">* 서비스 이슈 등록하기</h3><ol type="1" id="fd328116-3b5e-44d6-bb4f-043cdee892c5" class="numbered-list" start="1"><li>오더 상세화면에서 상단에 서비스 이슈 버튼을 클릭합니다.<figure id="7671075a-053f-48ba-bafb-9c9b2217d226" class="image"><a href="./Help/J/J_06.png"><img style="width:1920px" src="./Help/J/J_06.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="0a465b4d-bb61-4c37-b461-df26f2d4a566" class="numbered-list" start="2"><li>해당오더 서비스 이슈 목록 팝업이 열리며, 신규 서비스 이슈 등록 시, 등록 버튼을 클릭합니다.<figure id="aa8e5b0a-ea8f-472b-9306-09d1caf15209" class="image"><a href="./Help/J/J_07.png"><img style="width:1920px" src="./Help/J/J_07.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="ee7f246a-ab8c-4911-8d7a-ec0aced457d6" class="numbered-list" start="3"><li>이슈유형, 발생일, 발생원인 등 입력할 수 있는 텍스트 박스가 추가됩니다.
</li></ol><ol type="1" id="51fbec5c-2c46-42a2-acbb-64f50a0bd2ac" class="numbered-list" start="4"><li>이슈를 입력한 뒤 저장 버튼을 클릭하여 서비스 이슈를 등록합니다.<figure id="c5ef91a7-04fd-4b83-a142-aaae2f63f23d" class="image"><a href="./Help/J/J_08.png"><img style="width:1920px" src="./Help/J/J_08.png"/></a></figure></li></ol><p id="9cbc7c18-318c-4587-902c-ed23e9000d7d" class="">
</p><p id="0ed9ff12-7c31-4253-8d9f-96b99be859a0" class="">
</p><p id="3bed5388-6c51-4a6a-aafb-43537f8e6c3d" class="">
</p><p id="0424be32-e5c8-43cb-8980-114a13fb1403" class="">
</p><h3 id="J_05" class="">* 서비스 이슈 현황</h3><ul id="4c001035-efe1-4364-b16d-d7e8ce53c7ac" class="bulleted-list"><li style="list-style-type:disc">(해당 오더의 서비스 이슈를 보는 경우)<ol type="1" id="8a048a94-8c2e-41af-93fc-96039fbd1829" class="numbered-list" start="1"><li>해당 오더를 더블클릭하여 상세오더정보를 확인합니다.</li></ol><ol type="1" id="d613f0a6-9315-472e-9dcb-4ee128efd78c" class="numbered-list" start="2"><li>서비스 이슈 버튼을 클릭하여, 해당 오더의 이슈 목록을 확인할 수 있습니다.<figure id="e1c4a198-7f71-4b97-9eee-c341a67db082" class="image"><a href="./Help/J/J_08.png"><img style="width:1920px" src="./Help/J/J_08.png"/></a><figcaption>  </figcaption></figure></li></ol></li></ul><ul id="db28c8ed-362d-4954-aebf-ae566cc233a8" class="bulleted-list"><li style="list-style-type:disc">(여러 건의 서비스 이슈를 한번에 보는 경우)<ol type="1" id="40bb5006-d584-49fc-9b73-0fca76603af1" class="numbered-list" start="1"><li>오더현황 목록 상단에 서비스이슈현황 버튼을 클릭합니다.<figure id="8309e23f-dfd0-4b09-a9e8-a89b22c25afc" class="image"><a href="./Help/J/J_09.png"><img style="width:1920px" src="./Help/J/J_09.png"/></a></figure></li></ol><ol type="1" id="6b7a6e59-006c-47c7-b336-4b16cb494ffe" class="numbered-list" start="2"><li>조회하고자 하는 기간을 설정한 뒤, 조회버튼을 클릭하여 해당 기간내에 등록된 서비스 이슈 목록을 확인할 수 있습니다.<ul id="0125d9a2-430e-48b1-8a44-41f28d183b06" class="bulleted-list"><li style="list-style-type:disc">서비스 이슈 등록 시 입력한 발생일 기준으로 조회됩니다.<figure id="3a2fe3ba-1c16-46ec-87cb-aa2493919eef" class="image"><a href="./Help/J/J_10.png"><img style="width:1920px" src="./Help/J/J_10.png"/></a></figure></li></ul></li></ol></li></ul></div></article></body></html>