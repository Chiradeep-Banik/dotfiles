#!/bin/python3
from os import system,environ

curUser = environ.get('USER')
print(curUser)

system("source ~/.bashrc")
if(curUser == 'root'):
    system("apt update && apt upgrade -y")
    system("apt install -y vim git")
else:
    system("sudo apt update && sudo apt upgrade -y")
    system("sudo apt install -y vim git")