from time import sleep
from files.checkYes import checkYes
import os
clear = lambda: os.system('cls')

def exit_program(): 
    clear()
    while True:
        userInput = input("Are you sure you want to exit the program? y/n :: ")
        result = checkYes(userInput)
        if result == True:
            clear()
            print("Exiting the program now.")
            exit()
        elif result == False:
            clear()
            print("Not exiting the program. Going back to menu")
            sleep(1)
            clear()
            return
        else:
            print("\nNot a proper input.")
            sleep(1)
        