using System;
using CommonLibrary.CommonUtils;
using CommonLibrary.Extensions;
using System.Security.Cryptography;
using System.Text;

//===============================================================
// FileName       : Hash.cs
// Description    : Hash Class(MD5, SHA~, HMACMD5, HMACSHA~...)
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.Utils
{
    public static class Hash
    {
        /// <summary>
        /// MD5 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool MD5(string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool   lo_blnRet       = false;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;
            strHash = string.Empty;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new MD5CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                strHash         = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet       = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// MD5 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Hash value</return>
        public static string MD5(this string strVal, CodePage encodingCode = CodePage.UTF_8)
        {
            string lo_strHash      = string.Empty;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new MD5CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                lo_strHash      = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
            }
            catch
            {
                lo_strHash = string.Empty;
            }

            return lo_strHash;
        }

        /// <summary>
        /// SHA256 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool SHA256(string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool   lo_blnRet       = false;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;
            strHash = string.Empty;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA256CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                strHash         = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet       = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// SHA256 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Hash value</return>
        public static string SHA256(this string strVal, CodePage encodingCode = CodePage.UTF_8)
        {
            string lo_strHash      = string.Empty;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA256CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                lo_strHash      = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
            }
            catch
            {
                lo_strHash = string.Empty;
            }

            return lo_strHash;
        }

        /// <summary>
        /// SHA1 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool SHA1(string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool   lo_blnRet       = false;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;
            strHash = string.Empty;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA1CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                strHash         = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet       = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// SHA1 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Hash value</return>
        public static string SHA1(this string strVal, CodePage encodingCode = CodePage.UTF_8)
        {
            string lo_strHash      = string.Empty;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA1CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                lo_strHash      = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
            }
            catch
            {
                lo_strHash = string.Empty;
            }

            return lo_strHash;
        }

        /// <summary>
        /// SHA384 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool SHA384(string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool   lo_blnRet       = false;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;
            strHash = string.Empty;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA384CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                strHash         = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet       = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// SHA384 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Hash value</return>
        public static string SHA384(this string strVal, CodePage encodingCode = CodePage.UTF_8)
        {
            string lo_strHash      = string.Empty;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA384CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                lo_strHash      = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
            }
            catch
            {
                lo_strHash = string.Empty;
            }

            return lo_strHash;
        }

        /// <summary>
        /// SHA512 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="intCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool SHA512(string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool   lo_blnRet       = false;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;
            strHash = string.Empty;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA512CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                strHash         = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet       = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// SHA512 Hashing Function
        /// </summary>
        /// <param name="strVal">Plain text</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Hash value</return>
        public static string SHA512(this string strVal, CodePage encodingCode = CodePage.UTF_8)
        {
            string lo_strHash      = string.Empty;
            byte[] lo_arrPlainByte = null;
            byte[] lo_arrHashByte  = null;

            try
            {
                lo_arrPlainByte = Encoding.GetEncoding(encodingCode.GetHashCode()).GetBytes(strVal);
                lo_arrHashByte  = (new SHA512CryptoServiceProvider()).ComputeHash(lo_arrPlainByte);
                lo_strHash      = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
            }
            catch
            {
                lo_strHash = string.Empty;
            }

            return lo_strHash;
        }

        /// <summary>
        /// HMACMD5 Hashing Function
        /// </summary>
        /// <param name="strKey">Key</param>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool HMACMD5(string strKey, string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool     lo_blnRet       = false;
            byte[]   lo_arrPlainByte = null;
            byte[]   lo_arrHashByte  = null;
            byte[]   lo_arrKeyByte   = null;

            HMACMD5  lo_objHash      = null;
            Encoding lo_objEncoding  = null;
            strHash = string.Empty;

            try
            {
                lo_objEncoding  = Encoding.GetEncoding(encodingCode.GetHashCode());
                lo_arrKeyByte   = lo_objEncoding.GetBytes(strKey);
                lo_objHash      = new HMACMD5(lo_arrKeyByte);
                lo_arrPlainByte = lo_objEncoding.GetBytes(strVal);
                lo_arrHashByte  = lo_objHash.ComputeHash(lo_arrPlainByte);

                strHash   = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }
            finally
            {
                lo_objHash     = null;
                lo_objEncoding = null;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// HMACSHA1 Hashing Function
        /// </summary>
        /// <param name="strKey">Key</param>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool HMACSHA1(string strKey, string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool     lo_blnRet       = false;
            byte[]   lo_arrPlainByte = null;
            byte[]   lo_arrHashByte  = null;
            byte[]   lo_arrKeyByte   = null;

            HMACSHA1 lo_objHash      = null;
            Encoding lo_objEncoding  = null;
            strHash = string.Empty;

            try
            {
                lo_objEncoding  = Encoding.GetEncoding(encodingCode.GetHashCode());
                lo_arrKeyByte   = lo_objEncoding.GetBytes(strKey);
                lo_objHash      = new HMACSHA1(lo_arrKeyByte);
                lo_arrPlainByte = lo_objEncoding.GetBytes(strVal);
                lo_arrHashByte  = lo_objHash.ComputeHash(lo_arrPlainByte);

                strHash   = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }
            finally
            {
                lo_objHash     = null;
                lo_objEncoding = null;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// HMACSHA256 Hashing Function
        /// </summary>
        /// <param name="strKey">Key</param>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool HMACSHA256(string strKey, string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool       lo_blnRet       = false;
            byte[]     lo_arrPlainByte = null;
            byte[]     lo_arrHashByte  = null;
            byte[]     lo_arrKeyByte   = null;

            HMACSHA256 lo_objHash      = null;
            Encoding   lo_objEncoding  = null;
            strHash = string.Empty;

            try
            {
                lo_objEncoding  = Encoding.GetEncoding(encodingCode.GetHashCode());
                lo_arrKeyByte   = lo_objEncoding.GetBytes(strKey);
                lo_objHash      = new HMACSHA256(lo_arrKeyByte);
                lo_arrPlainByte = lo_objEncoding.GetBytes(strVal);
                lo_arrHashByte  = lo_objHash.ComputeHash(lo_arrPlainByte);

                strHash   = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }
            finally
            {
                lo_objHash     = null;
                lo_objEncoding = null;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// HMACSHA384 Hashing Function
        /// </summary>
        /// <param name="strKey">Key</param>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool HMACSHA384(string strKey, string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool       lo_blnRet       = false;
            byte[]     lo_arrPlainByte = null;
            byte[]     lo_arrHashByte  = null;
            byte[]     lo_arrKeyByte   = null;

            HMACSHA384 lo_objHash      = null;
            Encoding   lo_objEncoding  = null;
            strHash = string.Empty;

            try
            {
                lo_objEncoding  = Encoding.GetEncoding(encodingCode.GetHashCode());
                lo_arrKeyByte   = lo_objEncoding.GetBytes(strKey);
                lo_objHash      = new HMACSHA384(lo_arrKeyByte);
                lo_arrPlainByte = lo_objEncoding.GetBytes(strVal);
                lo_arrHashByte  = lo_objHash.ComputeHash(lo_arrPlainByte);

                strHash   = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }
            finally
            {
                lo_objHash     = null;
                lo_objEncoding = null;
            }

            return lo_blnRet;
        }

        /// <summary>
        /// HMACSHA512 Hashing Function
        /// </summary>
        /// <param name="strKey">Key</param>
        /// <param name="strVal">Plain text</param>
        /// <param name="strHash">Hash value</param>
        /// <param name="encodingCode">Code Infomation</param>
        /// <return>Result</return>
        public static bool HMACSHA512(string strKey, string strVal, out string strHash, CodePage encodingCode = CodePage.UTF_8)
        {
            bool       lo_blnRet       = false;
            byte[]     lo_arrPlainByte = null;
            byte[]     lo_arrHashByte  = null;
            byte[]     lo_arrKeyByte   = null;

            HMACSHA512 lo_objHash      = null;
            Encoding   lo_objEncoding  = null;
            strHash = string.Empty;

            try
            {
                lo_objEncoding  = Encoding.GetEncoding(encodingCode.GetHashCode());
                lo_arrKeyByte   = lo_objEncoding.GetBytes(strKey);
                lo_objHash      = new HMACSHA512(lo_arrKeyByte);
                lo_arrPlainByte = lo_objEncoding.GetBytes(strVal);
                lo_arrHashByte  = lo_objHash.ComputeHash(lo_arrPlainByte);

                strHash   = StringExtensions.ConvertByte2Hex(lo_arrHashByte);
                lo_blnRet = true;
            }
            catch
            {
                lo_blnRet = false;
                strHash   = string.Empty;
            }
            finally
            {
                lo_objHash     = null;
                lo_objEncoding = null;
            }

            return lo_blnRet;
        }

        public static string Base64Encode(string strMessage)
        {
            var    lo_objEncoding   = new ASCIIEncoding();
            byte[] lo_bMessageBytes = lo_objEncoding.GetBytes(strMessage);
            return Convert.ToBase64String(lo_bMessageBytes);
        }

        public static string Base64Decode(string strMessage)
        {
            var     lo_objEncoding     = new ASCIIEncoding();
            Decoder lo_objDecode       = lo_objEncoding.GetDecoder();
            byte[]  lo_arrMessageBytes = Convert.FromBase64String(strMessage);
            int     lo_intCharCount    = lo_objDecode.GetCharCount(lo_arrMessageBytes, 0, lo_arrMessageBytes.Length);
            char[]  lo_arrDecodedChar  = new char[lo_intCharCount];

            lo_objDecode.GetChars(lo_arrMessageBytes, 0, lo_arrMessageBytes.Length, lo_arrDecodedChar, 0);
            return new string(lo_arrDecodedChar);
        }
    }
}