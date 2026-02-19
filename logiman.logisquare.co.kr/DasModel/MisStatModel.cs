using Newtonsoft.Json;
using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class MisStatModel
    {
        public int    CenterCode       { get; set; }
        public string SearchYMD        { get; set; }
        public string OrderItemCode    { get; set; }
        public string ClientName       { get; set; }
        public string AgentName        { get; set; }
        public string AccessCenterCode { get; set; }
    }
    public class ReqStatOrderList
    {
        public int    CenterCode       { get; set; }
        public long   ClientCode       { get; set; }
        public string SearchYMD        { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string OrderItemCodes   { get; set; }
        public long   GoodsSeqNo       { get; set; }
        public string ClientName       { get; set; }
        public string AgentCode        { get; set; }
        public string AgentName        { get; set; }
        public string AccessCenterCode { get; set; }
        public int    ListType         { get; set; }
    }

    public class ResStatOrderList
    {
        public string                   SeriesName { get; set; }
        public List<StatOrderGridModel> data       { get; set; }

        public ResStatOrderList(string seriesName)
        {
            this.SeriesName = seriesName;
            this.data       = new List<StatOrderGridModel>();
        }
    }

    public class StatOrderGridModel
    {
        public string target_date                        { get; set; }
        public string YY                                 { get; set; }
        public string MM                                 { get; set; }
        public string DD                                 { get; set; }
        public int    order_count                        { get; set; }
        public int    order_count_cumulative             { get; set; }
        public double sales_amount                       { get; set; }
        public double sales_amount_cumulative            { get; set; }
        public double purchase_amount                    { get; set; }
        public double purchase_amount_cumulative         { get; set; }
        public double monthly_purchase_amount            { get; set; }
        public double monthly_purchase_amount_cumulative { get; set; }
        public double profit_amount                       { get; set; }
        public double profit_amount_cumulative            { get; set; }
        public double centerfee_amount                   { get; set; }
        public double centerfee_amount_cumulative        { get; set; }
        public double return_on_sales                    { get; set; }
        public double return_on_sales_cumulative         { get; set; }
        public int    center_code                        { get; set; }
        public string center_name                        { get; set; }
        public long   client_code                        { get; set; }
        public string client_name                        { get; set; }
        public string agent_code                         { get; set; }
        public string agent_name                         { get; set; }
    }

    public class ReqMonthList
    {
        public string DateFrom { get; set; }
        public string DateTo   { get; set; }
    }

    public class ResMonthList
    {
        public List<MonthModel> list { get; set; }
    }

    public class MonthModel
    {
        public string YMD           { get; set; }
        public string WORK_DAYS     { get; set; }
        public string HOLIDAY_FLAG  { get; set; }
        public string WEEK_NUM      { get; set; }
        public string WEEK_STR      { get; set; }
    }

    public class ResponseClientGrouping
    {
        public List<ResultDataClientGrouping> data { get; set; }
    }

    public class ResultDataClientGrouping
    {
        public string DD             { get; set; }
        public string MM             { get; set; }
        public string YY             { get; set; }
        public int    center_code    { get; set; }
        public string center_name    { get; set; }
        public long   client_code    { get; set; }
        public string client_name    { get; set; }
        public long   consignor_code { get; set; }
        public string consignor_name { get; set; }
        public string agent_code     { get; set; }
        public string agent_name     { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int total_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int applied_order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int applied_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int Unapplied_order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int Unapplied_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double apply_rate_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double apply_rate { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double profit_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double profit_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double return_on_sales { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double return_on_sales_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double sales_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double sales_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double purchase_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double purchase_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double monthly_purchase_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double monthly_purchase_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double centerfee_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double centerfee_amount_cumulative { get; set; }

        public string target_date { get; set; }
    }

    public class ResponseAgentGrouping
    {
        public List<ResultDataAgentGrouping> data { get; set; }
    }

    public class ResultDataAgentGrouping
    {
        public string DD          { get; set; }
        public string MM          { get; set; }
        public string YY          { get; set; }
        public int    center_code { get; set; }
        public string center_name { get; set; }
        public string agent_code  { get; set; }
        public string agent_name  { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int total_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int applied_order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int applied_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int Unapplied_order_count { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public int Unapplied_order_count_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double apply_rate { get; set; }


        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double profit_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double profit_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double return_on_sales { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double return_on_sales_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double sales_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double sales_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double purchase_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double purchase_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double monthly_purchase_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double monthly_purchase_amount_cumulative { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double centerfee_amount { get; set; }
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Populate, NullValueHandling = NullValueHandling.Ignore)]
        public double centerfee_amount_cumulative { get; set; }

        public string target_date { get; set; }
    }

    public class ChartStruct
    {
        public List<ChartItem> ChartItems { get; set; }
        public ChartStruct()
        {
            ChartItems = new List<ChartItem>();
        }
    }

    public class ChartItem
    {
        public string    ItemKey  { get; set; }
        public ChartData ItemData { get; set; }
        public ChartNewData ItemNewData { get; set; }

        public ChartItem(string itemKey)
        {
            this.ItemKey = itemKey;
        }
    }

    public class ChartData
    {
        public string       ItemName                 { get; set; }
        public double       OrderCountSum            { get; set; }
        public double       ProfitAmountSum          { get; set; }
        public double       ReturnOnSalesSum         { get; set; }
        public double       SalesAmountSum           { get; set; }
        public double       PurchaseAmountSum        { get; set; }
        public double       MonthlyPurchaseAmountSum { get; set; }
        public double       CenterFeeAmountSum       { get; set; }
        public List<string> TickValues               { get; set; }
        public ChartSubData ItemValues               { get; set; }

        public ChartData(string itemName, double orderCountSum, double profitAmountSum, double returnOnSalesSum, double salesAmountSum, double PurchaseAmountSum, double MonthlyPurchaseAmountSum, double CenterFeeAmountSum)
        {
            this.ItemName                 = itemName;
            this.OrderCountSum            = orderCountSum;
            this.ProfitAmountSum           = profitAmountSum;
            this.ReturnOnSalesSum         = returnOnSalesSum;
            this.SalesAmountSum           = salesAmountSum;
            this.PurchaseAmountSum        = PurchaseAmountSum;
            this.MonthlyPurchaseAmountSum = MonthlyPurchaseAmountSum;
            this.CenterFeeAmountSum       = CenterFeeAmountSum;
            this.TickValues               = new List<string>();
        }
    }

    public class ChartNewData
    {
        public string          ItemName                         { get; set; }
        public int             CenterCode                       { get; set; }
        public int             order_count                      { get; set; }
        public int             order_count_cumulative           { get; set; }
        public int             total_order_count_cumulative     { get; set; }
        public int             applied_order_count              { get; set; }
        public int             applied_order_count_cumulative   { get; set; }
        public int             Unapplied_order_count            { get; set; }
        public int             Unapplied_order_count_cumulative { get; set; }
        public List<string>    TickValues                       { get; set; }
        public ChartNewSubData ItemValues                       { get; set; }

        public ChartNewData(string itemName, int CenterCode, int order_count_cumulative, int total_order_count_cumulative, int applied_order_count_cumulative, int Unapplied_order_count_cumulative)
        {
            this.ItemName                         = itemName;
            this.CenterCode                       = CenterCode;
            this.order_count_cumulative           = order_count_cumulative;
            this.total_order_count_cumulative     = total_order_count_cumulative;
            this.applied_order_count_cumulative   = applied_order_count_cumulative;
            this.Unapplied_order_count_cumulative = Unapplied_order_count_cumulative;
            this.TickValues                       = new List<string>();
        }
    }

    public class ChartNewSubData
    {
        public List<int> order_count                      { get; set; }
        public List<int> order_count_cumulative           { get; set; }
        public List<int> total_order_count_cumulative     { get; set; }
        public List<int> applied_order_count              { get; set; }
        public List<int> applied_order_count_cumulative   { get; set; }
        public List<int> Unapplied_order_count            { get; set; }
        public List<int> Unapplied_order_count_cumulative { get; set; }
        public List<double> apply_rate                       { get; set; }

        public ChartNewSubData()
        {
            this.order_count                      = new List<int>();
            this.order_count_cumulative           = new List<int>();
            this.total_order_count_cumulative     = new List<int>();
            this.applied_order_count              = new List<int>();
            this.applied_order_count_cumulative   = new List<int>();
            this.Unapplied_order_count            = new List<int>();
            this.Unapplied_order_count_cumulative = new List<int>();
            this.apply_rate                       = new List<double>();
        }
    }

    public class ChartSubData
    {
        public List<double> OrderCount               { get; set; }
        public List<double> OrderCountSum            { get; set; }
        public List<double> ProfitAmount             { get; set; }
        public List<double> ProfitAmountSum          { get; set; }
        public List<double> ReturnOnSales            { get; set; }
        public List<double> ReturnOnSalesSum         { get; set; }
        public List<double> SalesAmount              { get; set; }
        public List<double> SalesAmountSum           { get; set; }
        public List<double> PurchaseAmount           { get; set; }
        public List<double> PurchaseAmountSum        { get; set; }
        public List<double> MonthlyPurchaseAmount    { get; set; }
        public List<double> MonthlyPurchaseAmountSum { get; set; }
        public List<double> CenterFeeAmount          { get; set; }
        public List<double> CenterFeeAmountSum       { get; set; }


        public ChartSubData()
        {
            this.OrderCount               = new List<double>();
            this.OrderCountSum            = new List<double>();
            this.ProfitAmount              = new List<double>();
            this.ProfitAmountSum           = new List<double>();
            this.ReturnOnSales            = new List<double>();
            this.ReturnOnSalesSum         = new List<double>();
            this.SalesAmount              = new List<double>();
            this.SalesAmountSum           = new List<double>();
            this.PurchaseAmount           = new List<double>();
            this.PurchaseAmountSum        = new List<double>();
            this.MonthlyPurchaseAmount    = new List<double>();
            this.MonthlyPurchaseAmountSum = new List<double>();
            this.CenterFeeAmount          = new List<double>();
            this.CenterFeeAmountSum       = new List<double>();
        }
    }


    public class ReqAutometicList
    {
        public int      SearchType      { get; set; }
        public int      GroupType       { get; set; }
        public string   SearchYMD       { get; set; }
        public string   DataFrom        { get; set; }
        public string   DataTo          { get; set; }
        public int      CenterCode      { get; set; }
        public string   OrderItemCodes  { get; set; }
        public string   ClientName      { get; set; }

        public string   AgentName       { get; set; }
        public string   ConsignorName   { get; set; }
        public string   AccessCenterCode { get; set; }
    }

    public class ResAutometicList
    {
        public List<AutometicList>           list       { get; set; }
        public List<AutometicBarList>        Barlist    { get; set; }
        public List<AutometicDetaillistList> Detaillist { get; set; }
        public List<AutometicModList>        Modlist    { get; set; }
    }

    public class AutometicList
    {
        public int      OrderCnt                { get; set; }
        public int      UnappliedOrderCnt       { get; set; }
        public double   UnappliedOrderRate      { get; set; }
        public double   UnappliedProfitRate     { get; set; }
        public int      AppliedOrderCnt         { get; set; }
        public double   AppliedOrderRate        { get; set; }
        public double   AppliedProfitRate       { get; set; }
        public int      ModSaleOrderCnt         { get; set; }
        public double   ModSaleOrderRate        { get; set; }
        public int      UnModSaleOrderCnt       { get; set; }
        public double   UnModSaleOrderRate      { get; set; }
        public double   SaleSupplyAmt           { get; set; }
        public double   OrgSaleSupplyAmt        { get; set; }
        public double   DiffSaleSupplyAmt       { get; set; }
        public int      ModPurchaseOrderCnt     { get; set; }
        public double   ModPurchaseOrderRate    { get; set; }
        public int      UnModPurchaseOrderCnt   { get; set; }
        public double   UnModPurchaseOrderRate  { get; set; }
        public double   PurchaseSupplyAmt       { get; set; }
        public double   OrgPurchaseSupplyAmt    { get; set; }
        public double   DiffPurchaseSupplyAmt   { get; set; }
    }

    public class AutometicBarList { 
        public string   YMD { get; set; }
        public string   YY { get; set; }
        public string   MM { get; set; }
        public int      UnappliedOrderCnt { get; set; }
        public int      AccuUnappliedOrderCnt { get; set; }
        public int      AppliedOrderCnt { get; set; }
        public int      AccuAppliedOrderCnt { get; set; }
    }

    public class AutometicDetaillistList { 
        public int      CenterCode              { get; set; }
        public string   CenterName              { get; set; }
        public string   PayClientCode           { get; set; }
        public string   ClientName              { get; set; }
        public string   ConsignorCode           { get; set; }
        public string   ConsignorName           { get; set; }
        public string   AgentCode               { get; set; }
        public string   AgentName               { get; set; }

        public int      OrderCnt                { get; set; }
        public int      AppliedOrderCnt         { get; set; }
        public int      UnappliedOrderCnt       { get; set; }
        public double   AppliedOrderRate        { get; set; }
        public double   SaleSupplyAmt           { get; set; }
        public double   PurchaseSupplyAmt       { get; set; }
        public double   ProfitSupplyAmt         { get; set; }
        public double   ProfitRate              { get; set; }

        public double   AppliedSaleSupplyAmt    { get; set; }
        public double   AppliedPurchaseSupplyAmt    { get; set; }
        public double   AppliedProfitSupplyAmt      { get; set; }
        public double   AppliedProfitRate           { get; set; }
        public double   UnappliedSaleSupplyAmt      { get; set; }
        public double   UnappliedPurchaseSupplyAmt  { get; set; }
        public double   UnappliedProfitSupplyAmt    { get; set; }
        public double   UnappliedProfitRate         { get; set; }
    }

    public class AutometicModList {
        public int      CenterCode              { get; set; }
        public string   CenterName              { get; set; }
        public string   PayClientCode           { get; set; }
        public string   ClientName              { get; set; }
        public string   ConsignorCode           { get; set; }
        public string   ConsignorName           { get; set; }
        public string   AgentCode               { get; set; }
        public string   AgentName               { get; set; }
        public int      AppliedOrderCnt         { get; set; }
        public int      ModSaleOrderCnt         { get; set; }
        public double   DiffSaleSupplyAmt       { get; set; }
        public double   ModSaleOrderRate        { get; set; }
        public double   ModPurchaseOrderCnt     { get; set; }
        public double   DiffPurchaseSupplyAmt   { get; set; }
        public double   ModPurchaseOrderRate    { get; set; }
        public double   OrgSaleSupplyAmt        { get; set; }
        public double   OrgPurchaseSupplyAmt    { get; set; }
        public double   OrgProfitSupplyAmt      { get; set; }
        public double   OrgProfitRate           { get; set; }
        public double   SaleSupplyAmt           { get; set; }
        public double   PurchaseSupplyAmt       { get; set; }
        public double   ProfitSupplyAmt         { get; set; }
        public double   ProfitRate              { get; set; }
    }

    public class ReqStatCarDispatchList
    {
        public long   SeqNo            { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string SearchYM         { get; set; }
        public string PickupYMD        { get; set; }
        public string PickupYear       { get; set; }
        public string PickupYearMonth  { get; set; }
        public int    BaseYear         { get; set; }
        public int    BaseMonth        { get; set; }
        public int    BaseWeek         { get; set; }
        public int    CenterCode       { get; set; }
        public int    TransType        { get; set; }
        public string OrderItemCode    { get; set; }
        public string OrderItemCodes   { get; set; }
        public string AgentCode        { get; set; }
        public string AgentName        { get; set; }
        public long   OrderClientCode  { get; set; }
        public long   PayClientCode    { get; set; }
        public long   ConsignorCode    { get; set; }
        public string ClientName       { get; set; }
        public string ConsignorName    { get; set; }
        public int    CarDivType       { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResStatCarDispatchList
    {
        public List<ResultStatCarDispatcList> list                { get; set; }
        public int                            RecordCnt           { get; set; }
        public int                            CarDivTypeCnt       { get; set; }
        public int                            CarDivType3Cnt      { get; set; }
        public int                            CarDivType5Cnt      { get; set; }
        public double                         CarDivTypeSale      { get; set; }
        public double                         CarDivType3Sale     { get; set; }
        public double                         CarDivType5Sale     { get; set; }
        public double                         CarDivTypePurchase  { get; set; }
        public double                         CarDivType3Purchase { get; set; }
        public double                         CarDivType5Purchase { get; set; }
    }

    public class ResultStatCarDispatcList
    {
        public string SeqNo             { get; set; }
        public string PickupYMD         { get; set; }
        public string PickupYear        { get; set; }
        public string PickupYearMonth   { get; set; }
        public int    BaseYear          { get; set; }
        public int    BaseMonth         { get; set; }
        public int    BaseWeek          { get; set; }
        public int    CenterCode        { get; set; }
        public string CenterName        { get; set; }
        public int    TransType         { get; set; }
        public string OrderItemCodes    { get; set; }
        public string AgentCode         { get; set; }
        public string AgentName         { get; set; }
        public string OrderClientCode   { get; set; }
        public string PayClientCode     { get; set; }
        public string ClientName        { get; set; }
        public string ConsignorCode     { get; set; }
        public string ConsignorName     { get; set; }
        public int    CarDivType        { get; set; }
        public string CarDivTypeM       { get; set; }
        public int    OrderCnt          { get; set; }
        public double SaleSupplyAmt     { get; set; }
        public double PurchaseSupplyAmt { get; set; }
        public double SalesProfitAmt    { get; set; }
        public double ProfitRate        { get; set; }
        public double ExclusiveRate     { get; set; }
        public string RegDate           { get; set; }
        public double SalesProfitAmt3   { get; set; }
        public double SalesProfitAmt5   { get; set; }
        public double ProfitRate3       { get; set; }
        public double ProfitRate5       { get; set; }
    }

    public class ReqStatCarDivTypeList
    {
        public string SearchYM         { get; set; }
        public int    CenterCode       { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResStatCarDivTypeList
    {
        public List<ResultStatCarDivTypeList> list           { get; set; }
        public double                            CarDivType1Cnt { get; set; }
        public double                            CarDivType4Cnt { get; set; }
        public double                            CarDivType6Cnt { get; set; }

        public double CarDivType1UseCarCnt { get; set; }
        public double CarDivType4UseCarCnt { get; set; }
        public double CarDivType6UseCarCnt { get; set; }
    }

    public class ResultStatCarDivTypeList
    {
        public int    CenterCode             { get; set; }
        public string CenterName             { get; set; }
        public string target_date            { get; set; }
        public string YY                     { get; set; }
        public string MM                     { get; set; }
        public int    CarDivType1Cnt         { get; set; }
        public int    CarDivType4Cnt         { get; set; }
        public int    CarDivType6Cnt         { get; set; }
        public int    TotCarDivTypeCnt       { get; set; }
        public int    CarDivType1UseCarCnt   { get; set; }
        public int    CarDivType4UseCarCnt   { get; set; }
        public int    CarDivType6UseCarCnt   { get; set; }
        public int    TotCarDivTypeUseCarCnt { get; set; }
    }

    public class CarDivChartStruct
    {
        public List<CarDivChartItem> ChartItems { get; set; }
        public CarDivChartStruct()
        {
            ChartItems = new List<CarDivChartItem>();
        }
    }

    public class CarDivChartItem
    {
        public string            ItemKey    { get; set; }
        public CarDivChartData   ItemData   { get; set; }
        public CarDivChartItem(string itemKey)
        {
            this.ItemKey = itemKey;
        }
    }
    
    public class CarDivChartData
    {
        public string             CenterName              { get; set; }
        public double             SumCarDivType1Cnt       { get; set; }
        public double             SumCarDivType4Cnt       { get; set; }
        public double             SumCarDivType6Cnt       { get; set; }
        public double             SumCarDivType1UseCarCnt { get; set; }
        public double             SumCarDivType4UseCarCnt { get; set; }
        public double             SumCarDivType6UseCarCnt { get; set; }
        public List<string>       TickValues              { get; set; }
        public CarDivChartSubData ItemValues              { get; set; }

        public CarDivChartData(string CenterName, double SumCarDivType1Cnt, double SumCarDivType4Cnt, double SumCarDivType6Cnt, double SumCarDivType1UseCarCnt, double SumCarDivType4UseCarCnt, double SumCarDivType6UseCarCnt)
        {
            this.CenterName              = CenterName;
            this.SumCarDivType1Cnt       = SumCarDivType1Cnt;
            this.SumCarDivType4Cnt       = SumCarDivType4Cnt;
            this.SumCarDivType6Cnt       = SumCarDivType6Cnt;
            this.SumCarDivType1UseCarCnt = SumCarDivType1UseCarCnt;
            this.SumCarDivType4UseCarCnt = SumCarDivType4UseCarCnt;
            this.SumCarDivType6UseCarCnt = SumCarDivType6UseCarCnt;
            this.TickValues              = new List<string>();
        }
    }

    public class CarDivChartSubData
    {
        public List<int> CarDivType1Cnt { get; set; }
        public List<int> CarDivType4Cnt { get; set; }
        public List<int> CarDivType6Cnt { get; set; }
        public List<int> TotalCnt       { get; set; }

        public List<int> CarDivType1UseCarCnt   { get; set; }
        public List<int> CarDivType4UseCarCnt   { get; set; }
        public List<int> CarDivType6UseCarCnt   { get; set; }
        public List<int> TotCarDivTypeUseCarCnt { get; set; }

        public CarDivChartSubData()
        {
            this.CarDivType1Cnt = new List<int>();
            this.CarDivType4Cnt = new List<int>();
            this.CarDivType6Cnt = new List<int>();
            this.TotalCnt       = new List<int>();

            this.CarDivType1UseCarCnt   = new List<int>();
            this.CarDivType4UseCarCnt   = new List<int>();
            this.CarDivType6UseCarCnt   = new List<int>();
            this.TotCarDivTypeUseCarCnt = new List<int>();
        }
    }

    public class ReqStatTransRateSummaryList
    {
        public string FromYMD          { get; set; }
        public string ToYMD            { get; set; }
        public string PreMonFromYMD    { get; set; }
        public string PreMonToYMD      { get; set; }
        public int    CenterCode       { get; set; }
        public string OrderItemCodes   { get; set; }
        public string ClientName       { get; set; }
        public string AgentName        { get; set; }
        public string ConsignorName    { get; set; }
        public string AccessCenterCode { get; set; }
    }

    public class ResStatTransRateSummaryList
    {
        public List<ResultStatTransRateSummaryList> list           { get; set; }
        public string                               PreWeekFromYMD { get; set; }
        public string                               PreWeekToYMD { get; set; }
    }

    public class ResultStatTransRateSummaryList
    {
        public int    OrderCnt                       { get; set; }
        public int    UnappliedOrderCnt              { get; set; }
        public int    AppliedOrderCnt                { get; set; }
        public double AppliedSaleSupplyAmt           { get; set; }
        public double AppliedPurchaseSupplyAmt       { get; set; }
        public double UnappliedSaleSupplyAmt         { get; set; }
        public double UnappliedPurchaseSupplyAmt     { get; set; }
        public double UnappliedOrderRate             { get; set; }
        public double AppliedOrderRate               { get; set; }
        public double UnappliedProfitRate            { get; set; }
        public double AppliedProfitRate              { get; set; }
        public int    PreWOrderCnt                   { get; set; }
        public int    PreWUnappliedOrderCnt          { get; set; }
        public int    PreWAppliedOrderCnt            { get; set; }
        public double PreWAppliedSaleSupplyAmt       { get; set; }
        public double PreWAppliedPurchaseSupplyAmt   { get; set; }
        public double PreWUnappliedSaleSupplyAmt     { get; set; }
        public double PreWUnappliedPurchaseSupplyAmt { get; set; }
        public double PreWUnappliedOrderRate         { get; set; }
        public double PreWAppliedOrderRate           { get; set; }
        public double PreWUnappliedProfitRate        { get; set; }
        public double PreWAppliedProfitRate          { get; set; }
        public int    PreMOrderCnt                   { get; set; }
        public int    PreMUnappliedOrderCnt          { get; set; }
        public int    PreMAppliedOrderCnt            { get; set; }
        public double PreMAppliedSaleSupplyAmt       { get; set; }
        public double PreMAppliedPurchaseSupplyAmt   { get; set; }
        public double PreMUnappliedSaleSupplyAmt     { get; set; }
        public double PreMUnappliedPurchaseSupplyAmt { get; set; }
        public double PreMAppliedOrderRate           { get; set; }
        public double PreMUnappliedOrderRate         { get; set; }
        public double PreMUnappliedProfitRate        { get; set; }
        public double PreMAppliedProfitRate          { get; set; }
    }
}

