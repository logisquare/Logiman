<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="L_01.aspx.cs" Inherits="Help.L_01" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>매출마감</title><style>
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
.select-value-color-translucentGray { background-color: rgba(255, 255, 255, 0.0375); }
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
	
</style></head><body><article id="3c77a7a6-a692-4b60-800b-a235cba40075" class="page sans"><header><div class="page-header-icon undefined"><img class="icon" src="https://www.notion.so/icons/sign-in_blue.svg"/></div><h1 class="page-title">매출마감</h1></header><div class="page-body"><p id="eb1df0f0-2be8-41bc-8d2f-619f7b60c44c" class="block-color-yellow_background">* 매출계산서 발행 및 수정발행, 주요내용 메모 등 매출 관련 업무를 진행하는 화면입니다.</p><p id="0853ee1a-3316-4066-8f53-b4745a1ea568" class="">
</p><p id="f9ea45dd-669c-40a9-adf4-e26da3571631" class=""><mark class="highlight-red">[아래 버튼을 누르면 해당 설명으로 이동합니다]</mark></p><nav id="4e3e8f35-73ae-494b-89bc-f28b4b416109" class="block-color-gray table_of_contents"><div class="table_of_contents-item table_of_contents-indent-0"><a class="table_of_contents-link" href="#L_01">매출마감</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#L_02">* 매출 등록 거래처 조회하기</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#L_03">* 매출마감하기</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#L_04">* 매출 계산서 별도발행/별도발행 취소</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#L_05">* 계산서 발행내역 확인</a></div><div class="table_of_contents-item table_of_contents-indent-1"><a class="table_of_contents-link" href="#L_06">* 전표 메모작성</a></div></nav><p id="9cdc54db-27a6-4c9b-a077-b489ecff6a2b" class="">
</p><p id="92ab8e15-695d-4caa-8dcd-527846cbcbd3" class="">
</p><p id="0d101850-debb-4213-beb2-b17b3a209095" class="">
</p><h1 id="L_01" class="">매출마감</h1><h3 id="L_02" class="">* 매출 등록 거래처 조회하기</h3><ol type="1" id="f7cd68c8-2680-4bb4-bdb1-411f5b7eb605" class="numbered-list" start="1"><li>회원사를 선택합니다. (조건 조회 전, 선행되어야하는 필수 선택값입니다.)<ul id="e6fab5e9-15b2-4317-961e-0ba146367af4" class="bulleted-list"><li style="list-style-type:disc"><mark class="highlight-red_background">2개 이상의 가맹점을 조회할 수 있는 계정인 경우에만 표시됩니다.</mark>
</li></ul></li></ol><ol type="1" id="4054751c-973e-4b62-8348-8bf234c780bf" class="numbered-list" start="2"><li>조회버튼을 클릭하면 해당 기간 내에 등록된 거래처의 사업자정보가 금액과 함께 표시됩니다.<figure id="f1f6553f-85f5-44a6-bb7c-43ac65ff0f39" class="image"><a href="./Help/L/L_01.png"><img style="width:1922px" src="./Help/L/L_01.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="58be93f6-93da-46b6-a401-3e605f618b69" class="numbered-list" start="3"><li>사업자정보를 클릭하면 거래처의 오더정보가 표시됩니다.
(노란색 : 이월 오더정보)<figure id="148496fe-b466-4b79-92cc-7440ffd1df28" class="image"><a href="./Help/L/L_02.png"><img style="width:1922px" src="./Help/L/L_02.png"/></a><figcaption>  </figcaption></figure></li></ol><p id="006645fa-006d-4e17-a110-8847f9e4accd" class="">
</p><p id="fcc273ea-22ea-46b9-b32a-378693fafd98" class="">
</p><p id="52327ee7-f09c-4157-bb7c-a778b79f0c86" class="">
</p><h3 id="L_03" class="">* 매출마감하기</h3><ol type="1" id="d612c461-8712-4656-b8ad-60da1eecdb0c" class="numbered-list" start="1"><li>회원사를 선택합니다.</li></ol><ol type="1" id="a87f9847-a17d-4a0d-b991-dcf52bf98da9" class="numbered-list" start="2"><li>검색하고자하는 일자와 조건들을 선택하여 오더를 검색합니다.<figure id="b4eabb21-ac83-4d00-a851-d78732a9cb3d" class="image"><a href="./Help/L/L_03.png"><img style="width:1922px" src="./Help/L/L_03.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="982d979d-0248-4466-8371-ecc4cdb34bd7" class="numbered-list" start="3"><li>검색한 조건에 포함되는 청구처 정보는 좌측 [거래처] 내역에 노출됩니다.<figure id="042ba126-faa1-4a02-9554-71689d175f62" class="image"><a href="./Help/L/L_04.png"><img style="width:1922px" src="./Help/L/L_04.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="e97da875-8bbe-435d-b778-d8e48f78d867" class="numbered-list" start="4"><li>거래처 내역에서 조회하고자 하는 거래처를 더블클릭 또는 선택하면 우측 운송내역에 해당 오더가 표시됩니다.
(노란색 행 : 이월된 오더)<figure id="d3fd89c7-9b40-429c-b378-39023782f775" class="image"><a href="./Help/L/L_05.png"><img style="width:1922px" src="./Help/L/L_05.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="f0943931-84ff-4289-98f0-c4531542683c" class="numbered-list" start="5"><li>해당 거래처와 마감할 오더의 금액을 확인한 다음 오더를 선택하여 오른쪽 상단에 ‘일괄마감’, ‘개별마감’ 버튼을 통해 매출마감을 진행합니다.<figure id="ce07186b-b965-4268-8a6a-503dad8a48ac" class="image"><a href="./Help/L/L_06.png"><img style="width:1922px" src="./Help/L/L_06.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="4e39fecf-a128-4a71-bf66-37f7c83277c0" class="numbered-list" start="6"><li>마감과 동시에 “매출마감전표번호”가 생성됩니다. (매출마감전표는 다음과 같은 규칙으로 생성됩니다.)
ex. 매출전표 : 2304060081095
      앞 6자리 (23년 04월 06일) + 00 + 뒷 5자리 (1 ~ 99,999까지의 순차부여)</li></ol><p id="0bc05943-d7ae-4e09-a211-fcdf21543338" class="">
</p><p id="1c73ffef-a70f-41de-9e36-db8aab1502f5" class="">
</p><p id="b8b0ecef-70d9-4a33-a9b5-8cce7dbfedd8" class="">
</p><h3 id="L_04" class="">* 매출 계산서 별도발행/별도발행 취소</h3><ol type="1" id="2544aa0d-3dec-44a7-b60b-053738ad520d" class="numbered-list" start="1"><li>별도발행 : 계산서가 연결되지 않은 매출전표를 체크한 다음 ‘별도발행’을 선택합니다.
별도발행취소 : 별도발행된 전표를 체크한 다음 ‘별도발행취소’을 선택합니다.<figure id="2fbf0e28-0624-4917-9bde-ca0f49e5b924" class="image"><a href="./Help/L/L_07.png"><img style="width:1922px" src="./Help/L/L_07.png"/></a><figcaption>  </figcaption></figure></li></ol><ol type="1" id="15d2fc3f-0c99-4bf9-b603-2891e53d71d0" class="numbered-list" start="2"><li>별도발행 시 계산서의 종류, 작성일, 발행일을 선택하여 ‘등록’ 버튼을 클릭합니다. <mark class="highlight-red">(*는 필수값)</mark><figure id="7606decb-19c3-4bbd-9ef6-8640a25bfa81" class="image"><a href="./Help/L/L_08.png"><img style="width:1920px" src="./Help/L/L_08.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="e54f5bff-faa7-4ab5-811b-4888e78e86f4" class="numbered-list" start="3"><li>‘별도발행취소’ 버튼 클릭 시, 별도발행여부를 확인한 뒤 취소를 진행합니다.
(별도발행 매출전표가 아닌 경우 취소 불가)<figure id="5a55f3ab-cf09-4b55-9fb1-a56507923ce1" class="image"><a href="./Help/L/L_09.png"><img style="width:1922px" src="./Help/L/L_09.png"/></a><figcaption> </figcaption></figure></li></ol><p id="b5cb6da2-c57f-4e67-9b4e-25f11eebfb57" class="">
</p><p id="82225204-4755-4a6d-a52f-fe4f593a116e" class="">
</p><p id="06283d80-dfcb-4ea1-b104-b14127820b9a" class="">
</p><h3 id="L_05" class="">* 계산서 발행내역 확인</h3><ol type="1" id="1fd5d3a0-e435-42de-9081-e8543b1b3ae3" class="numbered-list" start="1"><li>매출마감현황 화면의 우측 상단 ‘계산서 발행내역’ 버튼을 클릭합니다.<figure id="5696e687-5d58-4c78-9924-81ae5b529c7e" class="image"><a href="./Help/L/L_10.png"><img style="width:1922px" src="./Help/L/L_10.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="c6bf939e-a9ef-4bbd-997b-8dce1aca97cc" class="numbered-list" start="2"><li>작성일자를 기준으로 발행된 계산서 내역을 조회할 수 있습니다.<figure id="883541c0-bd66-48d3-9e22-ede9e65593f1" class="image"><a href="./Help/L/L_11.png"><img style="width:1486px" src="./Help/L/L_11.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="57a44427-c102-49b2-8b8d-8216e0647a71" class="numbered-list" start="3"><li>발행된 계산서 내역을 더블클릭하면 발행된 계산서 정보를 확인할 수 있고, 하단에 ‘수정발행’ 버튼으로 발행된 계산서의 수정발행 또한 가능합니다.<figure id="39aae5fe-047b-4df7-b51d-eed1b89bae16" class="image"><a href="./Help/L/L_12.png"><img style="width:1136px" src="./Help/L/L_12.png"/></a><figcaption> </figcaption></figure></li></ol><p id="3b29d208-fe6b-49ba-a0f6-bc4c4c53394d" class="">
</p><p id="f95d0433-029d-4269-a1a5-029e93d7d16f" class="">
</p><p id="b13da87e-1950-4a57-947c-39aad4e8e7a5" class="">
</p><h3 id="L_06" class="">* 전표 메모작성</h3><ol type="1" id="4ce246c9-d734-423d-bd54-67c754dd00ca" class="numbered-list" start="1"><li>매출마감 &gt; 매출마감현황 화면에서 항목 중 ‘메모’의 그리드를 더블클릭하면 텍스트 입력이 가능합니다.<figure id="f64a19ec-e9b9-4d97-89b0-b2a7a8cad464" class="image"><a href="./Help/L/L_13.png"><img style="width:1922px" src="./Help/L/L_13.png"/></a><figcaption> </figcaption></figure></li></ol><ol type="1" id="f3cacad8-f851-438b-94c5-0f3adca9a672" class="numbered-list" start="2"><li>‘등록’ 버튼을 클릭하여, 등록작성한 메모를 저장합니다.<figure id="67c6c479-e2ea-43d3-a6bf-e14c4e70c6a0" class="image"><a href="./Help/L/L_14.png"><img style="width:1920px" src="./Help/L/L_14.png"/></a><figcaption> </figcaption></figure></li></ol><p id="bd0c022d-8dbc-4fdc-93bb-b621aaf08a52" class="">
</p><p id="e251c186-f6cf-4a1a-960e-75899799b24b" class="">
</p><p id="0861c34f-a4ac-4e1b-894b-65b22a9f0d41" class="">
</p></div></article></body></html>