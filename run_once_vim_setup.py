#!/bin/python3
import os 

curUser = name = os.popen('whoami').read() 
print(curUser)

os.system("source ~/.bashrc")
if(curUser == 'root'):
    os.system("apt update && apt upgrade -y")
    os.system("apt install -y vim git")
else:
    os.system("sudo apt update && sudo apt upgrade -y")
    os.system("sudo apt install -y vim git")