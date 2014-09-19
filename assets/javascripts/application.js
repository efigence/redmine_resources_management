$(document).ready(function(){
	$('.chosen').chosen();
  $('.datetimepicker').datetimepicker({
  	formatDate:'Y-m-d H:i',
  	format:'Y-m-d H:i'
  });
  $('.datepicker').datetimepicker({
  	timepicker:false,
  	formatDate:'Y-m-d',
  	format:'Y-m-d'
  });
});