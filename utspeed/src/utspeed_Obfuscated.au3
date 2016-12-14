#NoTrayIcon
Func _ArrayAdd(ByRef $avArray, $vValue)
If Not IsArray($avArray) Then Return SetError(1, 0, -1)
If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, -1)
Local $iUBound = UBound($avArray)
ReDim $avArray[$iUBound + 1]
$avArray[$iUBound] = $vValue
Return $iUBound
EndFunc
Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = -1)
If Not IsArray($avArray) Then Return SetError(1, 0, -1)
If UBound($avArray, 0) > 2 Or UBound($avArray, 0) < 1 Then Return SetError(2, 0, -1)
Local $iUBound = UBound($avArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
Local $iStep = 1
If Not $iForward Then
Local $iTmp = $iStart
$iStart = $iEnd
$iEnd = $iTmp
$iStep = -1
EndIf
Switch UBound($avArray, 0)
Case 1
If Not $iPartial Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return $i
Next
EndIf
Case 2
Local $iUBoundSub = UBound($avArray, 2) - 1
If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iUBoundSub = $iSubItem
EndIf
For $j = $iSubItem To $iUBoundSub
If Not $iPartial Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i][$j] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i][$j] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If StringInStr($avArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
Next
EndIf
Next
Case Else
Return SetError(7, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
GLOBAL $TITLE="utspeed "&FileGetVersion(@AutoItExe)
if Int($cmdline[0] / 2) <> $cmdline[0] / 2 Or $cmdline[0]=0 Then
MsgBox(0,$TITLE,"Error: Wrong Number Of Parameters",60*5)
Exit
EndIf
Local $Commands[1], $Values[1]
for $i=1 To $cmdline[0] Step 2
if StringLeft($cmdline[$i],1)="/" And StringLeft($cmdline[$i+1],1)<>"/"Then
_ArrayAdd($Commands,StringTrimLeft($cmdline[$i],1))
_ArrayAdd($Values,$cmdline[$i+1])
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
Func _tspeed($address,$port,$user,$pass,$setting,$value,$action="setsetting")
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
Local $Data=Inetread($FINALURL,1+16)
if @error then
MsgBox(0,$TITLE,"Error: Couldn't Establish A Connection",60*5)
Return 0
endif
Return 1
EndFunc
