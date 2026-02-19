using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;

//===============================================================
// FileName       : MailAction.cs
// Description    : 메일 전송 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonUtils
{
    public sealed class MailAction
    {
        #region Member variables
        private const CodePage       MAIL_DEFAULT_ENCODING = CodePage.UTF_8;      //Default Encoding

        public string                Subject                        { get; set; }          //Mail Subject
        public string                Body                           { get; set; }          //Mail Body
        public string                SmtpHost                       { get; set; }          //SMTP Host (Default:localhost)
        public string                SmtpUserName                   { get; set; }          //SMTP Authentication user name
        public string                SmtpPassword                   { get; set; }          //SMTP Authentication password

        public string                ErrMsg                         { get; private set; }  //Error message
        public bool                  EnableSsl                      { get; set; }          //Flag to set whether to enable SSL
        public bool                  UseDefaultCredentials          { get; set; }          //Flag to set whether to use default credentials
        public bool                  IsBodyHtml                     { get; set; }          //Flag to set whether body is html format
        public bool                  IgnoreSsl                      { get; set; }          //Flag to set whether to ignore SSL authentication

        public int                   SmtpPort                       { get; set; }          //SMTP Port (Default:25)
        public int                   SmtpTimeout                    { get; set; }          //SMTP Timeout (Default:100 Sec)
        public int                   RetVal                         { get; private set; }  //Error code
        public MailAddress           FromMail                       { get; set; }          //Sender email address (required)
        public MailAddressCollection ToMails                        { get; set; }          //Receiver email addresses (required)

        public MailAddressCollection ToCCMails                      { get; set; }          //CC email addresses
        public MailAddressCollection ToBCCMails                     { get; set; }          //BCC email addresses
        public Encoding              SubjectEncoding                { get; set; }          //Mail Subject encoding
        public Encoding              BodyEncoding                   { get; set; }          //Mail Body encoding
        public Encoding              HeadersEncoding                { get; set; }          //Mail Headers encoding

        public List<Attachment>      Attachments                    { get; set; }          //Attachment object
        #endregion

        #region Constructor and Destructor
        /// ------------------------------------------
        /// <summary>
        /// Initialize Member variables
        /// </summary>
        /// ------------------------------------------
        private void Initialize()
        {
            this.Subject               = string.Empty;
            this.Body                  = string.Empty;
            this.SmtpHost              = "127.0.0.1";           //Default:localhost
            this.SmtpUserName          = string.Empty;
            this.SmtpPassword          = string.Empty;

            this.ErrMsg                = string.Empty;
            this.EnableSsl             = false;
            this.UseDefaultCredentials = true;
            this.IsBodyHtml            = true;
            this.IgnoreSsl             = true;

            this.SmtpPort              = 25;                    //Default:25
            this.SmtpTimeout           = 100;                   //Default:100 Sec
            this.RetVal                = 0;
            this.FromMail              = null;
            this.ToMails               = new MailAddressCollection();

            this.ToCCMails             = new MailAddressCollection();
            this.ToBCCMails            = new MailAddressCollection();
            this.SubjectEncoding       = Encoding.GetEncoding(MAIL_DEFAULT_ENCODING.GetHashCode());
            this.BodyEncoding          = Encoding.GetEncoding(MAIL_DEFAULT_ENCODING.GetHashCode());
            this.HeadersEncoding       = Encoding.GetEncoding(MAIL_DEFAULT_ENCODING.GetHashCode());

            this.Attachments           = new List<Attachment>();
        }

        /// ------------------------------------------
        /// <summary>
        /// MailAction Constructor
        /// </summary>
        /// <param name="strReqSubject">Mail Subject</param>
        /// <param name="strReqBody">Mail Body</param>
        /// <param name="strReqSmtpHost">SMTP Host</param>
        /// <param name="intReqSmtpPort">SMTP Port</param>
        /// <param name="strReqSmtpUserName">SMTP User Name</param>
        /// <param name="strReqSmtpPassword">SMTP Password</param>
        /// ------------------------------------------
        public MailAction(string strReqSubject = "", string strReqBody = "", string strReqSmtpHost = "", int intReqSmtpPort = 25, string strReqSmtpUserName = "", string strReqSmtpPassword = "")
        {
            this.Initialize();

            this.Subject      = strReqSubject;
            this.Body         = strReqBody;
            this.SmtpPort     = intReqSmtpPort;
            this.SmtpUserName = strReqSmtpUserName;
            this.SmtpPassword = strReqSmtpPassword;

            if (!string.IsNullOrEmpty(strReqSmtpHost))
            {
                this.SmtpHost = strReqSmtpHost;
            }
            if (!string.IsNullOrEmpty(strReqSmtpUserName))
            {
                this.UseDefaultCredentials = false;
            }
        }

        /// ------------------------------------------
        /// <summary>
        /// MailAction Destructor
        /// </summary>
        /// ------------------------------------------
        ~MailAction()
        {
            this.FromMail        = null;
            this.ToMails         = null;
            this.ToCCMails       = null;
            this.ToBCCMails      = null;
            this.SubjectEncoding = null;

            this.BodyEncoding    = null;
            this.HeadersEncoding = null;
            this.Attachments     = null;
        }
        #endregion

        /// ------------------------------------------
        /// <summary>
        /// Set sender's email address
        /// </summary>
        /// <param name="strMailAddr">Sender's email address</param>
        /// ------------------------------------------
        public void SetFromMail(string strMailAddr)
        {
            this.FromMail = null;
            this.FromMail = new MailAddress(strMailAddr);
        }

        /// ------------------------------------------
        /// <summary>
        /// Set sender's email address
        /// </summary>
        /// <param name="strMailAddr">Sender's email address</param>
        /// <param name="strDisplayName">Sender's name</param>
        /// ------------------------------------------
        public void SetFromMail(string strMailAddr, string strDisplayName)
        {
            this.FromMail = null;
            this.FromMail = new MailAddress(strMailAddr, strDisplayName);
        }

        /// ------------------------------------------
        /// <summary>
        /// Add receiver's email address
        /// </summary>
        /// <param name="strMailAddr">Receiver's email address</param>
        /// ------------------------------------------
        public void AddToMail(string strMailAddr)
        {
            this.ToMails.Add(new MailAddress(strMailAddr));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add receiver's email address
        /// </summary>
        /// <param name="strMailAddr">Receiver's email address</param>
        /// <param name="strDisplayName">Receiver's name</param>
        /// ------------------------------------------
        public void AddToMail(string strMailAddr, string strDisplayName)
        {
            this.ToMails.Add(new MailAddress(strMailAddr, strDisplayName));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add receiver's email address
        /// </summary>
        /// <param name="objReqMail">Receiver's email address object</param>
        /// ------------------------------------------
        public void AddToMail(MailAddress objReqMail)
        {
            this.ToMails.Add(objReqMail);
        }

        /// ------------------------------------------
        /// <summary>
        /// Add CC's email address
        /// </summary>
        /// <param name="strMailAddr">CC's email address</param>
        /// ------------------------------------------
        public void AddToCCMail(string strMailAddr)
        {
            this.ToCCMails.Add(new MailAddress(strMailAddr));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add CC's email address
        /// </summary>
        /// <param name="strMailAddr">CC's email address</param>
        /// <param name="strDisplayName">CC's name</param>
        /// ------------------------------------------
        public void AddToCCMail(string strMailAddr, string strDisplayName)
        {
            this.ToCCMails.Add(new MailAddress(strMailAddr, strDisplayName));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add CC's email address
        /// </summary>
        /// <param name="objReqMail">CC's email address object</param>
        /// ------------------------------------------
        public void AddToCCMail(MailAddress objReqMail)
        {
            this.ToCCMails.Add(objReqMail);
        }

        /// ------------------------------------------
        /// <summary>
        /// Add BCC's email address
        /// </summary>
        /// <param name="strMailAddr">BCC's email address</param>
        /// ------------------------------------------
        public void AddToBCCMail(string strMailAddr)
        {
            this.ToBCCMails.Add(new MailAddress(strMailAddr));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add BCC's email address
        /// </summary>
        /// <param name="strMailAddr">BCC's email address</param>
        /// <param name="strDisplayName">BCC's name</param>
        /// ------------------------------------------
        public void AddToBCCMail(string strMailAddr, string strDisplayName)
        {
            this.ToBCCMails.Add(new MailAddress(strMailAddr, strDisplayName));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add BCC's email address
        /// </summary>
        /// <param name="objReqMail">BCC's email address object</param>
        /// ------------------------------------------
        public void AddToBCCMail(MailAddress objReqMail)
        {
            this.ToBCCMails.Add(objReqMail);
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="strFileName">File name of attachment</param>
        /// ------------------------------------------
        public void AddAttachment(string strFileName)
        {
            if (File.Exists(strFileName))
            {
                this.Attachments.Add(new Attachment(strFileName));
            }
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="objStream">Stream object for attachment</param>
        /// <param name="objContentType">Content type object of attachment</param>
        /// ------------------------------------------
        public void AddAttachment(Stream objStream, ContentType objContentType)
        {
            this.Attachments.Add(new Attachment(objStream, objContentType));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="objStream">Stream object for attachment</param>
        /// <param name="strAttachedFileName">Attached file name</param>
        /// ------------------------------------------
        public void AddAttachment(Stream objStream, string strAttachedFileName)
        {
            this.Attachments.Add(new Attachment(objStream, strAttachedFileName));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="strFileName">File name of attachment</param>
        /// <param name="objContentType">Content type object of attachment</param>
        /// ------------------------------------------
        public void AddAttachment(string strFileName, ContentType objContentType)
        {
            if (File.Exists(strFileName))
            {
                this.Attachments.Add(new Attachment(strFileName, objContentType));
            }
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="strFileName">File name of attachment</param>
        /// <param name="strMediaType">Media type string of attachment</param>
        /// ------------------------------------------
        public void AddAttachment(string strFileName, string strMediaType)
        {
            if (File.Exists(strFileName))
            {
                this.Attachments.Add(new Attachment(strFileName, strMediaType));
            }
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="objStream">Stream object for attachment</param>
        /// <param name="strAttachedFileName">Attached file name</param>
        /// <param name="strMediaType">Media type string of attachment</param>
        /// ------------------------------------------
        public void AddAttachment(Stream objStream, string strAttachedFileName, string strMediaType)
        {
            this.Attachments.Add(new Attachment(objStream, strAttachedFileName, strMediaType));
        }

        /// ------------------------------------------
        /// <summary>
        /// Add Attachment
        /// </summary>
        /// <param name="objReqAttachment">Attachment object</param>
        /// ------------------------------------------
        public void AddAttachment(Attachment objReqAttachment)
        {
            this.Attachments.Add(objReqAttachment);
        }

        /// ------------------------------------------
        /// <summary>
        /// Send email
        /// </summary>
        /// ------------------------------------------
        public int SendMail()
        {
            MailMessage lo_objMessage    = null;
            SmtpClient  lo_objSmtpClient = null;

            try
            {
                lo_objMessage = new MailMessage();

                //If objFromMail has not been set the email couldn't be sent.(required)
                if (this.FromMail == null || string.IsNullOrEmpty(this.FromMail.Address))
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_20051;
                    this.ErrMsg = ErrorHandler.COMMON_LIB_ERR_20051_MSG;
                    return this.RetVal;
                }

                lo_objMessage.From = FromMail;

                //If objToMails has not been set the email couldn't be sent.(required)
                if (ToMails.Count.Equals(0))
                {
                    this.RetVal = ErrorHandler.COMMON_LIB_ERR_20052;
                    this.ErrMsg = ErrorHandler.COMMON_LIB_ERR_20052_MSG;
                    return this.RetVal;
                }

                foreach (MailAddress lo_objTmp in this.ToMails)
                {
                    lo_objMessage.To.Add(lo_objTmp);
                }

                //Set CC mail adderesses if it has been set.(optional)
                if (this.ToCCMails.Count > 0)
                {
                    foreach (MailAddress lo_objTmp in this.ToCCMails)
                    {
                        lo_objMessage.CC.Add(lo_objTmp);
                    }
                }

                //Set BCC mail adderesses if it has been set.(optional)
                if (this.ToBCCMails.Count > 0)
                {
                    foreach (MailAddress lo_objTmp in this.ToBCCMails)
                    {
                        lo_objMessage.Bcc.Add(lo_objTmp);
                    }
                }

                //Set attachments if it has been set.(optional)
                if (this.Attachments.Count > 0)
                {
                    foreach (Attachment lo_objTmp in this.Attachments)
                    {
                        lo_objMessage.Attachments.Add(lo_objTmp);
                    }
                }

                //Set the configuration for the email message
                lo_objMessage.Subject                  = this.Subject;
                lo_objMessage.Body                     = this.Body;
                lo_objMessage.IsBodyHtml               = this.IsBodyHtml;
                lo_objMessage.SubjectEncoding          = this.SubjectEncoding;
                lo_objMessage.HeadersEncoding          = this.HeadersEncoding;
                lo_objMessage.BodyEncoding             = this.BodyEncoding;

                //Create SMTP Client object with SMTP host and port information and set the configuration
                lo_objSmtpClient                       = new SmtpClient(this.SmtpHost, this.SmtpPort);
                lo_objSmtpClient.Timeout               = this.SmtpTimeout * 1000;       //Compute millisecond
                lo_objSmtpClient.EnableSsl             = this.EnableSsl;
                lo_objSmtpClient.UseDefaultCredentials = this.UseDefaultCredentials;

                if (this.UseDefaultCredentials) //If we use default credentials
                {
                    lo_objSmtpClient.Credentials = CredentialCache.DefaultNetworkCredentials;
                }
                else //If we use a specific credentials
                {
                    lo_objSmtpClient.Credentials = new NetworkCredential(this.SmtpUserName, this.SmtpPassword);
                }

                //Ignore SSL validation
                if (this.IgnoreSsl)
                {
                    ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, sslPolicyErrors) => true;
                }

                //Send an email
                lo_objSmtpClient.Send(lo_objMessage);
            }
            //catch (SmtpException lo_objEx)
            //{
            //    this.RetVal = ErrorHandler.COMMON_LIB_ERR_20053;
            //    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_20053_MSG, lo_objEx.Message);
            //    return this.RetVal;
            //}
            //catch (Exception lo_objEx)
            //{
            //    this.RetVal = ErrorHandler.COMMON_LIB_ERR_20054;
            //    this.ErrMsg = string.Format(ErrorHandler.COMMON_LIB_ERR_20054_MSG, lo_objEx.Message);
            //    return this.RetVal;
            //}
            finally
            {
                if (lo_objMessage != null)
                {
                    lo_objMessage.Dispose();
                    lo_objMessage = null;
                }

                if (lo_objSmtpClient != null)
                {
                    lo_objSmtpClient.Dispose();
                    lo_objSmtpClient = null;
                }
            }

            return this.RetVal;
        }
    }
}