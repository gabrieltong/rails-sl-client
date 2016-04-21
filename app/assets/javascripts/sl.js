$(function(){
	$.datetimepicker.setLocale('zh');
	$('.tags').tagsInput();

	// 编辑优惠券界面
	showIndate();
	$("#card_a_tpl_indate_type_input input").click(showIndate)
})

function showIndate()
{
	$("#card_a_tpl_indate_from_input").hide()
	$("#card_a_tpl_indate_to_input").hide()
	$("#card_a_tpl_indate_after_input").hide()
	$("#card_a_tpl_indate_today_input").hide()
	
	if($("input[name='card_a_tpl[indate_type]']:checked").val() == 'fixed')
	{
		$("#card_a_tpl_indate_from_input").show()
		$("#card_a_tpl_indate_to_input").show()
	}
	if($("input[name='card_a_tpl[indate_type]']:checked").val() == 'dynamic')
	{
		$("#card_a_tpl_indate_after_input").show()
		$("#card_a_tpl_indate_today_input").show()
	}
}