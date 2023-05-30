# import statements here
#DEPENDENCIES CURRENTLY BEING USED!!!
#COLORAMA

#Script requires >Python3.

from time import sleep
import os
clear = lambda: os.system('cls')

from colorama import Fore
from files.Winstall import winstall_main
from files.DisplayName import display_name
from files.PerformChecks import perform_checks
from files.DisplayMenu import display_menu
from files.checkYes import checkYes
from files.Automation import automation
from files.ExitProgram import exit_program

# from time import sleep

def main() :
    
    broken = "Haha this is broken right now pffttttt"
    
    tasks = {
        1 : {
            'label' : 'Winget Install',
            'action' : lambda: winstall_main(),
            'color' : Fore.WHITE
        },
        2 : {
            'label' : 'Disable VBS',
            'action' : lambda: print(broken),
            'color' : Fore.WHITE
        },
        3 : {
            'label' : 'Uninstall Edge',
            'action' : lambda: print(broken),
            'color' : Fore.WHITE
        },
        4 : {
            'label' : 'Remove Brain perhaps?',
            'action' : lambda: print(broken),
            'color' : Fore.WHITE
        },
        5 : {
            'label' : 'Exit Program',
            'action' : lambda: exit_program(),
            'color' : Fore.RED
        },
        69 : {
            'label' : 'Run the entire script and perform all of the tasks.',
            'action' : lambda: print(broken),
            'color' : Fore.GREEN
        },
    }
    
    #Print the GIGANTIC Winrice Logo
    display_name()
        
    #Perform Checks before moving ahead
    # perform_checks()
    
    #Asking user how to proce
    display_menu(tasks)
    

main()

