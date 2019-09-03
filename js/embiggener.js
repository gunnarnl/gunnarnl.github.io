$(document).ready(function() {
	
	//Click event for items with 'enlarge' class.
	$('.enlarge').click(function() {
		
		var bigWidth = 0;
		var bigHeight = 0;
	
		var imgSource = $(this).attr('src');
		var bgdiv = '<div id="imgbgdiv"><img id="bigimg" src="'+imgSource+'"/></div>';
		
		//get source image width and height
		var fullimage = new Image();
		fullimage.src = imgSource;
		var imgWidth = fullimage.width;
		var imgHeight = fullimage.height;
		var imgRatio = imgWidth / imgHeight;
		
		//get viewport
		var viewportWidth = $(window).width();
		var viewportHeight = $(window).height();
		var viewportRatio = viewportWidth / viewportHeight;
		
		//this mess of nested ifs sets the image dimensions relative to the viewport
		/*if (imgHeight>=(viewportHeight-100)) {
			bigHeight = viewportHeight-100;
			bigWidth = bigHeight*imgRatio;			
			if (bigWidth>=(viewportWidth-100)) {
				bigWidth = viewportWidth-100;
				bigHeight = (1/imgRatio) * bigWidth;
			}
			else {}
		}
		else {
			if (imgWidth>=(viewportWidth-100)) {
				bigWidth = viewportWidth-100;
				bigHeight = (1/imgRatio) * bigWidth;
			}
			else {
				bigHeight = imgHeight;
				bigWidth = imgWidth;
			}
		}*/
		
		if (imgHeight >= (viewportHeight-100) || imgWidth >= (viewportHeight-100)){
			if (imgRatio >= viewportRatio){
				bigWidth = viewportWidth-100;
				bigHeight = (1/imgRatio) * bigWidth;
			}
			else {
				bigHeight = viewportHeight-100;
				bigWidth = imgRatio * bigHeight;
			}
		}
		else {
			bigHeight = imgHeight;
			bigWidth = imgWidth;
		}
		
		cssHeight = Math.floor(bigHeight)+'px';
		cssWidth = Math.floor(bigWidth)+'px';
		marginTop = ((viewportHeight - Math.floor(bigHeight))/2)-7;
			
		//inserts div element and sets size in css
		$('body').prepend(bgdiv);
		$('#bigimg').css({'height':cssHeight, 'width':cssWidth, 'margin-top':marginTop+'px'});
		$('body').css('overflow', 'hidden');
		
		//removes div element with click
		$(document).on('click', '#imgbgdiv', function() {
			$(this).remove();
			$('body').css('overflow', 'visible');
		});
	});
});
		