function highlightTableRows(tableId) {
    var previousClass = null;
    var table = document.getElementById(tableId); 
    var tbody = table.getElementsByTagName("tbody")[0];
    var rows = tbody.getElementsByTagName("tr");
    // add event handlers so rows light up and are clickable
    for (i=0; i < rows.length; i++) {
        rows[i].onmouseover = function() { previousClass=this.className;this.className+=' over' };
        rows[i].onmouseout = function() { this.className=previousClass };
    }
}

function doPageSizeSubmit(){
	document.getElementById("frm").submit();
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function getSelectedCheckbox(buttonGroup) {
   // Go through all the check boxes. return an array of all the ones
   // that are selected (their position numbers). if no boxes were checked,
   // returned array will be empty (length will be zero)
   var retArr = [];
   var lastElement = 0;
   var bFlag = false;
	var cb = MM_findObj(buttonGroup);   

if (cb){
   if (cb[0]) { // if the button group is an array (one check box is not an array)
      for (var i=0; i<cb.length; i++) {
         if (cb[i].checked) {
   				bFlag = true;
         }
      }
   } else { // There is only one check box (it's not an array)
      if (cb.checked) { // if the one check box is checked
	      bFlag = true;
      }
   }
} else{
	alert("No items to delete!");
	return false;
} 

   if(bFlag==true){
	   	return confirm("Do you want to delete?");
   }else{
	   alert("Please check the items to delete!");
   }
   
   return bFlag;


} // Ends the "getSelectedCheckbox" function


function doDelete(){
	return confirm("Do you want to delete?");
}

function trim(str)
{
   return str.replace(/^\s*|\s*$/g,"");
}

bCancel = false;

//validate form 
function validateForm(frm, arr){
	if(bCancel==true){
		return true;
	}
	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if (trim(obj.value)=="") {
						alert("The field is required!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
			if(trim(obj.value)==""){
				alert("The field is required!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}


//check date
	
	function isValidDate(dateStr) {
// Checks for the following valid date formats:
// MM/DD/YY   MM/DD/YYYY   MM-DD-YY   MM-DD-YYYY
// Also separates date into month, day, and year variables

var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{2}|\d{4})$/;

// To require a 4 digit year entry, use this line instead:
// var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{4})$/;

var matchArray = dateStr.match(datePat); // is the format ok?
if (matchArray == null) {
alert("Date is not in a valid format.");
return false;
}
month = matchArray[1]; // parse date into variables
day = matchArray[3];
year = matchArray[4];
if (month < 1 || month > 12) { // check month range
alert("Month must be between 1 and 12.");
return false;
}
if (day < 1 || day > 31) {
alert("Day must be between 1 and 31.");
return false;
}
if ((month==4 || month==6 || month==9 || month==11) && day==31) {
alert("Month "+month+" doesn't have 31 days!");
return false
}
if (month == 2) { // check for february 29th
var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
if (day>29 || (day==29 && !isleap)) {
alert("February " + year + " doesn't have " + day + " days!");
return false;
   }
}
return true;  // date is valid
}



// Show the document's title on the status bar
window.defaultStatus=document.title;


//////Get current date/////////////
var now = new Date();
var yr = now.getYear();

if (yr == 100) { yr += 1900 }

var mName = now.getMonth() + 1;
var dayNr = now.getDate();
//dayNr = (dayNr > 2) ? dayNr-2 : dayNr
var hours = now.getHours();
var minutes = ((now.getMinutes() < 10) ? ":0" : ":") + now.getMinutes();
// String to display month, day, & year.
var MonthDayYear =(mName + "/" + dayNr + "/" + yr);
// String to display current time.
var TimeValue =(hours + minutes);

//document.write(MonthDayYear);
// -->
// Check all elements of array are numbers or not
function checkNumber(frm, arr){
	if(bCancel==true){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if ((trim(obj.value)!=="")&&! Number(trim(obj.value))) {
						alert("The field must be Number (>0)!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
			if ((trim(obj.value)!=="")&&! Number(trim(obj.value))){
				alert("The field must be Number (>0)!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}
// Check all elements of array are Dates or not
function checkDate(frm,arr){
if(bCancel==true){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if ( trim(obj.value)!="" && ! isValidDate(trim(obj.value) ) ) {
    					alert("please input a validate date");
					 obj.focus();
				 return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
				if (trim(obj.value)==""){
					alert("please input a validate date");
					 obj.focus();
					 return false;
				}			
			if ( trim(obj.value)!="" && ! isValidDate(trim(obj.value))   && obj.visibility ){
				obj.focus();
				return false;
			}
		}
	}
	return true;

}
//Main function
//frm: the main form

function myCheckValidateForm(frm, arrRequireds, arrNumbers,arrDates){
  
   return (validateForm(frm,arrRequireds)&& checkNumber(frm,arrNumbers)&& checkDate(frm,arrDates));
   
}

function setValueEmpty(chkgroup, txtgroup ) {
	//When check box is unnabled, value of text box will clear.
	if ( (chkgroup != null) && (txtgroup != null) ) {
		for (var i = 0; i < chkgroup.length; i++ ) {		
			if ( chkgroup[i].checked == false)
				txtgroup[i].value = "";
			else {
				if ( txtgroup[i].value == "" ||  txtgroup[i].value == null ) 
					chkgroup[i].checked = false;		
			}
		}
	}
}

function trimSpace(inputString) {
   // Removes leading and trailing spaces from the passed string. Also removes
   // consecutive spaces and replaces it with one space. If something besides
   // a string is passed in (null, custom object, etc.) then return the input.
   if (typeof inputString != "string") { 
   		return inputString; 
   }
   var retValue = inputString;
   var ch = retValue.substring(0, 1);
   while (ch == " ") { // Check for spaces at the beginning of the string
      retValue = retValue.substring(1, retValue.length);
      ch = retValue.substring(0, 1);
   }
   ch = retValue.substring(retValue.length-1, retValue.length);
   while (ch == " ") { // Check for spaces at the end of the string
      retValue = retValue.substring(0, retValue.length-1);
      ch = retValue.substring(retValue.length-1, retValue.length);
   }
   while (retValue.indexOf("  ") != -1) { // Note that there are two spaces in the string - look for multiple spaces within the string
      retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length); // Again, there are two spaces in each of the strings
   }
   return retValue; // Return the trimmed string back to the user
} // Ends the "trim" function

function checkValueEmpty(chkgroup, txtgroup){
    // Enable check box when text field have a value. This value must not empty.
    if ( (chkgroup != null) && (txtgroup != null) ) {
	    var s;
		for (var i = 0; i < chkgroup.length; i++ ){
		    s = trimSpace(txtgroup[i].value);
			if ( (s != "") || (s.length != 0) )
				chkgroup[i].checked = true;			
			else 
				chkgroup[i].checked = false;
		}
	}
}

function isIntegerChar(c)
{	return ( ( (c >= "0") && (c <= "9") ) || c=='-');
}
function isIntegerString(s)
{   
  var i;
  if (isEmpty(s)) 
     if (isIntegerString.arguments.length == 1) {
     return false;
     }
  for (i = 0; i < s.length; i++)
  {   
    var c = s.charAt(i);
    if (isIntegerChar(c)==false)
    return false;
  }
  return true;
}

///Start of Validation Of Phuoc
function isFloatChar(c)
{	
	return (( (c >= "0") && (c <= "9") )|| c == '.'|| c == ',' || c=='-'|| c=='E'|| c=='e');
}


function isFloatString(s)
{   
  var i;
  if (isEmpty(s)) {
     return true;
     }

  for (i = 0; i < s.length; i++)
  {   
    var c = s.charAt(i);
    if (isFloatChar(c)==false){
    return false;
    }
  }
  return true;
}
function isLongChar(c)
{	
	return (( (c >= "0") && (c <= "9") )|| c == ',' || c=='-'|| c=='e'|| c=='E');
}


function isLongString(s)
{   
  var i;
  if (isEmpty(s)) {
     return true;
     }

  for (i = 0; i < s.length; i++)
  {   
    var c = s.charAt(i);
    if (isLongChar(c)==false){
    return false;
    }
  }
  return true;
}
function isEmpty(s)
{   
	return ((s == null) || (s.length == 0))
}

function testDate(strdate,type)
  
  // TestDate(StringdateToChange,TypeOfFormat,StringOut)
  // StringdateToChange : Ngay muon kiem tra hop le
  // TypeOfFormat : Dang truyen vao cua ngay muon kiem tra hop le:
  // TypeOfFormat =1 : Truyen vao dd/mm/yyyy
  // TypeOfFormat =2 : Truyen vao mm/dd/yyyy
  // Tri tra ve cua ham 1: Ngay hop le
  //		      0: Ngay khong hop le rterretret
  {
   
	var m,d,y;

	var t=[0,31,28,31,30,31,30,31,31,30,31,30,31];
	var s, pos1,pos2;
	var s = strdate;
	if (s.length==0) return 1;
	pos1=s.indexOf("/",0);
	pos2=s.indexOf("/",pos1+1);
	if ((pos1<0)||(pos2<0))
		return false;
	d=parseInt(s.substr(0,pos1),10);
	m=parseInt(s.substr(pos1+1,pos2-pos1-1),10);
	y=parseInt(s.substr(pos2+1,s.length-pos2-1),10);
	var y1=s.substr(pos2+1,s.length-pos2-1);
	if (y1.length!=4) 
	 {
	   return false;
	 }
	if (y%4==0){
		if ((y%100) ==0 && (y%400) != 0){
			t[2]=28;
		}
		//Nam nhuan
		else{
			t[2]=29;
		    }
		}
	if (type == 1) {
		if ( (t[m]<d)||(d<1) || (m<1) || (m>12)){
			return false;
		}
		}	
	if (type == 2){
		if ((t[d]<m)||(m<1) || (d<1) || (d>12)){
			return false;
		}
		}
	return true;	
   }// end Testday
function checkComboboxsForm(frm, arr){
	if(bCancel==true){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if (trim(obj.value)=="0" ||trim(obj.value)=="") {
						alert("The field must be selected!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
			if(trim(obj.value)=="0"||trim(obj.value)==""){
				alert("The field must be selected!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}


function checkValidateAllTypes(frm, arrRequireds, arrIntegers,arrFloats,arrComboboxs ,arrDates)
{
  if (arrRequireds!='') {
	if(!validateForm(frm,arrRequireds)) {
		return false;
	}
	}
  if (arrIntegers!='') {	
	if(!checkIntegerForm(frm,arrIntegers)){
		return false;
		}
	}
  if (arrFloats!='') {
	if(!checkFloatForm(frm,arrFloats)){
		return false;
		}
	}
  if (arrComboboxs!='') {	
	if (!checkComboboxsForm(frm,arrComboboxs)){
		return false;
		}
	}
  if (arrDates!='') {	
	 if(!checkDate(frm,arrDates)){
		return false;
	 }
	}
	return true;		
}

function checkIntegerForm(frm, arr){
	if(bCancel==true){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if (trim(obj.value)!=""&&!isIntegerString(trim(obj.value))) {
						alert("The Integer is required!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
			 if (trim(obj.value)!=""&&!isIntegerString(trim(obj.value))) {
				alert("The Integer is required!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}
function checkLongForm(frm, arr){
	if(trim(arr)==""){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		         if (obj!=null&&trim(obj.value)!=""&&!isLongString(trim(obj.value))) {
						alert("The Integer is required!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
			 if (obj!=null&&trim(obj.value)!=""&&!isLongString(trim(obj.value))) {
				alert("The Integer is required!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}
function checkFloatForm(frm, arr){
	if(bCancel==true){
		return true;
	}

	var listParam = arr.split(",");

	if(listParam){
		if(listParam[0]){
			for (var i=0; i<listParam.length; i++){
				obj = frm.elements[trim(listParam[i])];
		        if (trim(obj.value)!=""&&!isFloatString(trim(obj.value))) {
						alert("The Real Number is required!");
						obj.focus();
						return false;
		         }
	      	}
		}else{//there is one parameter
			obj = frm.elements[trim(listParam)];
				if(trim(obj.value)==""){
						alert("The Real Number is required!");
						obj.focus();
						return false;

		        }			
			 if (trim(obj.value)!=""&&!isFloatString(trim(obj.value))) {
				alert("The Real Number is required!");
				obj.focus();
				return false;
			}
		}
	}
	return true;
}

function getReturn(flags){
if((null!=flags)&&(flags!="")){
	document.getElementById("returnUrl").href="departmentTrafficlight.html";
}else{
	document.getElementById("returnUrl").href="trafficLight.html";
}
return true;
}