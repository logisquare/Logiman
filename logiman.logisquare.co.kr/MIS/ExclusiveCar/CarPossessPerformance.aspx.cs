using CommonLibrary.CommonModule;
using CommonLibrary.CommonUtils;
using System;
using System.Web.UI.WebControls;

namespace MIS.ExclusiveCar
{
    public partial class CarPossessPerformance : PageBase
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
            CommonDDLB.CENTER_CODE_DDLB(objSes.AdminID,CenterCode);
            CHART_YEAR_DDLB(DateYear);    //년도 가져오기 - 2017년 이후
            SEARCH_MONTH_DDLB(DateMonth); //월 가져오기
            OrderItemCode.Value = "OA007";
        }

        public static void CHART_YEAR_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();
            int startYear = 2019;
            int currYear  = DateTime.Now.Year;

            for (int i = startYear; i <= currYear; i++)
            {
                DDLB.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            DDLB.SelectedValue = currYear.ToString();
        }

        public static void SEARCH_MONTH_DDLB(DropDownList DDLB)
        {
            DDLB.Items.Clear();

            for (int i = 1; i <= 12; i++)
            {
                DDLB.Items.Add(new ListItem(i + "월", $"{i:00}"));
            }

            DDLB.SelectedValue = DateTime.Now.ToString("MM");
        }
    }
}