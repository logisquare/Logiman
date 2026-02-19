using CommonLibrary.CommonModule;
using System;
using System.Drawing;
using System.IO;
using System.Web;

public partial class Upload : PageInit
{
    protected void Page_Load(object sender, EventArgs e)
    {

        GetInitData();
    }

    protected void GetInitData()
    {
        int lo_intRetVal = 0;
        string image = string.Empty;
        try
        {

            HttpFileCollection uploadedFiles = Request.Files;
            image = SiteGlobal.GetRequestForm("image");

            for (int i = 0; i < uploadedFiles.Count; i++)
            {
                HttpPostedFile userPostedFile = uploadedFiles[i];

                if (userPostedFile.ContentLength > 5000000)
                {
                    Response.Write("1");
                }
                else
                {
                    if (!String.IsNullOrEmpty(userPostedFile.FileName))
                    {
                        string result = UploadFileSave(userPostedFile, i);
                        if (result != "")
                        {
                            // 업로드 성공
                            Response.Write(result);
                        }
                        else
                        {
                            Response.Write(result);
                        }
                    }
                }
            }

        }
        catch (Exception lo_ex)
        {
            lo_intRetVal = 9900;
            SiteGlobal.WriteLog(
                "BoardUpload",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                lo_intRetVal);
        }
    }

    private string UploadFileSave(HttpPostedFile SaveFile, int no)
    {
        int lo_intRetVal = 0;

        // 저장폴더
        string wPath = SiteGlobal.FILE_SERVER_ROOT + @"\BOARD\";
        DirectoryInfo di = new DirectoryInfo(wPath);
        // 폴더가 없을 경우 생성
        if (di.Exists == false)
        {
            di.Create();
        }

        string fileType = SaveFile.FileName.Substring(SaveFile.FileName.LastIndexOf(".") + 1);          // 확장자
        string saveFileName = DateTime.Now.ToString("yyyyMMddhhmmss") + '_' + no + "." + fileType;      // 변경할 파일 이름
        string lo_strOutMsg = string.Empty;

        try
        {
            // 이미지 확장자 일 경우
            if (("jpg|jpeg|bmp|gif|png").IndexOf(fileType.ToLower()) > -1)
            {
                Bitmap img = new Bitmap(SaveFile.InputStream);
                //RotateFlipType rft = RotateFlipType.RotateNoneFlipNone;
                //PropertyItem[] properties = img.PropertyItems;

                // 저장
                img.Save(wPath + saveFileName);
                lo_strOutMsg = SiteGlobal.FILE_DOMAIN + @"\BOARD\" + saveFileName;
            }
            else
            {
                lo_strOutMsg = "";
            }
        }
        catch (Exception lo_ex)
        {
            lo_intRetVal = 9901;
            SiteGlobal.WriteLog(
                "BoardUpload",
                "Exception",
                "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                lo_intRetVal);
        }
        return lo_strOutMsg;
    }
}

