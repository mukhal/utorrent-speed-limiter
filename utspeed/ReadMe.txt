==========About============
Welcome To TeamMC!!!	
WebSite: http://TeamMC.cc
E-Mail: john@teammc.cc

Program WebSite: http://teammc.cc/utorrent
Program Version: 1.1.0.0 / 20100208

Related Project: uTorrent LanManager (http://teammc.cc/utorrent - http://forum.utorrent.com/viewtopic.php?pid=391389)

uTorrent Website: http://www.utorrent.com
uTorrent Project Topic: http://forum.utorrent.com/viewtopic.php?id=38511
uTorrent Version: 1.8.x to 2.1.0

This is a commandline drivin AutoIt script to help control the speed limits and other settings of uTorrent for 
the purpose of advance scheduling or automation when used with winodws task scheduler, batch files, shortcuts or another program.

If You Dont Know About AutoIT Check It Out At http://autoitscript.com

==========Files============
utspeed.exe - The program executable, execute this with parameters to adjust the settings of utorrent.
utspeed.ini - (Optional) This is the settings INI file, its name should be the same as the above exe file except with 
		the ini extention, this file is optional, the user/pass/ip/port can be placedin the command line.
utspeed-test.bat - (Testing File) An example of how to use utspeed.exe, this example requires you to configure the INI file first.

Folder "src" - (Source Files) These are the source files.

=====uTorrent Settings=====
uTorrents WebUI needs to be enabled before the use of this application, to do this:
1) Goto the settings menu and click on the Web UI option.
2) Check 'Enable Web UI' and configure a Username and  Password
3) Check 'Alternative Listening Port' and change the port to something random (8080 is often fine but a 'first stop' for an attacker)
4) Click Ok and then use the same settings when you use utspeed.exe, the host will be the address of the computer with uTorrent (localhost for the same computer)

==========Usage============
When you execute utspeed.exe and a settings INI file doesnt exist, just include the settings in the command line:
	utspeed.exe /user admin /pass 1234 /ip 192.168.0.1 /port 8900 /max_dl_rate 300 /max_ul_rate 20 /conns_globally 230

Or If the INI file is setup with the proper host/port and user/pass then you dont need to include them in the command line:
	utspeed.exe /max_dl_rate 300 /max_ul_rate 20 /conns_globally 230


Note: switches are passed "raw" to uTorrents WebUI, so no error checking exists, currently only "setsetting" type options will work

Some Switches:

/user
/pass
/ip
/port
/max_ul_rate
/max_dl_rate
/conns_globally
/conns_per_torrent
/sched_enable 1/0
/sched_ul_rate
/sched_dl_rate
/max_active_torrent
/max_active_downloads

==========Changes==========
v1.1.0.0
*Added: Token Auth Support!
*Changed: Error messages will once again stop the script, but will timeout and continue again after 5 minutes
*Chnaged: A few readme updates

v1.0.2.0
*Changed: Tweaked ReadMe
*Fixed: Error Messages No Longer Stop The Program From Continuing
*KNOWN ISSUE: Token_auth unsupported

v1.0.1.0
*Changed: Updated instruction
*Changed: Minor code tweaks

v1.0.0.0
*Added: WebUI Functionality
*Added: Load WebUI Address/Port/UserName/Password From Command Line Or .INI

v0.8.0.0
*Version Using Direct Control Of uTorrent Being The Last Version To Not Use The WebUI