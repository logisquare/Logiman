using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ReqUnipassDetailList
    {
        public string cargMtNo { get; set; }
        public string mblNo    { get; set; }
        public string hblNo    { get; set; }
        public string blYy     { get; set; }
        public string snarSgn  { get; set; }
    }

    public class ResUnipassDetailList
    {
        public List<UnipassDetailListGridModel> list      { get; set; }
    }

    public class UnipassDetailListGridModel
    {
        public string bfhnGdncCn           { get; set; }
        public string cargTrcnRelaBsopTpcd { get; set; }
        public string dclrNo               { get; set; }
        public string pckGcnt              { get; set; }
        public string pckUt                { get; set; }
        public string prcsDttm             { get; set; }
        public string rlbrBssNo            { get; set; }
        public string rlbrCn               { get; set; }
        public string rlbrDttm             { get; set; }
        public string shedNm               { get; set; }
        public string shedSgn              { get; set; }
        public string wght                 { get; set; }
        public string wghtUt               { get; set; }
    }
}