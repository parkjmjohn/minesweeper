Midterm Project
Progress Report


Group Members
John Park (jjp282)
Xiuyu Li (xl289)
Conan Gillis (cg527)
Willis Guo (wg238)
 
Summary of Progress
We built the basic structure of our Minesweeper game in our Beta version. Our game was implemented by building a frontend and a backend. In the frontend, we created a type square to represent a single square on the board and a type t to be the game board of squares. We also created the functionality of printing the board (a user-friendly interface), revealing all bombs after the game is lost, revealing area around a 0-valued square after it is clicked, clicking to reveal a square on the board, and labeling flags on the board. In the backend, we created the ability of building the game by randomly placing the bombs on the board based on the number of rows and columns on the board. We also created a main where the game engine begins by taking in commands from the user. We created a command module to interpret the user’s input whether it be starting the game, quitting the game, clicking a square on the board, flagging a square on the board, or inputting invalid commands (in which we would raise and catch an exception). 

Vision
Building off of our Beta version, we planned to allow the players to create custom boards of any size and with any number of bombs. In response to users creating any sized board, we planned to allow the terminal to resize accordingly to the size of the board. Previously, our random function that placed the bombs onto the map produced the same random seed creating the same board. We have planned to fix that random function in order for the game to generate unique boards every time. To give the players more of a fair chance at winning the game, we planned to generate the bomb placement onto the board to occur after the player’s first move so that they can never lose on the first move (unless the number of bombs is equal to the number of squares on the board). We also planned to add the functionality of players to unflag squares if necessary. In addition, we planned to better the user interface of the game to make it user friendly by adding onto the frontend so that the board is well printed and that the coordinates are easily readable. These were all of our conditions for Satisfactory target. For our Good goal, we planned to make the game winnable by creating a winning state in our program. We planned to keep track of two stats: the time since a game first started and the number of flags placed (which helped the users keep track of the bombs left, although it might be incorrect since the user might place a flag on a wrong square). Making the game winnable and keeping track of the time, we then thought we should create a leaderboard. So we planned to create a leaderboard that outputs the top five scores with the usernames by using file manipulation and a sorting algorithm (the usernames were added after the demo). For our Excellent scope, we planned to create two advanced implementation. We planned to implement a help command for the users that will reveal a random non-bomb square on the board. The command will prioritize revealing the lowest valued square as possible [value as in the number of bombs that surrounds that square]. Our second features will be building an artificial intelligence feature that will have the game play by itself with logical moves. The help function would have access to the backend since it aimed to assist the user, so it should never be wrong. The AI could only access the frontend, which means it could only get the same amount of information as the human player.

Activity Breakdown
John Park
Implemented the leaderboard module
Used file manipulation to read and write scores
Created a bubble sort to help return the top five scores
Updated the main module to respond appropriately to new commands such as leaderboard and help
Implemented a terminal resizing algorithm

Xiuyu Li
Implemented the winnable and losable features for the game; added the restart feature and other transitions of different states of the game in the main, making the game more playable
Implemented the arbitrary size and bombs number, timer, bombs left counter features in the main and modified the print function to make the game interface look better 
Integrated the never lose in the first step feature to the main
Changed the step of the creation of the backend to generate a backend based on the first click of the user to implement this feature
Helped with the implementation of the AI
Helped debug the algorithm and added the winning and losing conditions
Integrated the AI to the main and added sleep in the execution to display the process of AI solving the minesweeper
Implemented the username feature for the leaderboard
Created a dictionary to match the sorted scores to the usernames and output those names with scores to the leaderboard


Conan Gillis
Implemented help function
Used backend to generate list of all squares of a certain number and used frontend to choose a random unrevealed square from the list and reveal it.
Implemented function to generate list of all squares in a backend with a certain value number or a bomb.
Implemented checker function to see if only bombs were unrevealed (i.e. if the game was won)


Willis Guo
Implemented the feature such that the first click will never have bombs surrounding it, unless there isn’t enough room for bomb placements.
Implemented the algorithm in the model module
Created a simple AI that could play the game without knowing the bomb placements.
The algorithm can win more than 80% of easy level games and 50% of intermediate level games.
Documented written functions for Backend and AI.


Productivity Analysis
Our group was able to work efficiently with each other. We convened whenever possible to work together but divided parts up when our schedules conflicted for maximum efficiency, giving each group member the parts of the problem they had the best tools and ideas to handle independently. We communicated with each other through Slack when we divided up the work, and would still have group meetings with only two or three members when some had difficulties figuring out a problem on our own. We were a little imperfect with finishing the project on time as we used a slip day to submit the project but we were still able to implement all of our intended functionalities by the start of the demo. 

Coding Standards Grades
Documentation
Meets expectations. In our documentation, every function is documented in the standard conventions of the course. Furthermore, they are documented concisely yet (we believe) readably, providing inteligible and digestible information concerning what they do. Special care has been taken to ensure that row and column inputs and outputs in our functions are clearly documented, to ensure no confusions are made.


Testing
Meets expectations. Due to the interactive and random nature of our program, we found it difficult to write explicit test cases for all of our functions. However, we did test all functions for which such testing was practical. Additionally, every other function was extensively tested interactively by a team member, either in the game user interface. This also allowed us to test functions even as we were developing what they meant (i.e. changing invariants to better fit with the rest of the program, changing the data structures, etc), ensuring the same level of algorithm correctness without having to reformat test cases which, in the context of our program, improved our coding efficiency without sacrificing accuracy.


Comprehensibility
Meets expectations. We have used comprehensible and suggestive variable names almost entirely throughout, and where variable names may lead to confusion due to complications in the code, our comments explain concisely and correctly exactly what each variable is, immediately facilitating understanding of the code. Additionally, while there are instances of lengthy patterns of recursion which were unavoidable in our program, their impact on code readability has been mitigated as much as possible and they (and the rest of the code) are still readable.


Formatting
Meets expectations. Our code is generally in line with formatting conventions for the course. Care has also been taken to keep code under the 80 line limit. Additionally, wherever possible helper functions have been kept inside the main function bodies, to ensure that they are always tightly linked to the functions they help, and to ensure compartmentalization even within modules. Finally, we have split up the program amongst different modules, each storing or processing different data points, to both aid comprehension and ensure specific blocks of code deal with specific things.



Scope Grade
Excellent

We gave ourselves an Excellent grade because we met all expectations. We created a rubric for ourselves that was similar to the rest of the projects in the course. It stands as follows:
Satisfactory: Implement all
Polish Beta version
Fix random function to produce unique boards every game
Add coordinate labels on all sides of the boards
Allow users to un-flag flagged squares
Allow users to create any sized board with any number of bombs
Allow users, if # of squares > # of bombs, to never lose on the first move (preferably giving the user a 0-valued square on the first move to give the user more of an advantage)

Good: Implement all
Make game winnable and loseable
Allow users to replay the game with the same configurations
Create a leaderboard
Keep track of how long the user takes to win the game
Create an equation to calculate a score based on the number of squares in the game, the number of bombs in the game, and the amount of time it took the user to finish the game
Store the username with the score
Use file manipulation to store the scores
Create a sorting algorithm to return the top scores

Excellent: Implement 2 out of 3
Create an AI
Using the logical game rules of Minesweeper, create an AI to play the game and showcase this by uploading every move the AI plays (which includes both flagging and click squares)
(Use the frontend only)
Create a help function
Create a help functionality that will return the lowest valued square revealed to help users finish the game without guessing
(Have access to the backend)
Create a challenging 3D map

We satisfied our guideline for an Excellent grade
