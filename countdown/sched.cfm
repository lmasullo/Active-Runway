<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
Send Text
<br>

<cfif IsDefined("url.time")>

<!---<cfset url.time = "1">--->
<!---Get the countdown number from url--->
<cfset strUrl = #url.time#>
<!---Current Date and Time--->
<cfset strNow = now()>
<!---Calculate time countdown number minutes from now--->
<cfset strNewDate = DateAdd("n", strUrl, strNow)>

<cfset strDate = #DateFormat(strNewDate, 'm/d/yyyy')#>
<cfset strTime = #DateTimeFormat(strNewDate, 'HH:nn:ss')#>

<cfoutput>
Now: #strNow#
<br>
New Date after add: #strNewDate#
<br>
New Date: #strDate#
<br>
New Time: #strTime#
<br>
</cfoutput>

	<cfschedule  
    action = "update" 
    task = "sendText"
    group="myGroup" 
    mode="application"  
    startDate = "#strDate#"
    startTime = "#strTime#"
    operation = "HTTPRequest" 
    interval="once"
    url = "http://www.activerunway.net/countdown/countdown.cfm">
    
<cfelseif IsDefined("url.pause")>
	
    <cfschedule  
    action = "pauseAll" 
    task = "sendText" 
    group="myGroup" 
    mode="application" 
    operation = "HTTPRequest" 
    url = "http://www.activerunway.net/countdown/countdown.cfm">
    
<cfelseif IsDefined("url.resume")>
	
    <cfschedule  
    action = "resume" 
    task = "sendText" 
    group="myGroup" 
    mode="application" 
    operation = "HTTPRequest" 
    url = "http://www.activerunway.net/countdown/countdown.cfm">
    
<cfelseif IsDefined("url.reset")>
	
    <cfschedule  
    action = "delete" 
    task = "sendText" 
    group="myGroup" 
    mode="application" 
    operation = "HTTPRequest" 
    url = "http://www.activerunway.net/countdown/countdown.cfm">



</cfif>

</body>
</html>
