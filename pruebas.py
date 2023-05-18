import random

names = ["rix", "chuy", "esmeralda"]

print("Welcome to the roulette! Names in the game are:", names)

input("Press Enter to spin the roulette...")

# create a dictionary to map the names to their positions on the roulette
positions = {names[i]: i*360//len(names) for i in range(len(names))}

# generate a random angle to spin the roulette
angle = random.randint(0, 359)

# print the roulette
print()
print(" " + "-"*22)
for i in range(len(names)):
    print("|", " "*7, names[i], " "*7, "|")
print(" " + "-"*22)
print()

# determine the winner based on the angle and positions on the roulette
winner = None
for name, position in positions.items():
    if angle >= position and angle < position+360//len(names):
        winner = name
        break

print("And the winner is... ", winner, "!")
