using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;

namespace CommonLibrary.DasServices
{
    public static class BaseDasService
    {
        public static ErrResult CheckServiceStop()
        {
            ErrResult objResult = new ErrResult();

            objResult.ErrorCode = 0;

            //======================================================================
            //서비스 점검 체크
            //======================================================================
            string strServiceStopFlag = CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_FLAG).ToString();
            if (strServiceStopFlag.Equals("Y"))
            {
                if (!CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_ALLOWIP).ToString().Contains(SiteGlobal.GetRemoteAddr()))
                {
                    objResult.ErrorCode = 9999;
                    objResult.ErrorMsg = CommonUtils.Utils.GetRegistryValue(CommonConstant.SERVICE_STOP_CONTENT).ToString();
                    if (string.IsNullOrWhiteSpace(objResult.ErrorMsg))
                    {
                        objResult.ErrorMsg = "시스템 점검중으로 서비스 이용이 불가합니다.";
                    }
                }
            }

            return objResult;
        }
    }
}