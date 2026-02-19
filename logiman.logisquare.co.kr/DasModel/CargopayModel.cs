using CommonLibrary.CommonModel;
using System.Collections;
using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ApproveHometaxGridModel
    {
        public int    SEQ_NO                 { get; set; }
        public int    CENTER_CODE            { get; set; }
        public string CENTER_NAME            { get; set; }
        public string NTS_CONFIRM_NUM        { get; set; }
        public int    INVOICE_KIND           { get; set; }
        public string INVOICE_KINDM          { get; set; }
        public string WRITE_DATE             { get; set; }
        public string ISSUE_DATE             { get; set; }
        public string INVOICE_TYPE           { get; set; }
        public string TAX_TYPE               { get; set; }
        public double TAX_TOTAL              { get; set; }
        public double SUPPLY_COST_TOTAL      { get; set; }
        public double TOTAL_AMOUNT           { get; set; }
        public string PURPOSE_TYPE           { get; set; }
        public string SERIAL_NUM             { get; set; }
        public string CASH                   { get; set; }
        public string CHKBILL                { get; set; }
        public string CREDIT                 { get; set; }
        public string NOTE                   { get; set; }
        public string REMARK1                { get; set; }
        public string REMARK2                { get; set; }
        public string REMARK3                { get; set; }
        public string MODIFY_CODE            { get; set; }
        public string MODIFY_CODEM           { get; set; }
        public string ORG_NTS_CONFIRM_NUM    { get; set; }
        public string INVOICER_CORP_NUM      { get; set; }
        public string INVOICER_MGT_KEY       { get; set; }
        public string INVOICER_TAX_REGID     { get; set; }
        public string INVOICER_CORP_NAME     { get; set; }
        public string INVOICER_CEO_NAME      { get; set; }
        public string INVOICER_ADDR          { get; set; }
        public string INVOICER_BIZ_TYPE      { get; set; }
        public string INVOICER_BIZ_CLASS     { get; set; }
        public string INVOICER_CONTACT_NAME  { get; set; }
        public string INVOICER_DEPT_NAME     { get; set; }
        public string INVOICER_TEL           { get; set; }
        public string INVOICER_EMAIL         { get; set; }
        public string INVOICEE_CORP_NUM      { get; set; }
        public string INVOICEE_TYPE          { get; set; }
        public string INVOICEE_MGT_KEY       { get; set; }
        public string INVOICEE_TAX_REGID     { get; set; }
        public string INVOICEE_CORP_NAME     { get; set; }
        public string INVOICEE_CEO_NAME      { get; set; }
        public string INVOICEE_ADDR          { get; set; }
        public string INVOICEE_BIZ_TYPE      { get; set; }
        public string INVOICEE_BIZ_CLASS     { get; set; }
        public string INVOICEE_CONTACT_NAME1 { get; set; }
        public string INVOICEE_DEPT_NAME1    { get; set; }
        public string INVOICEE_TEL1          { get; set; }
        public string INVOICEE_EMAIL1        { get; set; }
        public string INVOICEE_CONTACT_NAME2 { get; set; }
        public string INVOICEE_DEPT_NAME2    { get; set; }
        public string INVOICEE_TEL2          { get; set; }
        public string INVOICEE_EMAIL2        { get; set; }
        public string TRUSTEE_CORP_NUM       { get; set; }
        public string TRUSTEE_MGT_KEY        { get; set; }
        public string TRUSTEE_TAX_REGID      { get; set; }
        public string TRUSTEE_CORP_NAME      { get; set; }
        public string TRUSTEE_CEO_NAME       { get; set; }
        public string TRUSTEE_ADDR           { get; set; }
        public string TRUSTEE_BIZ_TYPE       { get; set; }
        public string TRUSTEE_BIZ_CLASS      { get; set; }
        public string TRUSTEE_CONTACT_NAME   { get; set; }
        public string TRUSTEE_DEPT_NAME      { get; set; }
        public string TRUSTEE_TEL            { get; set; }
        public string TRUSTEE_EMAIL          { get; set; }
        public string ISSUE_DATETIME         { get; set; }
        public int    SCAN_SEQ_NO            { get; set; }
        public string EXCEPT_CODE            { get; set; }
        public string FREIGHT_FLAG           { get; set; }
        public string YMD                    { get; set; }
        public string REG_DATE               { get; set; }
        public string TAX_GROUPID            { get; set; }
        public string SCAN_FILENAME          { get; set; }
        public string SCAN_FILE_URL          { get; set; }
        public string PRE_MATCHING_EXISTS    { get; set; }
        public string CLOSING_SEQ_NO         { get; set; }
        public string EXTRA_ACCT_INFO        { get; set; }
        public string ACCT_INFO              { get; set; }
        public string CARD_AGREE_AUTH_TEL    { get; set; }
        public string CARD_AGREE_FLAG        { get; set; }
        public string CARD_AGREE_FLAGM       { get; set; }
        public string CARD_AGREE_YMD         { get; set; }
        public string MODIFY_FLAG            { get; set; } = "N";
        public string MODIFY_NTS_CONFIRM_NUM { get; set; } = "";
    }

    public class ReqApproveHometaxApiList
    {
        public string NTS_CONFIRM_NUM    { get; set; }
        public int    SEQ_NO             { get; set; }
        public int    CENTER_CODE        { get; set; }
        public string CENTER_ID          { get; set; }
        public string CENTER_KEY         { get; set; }
        public int    SCAN_SEQ_NO        { get; set; }
        public string INVOICER_CORP_NUM  { get; set; }
        public string INVOICER_CORP_NAME { get; set; }
        public string INVOICER_CEO_NAME  { get; set; }
        public int    INVOICE_KIND       { get; set; }
        public string DATE_KIND          { get; set; }
        public string FROM_YMD           { get; set; }
        public string TO_YMD             { get; set; }
        public string FREIGHT_FLAG       { get; set; }
        public long   TAX_GROUPID        { get; set; }
        public string MATCHING_FLAG      { get; set; }
        public string PRE_MATCHING_FLAG  { get; set; }
        public int    PAGE_SIZE          { get; set; }
        public int    PAGE_NO            { get; set; }
        public double ORG_AMT            { get; set; } = -1;
    }

    public class ResApproveHometaxApiList
    {
        public List<ApproveHometaxGridModel> list       { get; set; }
        public int                           RECORD_CNT { get; set; }
    }

    public class ResApproveHometaxApiListFromAPI
    {
        public HeaderCommon                           Header  = new HeaderCommon();
        public ResApproveHometaxApiListFromAPIPayload Payload = new ResApproveHometaxApiListFromAPIPayload();
    }

    public class ResApproveHometaxApiListFromAPIPayload
    {
        public List<ApproveHometaxGridModel> List      { get; set; }
        public int                           ListCount { get; set; } = 0;
    }

    public class ApproveHometaxItemModel
    {
        public string NTS_CONFIRM_NUM { get; set; }
        public int    SERIAL_NUM      { get; set; }
        public string PURCHASE_DT     { get; set; }
        public string ITEM_NAME       { get; set; }
        public string SPEC            { get; set; }
        public int    QTY             { get; set; }
        public double UNIT_COST       { get; set; }
        public double SUPPLY_COST     { get; set; }
        public double TAX             { get; set; }
        public string REMARK          { get; set; }
    }

    public class ResApproveHometaxItemList
    {
        public List<ApproveHometaxItemModel> list      { get; set; }
        public int                           RecordCnt { get; set; }
    }

    public class ResApproveHometaxItemListFromAPI
    {
        public HeaderCommon                            Header  = new HeaderCommon();
        public ResApproveHometaxItemListFromAPIPayload Payload = new ResApproveHometaxItemListFromAPIPayload();
    }

    public class ResApproveHometaxItemListFromAPIPayload
    {
        public List<ApproveHometaxItemModel> List      { get; set; }
        public int                           ListCount { get; set; } = 0;
    }

    public class ReqPreMatchingIns
    {
        public int    CENTER_CODE     { get; set; }
        public string NTS_CONFIRM_NUM { get; set; }
        public string CLOSING_SEQ_NO  { get; set; }
    }

    public class ReqPreMatchingDel
    {
        public int    CENTER_CODE     { get; set; }
        public string CLOSING_SEQ_NO  { get; set; }
    }

    public class ResNoMatchTaxList
    {
        public Hashtable list { get; set; }
        public int RECORD_CNT { get; set; }
    }
}