<!DOCTYPE html> 
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> 
	<title>Engine Out Messaging</title> 
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.css" />
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.js"></script>

<!---Only runs the prevent browser sleep function when first start, not after complete--->
<cfif NOT IsDefined("form.txtDone")>
<!---Prevents the browser from sleeping by faking page redirects--->
	<script>
    iosSleepPreventInterval = setInterval(function () {
        window.location.href = "/new/page";
        window.setTimeout(function () {
            window.stop()
        }, 0);
    }, 20000);
    </script>
</cfif>

</head> 

<body> 

<div data-role="page">

	<div data-role="header">
		<h1>Engine Out<br>Messaging</h1>
	</div><!-- /header -->

	<div data-role="content">	
		
        <!---Section for message about no flight mins entered--->
        <section id="strAlert" style="color:red"></section>
        
<!---Sends the text to my phone when the countdown is complete--->
<cfif IsDefined("form.txtDone") AND form.txtDone EQ "Done">
    <cfmail
    username = "support@activerunway.net"
    password = "Laxman27!"
    server = "mail16.ezhostingserver.com"
    subject="Engine Out! Engine Out!"
    from='Engine Out Countdown Support <support@activerunway.net>'
    to='2542891124@txt.att.net'
    type="HTML"> 
    Your engine has just stopped running! Land immediately!
    Thank you.
    </cfmail>
    
	<section id="strSent" style="color:blue">Message sent successfully.</section>

</cfif>
    
<form name="frmCountdown" id="frmCountdown" action="index.cfm" method="post" data-ajax="false">
    
    <label for="txtMins">Total Flight Minutes:</label>
    <!---<input type="number" name="txtMins" pattern="[1-180]*" id="txtMins" value="1" onChange="fnTxtMins();">--->
    <input type="range" name="sldMins" id="sldMins" data-highlight="true" min="1" max="180" value="1" onChange="fnDel();">
    
    
    <br>
    	<!---Section to put start and pause messages--->
        <section id="strStart" style="color:blue" align="center"></section>
    <br>
    
    <input type="button" id="btnStart" value="Start"  onclick="fnStart();">
    
    <input type="button" id="btnStop" value="Pause" disabled onclick="fnStop();">

    <input type="button" id="btnResume" value="Resume" disabled  onclick="fnResume();">
            
    <input type="button" id="btnReset" value="Reset" disabled onclick="fnReset();">
    
    <input type="text" name="txtDone" id="txtDone" value="Start">
    
    <input type="hidden" name="txtPause" id="txtPause" value="">
    
    <section id="strRan" hidden="true"></section>
    
    <section id="timer" hidden="true"></section>

</form>   

       
	</div><!-- /content -->
	
	<div data-role="footer">
		<h4>&copy; 2014 Engine Out Messaging</h4>
	</div><!-- /footer --></div>
</body>
</html>

<script>
//function to generate the random number and start the countdown
function fnStart() {
	
	if (document.getElementById("sldMins").value > 0) {
		document.getElementById("strAlert").innerHTML = "";//clears the alert if no flight mins were entered
		//checks if the txtDone field is Done and then clears the sent message
		if (document.getElementById("txtDone").value == "Done"){
			document.getElementById("strSent").innerHTML = "";//deletes the sent message
		}
		var intMin = document.getElementById("sldMins").value;//sets the total flight minutes
		//alert(intMin);
		var x = Math.floor((Math.random() * intMin) + 1);//calculates the random number
		document.getElementById("strRan").innerHTML = x;//puts the countdown in the random number section
		var intRan = x;//puts the random number in the section
		$('#sldMins').slider({ disabled: true });//makes the slider disabled
		$('#btnStart').button({ disabled: true });//makes the start button disabled
		$('#btnStop').button({ disabled: false });//makes the stop button enabled
		$('#btnReset').button({ disabled: false });//makes the Reset button enabled
		document.getElementById("strStart").innerHTML = "Countdown has Started!";//makes the start message visible
		countdown(intRan);//start the countdown with the random number
	
	}else {
		document.getElementById("strAlert").innerHTML = "Please enter a Flight Minutes value > 0";//Alert message to not enter a zero
	}
}

//function to run countdown
function countdown(minutes) {
    var seconds = 60;
    var mins = minutes;
    function tick() {

		var counter = document.getElementById("timer");
        var current_minutes = mins-1;
        seconds--;
        counter.innerHTML = current_minutes.toString() + ":" + (seconds < 10 ? "0" : "") + String(seconds);
		
        if( seconds > 0 ) {
            myVar = setTimeout(tick, 1000);
        } else {
             
            if(mins > 1){
                 
               // countdown(mins-1);   never reach “00″ issue solved:Contributed by Victor Streithorst    
               myVar = setTimeout(function () { countdown(mins - 1); }, 1000);
                     
            }
        }
		
		var counter2 = document.getElementById("timer").innerHTML;
		if (counter2 == "0:00"){//triggers when the timer hits 0
			//alert(counter2);
			document.getElementById("txtDone").value = "Done";//sets the hidden fields value so the cfmail will trigger
			$("#frmCountdown").submit();//submit the form to send the text message
		}
    }
    tick();
	
}


//put the value of the slider into the flight minutes box
function fnStop()
	{
		//document.getElementById("mybutton2").innnerHTML= "New Button Text using innerHTML";
		//document.getElementById("mybutton2").childNodes[0].nodeValue="New Button Text using childNodes";
		$('#btnStop').button({ disabled: true });//makes the start button disabled
		$('#btnResume').button({ disabled: false });//makes the Resume button enabled
		document.getElementById("strStart").innerHTML = "Countdown has been Stopped.";
		clearInterval(myVar);//stops the timer
		//document.getElementById("btnStart").value="New Button Text";
		//document.getElementById("btnStart").innerHTML="New Button Text";
		//document.getElementById("myButton1").value="New Button Text";
		//replaceButtonText('btnStop', 'new button text');
		//$('#btnStop').prev('.ui-btn-inner').children('.ui-btn-text').html('...Canceling');
	}

//put the value of the slider into the flight minutes box
function fnResume()
	{
		var strTimer = document.getElementById("timer").innerHTML;//gets the value of the timer after the pause
		var intTimer = parseInt(strTimer);//turn string into integer
		$('#btnStop').button({ disabled: false });
		$('#btnResume').button({ disabled: true });//makes the Resume button disabled
		document.getElementById("strStart").innerHTML = "Countdown has Resumed.";
		if (intTimer == 0){
			countdown(1);//start the countdown with 1
		}else{
			countdown(intTimer);//start the countdown with the new timer number
		}
	}

//clears the timer
function fnReset() {
	clearTimeout(myVar);//stops the timer
	$('#sldMins').slider({ disabled: false });//makes the slider button enabled
	$('#btnStart').button({ disabled: false });//makes the start button enabled
	$('#btnStop').button({ disabled: true });//makes the stop button disabled
	$('#btnResume').button({ disabled: true });//makes the resume button disabled
	$('#btnReset').button({ disabled: true });//makes the Reset button disabled
	document.getElementById("strAlert").innerHTML = "";//clears the alert if no flight mins were entered
	document.getElementById("strStart").innerHTML = "";//clears the start message
	document.getElementById("strRan").innerHTML = "";//clears the random number
	document.getElementById("timer").innerHTML = "";//clears the timer section
	$("#sldMins").val(0).slider("refresh");//clears the fligth minutes slider
}

//clears the message sent message when changing the slider
function fnDel()
	{
		document.getElementById("strSent").innerHTML = "";
		$('#btnReset').button({ disabled: false });//makes the Reset button enabled
	}
	
</script>

<!---Sets the txtDone section to Done--->
<cfif IsDefined("form.txtDone") AND form.txtDone EQ "Done">
    <cfset form.txtDone EQ "Start">
</cfif>


<!---<SCRIPT LANGUAGE="JavaScript">
<!--
function replaceButtonText(buttonId, text)
{
  if (document.getElementById)
  {
    var button=document.getElementById(buttonId);
    if (button)
    {
      if (button.childNodes[0])
      {
        button.childNodes[0].nodeValue=text;
      }
      else if (button.value)
      {
        button.value=text;
      }
      else //if (button.innerHTML)
      {
        button.innerHTML=text;
      }
    }
  }
}
//-->
</SCRIPT>--->

<!---<script>
	//put the value of the slider into the flight minutes box
	function fnSlider()
		{
			var str1 = document.getElementById('sldMins').value;//get the value from the slider
			document.getElementById('txtMins').value = str1;//put the slider value into the flight mins box
		}
</script>--->

<!---<script>
	//put the value of the text flight mins into the flight minutes slider
	function fnTxtMins()
		{	
			var str1 = document.getElementById('txtMins').value;//get the value from the txtMins
			document.getElementById('sldMins').value = str1;//put the txtMins value into the sldMins
			$("#sldMins").slider("refresh");
		}
</script>--->


