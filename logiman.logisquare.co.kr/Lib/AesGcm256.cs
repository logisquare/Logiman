using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Engines;
using Org.BouncyCastle.Crypto.Modes;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Security;
using System;
using System.IO;
using System.Text;

//===============================================================
// FileName       : AesGcm256.cs
// Description    : AES-GMS 256 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonUtils
{
    public class AesGcm256
    {
        private static readonly SecureRandom Random = new SecureRandom();

        private const int NONCE_BIT_SIZE = 128;
        private const int MAC_BIT_SIZE   = 128;
        private const int KEY_BIT_SIZE   = 256;

        public AesGcm256()
        {

        }

        /// <summary>
        /// 키생성
        /// </summary>
        /// AESGCM256.toHex((AESGCM256.NewKey()));
        public static byte[] NewKey()
        {
            var key = new byte[KEY_BIT_SIZE / 8];
            Random.NextBytes(key);
            return key;
        }

        /// <summary>
        /// IV키생성
        /// </summary>
        /// AESGCM256.toHex((AESGCM256.NewIv()));
        public static byte[] NewIv()
        {
            var iv = new byte[NONCE_BIT_SIZE / 8];
            Random.NextBytes(iv);
            return iv;
        }

        public static byte[] HexToByte(string hexStr)
        {
            byte[] bArray = new byte[hexStr.Length / 2];
            for (int i = 0; i < (hexStr.Length / 2); i++)
            {
                byte firstNibble  = Byte.Parse(hexStr.Substring((2 * i), 1), System.Globalization.NumberStyles.HexNumber);
                byte secondNibble = Byte.Parse(hexStr.Substring((2 * i) + 1, 1), System.Globalization.NumberStyles.HexNumber);
                int finalByte = (secondNibble) | (firstNibble << 4);

                bArray[i] = (byte)finalByte;
            }
            return bArray;
        }

        public static string toHex(byte[] data)
        {
            string hex = string.Empty;
            foreach (byte c in data)
            {
                hex += c.ToString("X2");
            }
            return hex;
        }

        public static string toHex(string asciiString)
        {
            string hex = string.Empty;
            foreach (char c in asciiString)
            {
                int tmp = c;
                hex += string.Format("{0:x2}", System.Convert.ToUInt32(tmp.ToString()));
            }
            return hex;
        }

        public static byte[] getKeyBytes(string strKey)
        {
            string lo_strRandom = "LogislabAESGCM256InitialKey!@#$%";
            string lo_strKey    = string.Empty;

            for (int lo_intLoop = 0; lo_intLoop < lo_strRandom.Length; lo_intLoop++)
            {
                if (strKey.Length > lo_intLoop)
                {
                    lo_strKey += strKey.Substring(lo_intLoop, 1);
                }
                else
                {
                    lo_strKey += lo_strRandom.Substring(lo_intLoop, 1);
                }
            }
            return Encoding.UTF8.GetBytes(lo_strKey);
        }

        public static byte[] getIVBytes(string strKey)
        {
            string lo_strRandom = "LogislabIVKey!@#";
            string lo_strKey    = string.Empty;

            for (int lo_intLoop = 0; lo_intLoop < lo_strRandom.Length; lo_intLoop++)
            {
                if (strKey.Length > lo_intLoop)
                {
                    lo_strKey += strKey.Substring(lo_intLoop, 1);
                }
                else
                {
                    lo_strKey += lo_strRandom.Substring(lo_intLoop, 1);
                }
            }
            return Encoding.UTF8.GetBytes(lo_strKey);
        }

        /// <summary>
        /// 암호화
        /// </summary>
        /// AESGCM256.AESGCM256Encrypt(PlainText, AESGCM256.HexToByte(key), AESGCM256.HexToByte(iv))
        public static string AESGCM256Encrypt(string PlainText, byte[] key, byte[] iv)
        {
            string lstrEncData = string.Empty;
            try
            {
                byte[]         plainBytes = Encoding.UTF8.GetBytes(PlainText);
                GcmBlockCipher cipher     = new GcmBlockCipher(new AesFastEngine());
                AeadParameters parameters = new AeadParameters(new KeyParameter(key), MAC_BIT_SIZE, iv, null);

                cipher.Init(true, parameters);

                byte[] encryptedBytes = new byte[cipher.GetOutputSize(plainBytes.Length)];
                Int32  retLen         = cipher.ProcessBytes(plainBytes, 0, plainBytes.Length, encryptedBytes, 0);
                cipher.DoFinal(encryptedBytes, retLen);

                byte[] iv_encryptedBytes = new byte[iv.Length + encryptedBytes.Length];

                Buffer.BlockCopy(iv, 0, iv_encryptedBytes, 0, iv.Length);
                Buffer.BlockCopy(encryptedBytes, 0, iv_encryptedBytes, iv.Length, encryptedBytes.Length);

                lstrEncData = Convert.ToBase64String(iv_encryptedBytes, Base64FormattingOptions.None);

            }
            catch (Exception)
            {
                lstrEncData = "";
            }

            return lstrEncData;
        }

        /// <summary>
        /// 복호화
        /// </summary>
        /// _AESGCM256.AESGCM256Decrypt(EncryptedText, _AESGCM256.HexToByte(key))
        public static string AESGCM256Decrypt(string EncryptedText, byte[] key)
        {
            string lstrDecData    = string.Empty;
            byte[] encryptedBytes = Convert.FromBase64String(EncryptedText);

            using (var cipherStream = new MemoryStream(encryptedBytes))
            using (var cipherReader = new BinaryReader(cipherStream))
            {
                var iv         = cipherReader.ReadBytes(NONCE_BIT_SIZE / 8);
                var cipher     = new GcmBlockCipher(new AesFastEngine());
                var parameters = new AeadParameters(new KeyParameter(key), MAC_BIT_SIZE, iv, null);
                cipher.Init(false, parameters);

                var cipherText = cipherReader.ReadBytes(encryptedBytes.Length - iv.Length);
                var plainText  = new byte[cipher.GetOutputSize(cipherText.Length)];

                try
                {
                    var len = cipher.ProcessBytes(cipherText, 0, cipherText.Length, plainText, 0);
                    cipher.DoFinal(plainText, len);

                    lstrDecData = Encoding.UTF8.GetString(plainText).TrimEnd("\r\n\0".ToCharArray());
                }
                catch (InvalidCipherTextException)
                {
                    lstrDecData = "";
                }

                return lstrDecData;
            }
        }
    }
}