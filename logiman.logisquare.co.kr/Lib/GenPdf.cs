using NReco.PdfGenerator;

namespace CommonLibrary.CommonUtils
{
    public class GenPdf
    {
        private string m_Args = string.Empty;
        private string m_Urls = string.Empty;
        private PageMargins m_Margin = null;
        private PageOrientation m_Orient;
        private float m_Zoom;
        private bool m_Grayscale;
        private bool m_LowQuality;
        private string m_PdfToolPath = string.Empty;

        public GenPdf()
        {
            InitVariables();
        }

        public void InitVariables()
        {
            m_Args = "";
            m_Urls = "";
            m_Margin = new PageMargins();
            m_Margin.Top = m_Margin.Bottom = m_Margin.Left = m_Margin.Right = 0;
            m_Orient = PageOrientation.Landscape;   // Default 를 가로로 한다.
            m_Zoom = 1.0F;
            m_Grayscale = false;
            m_LowQuality = false;
            m_PdfToolPath = string.Empty;
        }

        public void SetMargin(int nTop, int nBottom, int nLeft, int nRight)
        {
            m_Margin.Top = nTop;
            m_Margin.Bottom = nBottom;
            m_Margin.Left = nLeft;
            m_Margin.Right = nRight;
        }

        public void SetOrientation(int nOrient) // 0:가로, 1:세로
        {
            if (nOrient.Equals(0))
            {
                m_Orient = PageOrientation.Landscape;
            }
            else if (nOrient.Equals(1))
            {
                m_Orient = PageOrientation.Portrait;
            }
        }

        public void SetZoom(int nZoomPCT)   // 줌 레벨을 0이상의 퍼센트로 설정한다
        {
            if (nZoomPCT <= 0)
            {
                return;
            }

            m_Zoom = (float)(nZoomPCT / 100.0);
        }

        public void SetEncoding(string strEncoding)
        {
            if (string.IsNullOrWhiteSpace(strEncoding))
            {
                return;
            }

            m_Args += " --encoding " + strEncoding;
        }

        public void SetGrayScale(bool bFlag)
        {
            m_Grayscale = bFlag;
        }

        public void SetLowQuality(bool bFlag)
        {
            m_LowQuality = bFlag;
        }

        public void SetPdfToolPath(string strPdfToolPath)
        {
            m_PdfToolPath = strPdfToolPath;
        }

        public void AddUrl(string strUrl)
        {
            if (string.IsNullOrWhiteSpace(strUrl))
            {
                return;
            }

            if (string.IsNullOrWhiteSpace(this.m_Urls))
            {
                this.m_Urls = strUrl;
            }
            else
            {
                this.m_Urls += " " + strUrl;
            }
        }

        public bool CreatePdf(string strPdfFile)
        {
            int nUrlCnt = 0;

            try
            {
                HtmlToPdfConverter pdf = new HtmlToPdfConverter();

                pdf.Orientation = m_Orient;
                pdf.Margins = m_Margin;
                pdf.Zoom = m_Zoom;
                pdf.Grayscale = m_Grayscale;
                pdf.LowQuality = m_LowQuality;

                if (string.IsNullOrWhiteSpace(strPdfFile))
                {
                    return false;
                }

                if (string.IsNullOrWhiteSpace(m_Urls.Replace(" ", "")))
                {
                    return false;
                }

                if (!string.IsNullOrWhiteSpace(m_PdfToolPath))
                {
                    pdf.PdfToolPath = m_PdfToolPath;
                }

                nUrlCnt = m_Urls.Split(' ').Length;
                string[] arrUrl = new string[nUrlCnt];

                arrUrl = m_Urls.Split(' ');

                pdf.GeneratePdfFromFiles(arrUrl, null, strPdfFile);
            }
            catch
            {
                return false;
            }

            return true;
        }

        public bool CreatePdfFromString(string strHtml, string strPdfFile)
        {
            try
            {
                HtmlToPdfConverter pdf = new HtmlToPdfConverter();

                pdf.Orientation = m_Orient;
                pdf.Margins = m_Margin;
                pdf.Zoom = m_Zoom;
                pdf.Grayscale = m_Grayscale;
                pdf.LowQuality = m_LowQuality;

                if (string.IsNullOrWhiteSpace(strPdfFile))
                {
                    return false;
                }

                if (string.IsNullOrWhiteSpace(strHtml))
                {
                    return false;
                }

                if (!string.IsNullOrWhiteSpace(m_PdfToolPath))
                {
                    pdf.PdfToolPath = m_PdfToolPath;
                }

                pdf.GeneratePdf(strHtml, null, strPdfFile);
            }
            catch
            {
                return false;
            }

            return true;
        }
    }
}