<scrolltotop>

    <div class="scroll-top-wrapper ">
        <span class="scroll-top-inner">
            <i class="fa fa-2x fa-arrow-circle-up"></i>
        </span>
    </div>

    <script type="text/javascript">
		$(function(){
		 
			$(document).on( 'scroll', function(){
		 
				if ($(window).scrollTop() > 100) {
					$('.scroll-top-wrapper').addClass('show');
				} else {
					$('.scroll-top-wrapper').removeClass('show');
				}
			});
		 
			$('.scroll-top-wrapper').on('click', scrollToTop);
		});
		 
		function scrollToTop() {
			verticalOffset = typeof(verticalOffset) != 'undefined' ? verticalOffset : 0;
			element = $('body');
			offset = element.offset();
			offsetTop = offset.top;
			$('html, body').animate({scrollTop: offsetTop}, 500, 'linear');
		}
    </script>

     <style scoped>
     	.scroll-top-wrapper {
     		position: fixed;
     		opacity: 0;
     		visibility: hidden;
     		overflow: hidden;
     		text-align: center;
     		z-index: 99999999;
     		background-color: #777777;
     		color: #eeeeee;
     		width: 50px;
     		height: 48px;
     		line-height: 48px;
     		right: 30px;
     		bottom: 30px;
     		padding-top: 2px;
     		border-top-left-radius: 3px;
     		border-top-right-radius: 3px;
     		border-bottom-right-radius: 3px;
     		border-bottom-left-radius: 3px;
     		-webkit-transition: all 0.5s ease-in-out;
     		-moz-transition: all 0.5s ease-in-out;
     		-ms-transition: all 0.5s ease-in-out;
     		-o-transition: all 0.5s ease-in-out;
     		transition: all 0.5s ease-in-out;
     	}
     	.scroll-top-wrapper:hover {
     		background-color: #888888;
     	}
     	.scroll-top-wrapper.show {
     		visibility:visible;
     		cursor:pointer;
     		opacity: 1.0;
     	}
     	.scroll-top-wrapper i.fa {
     		line-height: inherit;
     	}
     </style>
</scrolltotop>