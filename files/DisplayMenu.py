from colorama import Fore
# from Automation import automation
from time import sleep
import os
clear = lambda: os.system('cls')

def display_menu(menu) :
    def printItems():
        for key, item in menu.items():
            print(f'{item["color"]}{key}. {item["label"]}' + Fore.RESET); sleep(0.1)
        print("------------------------------------")
    
    def choiceAction(key):
        if key in menu:
            action = menu[key].get('action')
            print(f'Creating session for your choice...'); sleep(0.6)
            action()
        else: 
            print("\nIncorrect choice."); sleep(0.5); 
            print("Re-launching menu."); sleep(1.5); clear()
    
    clear()
    while True:
        printItems()
        choice = int(input("Enter your choice :: "))
        choiceAction(choice)
    
    return
