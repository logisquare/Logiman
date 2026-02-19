using CommonLibrary.CommonModel;
using CommonLibrary.CommonModule;
using CommonLibrary.Constants;
using CommonLibrary.DasServices;
using CommonLibrary.Extensions;
using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

//===============================================================
// FileName       : PasswordManager.cs
// Description    : Password management class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonUtils
{
    public static class PasswordManager
    {
        /// <summary>
        /// Const variables to set the password policy
        /// </summary>
        ///
        private const int PASSWORD_DIGIT_MIN              = 8;      //Minimum digit of password
        private const int PASSWORD_DIGIT_MAX              = 16;     //Maximum digit of password
        private const int PASSWORD_SPECIAL_CHAR_MIN       = 1;      //Necessary minimum number of special character
        private const int PASSWORD_NUMERIC_CHAR_MIN       = 1;      //Necessary minimum number of nemeric character
        private const int PASSWORD_LOWERCASE_CHAR_MIN     = 1;      //Necessary minimum number of lower-case character

        private const int PASSWORD_UPPERCASE_CHAR_MIN     = 0;      //Necessary minimum number of upper-case character
        private const int PASSWORD_CONSECUTIVE_SAME_LIMIT = 3;      //Limited number of consective alphanumeric same character
        private const int PASSWORD_CONSECUTIVE_SEQ_LIMIT  = 3;      //Limited number of consective alphanumeric sequence character

        private readonly static string strPasswordResetConfirmUrl =
            $"{HttpContext.Current.Request.Url.Scheme}://{HttpContext.Current.Request.Url.Host}{"/SSO/Login/ResetPassword"}";

        ///----------------------------------------------------------------------
        /// <summary>
        /// ChangeMode enumeration
        /// </summary>
        ///----------------------------------------------------------------------
        public enum ChangeMode
        {
            Normal = 1,
            Reset  = 2
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        /// Change password
        /// </summary>
        /// <param name="changeMode">Chage Mode(Normal or Reset)</param>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <param name="strNewPassword">Entered New Password</param>
        /// <param name="strCurrPassword">Entered Old Password</param>
        /// <param name="strHAdminID">Logined Administrator's ID</param>
        /// <param name="blnIsReset">Flag if this change is for reset or not</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public static int ChangePassword(ChangeMode changeMode, string strAdminID, string strNewPassword, string strCurrPassword, string strHAdminID, 
                                         int intResetFlag, out string strErrMsg)
        {
            int    lo_intRetVal        = ErrorHandler.COMMON_LIB_SUCCESS;
            string lo_strCurrHashedPwd = string.Empty;
            string lo_strNewHashedPwd  = string.Empty;

            AdminDasServices                lo_objAdminDasServices    = new AdminDasServices();
            ServiceResult<AdminPwdInfo>     lo_objResAdminPwdInfo     = null;
            ServiceResult<AdminPrevPwdInfo> lo_objResAdminPrevPwdInfo = null;
            ServiceResult<bool>             lo_objResUpdAdminPwd      = null;
            BCrypt                          lo_objBCrypt              = new BCrypt();

            strErrMsg = string.Empty;

            try
            {
                //Check new password is valid
                lo_intRetVal = ValidatePasswordPolicy(strNewPassword, out strErrMsg);
                if (lo_intRetVal.IsFail())
                {
                    return lo_intRetVal;
                }

                //Get current passowrd from DB
                lo_objResAdminPwdInfo = lo_objAdminDasServices.GetCurrentPassword(strAdminID);
                lo_intRetVal          = lo_objResAdminPwdInfo.result.ErrorCode;
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg = lo_objResAdminPwdInfo.result.ErrorMsg;
                    return lo_intRetVal;
                }

                lo_strCurrHashedPwd = lo_objResAdminPwdInfo.data.CurrPassword;

                //In case of the change mode is normal
                if (changeMode.Equals(ChangeMode.Normal))
                {
                    //Compare an entered old password to a retrieved current password from DB
                    if (!lo_objBCrypt.CheckPassword(strCurrPassword, lo_strCurrHashedPwd))
                    {
                        lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22009;
                        strErrMsg    = ErrorHandler.COMMON_LIB_ERR_22009_MSG;
                        return lo_intRetVal;
                    }
                }

                //Check if the new password is equaled with the old one
                if (lo_objBCrypt.CheckPassword(strNewPassword, lo_strCurrHashedPwd))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22010;
                    strErrMsg    = ErrorHandler.COMMON_LIB_ERR_22010_MSG;
                    return lo_intRetVal;
                }

                //Get previous 3 passwords
                lo_objResAdminPrevPwdInfo = lo_objAdminDasServices.GetPrevPassword(strAdminID);
                lo_intRetVal              = lo_objResAdminPrevPwdInfo.result.ErrorCode;
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg = lo_objResAdminPrevPwdInfo.result.ErrorMsg;
                    return lo_intRetVal;
                }

                //Check if the new password is equaled with the previous 3 passwords
                if (lo_objResAdminPrevPwdInfo.data.arrPrevPassword != null)
                {
                    foreach (string lo_strTmpPwd in lo_objResAdminPrevPwdInfo.data.arrPrevPassword)
                    {
                        if (lo_objBCrypt.CheckPassword(strNewPassword, lo_strTmpPwd))
                        {
                            lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22011;
                            strErrMsg    = ErrorHandler.COMMON_LIB_ERR_22011_MSG;
                            return lo_intRetVal;
                        }
                    }
                }

                //Compute hash value of the new password
                lo_strNewHashedPwd = lo_objBCrypt.HashPassword(strNewPassword, lo_objBCrypt.GenerateSaltByRandom());

                //Update new password
                lo_objResUpdAdminPwd = lo_objAdminDasServices.UpdAdminPwd(strAdminID, lo_strNewHashedPwd, strHAdminID, intResetFlag);
                lo_intRetVal         = lo_objResUpdAdminPwd.result.ErrorCode;
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg = lo_objResAdminPrevPwdInfo.result.ErrorMsg;
                    return lo_intRetVal;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9101;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }
            finally
            {
                lo_objBCrypt = null;
            }

            return lo_intRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check the entered password with DB
        /// </summary>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <param name="strPassword">Password</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public static int CheckEnteredPassword(string strAdminID, string strPassword, out int intGradeCode, out string strErrMsg)
        {
            int    lo_intRetVal            = ErrorHandler.COMMON_LIB_SUCCESS;
            int    lo_intTodayLoginFailCnt = 0;
            int    lo_intAdminLogInTryCnt  = 0;
            string lo_strDBCurrPwd         = string.Empty;

            ServiceResult<AdminPwdInfo> lo_objResAdminPwdInfo  = null;
            AdminDasServices            lo_objAdminDasServices = new AdminDasServices();
            BCrypt                      lo_objBCrypt           = new BCrypt();

            strErrMsg    = string.Empty;
            intGradeCode = 0;

            try
            {
                //Retrieve a current password from DB 
                lo_objResAdminPwdInfo = lo_objAdminDasServices.GetCurrentPassword(strAdminID);
                lo_intRetVal          = lo_objResAdminPwdInfo.result.ErrorCode;
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg = lo_objResAdminPwdInfo.result.ErrorMsg;
                    return lo_intRetVal;
                }

                lo_strDBCurrPwd         = lo_objResAdminPwdInfo.data.CurrPassword;
                lo_intTodayLoginFailCnt = lo_objResAdminPwdInfo.data.TodayLoginFailCnt;
                lo_intAdminLogInTryCnt  = lo_objResAdminPwdInfo.data.AdminLogInTryCnt;
                intGradeCode            = lo_objResAdminPwdInfo.data.GradeCode;

                // 설정된 비밀번호가 없다면, 이관 계정의 최초 로그인. 비밀번호 재설정을 진행한다.
                if (string.IsNullOrWhiteSpace(lo_strDBCurrPwd))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22000;
                    strErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_22000_MSG, lo_intAdminLogInTryCnt);
                    return lo_intRetVal;
                }

                if (lo_intTodayLoginFailCnt > lo_intAdminLogInTryCnt)
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22014;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22014_MSG, lo_intAdminLogInTryCnt);
                    return lo_intRetVal;
                }

                //Compare an entered password to a retrieved password from DB
                if (!lo_objBCrypt.CheckPassword(strPassword, lo_strDBCurrPwd))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22009;
                    strErrMsg    = ErrorHandler.COMMON_LIB_ERR_22009_MSG;
                    return lo_intRetVal;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9102;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }
            finally
            {
                lo_objBCrypt = null;
            }

            return lo_intRetVal;
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        /// Send verification email to administrator
        /// </summary>
        /// <param name="strAdminID">Administrator's ID</param>
        /// <param name="strIPAddr">Accessed IP Address</param>
        /// <param name="strAdminEmail">Email Address</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public static int SendVerificationEmail(string strAdminID, string strIPAddr, string strAdminEmail, out string strErrMsg)
        {
            int    lo_intRetVal          = ErrorHandler.COMMON_LIB_SUCCESS;
            string lo_strToken           = string.Empty;
            string lo_strEncToken        = string.Empty;

            MailAction                   lo_objMail                   = new MailAction();
            AdminDasServices             lo_objAdminDasServices       = new AdminDasServices();
            ServiceResult<PasswordReset> lo_objResInsertPasswordReset = null;

            strErrMsg = string.Empty;

            try
            {
                //Validate an accessed IP and insert the verification email information
                lo_objResInsertPasswordReset = lo_objAdminDasServices.InsertPasswordReset(strAdminID, strIPAddr, strAdminEmail);
                lo_intRetVal                 = lo_objResInsertPasswordReset.result.ErrorCode;
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg = lo_objResInsertPasswordReset.result.ErrorMsg;
                    return lo_intRetVal;
                }

                //Encrypt Token value
                lo_strEncToken = Utils.GetEncrypt(lo_strToken, SiteGlobal.AES2_ENC_IV_VALUE);
                if (string.IsNullOrEmpty(lo_strEncToken))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22012;
                    strErrMsg    = ErrorHandler.COMMON_LIB_ERR_22012_MSG;
                    return lo_intRetVal;
                }

                //Send a verification email
                lo_objMail.Subject  = $"[{SiteGlobal.DOMAINNAME}] Administrator's Password Reset Confirmation";
                lo_objMail.Body     = GetMailBody4PasswordReset(strAdminID, lo_strEncToken);
                lo_objMail.SmtpHost = SiteGlobal.MAIL_SERVER;
                lo_objMail.SmtpPort = SiteGlobal.MAIL_PORTNO;
                lo_objMail.SetFromMail(CommonConstant.ADMIN_FROM_EMAIL);
                lo_objMail.AddToMail(strAdminEmail);

                lo_intRetVal = lo_objMail.SendMail();
                if (lo_intRetVal.IsFail())
                {
                    strErrMsg    = lo_objMail.ErrMsg;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9103;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }
            finally
            {
                lo_objMail = null;
            }

            return lo_intRetVal;
        }

        private static string GetMailBody4PasswordReset(string strAdminID, string strEncToken)
        {
            StringBuilder pl_sbBody = new StringBuilder();

            pl_sbBody.Append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>");
            pl_sbBody.Append("<HTML>");
            pl_sbBody.Append("<HEAD>");
            pl_sbBody.Append("<META HTTP-EQUIV='Content-Type'>");
            pl_sbBody.Append("<STYLE type='text/css'>");
            pl_sbBody.Append("BODY { font: 9pt/12pt Tahoma }");
            pl_sbBody.Append("H1 { font: 13pt/15pt Tahoma }");
            pl_sbBody.Append("H2 { font: 9pt/12pt Tahoma }");
            pl_sbBody.Append("A:link { color: red }");
            pl_sbBody.Append("A:visited { color: maroon }");
            pl_sbBody.Append("</STYLE>");
            pl_sbBody.Append("</HEAD>");
            pl_sbBody.Append("<BODY>");
            pl_sbBody.Append("<TABLE width=500 border=0 cellspacing=10>");
            pl_sbBody.Append("<TR><TD>");
            pl_sbBody.AppendFormat("Please access this link to change your password of <b>{0}</b>.<br/>", strAdminID);
            pl_sbBody.AppendFormat(" >> <a href=\"{0}?token={1}\">Go to Reset Password</a>", strPasswordResetConfirmUrl, HttpUtility.UrlEncode(strEncToken));
            pl_sbBody.Append("</TD></TR>");
            pl_sbBody.Append("</TABLE>");
            pl_sbBody.Append("</BODY>");
            pl_sbBody.Append("</HTML>");

            return pl_sbBody.ToString();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check a token to verify an administrator
        /// </summary>
        /// <param name="strIPAddr">Accessed IP Address</param>
        /// <param name="strToken">Token</param>
        /// <param name="strAdminID">Admin ID</param>
        /// <param name="intUseLangTypeCode">Language Type Code</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public static int CheckPasswordReset(string strIPAddr, string strToken, out int intUseLangTypeCode, out string strAdminID, out string strErrMsg)
        {
            int lo_intRetVal = ErrorHandler.COMMON_LIB_SUCCESS;

            AdminDasServices             lo_objAdminDasServices      = new AdminDasServices();
            ServiceResult<PasswordReset> lo_objResCheckPasswordReset = null;

            intUseLangTypeCode = 0;
            strAdminID         = string.Empty;
            strErrMsg          = string.Empty;

            try
            {
                //Get current passowrd from DB
                lo_objResCheckPasswordReset = lo_objAdminDasServices.CheckPasswordReset(strIPAddr, strToken);
                lo_intRetVal                = lo_objResCheckPasswordReset.result.ErrorCode;
                strErrMsg                   = lo_objResCheckPasswordReset.result.ErrorMsg;

                if (lo_intRetVal.IsSuccess())
                {
                    intUseLangTypeCode = lo_objResCheckPasswordReset.data.UseLangTypeCode;
                    strAdminID         = lo_objResCheckPasswordReset.data.AdminID;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9104;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_intRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Validate password's policy
        /// </summary>
        /// <param name="strPassword"></param>
        /// <param name="strErrMsg"></param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        public static int ValidatePasswordPolicy(string strPassword, out string strErrMsg)
        {
            int lo_intRetVal = ErrorHandler.COMMON_LIB_SUCCESS;
            strErrMsg = string.Empty;

            //Check strong complexity of password
            lo_intRetVal = CheckStrongComplexity(strPassword, out strErrMsg);
            if (lo_intRetVal.IsSuccess())
            {
                //Check whether the password has consecutive values
                lo_intRetVal = CheckConsecutiveString(strPassword, out strErrMsg);
            }

            return lo_intRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check entered password's strong complexity policy
        /// </summary>
        /// <param name="strPassword">Entered Password</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        private static int CheckStrongComplexity(string strPassword, out string strErrMsg)
        {
            int lo_intRetVal = ErrorHandler.COMMON_LIB_SUCCESS;
            strErrMsg = string.Empty;

            try
            {
                //Check a digit of password
                Regex lo_objRegex4Digit = new Regex($@"^.*(?=.{{{PASSWORD_DIGIT_MIN},{PASSWORD_DIGIT_MAX}}})");
                if (!lo_objRegex4Digit.IsMatch(strPassword))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22001;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22001_MSG, PASSWORD_DIGIT_MIN, PASSWORD_DIGIT_MAX);
                    return lo_intRetVal;
                }

                //Check the password has a special character
                Regex lo_objRegex4Special = new Regex(@"([\W])");
                if (lo_objRegex4Special.Matches(strPassword).Count < PASSWORD_SPECIAL_CHAR_MIN)
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22002;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22002_MSG, PASSWORD_SPECIAL_CHAR_MIN);
                    return lo_intRetVal;
                }

                //Check number of numeric characters
                Regex lo_objRegex4Num = new Regex(@"[0-9]");
                if (lo_objRegex4Num.Matches(strPassword).Count < PASSWORD_NUMERIC_CHAR_MIN)
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22003;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22003_MSG, PASSWORD_NUMERIC_CHAR_MIN);
                    return lo_intRetVal;
                }

                //Check number of lower-case characters
                Regex lo_objRegex4Lower = new Regex(@"[a-z]");
                if (lo_objRegex4Lower.Matches(strPassword).Count < PASSWORD_LOWERCASE_CHAR_MIN)
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22004;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22004_MSG, PASSWORD_LOWERCASE_CHAR_MIN);
                    return lo_intRetVal;
                }

                //Check number of upper-case characters
                Regex lo_objRegex4Upper = new Regex(@"[A-Z]");
                if (lo_objRegex4Upper.Matches(strPassword).Count < PASSWORD_UPPERCASE_CHAR_MIN)
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22005;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22005_MSG, PASSWORD_UPPERCASE_CHAR_MIN);
                    return lo_intRetVal;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9105;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_intRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check entered password's consecutive string policy
        /// </summary>
        /// <param name="strPassword">Entered Password</param>
        /// <param name="strErrMsg">Error Message</param>
        /// <returns>Result(0=Success, 0!=Failure)</returns>
        ///----------------------------------------------------------------------
        private static int CheckConsecutiveString(string strPassword, out string strErrMsg)
        {
            int lo_intRetVal = ErrorHandler.COMMON_LIB_SUCCESS;
            strErrMsg = string.Empty;

            try
            {
                //Check consecutive same numbers or characters
                Regex lo_objRegex = new Regex($@"^*.([0-9a-zA-Z])\1{{{PASSWORD_CONSECUTIVE_SAME_LIMIT},}}.*$");
                if (lo_objRegex.IsMatch(strPassword))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22006;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22006_MSG, PASSWORD_CONSECUTIVE_SAME_LIMIT);
                    return lo_intRetVal;
                }

                //Check consecutive sequential numbers
                Regex lo_objRegex4SeqNum = new Regex($@"[0-9]{{{PASSWORD_CONSECUTIVE_SEQ_LIMIT},}}");
                MatchCollection lo_objMatchs4SeqNum = lo_objRegex4SeqNum.Matches(strPassword);
                if (!CheckSequentialValue(lo_objMatchs4SeqNum, false))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22007;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22007_MSG, PASSWORD_CONSECUTIVE_SEQ_LIMIT);
                    return lo_intRetVal;
                }

                //Check consecutive sequential numbers
                Regex lo_objRegex4SeqChar = new Regex($@"[a-zA-Z]{{{PASSWORD_CONSECUTIVE_SEQ_LIMIT},}}");
                MatchCollection lo_objMatchs4SeqChar = lo_objRegex4SeqChar.Matches(strPassword);
                if (!CheckSequentialValue(lo_objMatchs4SeqChar, true))
                {
                    lo_intRetVal = ErrorHandler.COMMON_LIB_ERR_22008;
                    strErrMsg    = string.Format(ErrorHandler.COMMON_LIB_ERR_22008_MSG, PASSWORD_CONSECUTIVE_SEQ_LIMIT);
                    return lo_intRetVal;
                }
            }
            catch (Exception lo_ex)
            {
                lo_intRetVal = 9106;
                strErrMsg    = CommonConstant.HTTP_STATUS_CODE_999_MESSAGE;
                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, lo_intRetVal);
            }

            return lo_intRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Check entered password's sequential value policy
        /// </summary>
        /// <param name="objMatchColl">Match Collection Object</param>
        /// <param name="blnIsChar">Flag to set if the value is character or numeric(true=numeric, false=char)</param>
        /// <returns>Result(true=Success, false=Failure)</returns>
        ///----------------------------------------------------------------------
        private static bool CheckSequentialValue(MatchCollection objMatchColl, bool blnIsChar)
        {
            bool pl_blnRet         = true;
            int  lo_intDenominator = blnIsChar ? 65 : 10;
            int  lo_intCnt         = 0;
            int  lo_intCnt4Reverse = 0;

            try
            {
                foreach (Match lo_objMatch in objMatchColl)
                {
                    char[] lo_arrvChar = lo_objMatch.Value.ToCharArray();
                    char lo_strPrev = lo_arrvChar[0];
                    for (int lo_int = 1; lo_int < lo_arrvChar.Length; lo_int++)
                    {
                        char lo_strThis = lo_arrvChar[lo_int];
                        //Check ascending values
                        if ((lo_strPrev.ToInt() + 1) % lo_intDenominator == lo_strThis.ToInt() % lo_intDenominator)
                        {
                            lo_intCnt++;
                        }
                        else
                        {
                            lo_intCnt = 0;
                        }

                        //Check descending values
                        if ((lo_strPrev.ToInt() - 1) % lo_intDenominator == lo_strThis.ToInt() % lo_intDenominator)
                        {
                            lo_intCnt4Reverse++;
                        }
                        else
                        {
                            lo_intCnt4Reverse = 0;
                        }

                        if (lo_intCnt + 1 > PASSWORD_CONSECUTIVE_SEQ_LIMIT ||
                            lo_intCnt4Reverse + 1 > PASSWORD_CONSECUTIVE_SEQ_LIMIT)
                        {
                            pl_blnRet = false;
                        }
                        else
                        {
                            lo_strPrev = lo_strThis;
                        }
                    }
                }
            }
            catch (Exception lo_ex)
            {
                pl_blnRet = false;

                SiteGlobal.WriteLog("PasswordManager", "Exception",
                                    "\r\n\t[ex.Message] : " + lo_ex.Message + "\r\n\t[ex.StackTrace] : " +
                                    lo_ex.StackTrace, 9200);
            }

            return pl_blnRet;
        }
    }
}