# A Time Wasters Compendium
I've never been one for games on computers. The sad fact is I have arthritis in my thumbs so the moders shoot-em-up games hold little interest for me. That said, there are alternatives that require some level os skill without super-human dexterity.

The purpose of this app is to get some practice in creating simple to play games. The kind of thing we used to play before computers became graphic processing work-horses.

At present, this Mac app contains four games;

* Minesweeper
* WordCraft
* Snake
* Pyramid of Doom

Minesweeper and WordCraft were created by [Paul Hudson in his Hacking with Swift+ live streams]( https://www.hackingwithswift.com/plus ). I have 'messed' with them to extend the games. Snake is mine. Pyramid of Doom is a Stott Adams game from way back when the TRS-80 was still cool. 

More will be added at some point. This is just a starter project.

The opening screen animates a button for each game we have created:

![timeWaasters](./Images/timeWaasters.gif)

If you click on one of the buttons, the game will open.

## Minesweeper

Minesweeper is the classic game from the early days of computing. You are presented with a grid of buttons that hide a number of mines. Your job is to click on a square to clear it without clicking on any of the mines. The game ends when you have identified all of the mines and have cleared all of the non-mine cells.

![timeWaasters](./Images/minesweeper.png)

## WordCraft

Wordcraft is, on the face of it, a simple game. It can, however, be frustratingly difficult. You are given a grid of letters from which you select letters to create words. The twist is that you have to comply with a rule for each word. That may be something as simple as the word has to start with a specific letter or the word has to have an even or odd number of letters.

You also cannot use the same word twice!

![timeWaasters](./Images/wordCraft.png)

## Snake

This is a very old, low res, style of game where you have to move the snake around the board. Your objective is to grow the snake by eating food. Starts out easy, but becomes increasingly complicated as the snake grows. You must remain within the game board and you cannot cross the snake body. If you run into the snake body, you lose the game.

![timeWaasters](./Images/snakeGame.png)

## Pyramid of Doom

Decades ago, when I was coding in Z80 assembler on the TRS-80, Scott Adams created some text adventure games. None of your fancy graphics here - you type commands, they get interpreted and the console updates with the results. The original code was written in C and has been stable for a very long time. As far as I know, nothing has happened to it in all that time. 

This is my variant, written in Swift/SwiftUI. It took a long time to translate the original C code to Swift and a lot of debugging to makwe sure I was loading the original game files correctly. The result is Pyramid of Doom:

![timeWaasters](./Images/pyramidOfDoom.png)

This is currently a work in progress. It has some minor glitches (such as the game continues when you die!) and it needs some UI changes. However, it is very playable and quite difficult to master at first.

## Overviews

When you hover over the buttons on the home screen, the clock face will change to an information icon. If you click the information icon, you get an overview of the game.

![timeWaasters](./Images/gameInstructions.png)

While playing a game, you can get game play instructions by clicking the question mark icon.

![timeWaasters](./Images/minesweeperGameplay.png)

Typos to be fixed in review!

