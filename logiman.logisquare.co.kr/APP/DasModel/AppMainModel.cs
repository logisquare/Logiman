using System;
using System.Collections.Generic;

namespace CommonLibrary.DasServices
{

    public class ReqMainList
    {
        public string   AdminID             { get; set; }
        public string   AccessCenterCode    { get; set; }
    }

    public class ResMainList
    {
        public List<ResMainListViewModel> list { get; set; }
        public int AcceptOrderCnt   { get; set; }
        public int DispatchOrderCnt { get; set; }
    }

    public class ResMainListViewModel
    { 
        public string   PickupYMD   { get; set; }
        public double   SaleAmt     { get; set; }
        public double   PurchaseAmt { get; set; }
        public double   ProfitAmt   { get; set; }
        public double   ProfitRate   { get; set; }

    }
}