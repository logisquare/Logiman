using System;
using CommonLibrary.CommonUtils;

//===============================================================
// FileName       : StringExtensions.cs
// Description    : ValidCheck, DataType Convert
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.Extensions
{
    public static class StringExtensions
    {
        #region 실행결과 확인
        public static bool IsSuccess(this int intErrorCode)
        {
            return intErrorCode.Equals(ErrorHandler.COMMON_LIB_SUCCESS);
        }
        public static bool IsFail(this int intErrorCode)
        {
            return !intErrorCode.Equals(ErrorHandler.COMMON_LIB_SUCCESS);
        }
        #endregion

        /// <summary>
        /// Check whether the value is numeric
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Result</return>
        public static bool IsNumeric(string strVal)
        {
            bool   lo_blnRet = false;
            long   lo_intNum = 0;
            double lo_dblNum = 0;

            lo_blnRet = StringExtensions.ToInt64(strVal, out lo_intNum);
            if (!lo_blnRet)
            {
                lo_blnRet = StringExtensions.ToDouble(strVal, out lo_dblNum);
            }

            return lo_blnRet;
        }

        /// <summary>
        /// Convert Hex string to Byte array
        /// </summary>
        /// <param name="strHex">Hex data</param>
        /// <return>Byte array</return>
        public static byte[] ConvertHex2Byte(string strHex)
        {
            byte[] lo_arrBytes = new byte[strHex.Length / 2];
            int    lo_intIdx   = 0;

            for (lo_intIdx = 0; lo_intIdx < lo_arrBytes.Length; lo_intIdx++)
            {
                lo_arrBytes[lo_intIdx] = Convert.ToByte(strHex.Substring(lo_intIdx * 2, 2), 16);
            }

            return lo_arrBytes;
        }

        /// <summary>
        /// Convert Byte array to Hex string
        /// </summary>
        /// <param name="arrBytes">Byte array</param>
        /// <return>Hex data</return>
        public static string ConvertByte2Hex(byte[] arrBytes)
        {
            string lo_strHex = string.Empty;
            int    lo_intIdx = 0;

            if (arrBytes != null)
            {
                for (lo_intIdx = 0; lo_intIdx < arrBytes.Length; lo_intIdx++)
                {
                    lo_strHex += arrBytes[lo_intIdx].ToString("X2");
                }
            }

            return lo_strHex;
        }

        public static string ConvertMoneyFormat(object money)
        {
            double lo_cmoney = Convert.ToDouble(money);

            string lo_currencyMoney = $"{lo_cmoney:n0}";

            return lo_currencyMoney;
        }

        #region String Extension Methods
        /// <summary>
        /// Convert the value from string to bool
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="blnConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToBool(string strVal, out bool blnConvVal)
        {
            bool lo_blnRet = false;

            blnConvVal = false;
            lo_blnRet  = bool.TryParse(strVal, out blnConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to bool
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static bool ToBool(this object objVal)
        {
            return Convert.ToBoolean(objVal);
        }

        /// <summary>
        /// Convert the value from string to Byte
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="bytConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToByte(string strVal, out Byte bytConvVal)
        {
            bool lo_blnRet = false;

            bytConvVal = new Byte();
            lo_blnRet  = Byte.TryParse(strVal, out bytConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Byte (case 2.b)
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>

        public static Byte ToByte(this object objVal)
        {
            return Convert.ToByte(objVal);
        }

        /// <summary>
        /// Convert the value from string to SByte
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="sbtConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToSByte(string strVal, out SByte sbtConvVal)
        {
            bool lo_blnRet = false;

            sbtConvVal = new SByte();
            lo_blnRet  = SByte.TryParse(strVal, out sbtConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to SByte
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static SByte ToSByte(this object objVal)
        {
            return Convert.ToSByte(objVal);
        }

        /// <summary>
        /// Convert the value from string to Char
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="strConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToChar(string strVal, out Char strConvVal)
        {
            bool lo_blnRet = false;

            strConvVal = new Char();
            lo_blnRet  = Char.TryParse(strVal, out strConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Char
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Char ToChar(this object objVal)
        {
            return Convert.ToChar(objVal);
        }

        /// <summary>
        /// Convert the value from string to Decimal
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="dcmConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToDecimal(string strVal, out Decimal dcmConvVal)
        {
            bool lo_blnRet = false;

            dcmConvVal = new Decimal();
            lo_blnRet  = Decimal.TryParse(strVal, out dcmConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Decimal
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Decimal ToDecimal(this object objVal)
        {
            return Convert.ToDecimal(objVal);
        }

        /// <summary>
        /// Convert the value from string to Double
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="dblConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToDouble(string strVal, out Double dblConvVal)
        {
            bool lo_blnRet = false;

            dblConvVal = new Double();
            lo_blnRet  = Double.TryParse(strVal, out dblConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Double
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Double ToDouble(this object objVal)
        {
            return Convert.ToDouble(objVal);
        }

        /// <summary>
        /// Convert the value from string to Float
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="fltConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToFloat(string strVal, out Single fltConvVal)
        {
            bool lo_blnRet = false;

            fltConvVal = new Single();
            lo_blnRet  = Single.TryParse(strVal, out fltConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Float
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Single ToFloat(this object objVal)
        {
            return Convert.ToSingle(objVal);
        }

        /// <summary>
        /// Convert the value from string to Int16
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToInt16(string strVal, out Int16 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new Int16();
            lo_blnRet  = Int16.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Int16
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Int16 ToInt16(this object objVal)
        {
            return Convert.ToInt16(objVal);
        }

        /// <summary>
        /// Convert the value from string to Int32
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToInt(string strVal, out Int32 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new Int32();
            lo_blnRet  = Int32.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Int32
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static Int32 ToInt(this object objVal)
        {
            return Convert.ToInt32(objVal);
        }

        /// <summary>
        /// Convert the value from string to Int64
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToInt64(string strVal, out Int64 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new Int64();
            lo_blnRet  = Int64.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to Int64
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>

        public static Int64 ToInt64(this object objVal)
        {
            return Convert.ToInt64(objVal);
        }

        /// <summary>
        /// Convert the value from string to UInt16
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToUInt16(string strVal, out UInt16 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new UInt16();
            lo_blnRet  = UInt16.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to UInt16
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static UInt16 ToUInt16(this object objVal)
        {
            return Convert.ToUInt16(objVal);
        }

        /// <summary>
        /// Convert the value from string to UInt32
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToUInt(string strVal, out UInt32 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new UInt32();
            lo_blnRet  = UInt32.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to UInt32
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static UInt32 ToUInt(this object objVal)
        {
            return Convert.ToUInt32(objVal);
        }

        /// <summary>
        /// Convert the value from string to UInt64
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="intConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToUInt64(string strVal, out UInt64 intConvVal)
        {
            bool lo_blnRet = false;

            intConvVal = new UInt64();
            lo_blnRet  = UInt64.TryParse(strVal, out intConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to UInt64
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static UInt64 ToUInt64(this object objVal)
        {
            return Convert.ToUInt64(objVal);
        }

        /// <summary>
        /// Convert the value from string to DateTime
        /// </summary>
        /// <param name="strVal">String value</param>
        /// <param name="dtConvVal">Converted value</param>
        /// <return>Result</return>
        public static bool ToDateTime(string strVal, out DateTime dtConvVal)
        {
            bool lo_blnRet = false;

            dtConvVal = new DateTime();
            lo_blnRet = DateTime.TryParse(strVal, out dtConvVal);

            return lo_blnRet;
        }

        /// <summary>
        /// Convert the value from string to DateTime
        /// </summary>
        /// <param name="objVal">object value</param>
        /// <return>Converted value</return>
        public static DateTime ToDateTime(this object objVal)
        {
            return Convert.ToDateTime(objVal);
        }

        /// <summary>
        /// Substring Right length
        /// </summary>
        /// <param name="sValue">String value</param>
        /// <param name="nMaxLength">string max length</param>
        /// <return>Converted value</return>
        public static string Right(this string sValue, int nMaxLength)
        {
            //Check if the value is valid
            if (string.IsNullOrEmpty(sValue))
            {
                //Set valid empty string as string could be null
                sValue = string.Empty;
            }
            else if (sValue.Length > nMaxLength)
            {
                //Make the string no longer than the max length
                sValue = sValue.Substring(sValue.Length - nMaxLength, nMaxLength);
            }

            //Return the string
            return sValue;
        }
        #endregion
    }
}