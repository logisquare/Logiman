using System.Collections.Generic;

namespace CommonLibrary.DasServices
{
    public class ReqBoardList
    {
        public int SeqNo        { get; set; }
        public int BoardViewType { get; set; }
        public int BoardKind { get; set; }
        public string MainDisplayFlag { get; set; }
        public string BoardTitle { get; set; }
        public string BoardContent { get; set; }
        public string NewArticleFlag { get; set; }
        public string UseFlag { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
        public string ToDayYMD { get; set; }
        public int GradeCode { get; set; }
        public string AccessCenterCode { get; set; }
        public string AdminID { get; set; }
        public string AdminName { get; set; }
        public int    PageSize  { get; set; }
        public int    PageNo    { get; set; }
    }

    public class ResBoardList
    {
        public List<BoardViewGridModel> list      { get; set; }
        public int                          RecordCnt { get; set; }
    }

    public class BoardViewGridModel
    {
        public int SeqNo                     {get; set;}
        public int BoardViewType             {get; set;}
        public string BoardViewTypeM         {get; set;}
        public int BoardKind                 {get; set;}
        public string BoardKindM             {get; set;}
        public string MainDisplayFlag        {get; set;}
        public string MainDisplayFlagM       {get; set;}
        public string BoardTitle             {get; set;}
        public string BoardContent           {get; set;}
        public string UseFlag                {get; set;}
        public string YMD                    {get; set;}
        public string AccessGradeCode        {get; set;}
        public string GradeName              {get; set;}
        public string UseGradeName           {get; set;}
        public string AccessCenterCode       {get; set;}
        public string CenterName             {get; set;}
        public string UserCenterName         {get; set;}
        public int ViewCnt                   {get; set;}
        public int DisplaySort        	     {get; set;}	
        public string AdminID                {get; set;}
        public string AdminName              {get; set;}
        public string StartDate              {get; set;}
        public string EndDate                {get; set;}
        public string MainPeriodDate         {get; set;}
        public string RegDate                {get; set;}
        public string UpdAdminID             {get; set;}
        public string UpdAdminName           {get; set;}
        public string UpdDate                {get; set;}
        public string AvailCenterFlag        {get; set;}
        public string AvailGradeFlag         {get; set;}
        public string FileName              {get; set;}
        public string FileNameNew           { get; set;}
        public string FileSeqNo             {get; set;}
    }

    public class BoardViewModel
    {
        public int SeqNo { get; set; }
        public int BoardViewType { get; set; }
        public string BoardViewTypeM { get; set; }
        public int BoardKind { get; set; }
        public string BoardKindM { get; set; }
        public string MainDisplayFlag { get; set; }
        public string MainDisplayFlagM { get; set; }
        public string BoardTitle { get; set; }
        public string BoardContent { get; set; }
        public string UseFlag { get; set; }
        public string YMD { get; set; }
        public string AccessGradeCode { get; set; }
        public string GradeName { get; set; }
        public string UseGradeName { get; set; }
        public string AccessCenterCode { get; set; }
        public string CenterName { get; set; }
        public string UserCenterName { get; set; }
        public int ViewCnt { get; set; }
        public int DisplaySort { get; set; }
        public string AdminID { get; set; }
        public string AdminName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string MainPeriodDate { get; set; }
        public string RegDate { get; set; }
        public string UpdAdminID { get; set; }
        public string UpdAdminName { get; set; }
        public string UpdDate { get; set; }
        public string AvailCenterFlag { get; set; }
        public string AvailGradeFlag { get; set; }
        public int    FileSeqNo     { get; set; }
        public string FileName      { get; set; }
        public string FileNameNew   { get; set; }
    }
}