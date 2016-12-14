#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=.Icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=uTorrent Speed Change Tool
#AutoIt3Wrapper_Res_Fileversion=1.1.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;=================================================================================================
;Please See ReadMe.txt For More Information And Change Log
;=================================================================================================
#Include <Array.au3>
GLOBAL $TITLE="utspeed "&FileGetVersion(@AutoItExe)

if Int($cmdline[0] / 2) <> $cmdline[0] / 2 Or $cmdline[0]=0 Then
	MsgBox(0,$TITLE,"Error: Wrong Number Of Parameters",60*5)
	Exit
EndIf

Local $Commands[1], $Values[1]

for $i=1 To $CmdLine[0] Step 2;Examines switches for user/pass/ip/port
	if StringLeft($CmdLine[$i],1)="/" And StringLeft($CmdLine[$i+1],1)<>"/"Then
		_ArrayAdd($Commands,StringTrimLeft($CmdLine[$i],1))
		_ArrayAdd($Values,$CmdLine[$i+1])
	endif
Next

$ip=IniRead(StringTrimRight(@ScriptName,4)&".ini","settings","ip",0)
$port=IniRead(StringTrimRight(@ScriptName,4)&".ini","settings","port",0)
$user=IniRead(StringTrimRight(@ScriptName,4)&".ini","settings","user",0)
$pass=IniRead(StringTrimRight(@ScriptName,4)&".ini","settings","pass",0)

If _ArraySearch($Commands,"ip")<>-1 Then $ip=$Values[_ArraySearch($Commands,"ip")]
If _ArraySearch($Commands,"port")<>-1 Then $port=$Values[_ArraySearch($Commands,"port")]
If _ArraySearch($Commands,"user")<>-1 Then $user=$Values[_ArraySearch($Commands,"user")]
If _ArraySearch($Commands,"pass")<>-1 Then $pass=$Values[_ArraySearch($Commands,"pass")]

If $ip="" Or $user="" Or $port="" Or $pass="" Then
	MsgBox(0,$TITLE,"Error: Missing a critical setting(s)"&@CRLF&$ip&@CRLF&$port&@CRLF&$user&@CRLF&$pass,60*5)
	Exit
EndIf

For $i=1 To UBound($Commands)-1
	If $Commands[$i]<>"ip" And $Commands[$i]<>"port" And $Commands[$i]<>"user" And $Commands[$i]<>"pass" Then
		if $Values[$i]=="RANDOM" then $Values[$i]=Random(100,200)
		_tspeed($ip,$port,$user,$pass,$Commands[$i],$Values[$i])
	EndIf
Next
;gui/token.html
;=============================================================================
Func _tspeed($address,$port,$user,$pass,$setting,$value,$action="setsetting")
	;_cfl("Posting Setting: "&$setting&"="&$value)

	Local $TOKENURL="http://"&$user&":"&$pass&"@"&$address&":"&$port&"/gui/token.html"
	Local $Token=Inetread($TOKENURL,1+16)
	if @error then
		MsgBox(0,$TITLE,"Error: Couldn't Get Token",60*5)
	Else
		$Token=BinaryToString($Token)
		$Token=Stringmid($Token, _
			StringInStr($Token,">",0,1,StringInStr($Token,"id='token'"))+1, _
			StringInStr($Token,"<",0,1,StringInStr($Token,"id='token'")) - StringInStr($Token,">",0,1,StringInStr($Token,"id='token'"))-1 _
		)
	endif

	Local $FINALURL="http://"&$user&":"&$pass&"@"&$address&":"&$port&"/gui/?token="&$Token&"&action="&$action&"&s="&$setting&"&v="&$value
	;Local $FINALURL="http://"&$user&":"&$pass&"@"&$address&":"&$port&"/gui/?action="&$action&"&s="&$setting&"&v="&$value
	Local $Data=Inetread($FINALURL,1+16)
	if @error then
		MsgBox(0,$TITLE,"Error: Couldn't Establish A Connection",60*5)
		Return 0
	endif
	Return 1
EndFunc