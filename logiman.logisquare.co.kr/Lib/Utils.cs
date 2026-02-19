using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using CommonLibrary.Constants;
using Microsoft.Win32;
using System.Web.UI;
using CommonLibrary.CommonModule;
using Newtonsoft.Json;
using PBSDasNetCom;

//===============================================================
// FileName       : Utils.cs
// Description    : 각종 Util 함수
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonUtils
{
    public static class Utils
    {
        public static string AES_CARGOPAY_SITECODE = "CARGOPAY";
        public static string AES_LOGIMAN_SITECODE  = "LOGIMAN";

        public static string GetEncrypt(string strPlainText, string strAesEncIV = "")
        {
            return GetEncrypt(strPlainText, SiteGlobal.AES2_ENC_KEY_VALUE, strAesEncIV);
        }

        public static string GetEncrypt4Cargopass(string strPlainText, string strSessionKey, string strAesEncIV = "")
        {
            string lo_strAesEncKey = string.Empty;

            lo_strAesEncKey = SiteGlobal.AES2_ENC_KEY_CARGOPASS_VALUE + strSessionKey.PadLeft(5, '0');

            return GetEncrypt(strPlainText, lo_strAesEncKey, strAesEncIV);
        }

        public static string GetEncrypt(string strPlainText, string strAesEncKey, string strAesEncIV = "")
        {
            string lo_strEncrypted = string.Empty;
            string lo_strHexIV     = string.Empty;

            try
            {
                if (string.IsNullOrWhiteSpace(strAesEncKey))
                {
                    return lo_strEncrypted;
                }

                if (string.IsNullOrWhiteSpace(strAesEncIV))
                {
                    lo_strEncrypted = AesGcm256.AESGCM256Encrypt(strPlainText, AesGcm256.getKeyBytes(strAesEncKey.ToLower()), AesGcm256.NewIv());
                }
                else
                {
                    lo_strEncrypted = AesGcm256.AESGCM256Encrypt(strPlainText, AesGcm256.getKeyBytes(strAesEncKey.ToLower()), AesGcm256.getIVBytes(strAesEncIV.ToLower()));
                }
            }
            catch
            {
                lo_strEncrypted = string.Empty;
            }

            return lo_strEncrypted;
        }

        public static string GetDecrypt(string strEncrypted)
        {
            return GetDecrypt(strEncrypted, SiteGlobal.AES2_ENC_KEY_VALUE);
        }

        public static string GetDecrypt4Cargopass(string strEncrypted, string strSessionKey)
        {
            string lo_strAesEncKey = string.Empty;

            lo_strAesEncKey = SiteGlobal.AES2_ENC_KEY_CARGOPASS_VALUE + strSessionKey.PadLeft(5, '0');

            return GetDecrypt(strEncrypted, lo_strAesEncKey);
        }

        public static string GetDecrypt(string strEncrypted, string strAesEncKey)
        {
            string lo_strEncrypted = string.Empty;

            try
            {
                if (string.IsNullOrWhiteSpace(strAesEncKey))
                {
                    return lo_strEncrypted;
                }

                lo_strEncrypted = AesGcm256.AESGCM256Decrypt(strEncrypted, AesGcm256.getKeyBytes(strAesEncKey.ToLower()));
            }
            catch
            {
                lo_strEncrypted = string.Empty;
            }

            return lo_strEncrypted;
        }

        public static string GetAesDecrypt(string strEncrypted)
        {
            return GetAesDecrypt(AES_CARGOPAY_SITECODE, strEncrypted);
        }

        public static string GetAesDecrypt(string strSiteCode, string strString)
        {
            string lo_strEncrypted = string.Empty;

            IDasNetCom lo_objDas = new IDasNetCom();

            try
            {
                lo_strEncrypted = lo_objDas.GetEncryptStr(strSiteCode, strString);
            }
            catch (Exception lo_ex)
            {
                lo_strEncrypted = "";
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9001);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.Close();
                    lo_objDas = null;
                }
            }

            return lo_strEncrypted;
        }

        public static string GetAesEncrypt(string strString)
        {
            return GetAesEncrypt(AES_CARGOPAY_SITECODE, strString);
        }

        public static string GetAesEncrypt(string strSiteCode, string strString)
        {
            string lo_strEncrypted = string.Empty;

            IDasNetCom lo_objDas = new IDasNetCom();

            try
            {
                lo_strEncrypted = lo_objDas.GetEncryptStr(strSiteCode, strString);
            }
            catch (Exception lo_ex)
            {
                lo_strEncrypted = "";
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9001);
            }
            finally
            {
                if (lo_objDas != null)
                {
                    lo_objDas.Close();
                    lo_objDas = null;
                }
            }

            return lo_strEncrypted;
        }

        public static string IsNull(string strSrc, string strReplace)
        {
            if (string.IsNullOrWhiteSpace(strSrc))
            {
                return strReplace;
            }
            else
            {
                return strSrc;
            }
        }

        public static uint GetRandomNumber(int intNumSize = 10)
        {
            RNGCryptoServiceProvider lo_objRng    = null;
            uint                     lo_intNumber = 0;
            byte[]                   lo_data      = null;

            try
            {
                lo_objRng = new RNGCryptoServiceProvider();
                lo_data   = new byte[4];

                for (int lo_i = 0; lo_i < intNumSize; lo_i++)
                {
                    lo_objRng.GetBytes(lo_data);
                    lo_intNumber = BitConverter.ToUInt32(lo_data, 0);
                }
            }
            finally
            {
                lo_objRng = null;
                lo_data   = null;
            }

            return lo_intNumber;
        }

        public static object GetRegistryValue(string strName)
        {
            object lo_objValue;

            try
            {
                RegistryKey lo_objRegKey;
                lo_objRegKey = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\services\" + CommonConstant.WEBSERVICE_REGISTRY + 
                                        @"\Parameters\" + CommonConstant.WEBSERVICE_REGISTRY_KEY, false);
                if (lo_objRegKey.GetValue(strName) == null)
                {
                    lo_objRegKey.Close();
                    return "";
                }
                else
                {
                    lo_objValue = lo_objRegKey.GetValue(strName);
                    lo_objRegKey.Close();
                    return lo_objValue;
                }
            }
            catch
            {
                return "";
            }
        }

        public static string IsMobileBrowser(string strUserAgent)
        {
            string strMobile = "W";

            if (string.IsNullOrEmpty(strUserAgent))
            {
                strUserAgent = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"];
            }

            if (strUserAgent.ToLower().Contains(("ipad")) || strUserAgent.ToLower().Contains(("iphone")) ||
                strUserAgent.ToLower().Contains(("ipod")) || strUserAgent.ToLower().Contains(("macintosh")))
            {
                strMobile = "I";
            }
            else if (strUserAgent.ToLower().Contains(("android")))
            {
                //if (!strUserAgent.ToLower().Contains("nexus"))  // 윈도우 브라우저를 모바일장치 에뮬로 구동할경우 Android, Nexus 로 인식하므로 Nexus 는 제외
                //{
                    strMobile = "A";
                //}
            }

            return strMobile;
        }

        public static string ReplaceString4Numeric(string strString)
        {
            strString = strString.Replace("-", "");
            strString = strString.Replace("/", "");
            strString = strString.Replace(",", "");
            strString = strString.Replace(":", "");
            strString = strString.Replace(" ", "");

            return strString;
        }

        public static string ConvertDateFormat(string strYMD)
        {
            string lo_strDate = strYMD;

            if (string.IsNullOrWhiteSpace(lo_strDate))
            {
                return lo_strDate;
            }

            try
            {
                if (lo_strDate.Length.Equals(8))
                {
                    lo_strDate = lo_strDate.Substring(0, 4) + "-" + lo_strDate.Substring(4, 2) + "-" + lo_strDate.Substring(6);
                }
                else if (lo_strDate.Length.Equals(12))
                {
                    lo_strDate = DateTime.ParseExact(lo_strDate, "yyyyMMddHHmm", System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd HH:mm");
                }
                else if (lo_strDate.Length.Equals(14))
                {
                    lo_strDate = DateTime.ParseExact(lo_strDate, "yyyyMMddHHmmss", System.Globalization.CultureInfo.InvariantCulture).ToString("yyyy-MM-dd HH:mm:ss");
                }
            }
            catch (Exception)
            {
                lo_strDate = string.Empty;
            }

            return lo_strDate;
        }

        public static string DateFormatter(string date, string format, string retFormat, string exception)
        {
            string lo_strRetVal = string.Empty;
            DateTime lo_dt;

            lo_strRetVal = DateTime.TryParseExact(date.Trim(), format, System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out lo_dt) ? lo_dt.ToString(retFormat) : exception;

            return lo_strRetVal;
        }

        public static void ReplaceRootPageWithURL(Page page, string url)
        {
            string lo_strParam = string.Empty;

            try
            {
                lo_strParam = $"javascript:fnRootPageReplace('{url}');";

                if (!page.ClientScript.IsStartupScriptRegistered("fnRootPageReplace"))
                {
                    page.ClientScript.RegisterStartupScript(page.GetType(), "fnRootPageReplace", lo_strParam, true);
                }
            }
            catch
            {
                ShowAlert(page, "페이지 이동에 실패하였습니다.");
            }
        }

        public static void ReplacePageWithURL(Page page, string url)
        {
            string lo_strParam = string.Empty;

            try
            {
                lo_strParam = $"javascript:fnPageReplace('{url}');";

                if (!page.ClientScript.IsStartupScriptRegistered("fnPageReplace"))
                {
                    page.ClientScript.RegisterStartupScript(page.GetType(), "fnPageReplace", lo_strParam, true);
                }
            }
            catch
            {
                ShowAlert(page, "페이지 이동에 실패하였습니다.");
            }
        }

        public static void ShowAlert(Page page, string strMsg)
        {
            string lo_strParam = string.Empty;

            try
            {
                lo_strParam = $"javascript:fnDefaultAlert('{strMsg}');";

                if (!page.ClientScript.IsStartupScriptRegistered("fnDefaultAlert"))
                {
                    page.ClientScript.RegisterStartupScript(page.GetType(), "fnDefaultAlert", lo_strParam, true);
                }
            }
            catch
            {
                // ignored
            }
        }

        public static void ShowAlertCheckMenu(Page page, string strMsg) {
            string lo_strParam = string.Empty;

            try
            {
                lo_strParam = $"javascript:fnDefaultAlert('{strMsg}', 'warning', 'fnRootPageReplace', '/');";

                if (!page.ClientScript.IsStartupScriptRegistered("fnDefaultAlert"))
                {
                    page.ClientScript.RegisterStartupScript(page.GetType(), "fnDefaultAlert", lo_strParam, true);
                }
            }
            catch
            {
                // ignored
            }
        }

        public static DataTable GetConvertListToDataTable<T>(this List<T> data)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));

            DataTable table = new DataTable();

            for (int i = 0; i < props.Count; i++)
            {
                PropertyDescriptor prop = props[i];
                table.Columns.Add(prop.Name, prop.PropertyType);
            }

            object[] values = new object[props.Count];

            foreach (T item in data)
            {

                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = props[i].GetValue(item);
                }
                table.Rows.Add(values);
            }
            return table;
        }

        public static string GetCorpNoDashed(string strCORP_NO)
        {
            string lo_strCORP_NO = strCORP_NO;

            if (string.IsNullOrWhiteSpace(lo_strCORP_NO))
            {
                return lo_strCORP_NO;
            }

            try
            {
                if (lo_strCORP_NO.Length.Equals(10))
                {
                    lo_strCORP_NO = lo_strCORP_NO.Substring(0, 3) + "-" + lo_strCORP_NO.Substring(3, 2) + "-" + lo_strCORP_NO.Substring(5);
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9008);
            }

            return lo_strCORP_NO;
        }

        public static string SetPhoneNoDashed(string strPhoneNo)
        {
            string lo_strPhoneNo = strPhoneNo;

            if (string.IsNullOrWhiteSpace(lo_strPhoneNo))
            {
                return lo_strPhoneNo;
            }

            lo_strPhoneNo = ReplaceString4Numeric(lo_strPhoneNo);

            try
            {
                if (lo_strPhoneNo.Length >= 9)
                {
                    if (lo_strPhoneNo.Substring(0,2).Equals("02"))
                    {
                        if (lo_strPhoneNo.Length == 9)
                        {
                            lo_strPhoneNo = lo_strPhoneNo.Substring(0, 2) + "-" + lo_strPhoneNo.Substring(2, 3) + "-" + lo_strPhoneNo.Substring(5);
                        }
                        else if (lo_strPhoneNo.Length == 10)
                        {
                            lo_strPhoneNo = lo_strPhoneNo.Substring(0, 2) + "-" + lo_strPhoneNo.Substring(2, 4) + "-" + lo_strPhoneNo.Substring(6);
                        }
                    }
                    else
                    {
                        if (lo_strPhoneNo.Length == 10)
                        {
                            lo_strPhoneNo = lo_strPhoneNo.Substring(0, 3) + "-" + lo_strPhoneNo.Substring(3, 3) + "-" + lo_strPhoneNo.Substring(6);
                        }
                        else if (lo_strPhoneNo.Length == 11)
                        {
                            lo_strPhoneNo = lo_strPhoneNo.Substring(0, 3) + "-" + lo_strPhoneNo.Substring(3, 4) + "-" + lo_strPhoneNo.Substring(7);
                        }
                    }
                } 
                else if (lo_strPhoneNo.Length == 8)
                {
                    lo_strPhoneNo = lo_strPhoneNo.Substring(0, 4) + "-" + lo_strPhoneNo.Substring(4);
                }
                else if (lo_strPhoneNo.Length == 7)
                {
                    lo_strPhoneNo = lo_strPhoneNo.Substring(0, 3) + "-" + lo_strPhoneNo.Substring(3);
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("SiteGlobal", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }

            return lo_strPhoneNo;
        }

        public static string GetMobileNoDashed(string strMOBILE_NO)
        {
            string lo_strMOBILE_NO = strMOBILE_NO;

            if (string.IsNullOrWhiteSpace(lo_strMOBILE_NO))
            {
                return lo_strMOBILE_NO;
            }

            try
            {
                if (lo_strMOBILE_NO.Length.Equals(7))
                {
                    lo_strMOBILE_NO = lo_strMOBILE_NO.Substring(0, 3) + "-" + lo_strMOBILE_NO.Substring(3);
                }
                else if (lo_strMOBILE_NO.Length.Equals(8))
                {
                    lo_strMOBILE_NO = lo_strMOBILE_NO.Substring(0, 4) + "-" + lo_strMOBILE_NO.Substring(4);
                }
                else if (lo_strMOBILE_NO.Length.Equals(9))
                {
                    lo_strMOBILE_NO = lo_strMOBILE_NO.Substring(0, 2) + "-" + lo_strMOBILE_NO.Substring(2, 3) + "-" + lo_strMOBILE_NO.Substring(5);
                }
                else if (lo_strMOBILE_NO.Length.Equals(10))
                {
                    lo_strMOBILE_NO = lo_strMOBILE_NO.Substring(0, 3) + "-" + lo_strMOBILE_NO.Substring(3, 3) + "-" + lo_strMOBILE_NO.Substring(6);
                }
                else if (lo_strMOBILE_NO.Length.Equals(11))
                {
                    lo_strMOBILE_NO = lo_strMOBILE_NO.Substring(0, 3) + "-" + lo_strMOBILE_NO.Substring(3, 4) + "-" + lo_strMOBILE_NO.Substring(7);
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("SiteGlobal", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }

            return lo_strMOBILE_NO;
        }
        

        /// <summary>
        /// 항목 그룹 전체
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemGroupJson(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST) as DataTable;

            return list;
        }

        /// <summary>
        /// 부적절한 파일명 문자 제거하기
        /// </summary>
        /// <param name="fileName">파일명</param>
        /// <param name="replacement">변경 문자열</param>
        /// <returns>파일명</returns>
        public static string GetConvertFileName(string fileName, string replacement = "")
        {
            string regexSearch = "|\\\\?*<\":>/;,";

            Regex regex = new Regex($"[{Regex.Escape(regexSearch)}]");

            return regex.Replace(fileName, replacement);
        }

        /// <summary>
        /// 항목 그룹 전체
        /// </summary>
        /// <param name="httpContext"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemGroupJson(HttpContext httpContext)
        {
            if (null == httpContext.Cache[CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST])
            {
                return null;
            }

            DataTable list = httpContext.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST) as DataTable;

            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="page"></param>
        public static void SetCacheItemGroupJson(Page page)
        {
            string    lo_strCacheCode    = CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST;
            string    lo_strJsonDir      = CommonConstant.M_PAGE_CACHE_ITEM_GROUP_LIST_JSON;
            string    lo_strJsonContents = string.Empty;
            DataTable lo_objDataTable    = null;

            if (string.IsNullOrEmpty(lo_strJsonDir) || string.IsNullOrEmpty(lo_strCacheCode))
            {
                return;
            }

            try
            {
                if (null != page.Cache[lo_strCacheCode])
                {
                    return;
                }

                if (!File.Exists(lo_strJsonDir))
                {
                    return;
                }

                lo_strJsonContents = File.ReadAllText(lo_strJsonDir, Encoding.UTF8);
                lo_objDataTable    = JsonConvert.DeserializeObject<DataTable>(lo_strJsonContents);
                page.Cache.Insert(lo_strCacheCode, lo_objDataTable, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }
        }

        /// <summary>
        /// 항목 전체
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemJson(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_ITEM_LIST])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 항목 전체
        /// </summary>
        /// <param name="httpContext"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemJson(HttpContext httpContext)
        {
            if (null == httpContext.Cache[CommonConstant.M_PAGE_CACHE_ITEM_LIST])
            {
                return null;
            }

            DataTable list = httpContext.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 항목 전체 캐시 등록
        /// </summary>
        /// <param name="page"></param>
        public static void SetCacheItemJson(Page page)
        {
            string    lo_strCacheCode    = CommonConstant.M_PAGE_CACHE_ITEM_LIST;
            string    lo_strJsonDir      = CommonConstant.M_PAGE_CACHE_ITEM_LIST_JSON;
            string    lo_strJsonContents = string.Empty;
            DataTable lo_objDataTable    = null;

            if (string.IsNullOrEmpty(lo_strJsonDir) || string.IsNullOrEmpty(lo_strCacheCode))
            {
                return;
            }

            try
            {
                if (null != page.Cache[lo_strCacheCode])
                {
                    return;
                }

                if (!File.Exists(lo_strJsonDir))
                {
                    return;
                }

                lo_strJsonContents = File.ReadAllText(lo_strJsonDir, Encoding.UTF8);
                lo_objDataTable    = JsonConvert.DeserializeObject<DataTable>(lo_strJsonContents);
                page.Cache.Insert(lo_strCacheCode, lo_objDataTable, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }
        }

        /// <summary>
        /// 사용자 항목 전체
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemAdminJson(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 사용자 항목 전체
        /// </summary>
        /// <param name="httpContext"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemAdminJson(HttpContext httpContext)
        {
            if (null == httpContext.Cache[CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST])
            {
                return null;
            }

            DataTable list = httpContext.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 사용자 항목 전체 캐시 등록
        /// </summary>
        /// <param name="page"></param>
        public static void SetCacheItemAdminJson(Page page)
        {
            string    lo_strCacheCode    = CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST;
            string    lo_strJsonDir      = CommonConstant.M_PAGE_CACHE_ITEM_ADMIN_LIST_JSON;
            string    lo_strJsonContents = string.Empty;
            DataTable lo_objDataTable    = null;

            if (string.IsNullOrEmpty(lo_strJsonDir) || string.IsNullOrEmpty(lo_strCacheCode))
            {
                return;
            }

            try
            {
                if (null != page.Cache[lo_strCacheCode])
                {
                    return;
                }

                if (!File.Exists(lo_strJsonDir))
                {
                    return;
                }

                lo_strJsonContents = File.ReadAllText(lo_strJsonDir, Encoding.UTF8);
                lo_objDataTable = JsonConvert.DeserializeObject<DataTable>(lo_strJsonContents);
                page.Cache.Insert(lo_strCacheCode, lo_objDataTable, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }
        }

        /// <summary>
        /// 회원사 항목 전체
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemCenterJson(Page page)
        {
            if (null == page.Cache[CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST])
            {
                return null;
            }

            DataTable list = page.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 회원사 항목 전체
        /// </summary>
        /// <param name="httpContext"></param>
        /// <returns></returns>
        public static DataTable GetCacheItemCenterJson(HttpContext httpContext)
        {
            if (null == httpContext.Cache[CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST])
            {
                return null;
            }

            DataTable list = httpContext.Cache.Get(CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST) as DataTable;
            return list;
        }

        /// <summary>
        /// 회원사 항목 전체 캐시 생성
        /// </summary>
        /// <param name="page"></param>
        /// <returns></returns>
        public static void SetCacheItemCenterJson(Page page)
        {
            string                lo_strCacheCode    = CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST;
            string                lo_strJsonDir      = CommonConstant.M_PAGE_CACHE_ITEM_CENTER_LIST_JSON;
            string                lo_strJsonContents = string.Empty;
            DataTable             lo_objDataTable    = null;

            if (string.IsNullOrEmpty(lo_strJsonDir) || string.IsNullOrEmpty(lo_strCacheCode))
            {
                return;
            }

            try
            {
                if (null != page.Cache[lo_strCacheCode])
                {
                    return;
                }

                if (!File.Exists(lo_strJsonDir))
                {
                    return;
                }

                lo_strJsonContents = File.ReadAllText(lo_strJsonDir, Encoding.UTF8);
                lo_objDataTable = JsonConvert.DeserializeObject<DataTable>(lo_strJsonContents);
                page.Cache.Insert(lo_strCacheCode, lo_objDataTable, null, DateTime.Now.AddMonths(1), TimeSpan.Zero);
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }
        }

        /// <summary>
        /// 항목 목록 조회
        /// </summary>
        /// <param name="page"></param>
        /// <param name="strGroupCode"></param>
        /// <param name="strAccessCenterCode"></param>
        /// <param name="strAdminID"></param>
        /// <param name="strGroupName"></param>
        /// <returns></returns>
        public static DataTable GetItemList(Page page, string strGroupCode, string strAccessCenterCode, string strAdminID, out string strGroupName)
        {

            strGroupName = string.Empty;

            string    lo_strCenterFlag       = "N";
            string    lo_strAdminFlag        = "N";
            DataTable lo_objCodeTable        = new DataTable();
            DataTable lo_objCodeItemTable    = null;
            DataTable lo_objCodeItemSubTable = new DataTable();
            DataRow   lo_objDataRow          = null;
            string[]  lo_objAccessCenterCode = null;

            lo_objCodeTable.Columns.Add("ItemFullCode", typeof(string));
            lo_objCodeTable.Columns.Add("ItemName", typeof(string));
            lo_objCodeItemSubTable.Columns.Add("ItemFullCode", typeof(string));
            lo_objCodeItemSubTable.Columns.Add("ItemName",     typeof(string));

            try
            {
                lo_objCodeItemTable = GetCacheItemGroupJson(page);

                if (lo_objCodeItemTable == null) return null;

                if (lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "'").Length.Equals(0))
                {
                    return null;
                }

                lo_objDataRow = lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "' ")[0];

                lo_strCenterFlag = lo_objDataRow["CenterFlag"].ToString();
                lo_strAdminFlag  = lo_objDataRow["AdminFlag"].ToString();
                strGroupName     = lo_objDataRow["GroupName"].ToString();
            }
            catch (Exception)
            {
            }

            lo_objCodeItemTable = null;
            //관리자 즐겨찾기 항목  추가
            if (!string.IsNullOrWhiteSpace(strAdminID) && lo_strAdminFlag.Equals("Y"))
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemAdminJson(page);
                    if (lo_objCodeItemTable != null)
                    {
                        foreach (DataRow row in lo_objCodeItemTable.Select("ItemGroupCode = '" + strGroupCode + "' AND AdminID = '" + strAdminID + "'"))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception)
                {
                }
            }

            lo_objCodeItemTable = null;
            //마스터 항목 체크
            if (lo_strCenterFlag.Equals("Y") && !string.IsNullOrWhiteSpace(strAccessCenterCode))
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemCenterJson(page);
                    if (lo_objCodeItemTable == null) return null;

                    lo_objAccessCenterCode = strAccessCenterCode.Split(',');
                    for (int i = 0; i < lo_objAccessCenterCode.Length; i++)
                    {

                        foreach (DataRow row in lo_objCodeItemTable.Select("UseFlag = 'Y' AND GroupCode = '" + strGroupCode + "' AND CenterCode = " + lo_objAccessCenterCode[i]))
                        {
                            if (lo_objCodeItemSubTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                            {
                                lo_objCodeItemSubTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                            }
                        }
                    }

                    //사용자 항목 중 없는 회원사 항목 삭제
                    foreach (DataRow row in lo_objCodeTable.Rows)
                    {
                        if (lo_objCodeItemSubTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Remove(row);
                        }
                    }

                    //회원사 항목 추가
                    lo_objCodeItemSubTable.DefaultView.Sort = "ItemFullCode ASC";
                    foreach (DataRow row in lo_objCodeItemSubTable.Rows)
                    {
                        if (lo_objCodeTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception)
                {
                }
            }
            else
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemJson(page);

                    if (lo_objCodeItemTable == null) return null;

                    foreach (DataRow row in lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "'"))
                    {
                        if (lo_objCodeTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception)
                {
                }
            }

            return lo_objCodeTable;
        }


        /// <summary>
        /// 항목 목록 조회
        /// </summary>
        /// <param name="httpContext"></param>
        /// <param name="strGroupCode"></param>
        /// <param name="strAccessCenterCode"></param>
        /// <param name="strAdminID"></param>
        /// <param name="strGroupName"></param>
        /// <returns></returns>
        public static DataTable GetItemList(HttpContext httpContext, string strGroupCode, string strAccessCenterCode, string strAdminID, out string strGroupName)
        {

            strGroupName = string.Empty;

            string    lo_strCenterFlag       = "N";
            string    lo_strAdminFlag        = "N";
            DataTable lo_objCodeTable        = new DataTable();
            DataTable lo_objCodeItemTable    = null;
            DataTable lo_objCodeItemSubTable = new DataTable();
            DataRow   lo_objDataRow          = null;
            string[]  lo_objAccessCenterCode = null;

            lo_objCodeTable.Columns.Add("ItemFullCode", typeof(string));
            lo_objCodeTable.Columns.Add("ItemName",     typeof(string));
            lo_objCodeItemSubTable.Columns.Add("ItemFullCode", typeof(string));
            lo_objCodeItemSubTable.Columns.Add("ItemName",     typeof(string));

            try
            {
                lo_objCodeItemTable = GetCacheItemGroupJson(httpContext);

                if (lo_objCodeItemTable == null) return null;

                if (lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "'").Length.Equals(0))
                {
                    return null;
                }

                lo_objDataRow = lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "' ")[0];

                lo_strCenterFlag = lo_objDataRow["CenterFlag"].ToString();
                lo_strAdminFlag  = lo_objDataRow["AdminFlag"].ToString();
                strGroupName     = lo_objDataRow["GroupName"].ToString();
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("ContainerHandler", "Exception",
                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                    5100);
            }

            lo_objCodeItemTable = null;
            //관리자 즐겨찾기 항목  추가
            if (!string.IsNullOrWhiteSpace(strAdminID) && lo_strAdminFlag.Equals("Y"))
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemAdminJson(httpContext);
                    if (lo_objCodeItemTable != null)
                    {
                        foreach (DataRow row in lo_objCodeItemTable.Select("ItemGroupCode = '" + strGroupCode + "' AND AdminID = '" + strAdminID + "'"))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception lo_ex)
                {
                    SiteGlobal.WriteLog("ContainerHandler", "Exception",
                        "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                        5100);
                }
            }

            lo_objCodeItemTable = null;
            //마스터 항목 체크
            if (lo_strCenterFlag.Equals("Y") && !string.IsNullOrWhiteSpace(strAccessCenterCode))
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemCenterJson(httpContext);
                    if (lo_objCodeItemTable == null) return null;

                    lo_objAccessCenterCode = strAccessCenterCode.Split(',');
                    for (int i = 0; i < lo_objAccessCenterCode.Length; i++)
                    {

                        foreach (DataRow row in lo_objCodeItemTable.Select("UseFlag = 'Y' AND GroupCode = '" + strGroupCode + "' AND CenterCode = " + lo_objAccessCenterCode[i]))
                        {
                            if (lo_objCodeItemSubTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                            {
                                lo_objCodeItemSubTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                            }
                        }
                    }

                    //사용자 항목 중 없는 회원사 항목 삭제
                    foreach (DataRow row in lo_objCodeTable.Rows)
                    {
                        if (lo_objCodeItemSubTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Remove(row);
                        }
                    }

                    //회원사 항목 추가
                    lo_objCodeItemSubTable.DefaultView.Sort = "ItemFullCode ASC";
                    foreach (DataRow row in lo_objCodeItemSubTable.Rows)
                    {
                        if (lo_objCodeTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception lo_ex)
                {
                    SiteGlobal.WriteLog("ContainerHandler", "Exception",
                        "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                        5100);
                }
            }
            else
            {
                try
                {
                    lo_objCodeItemTable = GetCacheItemJson(httpContext);

                    if (lo_objCodeItemTable == null) return null;

                    foreach (DataRow row in lo_objCodeItemTable.Select("GroupCode = '" + strGroupCode + "'"))
                    {
                        if (lo_objCodeTable.Select("ItemFullCode = '" + row["ItemFullCode"] + "'").Length.Equals(0))
                        {
                            lo_objCodeTable.Rows.Add(row["ItemFullCode"].ToString(), row["ItemName"].ToString());
                        }
                    }
                }
                catch (Exception lo_ex)
                {
                    SiteGlobal.WriteLog("ContainerHandler", "Exception",
                        "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace,
                        5100);
                }
            }

            return lo_objCodeTable;
        }

        /// <summary>
        /// 회원사 개인정보 담당자 정보 조회
        /// </summary>
        /// <param name="page"></param>
        public static DataTable GetCenterPrivateInfo(int intCenterCode = 0)
        {
            string    lo_strJsonDir      = CommonConstant.M_PAGE_CENTER_PRIVATE_INFO_JSON;
            string    lo_strJsonContents = string.Empty;
            DataTable lo_objDataTable    = null;

            if (string.IsNullOrEmpty(lo_strJsonDir))
            {
                return null;
            }

            try
            {
                if (!File.Exists(lo_strJsonDir))
                {
                    return null;
                }

                lo_strJsonContents = File.ReadAllText(lo_strJsonDir, Encoding.UTF8);

                if (string.IsNullOrWhiteSpace(lo_strJsonContents))
                {
                    return null;
                }

                lo_strJsonContents = lo_strJsonContents.Replace("\r", string.Empty).Replace("\n", string.Empty);
                lo_objDataTable    = JsonConvert.DeserializeObject<DataTable>(lo_strJsonContents);

                if (lo_objDataTable == null)
                {
                    return null;
                }

                if (intCenterCode > 0)
                {
                    if (lo_objDataTable.Select("CenterCode = " + intCenterCode).Length > 0)
                    {
                        lo_objDataTable = lo_objDataTable.Select("CenterCode = " + intCenterCode).CopyToDataTable();
                    }
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception lo_ex)
            {
                SiteGlobal.WriteLog("Utils", "Exception"
                    , "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " + lo_ex.StackTrace, 9007);
            }

            return lo_objDataTable;
        }
    }

    #region ErrorHandler Class
    public static class ErrorHandler
    {
        public const int    COMMON_LIB_SUCCESS       = 0;

        //Exception Error
        public const int    COMMON_LIB_ERR_10000     = 10000;
        public const string COMMON_LIB_ERR_10000_MSG = "Unhandled exception occurred";

        //HttpAction Class
        public const int    COMMON_LIB_ERR_10001     = 10001;
        public const string COMMON_LIB_ERR_10001_MSG = "Invalid HTTP Status({0} {1})";
        public const int    COMMON_LIB_ERR_10002     = 10002;
        public const string COMMON_LIB_ERR_10002_MSG = "SendHttpAction WebException occurred({0})";
        public const int    COMMON_LIB_ERR_10003     = 10003;
        public const string COMMON_LIB_ERR_10003_MSG = "SendHttpAction Exception occurred({0})";

        //MailAction Class
        public const int    COMMON_LIB_ERR_10051     = 10051;
        public const string COMMON_LIB_ERR_10051_MSG = "Sender mail address should be set to send this mail";
        public const int    COMMON_LIB_ERR_10052     = 10052;
        public const string COMMON_LIB_ERR_10052_MSG = "Receiver mail address should be set to send this mail";
        public const int    COMMON_LIB_ERR_10053     = 10053;
        public const string COMMON_LIB_ERR_10053_MSG = "SendMail SmtpException occurred({0})";
        public const int    COMMON_LIB_ERR_10054     = 10054;
        public const string COMMON_LIB_ERR_10054_MSG = "SendMail Exception occurred({0})";
 
        //JSONParse Class
        public const int    COMMON_LIB_ERR_10151     = 10151;
        public const string COMMON_LIB_ERR_10151_MSG = "JsonWriter Exception occurred({0})";
        public const int    COMMON_LIB_ERR_10152     = 10152;
        public const string COMMON_LIB_ERR_10152_MSG = "JsonWriter Exception occurred({0})";
        public const int    COMMON_LIB_ERR_10153     = 10153;
        public const string COMMON_LIB_ERR_10153_MSG = "JsonWriter Exception occurred({0})";
        public const int    COMMON_LIB_ERR_10154     = 10154;
        public const string COMMON_LIB_ERR_10154_MSG = "JsonReader Exception occurred({0})";
        public const int    COMMON_LIB_ERR_10155     = 10155;
        public const string COMMON_LIB_ERR_10155_MSG = "JsonReader Exception occurred({0})";
        public const int    COMMON_LIB_ERR_10156     = 10156;
        public const string COMMON_LIB_ERR_10156_MSG = "JsonReader Exception occurred({0})";

        //MailAction Class
        public const string COMMON_LIB_ERR_20051_MSG = "Sender mail address should be set to send this mail";
        public const int    COMMON_LIB_ERR_20051     = 20051;
        public const string COMMON_LIB_ERR_20052_MSG = "Receiver mail address should be set to send this mail";
        public const int    COMMON_LIB_ERR_20052     = 20052;
        public const string COMMON_LIB_ERR_20053_MSG = "SendMail SmtpException occurred({0})";
        public const int    COMMON_LIB_ERR_20053     = 20053;
        public const string COMMON_LIB_ERR_20054_MSG = "SendMail Exception occurred({0})";
        public const int    COMMON_LIB_ERR_20054     = 20054;

        //PasswordManager Class: from 22001 to 22100
        public const int    COMMON_LIB_ERR_22000     = 22000;
        public const string COMMON_LIB_ERR_22000_MSG = "최초 로그인입니다. 비밀번호를 설정해 주세요.";
        public const int    COMMON_LIB_ERR_22001     = 22001;
        public const string COMMON_LIB_ERR_22001_MSG = "비밀번호를 {0}에서 {1}자리로 입력해주세요.";
        public const int    COMMON_LIB_ERR_22002     = 22002;
        public const string COMMON_LIB_ERR_22002_MSG = "비밀번호는 적어도 {0}개의 특수문자를 포함해야 합니다.";
        public const int    COMMON_LIB_ERR_22003     = 22003;
        public const string COMMON_LIB_ERR_22003_MSG = "비밀번호는 적어도 {0}개의 숫자를 포함해야 합니다.";
        public const int    COMMON_LIB_ERR_22004     = 22004;
        public const string COMMON_LIB_ERR_22004_MSG = "비밀번호는 적어도 {0}개의 소문자를 포함해야 합니다.";
        public const int    COMMON_LIB_ERR_22005     = 22005;
        public const string COMMON_LIB_ERR_22005_MSG = "비밀번호는 적어도 {0}개의 대문자를 포함해야 합니다.";
        public const int    COMMON_LIB_ERR_22006     = 22006;
        public const string COMMON_LIB_ERR_22006_MSG = "비밀번호는 동일한 {0}자리 문자나 숫자를 허용하지 않습니다.";
        public const int    COMMON_LIB_ERR_22007     = 22007;
        public const string COMMON_LIB_ERR_22007_MSG = "비밀번호는 연속된 {0}자리 숫자를 허용하지 않습니다.";
        public const int    COMMON_LIB_ERR_22008     = 22008;
        public const string COMMON_LIB_ERR_22008_MSG = "비밀번호는 연속된 {0}자리 문자를 허용하지 않습니다.";
        public const int    COMMON_LIB_ERR_22009     = 22009;
        public const string COMMON_LIB_ERR_22009_MSG = "비밀번호가 일치하지 않습니다. 다시 입력해 주십시오.";
        public const int    COMMON_LIB_ERR_22010     = 22010;
        public const string COMMON_LIB_ERR_22010_MSG = "새로운 비밀번호는 현재 비밀번호와 동일할 수 없습니다.";
        public const int    COMMON_LIB_ERR_22011     = 22011;
        public const string COMMON_LIB_ERR_22011_MSG = "새로운 비밀번호는 최근에 사용한 3개의 비밀번호와 동일할 수 없습니다.";
        public const int    COMMON_LIB_ERR_22012     = 22012;
        public const string COMMON_LIB_ERR_22012_MSG = "토큰 생성 실패";
        public const int    COMMON_LIB_ERR_22013     = 22013;
        public const string COMMON_LIB_ERR_22013_MSG = "비정상 토큰";
        public const int    COMMON_LIB_ERR_22014     = 22014;
        public const string COMMON_LIB_ERR_22014_MSG = "로그인 비밀번호 {0}회이상 오류로 금일 접속이 제한됩니다.";
    }
    #endregion
}