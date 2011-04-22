// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function() {
	$(".closeBtn").click(function(){
		$(".panel", $(this).parent().parent()).slideUp("slow");
		$(".panelBtn", $(this).parent()).toggle();
		return false;
	});
	$(".openBtn").click(function(){
		$(".panel", $(this).parent().parent()).slideDown("slow");
		$(".panelBtn", $(this).parent()).toggle();
		return false;
	});

	$("#progress_form").submit(function() {
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		return false;
	});
	$("#complete_form").submit(function() {
		$.post($(this).attr("action"), $(this).serialize(), null, "script");
		return false;
	});
});

//***********************************************************************************//
function charCount( src, dst, maxlimit )
{
	if ( src.value.length >= maxlimit )
		src.value = src.value.substring(0, maxlimit);
	$('#'+dst).text( parseInt(maxlimit - src.value.length) );
}
