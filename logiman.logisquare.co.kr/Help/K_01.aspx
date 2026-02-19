<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="K_01.aspx.cs" Inherits="Help.K_01" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>매입마감</title><style>
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
	
</style></head><body><article id="1a3bd537-0910-410d-bc61-d02973e2d5c7" class="page sans"><header><div class="page-header-icon undefined"><img class="icon" src="https://www.notion.so/icons/sign-out_blue.svg"/></div><h1 class="page-title">매입마감</h1></header><div class="page-body"><p id="caa16862-8510-47a0-a67e-196961d4c88f" class="block-color-yellow_background">* (일반/빠른/업체) 매입마감으로 나뉘며, 빠른입금(운) 마감은 계산서가 있어야 마감 가능합니다.
* 빠른입금(운)_바로지급건은 마감과 동시에 송금이 진행됩니다. (14일지급은 마감과 동시에 송금신청됩니다.</p><p id="90c58796-7eda-489b-a169-e9b9f3defd20" class="">
</p><p id="f55aa6c4-4e5c-48ba-b2a9-5e6fe817b22b" class=""><mark class="highlight-red">[아래 버튼을 누르면 해당 설명으로 이동합니다]</mark></p><nav id="874348df-eb7a-48f2-aed9-f398bd88b3bf" class="block-color-gray table_of_contents"><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#K_01">매입마감</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_02">* 조회기간 내 미매칭 계산서 조회하기</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_03">* 매입마감하기(일반입금)</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_04">* 매입마감하기(빠른입금(운))</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_05">* 매입마감하기(업체마감)</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_06">* 매입마감 취소하기(일반, 빠른, 업체)</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_07">* 매입계산서 매칭하기</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#K_08">* 매입마감 현황조회(상세)</a></div></nav><p id="4f1cd583-3bd3-4e54-966b-cacbc34e77c5" class="">
</p><p id="d84354ea-b437-4694-9281-94638c611b23" class="">
</p><p id="2f52df80-d0da-4936-b267-7f6c1a18cb0e" class="">
</p><p id="3fa9341d-4fbc-4469-94b8-db6adb3c1947" class="">
</p><p id="f32bc279-2701-43f5-8ae8-c2a0b375759c" class="">
</p><h1 id="K_01" class="">매입마감</h1><h3 id="K_02" class="">* 조회기간 내 미매칭 계산서 조회하기</h3><ol type="1" id="61c024b4-2c02-4a58-81fb-9f6b37a13216" class="numbered-list" start="1"><li>회원사를 선택합니다. (조건 조회 전, 선행되어야하는 필수 선택값입니다.)<ul id="a14680ae-b87e-4075-bcf8-e7197a3387f3" class="bulleted-list"><li style="list-style-type:disc">2개 이상의 가맹점을 조회할 수 있는 계정인 경우에만 표시됩니다.
</li></ul></li></ol><ol type="1" id="1da7d3d1-241d-4db7-934d-50a9490bd7a1" class="numbered-list" start="2"><li>조회버튼을 클릭하면 해당 기간내에 배차된 차량의 사업자정보가 왼쪽 Grid에 표시됩니다.<figure id="50c8d115-3cfe-4a33-a4d9-6ef9e9e93153" class="image"><a href="./Help/K/K_01.png"><img style="width:1920px" src="./Help/K/K_01.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="6ddffa0d-1845-4e09-ae7f-acb686bf0c94" class="numbered-list" start="3"><li>상단에 작성일자 : 선택일자 기준 최근 2개월 내 수집된 계산서 목록 중 해당 사업자번호와 동일한 계산서 수집내역을 볼 수 있습니다.<ul id="7d8b29ad-d14b-4bdd-98c8-445a82e9671e" class="bulleted-list"><li style="list-style-type:disc">작성일자를 변경하면 변경한 일자 기준으로 최근 2개월이 재조회됩니다.<figure id="cafa45bd-88a7-4e1b-9ebb-3bc23d01dbdc" class="image"><a href="./Help/K/K_02.png"><img style="width:1920px" src="./Help/K/K_02.png"/></a></figure></li></ul></li></ol><p id="d4d8365b-558c-4874-aefe-ddda496ef556" class="">
</p><p id="a2e47f4b-b81c-41e8-9735-0fc8f8739858" class="">
</p><p id="8aeb330e-b27e-44af-93fb-08295ac02d08" class="">
</p><p id="d4b0cae6-44d8-4be8-8dbc-be63d51f8ed2" class="">
</p><h3 id="K_03" class="">* 매입마감하기(일반입금)</h3><ol type="1" id="12cc1411-d825-4c0c-bb2e-472d40bb8c45" class="numbered-list" start="1"><li>회원사를 선택합니다. (조건 조회 전, 선행되어야하는 필수 선택값입니다.)<ul id="ca1fcaf1-6012-45e4-aacc-acbc3adfe115" class="bulleted-list"><li style="list-style-type:disc">2개 이상의 가맹점을 조회할 수 있는 계정인 경우에만 표시됩니다.
</li></ul></li></ol><ol type="1" id="a019dc84-da09-4363-8f15-62f8217501eb" class="numbered-list" start="2"><li>조회버튼을 클릭하면 해당 기간내에 배차된 차량의 사업자정보가 왼쪽 Grid에 표시되며, 마감하고자 하는 사업자정보를 선택합니다.
</li></ol><ol type="1" id="154d4897-af91-4fd1-a6ff-b546c1fd53bb" class="numbered-list" start="3"><li>선택과 동시에 사업자정보 기준으로 등록된 오더내역을 오른쪽에 표시합니다.
</li></ol><ol type="1" id="2cbaa6a3-4dc3-4752-91d7-eea72e153a59" class="numbered-list" start="4"><li>조회된 오더 중 마감하고자 하는 오더를 선택한 다음 우측 상단에 마감 버튼을 클릭합니다.<figure id="d528059b-8d43-4e28-b597-5fb6b8d7a07b" class="image"><a href="./Help/K/K_03.png"><img style="width:1920px" src="./Help/K/K_03.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="30d00d2d-39b9-4d84-8c20-0ce67ba7a5ca" class="numbered-list" start="5"><li>해당 오더와 매칭할 계산서 목록이 표시되며, 수집된 계산서와 매칭과 동시에 마감을 진행합니다.<ul id="ec094afd-00ed-4f7e-b4ea-b6a46126c6d4" class="bulleted-list"><li style="list-style-type:disc">수집된 계산서가 없는 경우, 작성일자를 지정하여 마감하면 차주가 머핀트럭앱에서 카고페이 위수탁 계산서 발행을 진행할 수 있습니다.<figure id="883c298e-24d0-415b-b57c-25815febf12e" class="image"><a href="./Help/K/K_04.png"><img style="width:1920px" src="./Help/K/K_04.png"/></a><figcaption> 
</figcaption></figure></li></ul><ul id="b772fd47-a521-434e-b6b8-f6654bcd15a0" class="bulleted-list"><li style="list-style-type:disc">마감 후에도 추후 수집된 계산서와 매칭할 수 있습니다. (매입마감현황 메뉴에서 매칭 가능)<figure id="66bb9c61-be84-4756-b75c-147a1128745b" class="image"><a href="./Help/K/K_05.png"><img style="width:1920px" src="./Help/K/K_05.png"/></a></figure><figure id="fa9e45e7-d075-4413-ac98-16295d94eccc" class="image"><a href="./Help/K/K_06.png"><img style="width:1920px" src="./Help/K/K_06.png"/></a></figure></li></ul></li></ol><p id="b2c93bc4-e662-4e6f-94b2-2cb93103deac" class="">
</p><p id="4fc9baaf-2a57-489e-b2a0-96581484253f" class="">
</p><p id="337c4825-4900-49b5-a6c3-77a009f7cd57" class="">
</p><h3 id="K_04" class="">* 매입마감하기(빠른입금(운))</h3><ul id="7018c543-f18d-4914-bd4e-958ab4777a68" class="bulleted-list"><li style="list-style-type:disc">빠른입금(운) 마감내역은 오더에서 비용정보 입력 시 선택<ol type="1" id="b76223d1-4dfb-4e98-8446-bd04684d3de1" class="numbered-list" start="1"><li>빠른입금마감 화면에서 &#x27;운송내역&#x27;을 조회합니다.(조회조건에 맞는 오더조회)<figure id="392737af-efda-4f66-a351-62404ad35a73" class="image"><a href="./Help/K/K_07.png"><img style="width:1920px" src="./Help/K/K_07.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="aabe1314-e60c-4495-a7e8-9d62338220c6" class="numbered-list" start="2"><li>마감하고자 하는 운송내역을 체크합니다. (체크와 동시에 우측에 수집된 계산서내역 조회)
</li></ol><ol type="1" id="8c2a0a24-b039-477d-b650-51041c1396d0" class="numbered-list" start="3"><li>일치하는 계산서를 체크하여 우측 상단에 &#x27;마감&#x27; 버튼을 클릭합니다.<ul id="a28c2927-f291-48fe-9538-2cda4ac1468b" class="bulleted-list"><li style="list-style-type:disc">바로지급 = 송금 이루어짐 // 14일지급 = 송금신청 들어가면서 14일 뒤 송금 이루어짐<figure id="5891bb39-aeee-4be8-9181-161b9beb5ece" class="image"><a href="./Help/K/K_08.png"><img style="width:1920px" src="./Help/K/K_08.png"/></a></figure></li></ul></li></ol></li></ul><p id="8e134d0d-942e-416b-bce9-9e8c41cbf17c" class="">
</p><p id="a258b178-3b9f-407e-823b-beead0f2a863" class="">
</p><p id="d45eafce-a161-481a-b1c3-5b880aedc641" class="">
</p><p id="b8d8890a-b08b-4cb1-addd-ecc60e625551" class="">
</p><h3 id="K_05" class="">* 매입마감하기(업체마감)</h3><ul id="653c6a5e-a625-4463-916e-e9e971b8700d" class="bulleted-list"><li style="list-style-type:disc">업체 매입마감은 오더에 배차정보에서 차량번호가 아닌 &quot;업체명&quot;으로 입력하여 등록하면, 업체매입마감 메뉴에서 마감 가능합니다.<ol type="1" id="2e01ac1b-370e-4d80-9722-93331d7a582e" class="numbered-list" start="1"><li>업체매입마감 화면에서 &#x27;배차된 사업자&#x27; 내역을 조회합니다.<figure id="c7eda7b6-1216-4ce7-8509-9cb667180ab2" class="image"><a href="./Help/K/K_09.png"><img style="width:1920px" src="./Help/K/K_09.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="09b09307-b442-4260-80ea-4c1d57fe2f16" class="numbered-list" start="2"><li>사업자내역을 클릭하면 해당 사업자가 등록된 운송내역을 확인할 수 있습니다.<figure id="dbbc3058-64b8-4bda-b944-5a41103a27a1" class="image"><a href="./Help/K/K_10.png"><img style="width:1920px" src="./Help/K/K_10.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="36740a84-1f58-421b-be54-14af8f33640b" class="numbered-list" start="3"><li>운송내역을 체크한 뒤, 마감 버튼을 클릭하면 마감여부를 확인한 후 마감합니다.<figure id="3f11c2b7-1077-45e1-a9cf-28785c881b13" class="image"><a href="./Help/K/K_11.png"><img style="width:1920px" src="./Help/K/K_11.png"/></a></figure></li></ol></li></ul><p id="670544ce-9a20-4d14-9ac8-2cb689540725" class="">
</p><p id="0c3a06d2-c0f3-4538-82f2-3bace580547b" class="">
</p><p id="c125f8d5-9128-4062-809d-34e9de7a22dd" class="">
</p><h3 id="K_06" class="">* 매입마감 취소하기(일반, 빠른, 업체)</h3><ul id="8a63e6b8-8c0b-474a-9f49-38a68b484f6c" class="bulleted-list"><li style="list-style-type:disc">일반, 업체 마감은 마감취소가 가능하지만, 빠른입금 마감은 마감과 동시에 송금신청이 들어가므로 직접 마감취소가 불가합니다. 경영지원팀에 마감취소 요청을 진행해야합니다.<figure id="c212f5cc-ce1d-46df-a647-929462771d65" class="image"><a href="./Help/K/K_12.png"><img style="width:1922px" src="./Help/K/K_12.png"/></a><figcaption> </figcaption></figure></li></ul><ul id="70ec95ab-7eab-4fdc-ad38-974836a426c5" class="bulleted-list"><li style="list-style-type:disc">일반, 업체 마감도 송금신청 또는 계산서 발행이 완료된 경우에는 직접 마감취소가 불가합니다. 이 경우도 동일하게 경영지원팀에 마감취소 요청을 진행해야합니다.<ol type="1" id="248aab55-d71f-45b8-8a37-2b0a7621e297" class="numbered-list" start="1"><li>매입마감된 내역을 체크합니다.<figure id="6458c052-e96f-4280-83d8-6192b7bde92e" class="image"><a href="./Help/K/K_13.png"><img style="width:1920px" src="./Help/K/K_13.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="bc964d38-a572-49ba-937d-cebd70e6a61d" class="numbered-list" start="2"><li>&#x27;마감취소&#x27; 버튼을 클릭하면 마감전표번호가 삭제되면서 마감내역이 해제됩니다.(한번 마감취소된 전표번호는 동일하게 사용할 수 없습니다.)</li></ol></li></ul><p id="da151c75-0284-4304-8b69-067e9d9a8823" class="">
</p><p id="5f9e3b09-3e3f-4d8e-b943-9ee3db1acbe7" class="">
</p><p id="396166f7-3b7a-490d-8464-2058f46f4462" class="">
</p><h3 id="K_07" class="">* 매입계산서 매칭하기</h3><ul id="2480872c-92c6-4030-b601-6c297fbca227" class="bulleted-list"><li style="list-style-type:disc">(마감과 동시에 매칭하기)<ol type="1" id="b44ee76c-985e-4007-b7aa-36f31e635d81" class="numbered-list" start="1"><li>&#x27;매입마감&#x27; 화면에서 조회하고자 하는 조건으로 배차내역을 검색합니다.</li></ol><ol type="1" id="d4721dae-0204-4ce1-9afe-802651fb6d22" class="numbered-list" start="2"><li>차량 사업자번호로 수집된 미매칭 계산서가 있는지 확인한 뒤, 오더를 체크하여 ‘마감’을 진행합니다.
</li></ol></li></ul><ul id="d62cd73d-a0b5-44f0-9d7c-2810b9420ad3" class="bulleted-list"><li style="list-style-type:disc">(마감 후 매칭하기)<ol type="1" id="bf08e6cb-5554-4aa3-a01e-c570982355c6" class="numbered-list" start="1"><li>‘매입마감현황’ 화면에서 마감된 내역을 조회합니다.</li></ol><ol type="1" id="132c370e-b57a-42f8-89ef-d6e777731da5" class="numbered-list" start="2"><li>계산서 항목에 ‘미연결’ 버튼을 눌러 연결된 계산서와 전표내역을 매칭합니다.
(’연결’ 상태인 전표도 연결해제 후, 다른 계산서와 연결할 수 있습니다.)</li></ol></li></ul><p id="1b92024b-fb01-44db-92a8-8aaa83b3a7dd" class="">
</p><p id="d4d653f9-0a24-4e9a-abaa-50e05a712358" class="">
</p><p id="ee725ca0-97e5-448f-b75b-b491c1420279" class="">
</p><h3 id="K_08" class="">* 매입마감 현황조회(상세)</h3><ol type="1" id="af019b65-c95a-4b42-b6d2-d72226b38202" class="numbered-list" start="1"><li>&#x27;매입마감&#x27; &gt; &#x27;매입마감현황&#x27; 화면에서 조회하고자하는 내역을 검색합니다.</li></ol><ol type="1" id="020b6450-456e-482c-ab5f-3af30a2c10fa" class="numbered-list" start="2"><li>내역을 더블클릭하면 마감된 오더내역 및 배차정보를 확인할 수 있습니다.<figure id="dd1917f9-9b9f-4d51-9499-64f2ac672fb5" class="image"><a href="./Help/K/K_14.png"><img style="width:1920px" src="./Help/K/K_14.png"/></a></figure></li></ol></div></article></body></html>