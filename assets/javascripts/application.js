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

  //every time whene reload page
  if($('#loan_email_notify').is(':checked')){
    $('.email_time').show();
  }else{
    $('.email_time').hide();
  }
  if($('#loan_phone_notify').is(':checked')){
    $('.phone_time').show()
  }else{
    $('.phone_time').hide()
  }

  //there is class email_time and phone_time for p
  $('#loan_email_notify').click(function(){
   if($(this).is(':checked')){
      $('.email_time').show();
    }else{
      $('.email_time').hide();
    }
  });
  $('#loan_phone_notify').click(function(){
   if($(this).is(':checked')){
      $('.phone_time').show();
    }else{
      $('.phone_time').hide();
    }
  });
 });