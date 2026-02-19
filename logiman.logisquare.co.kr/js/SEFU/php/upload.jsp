<%@page contentType="text/html; charset=EUC-KR" errorPage="/inc/error.jsp"%>
<%@include file="/inc/pre.jsp"%>
<%
// 파일 관련 
String NEWS_FILE_PATH = DOCUMENT_ROOT + "news/files" ;
String UPFILE_name = param.getValue("image_name") ; 
int UPFILE_size = param.getInt("image_size") ; 
int SEQ = param.getInt("SEQ") ; 
//SEQ = 986;

Connection conn = null ; 
try {
    conn = database.startTransaction("apecdb" ) ;

	if ( SEQ == 0 ) { // 입력이다. 

		if ( !UPFILE_name.equals("") ) { // 파일이 있다면..
			int FILESEQ = database.getMax(conn , "APEC_FILE_2006" , "SEQ") ; 
			String fquery = "insert into APEC_FILE_2006 ( SEQ , BBSSEQ  , FILENAME , FILEPATH , FILESIZE , FILEHITS ) " + 
						" values ( ? , ? , ? , ? , ? , 0 ) " ;
		 	database.simpleUpdate(conn , fquery , 
				new Object[] { "" + FILESEQ  , "" + SEQ , UPFILE_name , NEWS_FILE_PATH + "/" +SEQ + "/" + UPFILE_name , "" + UPFILE_size } ) ; 

			new File(NEWS_FILE_PATH + "/" +SEQ ).mkdirs();
			FileUtil.copy(param.getValue("image_path") , NEWS_FILE_PATH + "/" +SEQ + "/" + UPFILE_name , true) ; 
			out.println("../news/files/" +SEQ + "/" + UPFILE_name);
		}
	}
	// 2. reply 라면.. TSEQ = 가 이전것이다. 


	// 3. edit 라면.. 
	else if ( SEQ > 0 ) { // 수정
		if ( !UPFILE_name.equals("") ) { // 파일이 있다면..

			int FILESEQ = database.getMax(conn , "APEC_FILE_2006" , "SEQ") ; 
			String fquery = "insert into APEC_FILE_2006 ( SEQ , BBSSEQ  , FILENAME , FILEPATH , FILESIZE , FILEHITS ) " + 
						" values ( ? , ? , ? , ? , ? , 0 ) " ;
		 	database.simpleUpdate(conn , fquery , 
				new Object[] { "" + FILESEQ  , "" + SEQ , UPFILE_name , NEWS_FILE_PATH + "/" +SEQ +"/"+ UPFILE_name , "" + UPFILE_size } ) ; 
			new File(NEWS_FILE_PATH + "/" +SEQ ).mkdirs();
			FileUtil.copy(param.getValue("image_path") , NEWS_FILE_PATH + "/" +SEQ + "/" + UPFILE_name , true) ; 
			out.println("../news/files/" +SEQ + "/" + UPFILE_name);
		}

	}
	
	conn.commit() ; 
} catch (Exception e ){
	conn.rollback() ;
	throw new ErrorBack("Error Updating... " + e.getMessage()) ; 
} finally {
	database.freeConnection("apecdb" , conn) ; 
}

%>
