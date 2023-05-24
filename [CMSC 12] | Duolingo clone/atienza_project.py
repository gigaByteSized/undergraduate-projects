import os # Import os-specific modules
import random # Import random lib
import getpass # Import getpass for @echo off when typing passwords

PASSWORD_ = "cmsc12dabest" # Declare admin password

score = 0 # Initialize score

def viewLeaderboard(): # View leaderboard
	os.system('cls') # Clear screen

	for name, score in leaderboard.items(): # Iterate through the items in the dictionary
		print(name + ": " + score)
	input("Enter any key to continue: ")

def saveDictToFile(target, pay, load): # Function declaration for saving dictionaries to a file. Accepts three parameters, target (file), pay(key), and load (value).
	f = open(target, "a") # Opens the target for appending and assigns it to "f".
	foo = ""
	foo = (foo + str(pay) + ":/:" + str(load) + ";/;") # Parses each key i in the list, keys, and concatenates them with their respective values delimited with ":/:". Each key-value pair is delimited with ";/;".

	f.write(foo) # Writes "foo" to "f".
	f.close() # Closes "f".

def entry(): # Function for password entry and interface for saving new words to the wordlist
	guess = getpass.getpass() # Hidden password input using getpass()
	if guess == PASSWORD_:
		tick = 0
		choice = 0
		while True: # Code block for UI for adding new words to the list
			x = str(input("Enter the word to add: "))
			y = str(input("Enter meaning: "))
			print("[1] All about Family")
			print("[2] Let's Eat")
			print("[3] Greetings")
			choice = str(input("Enter category: "))
			while tick == 0:
				if choice == "1": 
					z = "allAboutFamily.txt"
					tick = 1
				elif choice == "letsEat.txt":
					z = "2"
					tick = 1
				elif choice == "3":
					z = "greetings.txt"
					tick = 1
				else:
					os.system('cls')
					print("Invalid input! Try again.")
			
			saveDictToFile(z,x,y) # Call saveDictToFile()
			os.system('cls')
			print("Word successfully added!")
			tick = 0
			choice = str(input("Would you like to add another word (Y/N): ")).lower()
			while tick == 0:
				if choice == "y": 
					tick += 1
				elif choice == "n":
					return
				else:
					os.system('cls')
					print("Invalid input! Try again.")
	else:
		os.system('cls')
		print("Wrong password!")
		return

def loadDictFromFile(target): # Function for loading dictionary from file. Accepts a single parameter, "target" (filename)
	try:
		f = open(target, "r") # Opens "target" for reading and assigns it to "f". If not present, the thrown FileNotFoundError is catched.
		f_str = f.read() # Reads "f" and assigns it to f_str.
		foo = {}
		y = ""

		# Code block for splitting the wordlist using delimiters ";/;" and ":/:"
		x = f_str.split(";/;")
		for i in range(len(x)):
			if x[i] == "": # Breaks if "x[i]"" is "".
				break
			y = x[i] # Assigns x[i] to y.
			z = y.split(":/:")  
			foo[z[0]] = z[1]

		return foo

	except FileNotFoundError as e: # Catches FileNotFoundError and returns an empty list.
		return {}

def categorizeByDifficulty(a,b,c): # Function for categorizing the three categories by their difficulty. For difficulty, I chose longer words and phrases as "harder".

	# Initialize empty dictionaries for easy, medium, and hard.
	easy = {}
	medium = {}
	hard ={}

	for x_item,x_value in a.items(): # Checks for the length of keys in the dictionaries and asigns them to the new dictionaries accordingly
		if len(x_item) <= 7:
			easy[x_item] = x_value
		elif len(x_item) <= 9:
			medium[x_item] = x_value
		else:
			hard[x_item] = x_value
    
	for y_item,y_value in b.items():
		if len(y_item) <= 7:
			easy[y_item] = y_value
		elif len(y_item) <= 9:
			medium[y_item] = y_value
		else:
			hard[y_item] = y_value
    
	for z_item,z_value in c.items():
		if len(z_item) <= 7:
			easy[z_item] = z_value
		elif len(z_item) <= 9:
			medium[z_item] = z_value
		else:
			hard[z_item] = z_value
    
	return easy, medium, hard # Returns three dictionaries as a tuple

def randomCorrect(a): # Function for random generation of correct key:value pair. Accepts 1 parameter for counter.
	global easyPairs, mediumPairs, hardPairs # Global variables

	# Chooses a random key:value pair and stores it to x, y. Deletes the taken pair using the key x from the global dictionary where it came from so the pair won't reappear in the next items.
	if a < 5: 
		x, y = random.choice(list(easyPairs.items()))
		del easyPairs[x]
	elif a < 10:
		x, y = random.choice(list(mediumPairs.items()))
		del mediumPairs[x]
	else:
		x, y = random.choice(list(hardPairs.items()))
		del hardPairs[x]

	return str(x), str(y) # Return a tuple of 2 strings

def randomWrong(a): # Function for generating wrong choices. Accepts 1 parameter for the key of the correct answer for the current number.
	global masterDict # Global variable

	i = True # Random generation of x->y->z happens until i == False
	while i == True:
		x = random.choice(list(masterDict.keys()))
		if x != a: # Only when x is not equal to the key of the correct answer it would let the next condition evaluate.
			y = random.choice(list(masterDict.keys()))
			if y != a and y != x:
				z = random.choice(list(masterDict.keys()))
				if z != a and z != y and z !=x:
					i = False

	return masterDict[x], masterDict[y], masterDict[z] # Return values of masterDict as a tuple and using x, y, and z as keys.

def generateChoices(a,b): # Function for choice generation. Accepts 2 parameters a and b which is the key:value pair of the correct answer.

	i,j,k = randomWrong(a) # Call randomWrong() and unpack the tuple into i,j, and k
	x = [b,i,j,k] # Assign an arbitrary order of the four choices as list x
	random.shuffle(x) # Shuffle the list
	# Print the shuffled list
	print("A. " + x[0])
	print("B. " + x[1])
	print("C. " + x[2])
	print("D. " + x[3])

	# Keep track of the correct answer using list.index(correctValue) and store it to y
	y = x.index(b)

	# Since indices return integers, we can easily "translate" the position of the correct value
	if y == 0:
		y = "a"
	elif y == 1:
		y = "b"
	elif y == 2:
		y = "c"
	else:
		y = "d"

	return str(y) # Return y

def gameStart(): # Function when the game actually starts
	os.system('cls')

	global score, leaderboard # Global variables

	counter = 0 # Question counter

	i = 0
	while i == 0:
		while counter < 5: # Easy questions for the first 5 questions
			word, meaning = randomCorrect(counter)
			print("Easy Round")
			print('What is the meaning of "' + str(word) +'"?')
			correctAnswer = generateChoices(word, meaning).lower() # Calls generateChoices to generate the choices to the terminal
			guess = str(input("Choice: ")).lower()
			
			# Code block for correct and wrong answer handling
			if guess == correctAnswer:
				score += 2 
				print("Correct!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1
			else:
				print("Wrong!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1

		os.system('cls')

		while counter < 10: # Medium questions for the next 5 questions
			word, meaning = randomCorrect(counter)
			print("Medium Round")
			print('What is the meaning of "' + str(word) +'"?')
			correctAnswer = generateChoices(word, meaning).lower()
			guess = str(input("Choice: ")).lower()
			
			if guess == correctAnswer:
				score += 5
				print("Correct!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1
			else:
				print("Wrong!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1

		os.system('cls')

		while counter < 15: # Hard questions for the last 5 questions
			word, meaning = randomCorrect(counter)
			print("Hard Round")
			print('What is the meaning of "' + str(word) +'"?')
			correctAnswer = generateChoices(word, meaning).lower()
			guess = str(input("Choice: ")).lower()
			
			if guess == correctAnswer:
				score += 10
				print("Correct!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1
			else:
				print("Wrong!")
				input("Enter any key to continue: ")
				os.system('cls')
				counter += 1
		i += 1 # Make looping condition false

	name = input("Enter your name: ") # Take name of player
	saveDictToFile("leaderboard.txt", name, score) # Save player name and score immediately to a file
	leaderboard = loadDictFromFile("leaderboard.txt") # Load new leaderboard to memory

	# Print score and congratulatory message
	print("Congratulations, " + str(name) + "! Your final score is: " + str(score))
	input("Enter any key to continue: ")
	os.system('cls')

def newGame(): # Function for new game
	os.system('cls')
	while True: # Loops the program until user chooses 0
		print("Welcome to DUOLINGO!")
		print("Choose a category to start learning!")
		print("[1] All about Family")
		print("[2] Let's Eat")
		print("[3] Greetings")
		print("[4] All Words")
		print("[done] Start the Game!")
		print("[0] Return to main menu")
		choice = str(input("Choice: ")).lower()

		# Display words included in the three categories and the masterDict
		if choice == "1": 
			choice = None
			os.system('cls')
			for i, j in allAboutFamily.items():
				print(str(i) + ": " +str(j))
			choice = str(input("Enter any key to return to word menu: "))
			if not choice == None:
				os.system('cls')
				continue
		elif choice == "2":
			choice = None
			os.system('cls')
			for i, j in letsEat.items():
				print(str(i) + ": " +str(j))
			choice = str(input("Enter any key to return to word menu: "))
			if not choice == None:
				os.system('cls')
				continue
		elif choice == "3":
			choice = None
			os.system('cls')
			for i, j in greetings.items():
				print(str(i) + ": " +str(j))
			choice = str(input("Enter any key to return to word menu: "))
			if not choice == None:
				os.system('cls')
				continue
		elif choice == "4":
			choice = None
			os.system('cls')
			for i, j in easyPairs.items():
				print(str(i) + ": " +str(j))
			for i, j in mediumPairs.items():
				print(str(i) + ": " +str(j))
			for i, j in hardPairs.items():
				print(str(i) + ": " +str(j))
			choice = str(input("Enter any key to return to word menu: "))
			if not choice == None:
				os.system('cls')
				continue
		elif choice == "done":
			gameStart()
		elif choice == "0":
			os.system('cls')
			return # Exits the function
		else: # Prints an error message.
			os.system('cls')
			print("Invalid input, try again!\n")

# Load wordlists and other dictionaries
allAboutFamily = loadDictFromFile("allAboutFamily.txt")
letsEat = loadDictFromFile("letsEat.txt")
greetings = loadDictFromFile("greetings.txt")
leaderboard = loadDictFromFile("leaderboard.txt")
masterDict = {}
masterDict.update(allAboutFamily)
masterDict.update(letsEat)
masterDict.update(greetings)

# Call categorizeByDifficulty() and unpack the tuple of dictionaries to easyPairs, mediumPairs, and hardPairs
easyPairs, mediumPairs, hardPairs = categorizeByDifficulty(allAboutFamily, letsEat, greetings)

while True: # Loops the program until user chooses 0
	# Prints the menu and asks the user for their chosen action.
	print("DUOLINGO MENU")
	print("[1] New Game")
	print("[2] View High Scores")
	print("[3] How to Play?")
	print("[4] Add Words")
	print("[0] Exit")
	choice = input("Choice: ")

	if choice == "1": 
		newGame() # Calls newGame()
	elif choice == "2":
		viewLeaderboard() # Calls leaderboard()
	elif choice == "3": # Shows a little instruction manual
		os.system('cls')
		print("#####################################################")
		print("##                   DUOLINGO!                     ##")
		print("##   At the start of the game, the program would   ##")
		print("##   display a list of bisaya(surigaonon) words/   ##")
		print("##  phrases and their equivalent English meaning.  ##")
		print("##                                                 ##")
		print("##  The player must choose the correct meaning of  ##")
		print("##  the displayed word with increasing complexity. ##")
		print("##                                                 ##")
		print("## There are three rounds; easy, medium, and hard  ##")
		print("##  where all items are multiple-choice questions  ##")
		print("##                                                 ##")
		print("##    2 points will be awarded for every correct   ##")
		print("##    answer in the easy round, 5 points will be   ##")
		print("## awarded for every correct answer in the medium  ##")
		print("## round, and 10 points will be awarded for every  ##")
		print("##        correct answer in the hard round.        ##")
		print("##                                                 ##")
		print("##                  Best of luck!                  ##")
		print("#####################################################")
		print("")
		input("Enter any key to go back: ")

	elif choice == "4": 
		entry() # Calls entry() v
	elif choice == "0":
		break # Exits the program
	else: # Prints an error message.
		os.system('cls')
		print("Invalid input, try again!")
			
	print("") # Newline