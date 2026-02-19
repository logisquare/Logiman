using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;

namespace TMS.Common
{
    public partial class SpecialNote : PageBase
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            _pageAccessType = PageAccessType.ReadWrite;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetInitData();
            }
        }

        protected void GetInitData()
        {
            string lo_strSeqNo = string.Empty;
            string lo_strType  = string.Empty;

            lo_strSeqNo = Utils.IsNull(SiteGlobal.GetRequestForm("SeqNo"), "");
            lo_strType  = Utils.IsNull(SiteGlobal.GetRequestForm("Type"),  "");
            Type.Value  = lo_strType;

            switch (lo_strType)
            {
                case "1":
                    NoteTitle.InnerText = "발주처 업무 특이사항";
                    ClientCode.Value    = lo_strSeqNo;
                    break;
                case "2":
                    NoteTitle.InnerText = "청구처 업무 특이사항";
                    ClientCode.Value    = lo_strSeqNo;
                    break;
                case "3":
                    NoteTitle.InnerText = "화주 비고";
                    ConsignorCode.Value = lo_strSeqNo;
                    break;
            }
        }
    }
}