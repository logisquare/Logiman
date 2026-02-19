using DocumentFormat.OpenXml.Spreadsheet;
using SpreadsheetLight;
using System;
using System.Data;
using System.IO;

//===============================================================
// FileName       : SpreadSheet.cs
// Description    : 엑셀 저장 Class
// Copyright      : 2018 by Logislab Inc. All rights reserved.
// Author         : shadow54@logislab.com, 2022-03-03
// Modify History : Just Created.
//================================================================
namespace CommonLibrary.CommonUtils
{
   public class SpreadSheet
	{
        SLDocument        sl              = null;
        SLSheetProtection sp              = null;
        private string    _strFileName    = String.Empty;
        private int       _intErrCode     = 0;
        private string    _strErrMsg      = String.Empty;
        private string    _strSheetName   = String.Empty;
        private int       _intStartRow    = 1;
        private int       _intStartColumn = 1;
        private int       _intEndRow      = 1;
        private int       _intEndColumn   = 1;
        private bool      _bWrapText      = false;

        private System.Drawing.Color _objForeColor = System.Drawing.Color.Black;
        private System.Drawing.Color _objBackColor = System.Drawing.Color.White;

		public SpreadSheet()
		{
			sl = new SLDocument();
            sp = new SLSheetProtection();
		}

		public SpreadSheet(string strFileName, string strSheetName)
		{
			sl = new SLDocument();
			sp = new SLSheetProtection();

            this._strFileName  = strFileName;
            this._strSheetName = strSheetName;
		}

		~SpreadSheet()
		{
		}

		public void FreezeCell(int nRow)	// 행 전체를 고정한다.
		{
			sl.FreezePanes(nRow, 0);
		}

		public void FreezeCell(int nRow, int nCol)	// nRow x nCol 만큼만 고정한다.
		{
			sl.FreezePanes(nRow, nCol);
		}


		public void InsertDataTable(DataTable dtTbl, bool bColumnHeader, int nFirstRow, int nFirstCol, bool isHeaderBold, bool isBodyBold, System.Drawing.Color objHeaderBgColor, HorizontalAlignmentValues objHeaderAlign, HorizontalAlignmentValues objBodyAlign)
		{
			int lo_intDataFirstRow = nFirstRow;
			int lo_intDataFirstCol = nFirstCol;

			SLStyle lo_styleH = sl.CreateStyle();
			SLStyle lo_styleB = sl.CreateStyle();

			if (bColumnHeader)
			{
				lo_intDataFirstRow++;

				if (objHeaderBgColor != null)
				{
					lo_styleH.Fill.SetPattern(PatternValues.Solid, objHeaderBgColor, objHeaderBgColor);
                    lo_styleH.Alignment.Horizontal = objHeaderAlign;
                    lo_styleH.Font.Bold            = isHeaderBold;
					sl.SetCellStyle(nFirstRow, nFirstCol, nFirstRow, dtTbl.Columns.Count + nFirstCol - 1, lo_styleH);
				}
			}

			lo_styleB.SetFontColor(_objForeColor);
			lo_styleB.Fill.SetPatternBackgroundColor(_objBackColor);
			
			lo_styleB.SetWrapText(_bWrapText);	// \r\n이 있는 경우, newline으로 적용할지 여부

            lo_styleB.Alignment.Horizontal = objBodyAlign;
            lo_styleB.Font.Bold            = isBodyBold;
			sl.SetCellStyle(lo_intDataFirstRow, lo_intDataFirstCol, lo_intDataFirstRow + dtTbl.Rows.Count, lo_intDataFirstCol + dtTbl.Columns.Count, lo_styleB);

			sl.ImportDataTable(nFirstRow, nFirstCol, dtTbl, bColumnHeader);

			if (this._intStartRow < nFirstRow)
			{
				this._intStartRow = nFirstRow;
			}

			if (this._intEndRow < lo_intDataFirstRow + dtTbl.Rows.Count - 1)
			{
				this._intEndRow = lo_intDataFirstRow + dtTbl.Rows.Count - 1;
			}

			if (this._intStartColumn < nFirstCol)
			{
				this._intStartColumn = nFirstCol;
			}

			if (this._intEndColumn < nFirstCol + dtTbl.Columns.Count - 1)
			{
				this._intEndColumn = nFirstCol + dtTbl.Columns.Count - 1;
			}
		}

		public void InsertDataTable(DataTable dtTbl, bool bColumnHeader, int nFirstRow, int nFirstCol)
		{
			InsertDataTable(dtTbl, bColumnHeader, nFirstRow, nFirstCol, false, false, System.Drawing.Color.LightGray, HorizontalAlignmentValues.Right, HorizontalAlignmentValues.Right);
		}

		public void SetColumnFormat(int nCol, int nSize, string strNumberFormat)
		{
			SLStyle lo_style = sl.CreateStyle();
			lo_style.FormatCode = strNumberFormat;
			sl.SetCellStyle(this._intStartRow, nCol, this._intEndRow, nCol, lo_style);

			sl.SetColumnWidth(nCol, nSize);
		}

        public void SetColumnFormat(int nCol, int nSize, string strNumberFormat, HorizontalAlignmentValues horizontalAlign)
        {
            SLStyle lo_style = sl.CreateStyle();

            lo_style.FormatCode = strNumberFormat;
            lo_style.SetHorizontalAlignment(horizontalAlign);
            //_intStartRow가 컬럼명로 되어 있으므로, 컬럼명 정렬을 하지 않기 위해 시작 row에 +1함
            sl.SetCellStyle(this._intStartRow + 1, nCol, this._intEndRow, nCol, lo_style);

            sl.SetColumnWidth(nCol, nSize);
        }

        public void SetAlignment(int nCol, HorizontalAlignmentValues objHorizonAlign, VerticalAlignmentValues objVerticalAlign)
		{
			SLStyle lo_style = sl.CreateStyle();

            lo_style.Alignment.Horizontal = objHorizonAlign;
            lo_style.Alignment.Vertical   = objVerticalAlign;
			sl.SetCellStyle(this._intStartRow, nCol, this._intEndRow, nCol, lo_style);
		}

		public void SetWrapText(int nCol)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.SetWrapText(true);
			lo_style.Alignment.Horizontal = HorizontalAlignmentValues.Right;
			sl.SetCellStyle(this._intStartRow, nCol, this._intEndRow, nCol, lo_style);
		}

		public void SetWrapText(int nCol, HorizontalAlignmentValues objAlign)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.SetWrapText(true);
			lo_style.Alignment.Horizontal = objAlign;
			sl.SetCellStyle(this._intStartRow, nCol, this._intEndRow, nCol, lo_style);
		}

		public void SetFontSize(int nSize, int nRowHeight)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.Font.FontSize = nSize;

			sl.SetCellStyle(this._intStartRow, this._intStartColumn, this._intEndRow, this._intEndColumn, lo_style);
			sl.SetRowHeight(this._intStartRow, this._intEndRow, nRowHeight);
		}

		public void InsertValue(int nRow, int nCol, String strValue, int nSize, bool isBold, HorizontalAlignmentValues objAlign)
		{
			SLStyle lo_style = sl.CreateStyle();

            lo_style.Font.FontSize        = nSize;
            lo_style.Font.Bold            = isBold;
            lo_style.Alignment.Horizontal = objAlign;
            lo_style.Alignment.Vertical   = VerticalAlignmentValues.Center;
			sl.SetCellStyle(nRow, nCol, lo_style);

			sl.SetCellValue(nRow, nCol, strValue);

			if (this._intStartRow > nRow)
			{
				this._intStartRow = nRow;
			}

			if (this._intEndRow < nRow)
			{
				this._intEndRow = nRow;
			}

			if (this._intStartColumn > nCol)
			{
				this._intStartColumn = nCol;
			}

			if (this._intEndColumn < nCol)
			{
				this._intEndColumn = nCol;
			}
		}

		public void InsertValue(int nRow, int nCol, int nValue, int nSize, bool isBold, HorizontalAlignmentValues objAlign)
		{
			SLStyle lo_style = sl.CreateStyle();

            lo_style.Font.FontSize        = nSize;
            lo_style.Font.Bold            = isBold;
            lo_style.Alignment.Horizontal = objAlign;
            lo_style.Alignment.Vertical   = VerticalAlignmentValues.Center;
			sl.SetCellStyle(nRow, nCol, lo_style);

			sl.SetCellValue(nRow, nCol, nValue);

			if (this._intStartRow > nRow)
			{
				this._intStartRow = nRow;
			}

			if (this._intEndRow < nRow)
			{
				this._intEndRow = nRow;
			}

			if (this._intStartColumn > nCol)
			{
				this._intStartColumn = nCol;
			}

			if (this._intEndColumn < nCol)
			{
				this._intEndColumn = nCol;
			}
		}

		public void SetBorder(BorderStyleValues objLineStyle, System.Drawing.Color objColor)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.SetTopBorder(objLineStyle, objColor);
			lo_style.SetRightBorder(objLineStyle, objColor);
			lo_style.SetBottomBorder(objLineStyle, objColor);
			lo_style.SetLeftBorder(objLineStyle, objColor);
			sl.SetCellStyle(this._intStartRow, this._intStartColumn, this._intEndRow, this._intEndColumn, lo_style);
		}

		public void MergeColumn(int nStartRow, int nStartCol, int nEndRow, int nEndCol)
		{
			sl.MergeWorksheetCells(nStartRow, nStartCol, nEndRow, nEndCol);
		}

		public void SetColorCell(int nRow, int nCol, System.Drawing.Color objColor)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.SetFontColor(objColor);

			sl.SetCellStyle(nRow, nCol, lo_style);
		}

		public void SetBackColorCell(int nRow, int nCol, System.Drawing.Color objBackColor)
		{
			SLStyle lo_style = sl.CreateStyle();

			lo_style.Fill.SetPattern(PatternValues.Solid, objBackColor, objBackColor);

			sl.SetCellStyle(nRow, nCol, lo_style);
		}


		public void SaveExcel(bool isAutoFitRow, bool isAutoFitColumn)
		{
			if (String.IsNullOrWhiteSpace(this._strFileName))
			{
				this._intErrCode = 9999;
				this._strErrMsg  = "파일명이 설정되지 않았습니다.";
				return;
			}

			if (!String.IsNullOrWhiteSpace(this._strSheetName))
			{
				sl.RenameWorksheet(SLDocument.DefaultFirstSheetName, this._strSheetName);
			}

			if (isAutoFitRow)
			{
				sl.AutoFitRow(this._intStartRow, this._intEndRow);
			}

			if (isAutoFitColumn)
			{
				sl.AutoFitColumn(this._intStartColumn, this._intEndColumn);
			}
            
			sl.SaveAs(this._strFileName);
		}

		public void AddWorkSheet(string strSheetName)
		{
			sl.AddWorksheet(strSheetName);
            sl.SelectWorksheet(strSheetName);
            _intStartRow = 1;
            _intEndRow   = 1;


            sl.AutoFitRow(this._intStartRow, this._intEndRow);
        }

        public void SetAutoFitRow(string strSheetName)
        {
            sl.SelectWorksheet(strSheetName);
            sl.AutoFitRow(this._intStartRow, this._intEndRow);
        }

        public void SetAutoFitColumn(string strSheetName)
        {
            sl.SelectWorksheet(strSheetName);
            sl.AutoFitColumn(this._intStartColumn, this._intEndColumn);
        }

        public void SaveExcelStream(bool isAutoFitRow, bool isAutoFitColumn, out MemoryStream outStream)
        {
            outStream = new MemoryStream();

            if (!string.IsNullOrWhiteSpace(this._strSheetName))
            {
                sl.RenameWorksheet(SLDocument.DefaultFirstSheetName, this._strSheetName);
            }

            if (isAutoFitRow)
            {
                sl.AutoFitRow(this._intStartRow, this._intEndRow);
            }

            if (isAutoFitColumn)
            {
                sl.AutoFitColumn(this._intStartColumn, this._intEndColumn);
            }

            sl.SaveAs(outStream);
        }

        public int ImportFile(string strFileName, DataTable dtTbl, bool bColumnHeader)
		{
			try
			{
                SLDocument            lo_filesl = new SLDocument(strFileName);
                SLWorksheetStatistics lo_stats  = lo_filesl.GetWorksheetStatistics();

                int lo_intRowIdx       = 0;
                int lo_intColIdx       = 0;
                int lo_intColumnHeader = 0;
				if (bColumnHeader)
				{
					lo_intColumnHeader = 1;
				}

				for (lo_intRowIdx = lo_stats.StartRowIndex + lo_intColumnHeader; lo_intRowIdx <= lo_stats.EndRowIndex; lo_intRowIdx++)
				{
					DataRow drRow = dtTbl.NewRow();
					for (lo_intColIdx = 0; lo_intColIdx < dtTbl.Columns.Count; lo_intColIdx++)
					{
						drRow[lo_intColIdx] = lo_filesl.GetCellValueAsString(lo_intRowIdx, lo_intColIdx + lo_stats.StartColumnIndex);
					}
					dtTbl.Rows.Add(drRow);
				}
			}
			catch (Exception ex)
			{
                this._intErrCode = 9999;
                this._strErrMsg  = ex.ToString();
				return this._intErrCode;
			}

			return this._intErrCode;
		}

		/// ------------------------------------------
		/// <summary>
		///  Excel 파일의 Full path 를 SET/GET
		/// </summary>
		/// ------------------------------------------
		public string FileName
		{
            get { return _strFileName; }
            set { _strFileName = value; }
		}

		/// ------------------------------------------
		/// <summary>
		///  Excel 파일에서 데이터를 읽을 Sheet명을 SET/GET
		///  Sheet명을 설정하지 않으면, default 로 Sheet1 에서 읽는다.
		/// </summary>
		/// ------------------------------------------
		public string SheetName
		{
			get { return _strSheetName; }
			set { _strSheetName = value; }
		}

		/// ------------------------------------------
		/// <summary>
		///  클래스내에서 발생한 오류코드를 반환
		/// </summary>
		/// ------------------------------------------
		public int ErrCode
		{
			get { return _intErrCode; }
		}

		/// ------------------------------------------
		/// <summary>
		///  클래스내에서 발생한 오류메시지를 반환
		/// </summary>
		/// ------------------------------------------
		public string ErrMsg
		{
			get { return _strErrMsg; }
		}

		public int StartRow
		{
			get { return _intStartRow; }
        }

		public int StartColumn
		{
			get { return _intStartColumn; }
		}

		public int EndRow
		{
			get { return _intEndRow; }
        }

		public int EndColumn
		{
			get { return _intEndColumn; }
			set { _intEndColumn = value; }
		}

		public System.Drawing.Color TextColor
		{
			get { return _objForeColor; }
			set { _objForeColor = value; }
		}

		public System.Drawing.Color BackColor
		{
			get { return _objBackColor; }
			set { _objBackColor = value; }
		}

		public bool WrapText
		{
			get { return _bWrapText; }
			set { _bWrapText = value; }
		}
	} 
}