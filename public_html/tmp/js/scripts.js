/** CONTACT FORM CODE **/
$(document).ready(function(){
$("#ajax-contact-form").submit(function(){

/** 'this' refers to the current submitted form**/
var str = $(this).serialize();

   $.ajax({
   type: "POST",
   url: "contact.php",
   data: str,
   success: function(msg){

$("#note").ajaxComplete(function(event, request, settings){

if(msg == 'OK') /** Message Sent? Show the 'Thank You' message and hide the form**/
{
result = '<div class="notification_ok">Your message has been sent. Thank you!<\/div>';
$("#ajax-contact-form").hide();
}
else
{
result = msg;
}

$(this).html(result);

});

}

 });

return false;

});

});
/** END CONTACT FORM CODE **/