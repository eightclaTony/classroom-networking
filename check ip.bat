@echo off
nmap -p 10001 -T4 -v -Pn --oN record.txt --open 10.88.194.0/24
pause