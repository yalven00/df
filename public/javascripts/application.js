// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function age(){
   var birthYear = document.getElementById("member_dob_1i")
   var age = document.getElementById('coregAge')
   var d = new Date();
   var y = d.getFullYear();
   var gender = document.getElementById('member_gender_f');
    if (gender =="F")
    {
      document.getElementById('coregGender').value = "2"
    }
    else
    {
      document.getElementById('coregGender').value = "1"

    }

    if (birthYear.value !="")
   {
       //alert("sup yo"+document.getElementById('coregAge').value)
       // //getElementById('coregAge').value = y - Number(birthYear.value);
	   age.value = y - Number(birthYear.value);
	   //alert(y - Number(birthYear.value) + "value of coregAge is "+ document.getElementage);
	   //alert("country: "+document.getElementById('country_id').value+"age "+document.getElementById('coregAge').value+" gender:"+document.getElementById('coregGender').value);
   }
}
