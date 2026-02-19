using CommonLibrary.CommonUtils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using CommonLibrary.CommonModule;

//===============================================================
// FileName       : HttpAction.cs
// Description    : Http Rquest 관리 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.Utils
{
    #region HttpHeader Class
    public sealed class HttpHeader
    {
        #region Member variables

        public HttpAction.MethodType Method           { get; set; } //Http method(Default:Get)
        public string                Accept           { get; set; } //Http Accept(It specifies the response body type)
        public string                ConentType       { get; set; } //Http Content type(It specifies the request body type)
        public string                Host             { get; set; } //Request Host
        public string                Referer          { get; set; } //Http Referer
        public string                TransferEncoding { get; set; } //Http Transfer Encoding
        public string                UserAgent        { get; set; } //Request User Agent
        public bool                  KeepAlive        { get; set; } //Flag to set whether to keep alive
        public Nullable<DateTime>    Date             { get; set; } //Http Date object
        public Nullable<DateTime>    IfModifiedSince  { get; set; } //Http Date of modified since object

        public Dictionary<string, string> CustomHeaders    { get; set; } //Additional headers
        #endregion

        #region Methods
        /// <summary>
        /// Initialize Member variables
        /// </summary>
        private void Initialize()
        {
            this.Method     = HttpAction.MethodType.Get;
            this.Accept     = string.Empty;
            this.ConentType = string.Empty;
            this.Host       = string.Empty;
            this.Referer    = string.Empty;

            this.TransferEncoding = string.Empty;
            this.UserAgent        = string.Empty;
            this.KeepAlive        = true;
            this.Date             = null;
            this.IfModifiedSince  = null;

            this.CustomHeaders = new Dictionary<string, string>();
        }

        /// <summary>
        /// HttpHeader Constructor
        /// </summary>
        public HttpHeader()
        {
            this.Initialize();
        }

        /// <summary>
        /// HttpHeader Constructor
        /// </summary>
        /// <param name="methodType">Http Method Type</param>
        public HttpHeader(HttpAction.MethodType methodType)
        {
            this.Initialize();
            this.Method = methodType;
        }

        /// <summary>
        /// HttpHeader Destructor
        /// </summary>
        ~HttpHeader()
        {
            this.CustomHeaders = null;
        }

        /// <summary>
        /// Add Http Header
        /// </summary>
        /// <param name="strName">Header name</param>
        /// <param name="strValue">Header value</param>
        public void AddCustomHeader(string strName, string strValue)
        {
            this.CustomHeaders.Add(strName, strValue);
        }
        #endregion
    }
    #endregion

    #region HttpAction Class
    public sealed class HttpAction
    {
        private bool _bLogUseFlag    = false;
        private int  LongProcessTime = 10;

        #region MethodType enumeration
        public enum MethodType
        {
            Get,        //Used when the client is requesting a resource on the Web server
            //Head,       //Used when the client is requesting some information about a resource but not requesting the resource itself
            Post,       //Used when the client is sending information or data to the server—for example, filling out an online form (i.e. Sends a large amount of complex data to the Web Server)
            Put,        //Used when the client is sending a replacement document or uploading a new document to the Web server under the request URL
            //Delete,     //Used when the client is trying to delete a document from the Web server, identified by the request URL
            //Trace,      //Used when the client is asking the available proxies or intermediate servers changing the request to announce themselves
            //Options     //Used when the client wants to determine other available methods to retrieve or process a document on the Web server
        }
        #endregion

        #region Member variables
        private const string   HTTPREQUEST_DEFAULT_CONTENTTYPE = "application/json; charset=utf-8";     //Default content type
        private const string   HTTPREQUEST_FORM_CONTENTTYPE    = "application/x-www-form-urlencoded";   //Default content type
        private const CodePage HTTPREQUEST_DEFAULT_ENCODING    = CodePage.UTF_8;                        //Default Encoding

        public bool   IgnoreSsl         { get; set; }         //Flag to set whether to ignore SSL certificate
        public bool   Expect100Continue { get; set; }         //Flag to set whether to use 100-Continue
        public bool   UriEncodeFlag     { get; set; }         //Flag to set whether to use UriEncode
        public int    ConnectTimeout    { get; set; }         //Connection Timeout(Unit:Sec)
        public int    HttpStatus        { get; private set; } //Http Status of response

        public int    RetVal            { get; private set; } //Error code
        public string Url               { get; set; }         //Request URL
        public string RequestData       { get; set; }         //Request string
        public string HttpStatusText    { get; private set; } //Http Description of response
        public string ResponseData      { get; private set; } //Response data as string
        public string ErrMsg            { get; private set; } //Error message
        public byte[] ResponseBytes     { get; private set; } //Response data as byte array

        public HttpHeader                 Header        { get; set; } //HttpHeader object
        public Dictionary<string, string> RequestParams { get; set; } //Request parameter(Name Value pair format)
        public Encoding                   Encoding      { get; set; } //Encoding object
        #endregion

        #region Methods
        #region Constructor and Destructor
        /// <summary>
        /// Initialize Member variables
        /// </summary>
        private void Initialize()
        {
            this.IgnoreSsl         = true;
            this.Expect100Continue = false;
            this.UriEncodeFlag     = false;
            this.ConnectTimeout    = 100; //Default:100 Sec
            this.HttpStatus        = 0;

            this.RetVal            = 0;
            this.RequestData       = string.Empty;
            this.Url               = string.Empty;
            this.HttpStatusText    = string.Empty;
            this.ResponseData      = string.Empty;

            this.ErrMsg            = string.Empty;
            this.ResponseBytes     = new byte[0];
            this.Header            = new HttpHeader();
            this.RequestParams     = new Dictionary<string, string>();
            this.Encoding          = Encoding.GetEncoding(HTTPREQUEST_DEFAULT_ENCODING.GetHashCode());
        }

        private void WriteHttpActionLog(string strLogText)
        {
            SiteGlobal.WriteInformation("HttpAction", "D", strLogText, _bLogUseFlag);
        }

        private void WriteHttpActionLog(string strLogText, bool bLogUseFlag)
        {
            SiteGlobal.WriteInformation("HttpAction", "D", strLogText, bLogUseFlag);
        }

        /// <summary>
        /// HttpAction Constructor
        /// </summary>
        /// <param name="strReqUrl">Http Request URL</param>
        /// <param name="methodType">Http Method Type</param>
        /// <param name="strContentType">Http Content Type</param>
        /// <param name="objReqParams">Http Request Parameters</param>
        /// <param name="encodingCode">Encoding Code Page</param>
        public HttpAction(string strReqUrl, Dictionary<string, string> objReqParams, HttpAction.MethodType methodType = HttpAction.MethodType.Get,
                          string strContentType = HTTPREQUEST_DEFAULT_CONTENTTYPE, CodePage encodingCode = HTTPREQUEST_DEFAULT_ENCODING)
        {
            this.Initialize();

            this.Url      = strReqUrl;
            this.Header   = new HttpHeader(methodType) {ConentType = strContentType};
            this.Encoding = Encoding.GetEncoding(encodingCode.GetHashCode());

            if (objReqParams != null)
            {
                this.RequestParams = objReqParams;
            }
        }

        /// <summary>
        /// HttpAction Constructor
        /// </summary>
        /// <param name="strReqUrl">Http Request URL</param>
        /// <param name="methodType">Http Method Type</param>
        /// <param name="strContentType">Http Content Type</param>
        /// <param name="strReqVal">Http Request Data</param>
        /// <param name="encodingCode">Encoding Code Page</param>
        public HttpAction(string strReqUrl, HttpAction.MethodType methodType = HttpAction.MethodType.Get, string strReqVal = "",
                          string strContentType = HTTPREQUEST_DEFAULT_CONTENTTYPE, CodePage encodingCode = HTTPREQUEST_DEFAULT_ENCODING)
        {
            this.Initialize();

            this.Url         = strReqUrl;
            this.Header      = new HttpHeader(methodType) {ConentType = strContentType};
            this.RequestData = strReqVal;
            this.Encoding    = Encoding.GetEncoding(encodingCode.GetHashCode());
        }

        /// <summary>
        /// HttpAction Constructor
        /// </summary>
        /// <param name="strReqUrl">Http Request URL</param>
        /// <param name="objReqHeader">Http Header Object</param>
        /// <param name="objReqParams">Http Request Parameters</param>
        /// <param name="encodingCode">Encoding Code Page</param>
        public HttpAction(string strReqUrl, HttpHeader objReqHeader, Dictionary<string, string> objReqParams, CodePage encodingCode = HTTPREQUEST_DEFAULT_ENCODING)
        {
            this.Initialize();

            this.Url      = strReqUrl;
            this.Header   = objReqHeader;
            this.Encoding = Encoding.GetEncoding(encodingCode.GetHashCode());

            if (objReqParams != null)
            {
                this.RequestParams = objReqParams;
            }
        }

        /// <summary>
        /// HttpAction Constructor
        /// </summary>
        /// <param name="strReqUrl">Http Request URL</param>
        /// <param name="objReqHeader">Http Header Object</param>
        /// <param name="strReqVal">Http Request Data</param>
        /// <param name="encodingCode">Encoding Code Page</param>
        public HttpAction(string strReqUrl, HttpHeader objReqHeader, string strReqVal = "", CodePage encodingCode = HTTPREQUEST_DEFAULT_ENCODING)
        {
            this.Initialize();

            this.Url         = strReqUrl;
            this.Header      = objReqHeader;
            this.RequestData = strReqVal;
            this.Encoding    = Encoding.GetEncoding(encodingCode.GetHashCode());
        }

        /// <summary>
        /// HttpAction Destructor
        /// </summary>
        ~HttpAction()
        {
            this.Encoding      = null;
            this.Header        = null;
            this.RequestParams = null;
        }
        #endregion


        /// <summary>
        /// Add request parameter
        /// </summary>
        /// <param name="strName">Parameter name</param>
        /// <param name="strValue">Parameter value</param>
        public void AddRequestParam(string strName, string strValue)
        {
            this.RequestParams.Add(strName, strValue);
        }

        /// <summary>
        /// Send Http request
        /// </summary>
        /// <return>Error code</return>
        public int SendHttpActionEx(bool bLogUseFlag = false)
        {
            string          lo_strRequestData = string.Empty;
            byte[]          lo_arrByteData    = null;
            HttpWebRequest  lo_objHttpWebReq  = null;
            HttpWebResponse lo_objHttpWebRes  = null;
            Stream          lo_objStream      = null;
            StreamReader    lo_objStreamIn    = null;
            MemoryStream    lo_objMemStream   = null;

            DateTime lo_dtStartDate = DateTime.Now;
            DateTime lo_dtEndDate   = DateTime.Now;

            try
            {
                _bLogUseFlag = bLogUseFlag;

                //Set the value of request parameters as string
                if (this.RequestParams != null && this.RequestParams.Count > 0) //Name Value pair format
                {
                    foreach (KeyValuePair<string, string> lo_objKVP in this.RequestParams)
                    {
                        if (!string.IsNullOrEmpty(lo_strRequestData))
                        {
                            lo_strRequestData += "&";
                        }

                        lo_strRequestData += lo_objKVP.Key + "=";

                        if (this.UriEncodeFlag)
                        {
                            lo_strRequestData += HttpUtility.UrlEncode(lo_objKVP.Value);
                        }
                        else
                        {
                            lo_strRequestData += lo_objKVP.Value;
                        }
                    }
                }
                else if (!string.IsNullOrEmpty(this.RequestData)) //String format
                {
                    if (this.UriEncodeFlag)
                    {
                        lo_strRequestData = HttpUtility.UrlEncode(this.RequestData);
                    }
                    else
                    {
                        lo_strRequestData = this.RequestData;
                    }
                }

                //If the http method is "GET", request parameters should be concatenated at the end of URL
                if (this.Header.Method.Equals(HttpAction.MethodType.Get))
                {
                    string lo_strUrl        = $"{this.Url}?{lo_strRequestData}";
                    lo_objHttpWebReq        = (HttpWebRequest) WebRequest.Create(lo_strUrl);
                    lo_objHttpWebReq.Method = WebRequestMethods.Http.Get;
                }
                //If the http method is "POST" or "PUT", some configurations can be set onto http header.
                else
                {
                    //Get encoded byte data
                    lo_arrByteData                 = this.Encoding.GetBytes(lo_strRequestData);
                    lo_objHttpWebReq               = (HttpWebRequest) WebRequest.Create(this.Url);
                    lo_objHttpWebReq.ContentLength = lo_arrByteData.Length;

                    if (this.Header.Method.Equals(HttpAction.MethodType.Post))
                    {
                        lo_objHttpWebReq.Method = WebRequestMethods.Http.Post;
                    }
                    else
                    {
                        lo_objHttpWebReq.Method = WebRequestMethods.Http.Put;
                    }
                }

                //Set the configuration for HttpWebRequest
                lo_objHttpWebReq.KeepAlive = this.Header.KeepAlive;
                lo_objHttpWebReq.Timeout   = this.ConnectTimeout * 1000; //Compute millisecond
                //lo_objHttpWebReq.ServicePoint.Expect100Continue = this.Expect100Continue; // 이 옵션이 활성화 시 서버쪽과 Delay 현상이 발생함

                if (!string.IsNullOrEmpty(this.Header.ConentType))
                {
                    lo_objHttpWebReq.ContentType = this.Header.ConentType;
                }
                else
                {
                    lo_objHttpWebReq.ContentType = HTTPREQUEST_DEFAULT_CONTENTTYPE; //Default value of ContentType
                }

                if (!string.IsNullOrEmpty(this.Header.Accept))
                {
                    lo_objHttpWebReq.Accept = this.Header.Accept;
                }

                if (!string.IsNullOrEmpty(this.Header.UserAgent))
                {
                    lo_objHttpWebReq.UserAgent = this.Header.UserAgent;
                }

                if (!string.IsNullOrEmpty(this.Header.Host))
                {
                    lo_objHttpWebReq.Host = this.Header.Host;
                }

                if (!string.IsNullOrEmpty(this.Header.Referer))
                {
                    lo_objHttpWebReq.Referer = this.Header.Referer;
                }

                if (!string.IsNullOrEmpty(this.Header.TransferEncoding))
                {
                    lo_objHttpWebReq.SendChunked      = true;
                    lo_objHttpWebReq.TransferEncoding = this.Header.TransferEncoding;
                }

                if (this.Header.Date != null)
                {
                    lo_objHttpWebReq.Date = Convert.ToDateTime(this.Header.Date);
                }

                if (this.Header.IfModifiedSince != null)
                {
                    lo_objHttpWebReq.IfModifiedSince = Convert.ToDateTime(this.Header.IfModifiedSince);
                }

                if (this.Header.CustomHeaders.Count > 0)
                {
                    foreach (KeyValuePair<string, string> lo_objKVP in this.Header.CustomHeaders)
                    {
                        lo_objHttpWebReq.Headers[lo_objKVP.Key] = lo_objKVP.Value;
                    }
                }

                //Ignore SSL validation
                if (this.IgnoreSsl)
                {
                    ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, sslPolicyErrors) => true;
                }

                if (this.Header.Method.Equals(HttpAction.MethodType.Post) || this.Header.Method.Equals(HttpAction.MethodType.Put))
                {
                    //Set request parameters using Stream object
                    lo_objStream = lo_objHttpWebReq.GetRequestStream();
                    lo_objStream.Write(lo_arrByteData, 0, lo_arrByteData.Length);
                }

                //Get response data
                lo_objHttpWebRes    = (HttpWebResponse) lo_objHttpWebReq.GetResponse();
                this.HttpStatus     = lo_objHttpWebRes.StatusCode.GetHashCode();
                this.HttpStatusText = lo_objHttpWebRes.StatusDescription;
                lo_objMemStream     = new MemoryStream();
                lo_objHttpWebRes.GetResponseStream().CopyTo(lo_objMemStream);
                lo_objMemStream.Position = 0;

                lo_objStreamIn     = new StreamReader(lo_objMemStream, this.Encoding);
                this.ResponseData  = lo_objStreamIn.ReadToEnd(); //String format
                this.ResponseBytes = lo_objMemStream.ToArray();  //Byte Array format
                if (this.HttpStatus.Equals((int)HttpStatusCode.OK))
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_SUCCESS;
                }
                else
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10001;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10001_MSG, this.HttpStatusText, this.HttpStatus);
                }
            }
            catch (WebException lo_objEx)
            {
                if (lo_objEx.Response != null)
                {
                    using (WebResponse lo_objRes = lo_objEx.Response)
                    {
                        HttpWebResponse lo_objErrHttpRes = (HttpWebResponse) lo_objRes;
                        this.HttpStatus     = lo_objErrHttpRes.StatusCode.GetHashCode();
                        this.HttpStatusText = lo_objErrHttpRes.StatusDescription;
                    }
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10002;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10002_MSG, lo_objEx.Message);
                    return this.RetVal;
                }
                else
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10003;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10003_MSG, lo_objEx.Message);
                    return this.RetVal;
                }
            }
            catch (Exception lo_objEx)
            {
                this.RetVal = ErrorHandler.COMMON_LIB_ERR_10003;
                this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10003_MSG, lo_objEx.Message);
                return this.RetVal;
            }
            finally
            {
                lo_dtEndDate = DateTime.Now;
                TimeSpan lo_dtDateDiff    = lo_dtEndDate - lo_dtStartDate;
                int      lo_intDiffSecond = lo_dtDateDiff.Seconds;

                if (lo_intDiffSecond >= this.LongProcessTime)
                {
                    WriteHttpActionLog($"LongProcessJob : {this.Url} : {lo_intDiffSecond} Seconds", true);
                }

                lo_objHttpWebReq = null;

                if (lo_objHttpWebRes != null)
                {
                    lo_objHttpWebRes.Close();
                    lo_objHttpWebRes = null;
                }

                if (lo_objStream != null)
                {
                    lo_objStream.Close();
                    lo_objStream = null;
                }

                if (lo_objStreamIn != null)
                {
                    lo_objStreamIn.Close();
                    lo_objStreamIn = null;
                }

                if (lo_objMemStream != null)
                {
                    lo_objMemStream.Close();
                    lo_objMemStream = null;
                }
            }

            return this.RetVal;
        }

        /// <summary>
        /// Send Http request
        /// </summary>
        /// <return>Error code</return>
        public int SendHttpAction(bool bLogUseFlag = false)
        {
            HttpWebRequest  lo_objHttpWebReq = null;
            HttpWebResponse lo_objHttpWebRes = null;
            Stream lo_objStream              = null;
            StreamReader lo_objStreamIn      = null;

            string lo_strRequestData = string.Empty;
            byte[] lo_arrByteData    = null;
            
            DateTime lo_dtStartDate = DateTime.Now;
            DateTime lo_dtEndDate   = DateTime.Now;

            try
            {
                _bLogUseFlag = bLogUseFlag;

                //Set the value of request parameters as string
                if (this.RequestParams != null && this.RequestParams.Count > 0) //Name Value pair format
                {
                    foreach (KeyValuePair<string, string> lo_objKVP in this.RequestParams)
                    {
                        if (!string.IsNullOrEmpty(lo_strRequestData))
                        {
                            lo_strRequestData += "&";
                        }

                        lo_strRequestData += lo_objKVP.Key + "=";

                        if (this.UriEncodeFlag)
                        {
                            lo_strRequestData += HttpUtility.UrlEncode(lo_objKVP.Value);
                        }
                        else
                        {
                            lo_strRequestData += lo_objKVP.Value;
                        }
                    }
                }
                else if (!string.IsNullOrEmpty(this.RequestData)) //String format
                {
                    if (this.UriEncodeFlag)
                    {
                        lo_strRequestData = HttpUtility.UrlEncode(this.RequestData);
                    }
                    else
                    {
                        lo_strRequestData = this.RequestData;
                    }
                }

                //If the http method is "GET", request parameters should be concatenated at the end of URL
                if (this.Header.Method.Equals(HttpAction.MethodType.Get))
                {
                    string lo_strUrl        = $"{this.Url}?{lo_strRequestData}";
                    lo_objHttpWebReq        = (HttpWebRequest) WebRequest.Create(lo_strUrl);
                    lo_objHttpWebReq.Method = WebRequestMethods.Http.Get;
                }
                //If the http method is "POST" or "PUT", some configurations can be set onto http header.
                else
                {
                    //Get encoded byte data
                    lo_objHttpWebReq               = (HttpWebRequest) WebRequest.Create(this.Url);
                    lo_arrByteData                 = this.Encoding.GetBytes(lo_strRequestData);
                    lo_objHttpWebReq.ContentLength = lo_arrByteData.Length;

                    if (this.Header.Method.Equals(HttpAction.MethodType.Post))
                    {
                        lo_objHttpWebReq.Method = WebRequestMethods.Http.Post;
                    }
                    else
                    {
                        lo_objHttpWebReq.Method = WebRequestMethods.Http.Put;
                    }
                }

                if (!string.IsNullOrEmpty(this.Header.ConentType))
                {
                    lo_objHttpWebReq.ContentType = this.Header.ConentType;
                }
                else
                {
                    lo_objHttpWebReq.ContentType = HTTPREQUEST_DEFAULT_CONTENTTYPE; //Default value of ContentType
                }

                if (this.Header.CustomHeaders.Count > 0)
                {
                    foreach (KeyValuePair<string, string> lo_objKVP in this.Header.CustomHeaders)
                    {
                        lo_objHttpWebReq.Headers[lo_objKVP.Key] = lo_objKVP.Value;
                    }
                }


                if (this.Header.Method.Equals(HttpAction.MethodType.Post) || this.Header.Method.Equals(HttpAction.MethodType.Put))
                {
                    //Set request parameters using Stream object
                    lo_objStream = lo_objHttpWebReq.GetRequestStream();
                    lo_objStream.Write(lo_arrByteData, 0, lo_arrByteData.Length);
                }

                //Get response data
                lo_objHttpWebRes = (HttpWebResponse) lo_objHttpWebReq.GetResponse();
                this.HttpStatus  = lo_objHttpWebRes.StatusCode.GetHashCode();
                string status = lo_objHttpWebRes.StatusCode.ToString();

                if (status.Equals("OK"))
                {
                    lo_objStreamIn     = new StreamReader(lo_objHttpWebRes.GetResponseStream(), this.Encoding);
                    this.ResponseData  = lo_objStreamIn.ReadToEnd();
                    this.ResponseBytes = this.Encoding.GetBytes(this.ResponseData);

                    this.RetVal = ErrorHandler.COMMON_LIB_SUCCESS;
                }
                else
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10001;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10001_MSG, this.HttpStatusText, this.HttpStatus);
                }
            }
            catch (WebException lo_objEx)
            {
                if (lo_objEx.Response != null)
                {
                    using (WebResponse lo_objRes = lo_objEx.Response)
                    {
                        HttpWebResponse lo_objErrHttpRes = (HttpWebResponse) lo_objRes;
                        this.HttpStatus     = lo_objErrHttpRes.StatusCode.GetHashCode();
                        this.HttpStatusText = lo_objErrHttpRes.StatusDescription;
                    }
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10002;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10002_MSG, lo_objEx.Message);
                    return this.RetVal;
                }
                else
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_10003;
                    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10003_MSG, lo_objEx.Message);
                    return this.RetVal;
                }
            }
            catch (Exception lo_objEx)
            {
                this.RetVal = ErrorHandler.COMMON_LIB_ERR_10003;
                this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_10003_MSG, lo_objEx.Message);
                return this.RetVal;
            }
            finally
            {
                lo_dtEndDate = DateTime.Now;
                TimeSpan lo_dtDateDiff    = lo_dtEndDate - lo_dtStartDate;
                int      lo_intDiffSecond = lo_dtDateDiff.Seconds;

                if (lo_intDiffSecond >= this.LongProcessTime)
                {
                    WriteHttpActionLog($"LongProcessJob : {this.Url} : {lo_intDiffSecond} Seconds", true);
                }

                lo_objHttpWebReq = null;

                if (lo_objHttpWebRes != null)
                {
                    lo_objHttpWebRes.Close();
                    lo_objHttpWebRes = null;
                }

                if (lo_objStream != null)
                {
                    lo_objStream.Close();
                    lo_objStream = null;
                }

                if (lo_objStreamIn != null)
                {
                    lo_objStreamIn.Close();
                    lo_objStreamIn = null;
                }
            }

            return this.RetVal;
        }
        #endregion
    }
    #endregion
}