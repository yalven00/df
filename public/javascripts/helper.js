console.log("loaded helper.js");
function validateForm(){

	var fn=0;
	var ln=0;
	var em=0;
	var pc=0;
				
		$("#member_first_name").live("keyup", function () {
		    if ($("#member_first_name").val().match(/^[a-zA-Z]+$/)) {
		          $("#member_first_name").css('border','1px solid #01750B');
		      	  $("#member_first_name").css('color','#01750B');  
			  	  fn=1;
			} else {
		          $("#member_first_name").css('color','#ff0000');
		          $("#member_first_name").css('border','1px solid #ff0000');
		      	  fn=0;
			}
		  })
		
		$("#member_last_name").live("keyup", function () {
		   if ($("#member_last_name").val().match(/^[a-zA-Z]+$/)) {
		          $("#member_last_name").css('border','1px solid #01750B');
		      	  $("#member_last_name").css('color','#01750B');  
			  	  ln=1
			} else {
		          $("#member_last_name").css('color','#ff0000');
		          $("#member_last_name").css('border','1px solid #ff0000');
		      	  ln=0;
			}
		  })
		
		$("#member_email").live("keyup", function () {
		    if ($("#member_email").val().match(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i)) {
		          $("#member_email").css('border','1px solid #01750B');
		      	  $("#member_email").css('color','#01750B');  				  
				  em=1;
			} else {
		          $("#member_email").css('color','#ff0000');
		          $("#member_email").css('border','1px solid #ff0000');			  	  
				  em=0;
		    }
		  })
		
		$("#member_postal_code").live("keyup", function () {
		    if ($("#member_postal_code").val().match(/^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$/)) {
		          $("#member_postal_code").css('border','1px solid #01750B');
		      	  $("#member_postal_code").css('color','#01750B');  
				  pc=1;  
		    } else {
		          $("#member_postal_code").css('color','#ff0000');
		          $("#member_postal_code").css('border','1px solid #ff0000');
		       	  pc=0;
			}
		  })
	
		$("#new_member").submit(function(e){
			console.log(em);
			if ((fn!=1) && (ln!=1) && (em!=1) && (pc!=1)){
				console.log("stoped form processing");
				return false
			}else{
				return true
			}
		})
}

function validate_pw()
{
    //console.log($(this).attr("id"));
  $("#coreg_optin_32_taken_true").click(function(){
      console.log("yes checked");
      $(".ml10").attr('disabled','disabled');
      // disable submit on yes checked

      $("#vp_password").focus();
      // set focus to password field.

      $("#vp_password").live("keyup", function () {

          if (($("#vp_password").val().match(/^(?=.*\d)(?=.*[a-z])[0-9a-zA-Z]{5,}$/))&&($("#vp_password").val().length >=6 )) {
              console.log("good stuff");
              $("#vp_text").css('color','#01750B');
              $("#vp_password").css('border','1px solid #01750B')
              $(".ml10").removeAttr('disabled');
          } else {
              $("#vp_text").css('color','#ff0000');
              $("#vp_password").css('border','1px solid #ff0000')
              console.log("keep typing son");
          }
      });
  });

  $("#coreg_optin_32_taken_false").click(function(){
      console.log("no checked");
      $(".ml10").removeAttr('disabled');

  });



//
}