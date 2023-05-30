from colorama import Fore, Style
from subprocess import Popen
from time import sleep
import sys

#Creating a clear function
import os
clear = lambda: os.system('cls')

def perform_checks() :
    sleep(2)
    clear()
    
    print("Starting the Checking process.\n")
    
    #calling powershell to open the script, dom't touch
    output = Popen(["powershell.exe", "files/ps/performcheck.ps1"], stdout=sys.stdout)
    output.communicate()
    
    #don't touch this either
    if output.returncode == 0:
        print("\nChecks performed successfully!")
        sleep(0.3)
        print("Opening Menu...")
        sleep(1)
        return
    else:
        print(output.stderr)
        print("The script did not execute successfully.")
        print(Fore.GREEN + "Please resolve the issues.")
        print(Fore.RED + "Exiting the Program now.")
        exit()
        
