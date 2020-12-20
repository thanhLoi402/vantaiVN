	function test(){
		alert('Testttttttttttttt');
	}
	function ShowDiv(elementId){
		if(document.getElementById(elementId)!=null){
			document.getElementById(elementId).style.display = 'block';
		}
	}
	function HideDiv(elementId){
		if(document.getElementById(elementId)!=null){
			document.getElementById(elementId).style.display = 'none';
		}
	}		
		
	function getRadioCheckedValue(formInput,radio_name){
	   var oRadio = formInput.elements[radio_name];		
	   for(var i = 0; i < oRadio.length; i++){
	      if(oRadio[i].checked){
	      	 return oRadio[i].value;
	      }
	   }
	   return '';
	}
	
	function getBoxCheckedValue(formInput,chkBox_name){
	   var oCheckBox = formInput.elements[chkBox_name];		
	   for(var i = 0; i < oCheckBox.length; i++){
	   	  //alert('CHECK '+i)
	      if(oCheckBox[i].checked){
	      	 return oCheckBox[i].value;
	      }
	   }
	   return '';
	}
	
	
	String.prototype.trim = function() {
	    return this.replace(/^\s+|\s+$/g, "");
	};
	function trim(str) {
	    str = str.toString();
	    var begin = 0;
	    var end = str.length - 1;
	    while (begin <= end && str.charCodeAt(begin) < 33) { ++begin; }
	    while (end > begin && str.charCodeAt(end) < 33) { --end; }
	    return str.substr(begin, end - begin + 1);
	}
	
	function isNumeric(s){
		strNum = "0123456987";
		for(var i = 0; i < s.length; i++) {
			var c = s.charAt(i);
			if(strNum.indexOf(c) < 0){			
				return false;
			}
		}
		return true;
	}