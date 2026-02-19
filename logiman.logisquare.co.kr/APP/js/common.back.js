$(function(){

	
	/* 슬라이드 컨텐츠 */
	$(document).on("click",".onoff",function(){
		
		if($(this).attr("class") == "onoff act"){			
			$(this).find("ul").slideUp(300);			
		}else{
			$(this).find("ul").slideDown(300);			
		}
		
		$(this).toggleClass("act");
		$(this).siblings("li").removeClass("act");
		$(this).siblings("li").find("ul").slideUp();
	
	})

	



})