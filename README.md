# TicTacToe

#### Video Demo: https://youtu.be/DyHt08RsObY

#### Description: A simple TicTacToe game implemented in the Godot Game Engine

As part of Harvard's CS50 course, each student must create a Final Project - TicTacToe is mine. It's an implementation of the well-known game "TicTacToe" in the Godot Game Engine v4.1, where the player plays against an "artificial intelligence" (it's really just a bunch of if-statements ^^). When I started the project I thought that implementing the AI will probably be the most difficult task, but actually learning how to use the Godot Game Engine and learning GDScript was a much bigger effort.

### main.gd

This file is kept very simple. It only implements that it is possible to start the game by clicking on the "Play" button (by changing the scene - a peculiarity of Godot) or to quit the game by clicking on "Quit".

### scores.gd

Scores.gd is a script that contains only 2 variables: player_score and computer_score.

A limitation of Godot is that variables reset as soon as a scene is reloaded. To be able to keep variables like the players score when a scene is changed, a workaround was necessary. Scores.gd is loaded as a singleton - this kind of implementation allows that player_score and computer_score can be treated like global variables and can be used by all scenes.

### computer_score.gd and player_score.gd

These two scripts take care of updating the two "labels" that represent the players' score. When the scene is loaded, the value is read from the global variables just mentioned and printed on the playing field.
Furthermore, the updating of the variables can also be achieved manually by sending a signal to these scripts.

### field.gd

This script file contains most of the game logic. It contains both the logic necessary for the player to execute a move (checking if it is the player's turn, if the field is free, etc.) and the logic that allows the AI to execute a move. (check if the field is free and possible winning scenarios).

Furthermore, the logic is included to check if a person has won the game. In this area, unfortunately, there is some redundancy in the code, but I couldn't think of a way to save on repetition here.

### game.gd

field.gd contains the logic to check if a player has won the round. Similarly, game.gd contains the logic to check if a player has won the whole game.

The two global variables player_score and computer_score are checked and if a player has won, this is reported and the game is reset.

### Used external assets:

Avatars - Person Icon Color | https://www.pngfind.com/mpng/hoRhooR_avatars-person-icon-color-hd-png-download/
Pixel art old computer vector icon for 8bit game on white background | https://www.freepik.com/premium-vector/pixel-art-old-computer-vector-icon-8bit-game-white-background_25227507.htm