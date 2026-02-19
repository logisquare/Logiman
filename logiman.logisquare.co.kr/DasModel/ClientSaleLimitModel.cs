using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ClientSaleLimit
    {
        public string YMD           { get; set; }
        public long   ClientCode    { get; set; }
        public int    CenterCode    { get; set; }
        public string CenterName    { get; set; }
        public string ClientName    { get; set; }
        public long   SaleSupplyAmt { get; set; }
        public string RegDate       { get; set; }
        public string UpdDate       { get; set; }
    }

    public class ReqClientSaleLimitList
    {
        public long   ClientCode       { get; set; }
        public int    CenterCode       { get; set; }
        public string ClientName       { get; set; }
        public string DateFrom         { get; set; }
        public string DateTo           { get; set; }
        public string AccessCenterCode { get; set; }
        public int    PageSize         { get; set; }
        public int    PageNo           { get; set; }
    }

    public class ResClientSaleLimitList
    {
        public List<ClientSaleLimit> list      { get; set; }
        public int                   RecordCnt { get; set; }
    }
    
    public class ReqClientSaleLimit
    {
        public string YMD        { get; set; }
        public int    CenterCode { get; set; }
        public long   ClientCode { get; set; }
        public long   OrderNo    { get; set; }

    }

    public class ResClientSaleLimit
    {
        public int    ClientBusinessStatus { get; set; }
        public string LimitCheckFlag       { get; set; }
        public string LimitAvailFlag       { get; set; }
        public double SaleLimitAmt         { get; set; }
        public double LimitAvailAmt        { get; set; }
        public double RevenueLimitPer      { get; set; }
        public double TotalSaleAmt         { get; set; }
        public double TotalPurchaseAmt     { get; set; }
    }
}