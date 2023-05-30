def checkYes(choice):
    words = {
        'true': { 'y', 'yes', 'yeah', 'Y', 'Yes', 'YES', 'Yeah', 'YEAH' },
        'false': { 'n', 'no', 'nah', 'N', 'No', 'NO', 'Nah', 'NAH' }
    }
    
    while True:
        for key, item in words.items():
            if choice in item:
                if key == 'true':
                    return True
                if key == 'false':
                    return False
        return
                    