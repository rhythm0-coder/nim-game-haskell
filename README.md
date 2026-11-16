# Nim Game with AI Opponent (Haskell)

A command-line version of the classic strategy game **Nim**, written in Haskell. Play against a friend, play against an AI that uses the optimal nim-sum strategy, or watch two AIs play each other.

## How to play

The piles of coins are shown as rows of stars:

```
Current piles:
1: *****
2: ****
3: ***
```

On your turn, pick a pile and choose how many coins to remove (at least one). The player who takes the **last coin wins**.

## Features

- **Three game modes**: player vs player, player vs AI, and AI vs AI. Name a player `AI` (case-sensitive) to make the computer control them.
- **Optimal AI opponent**: the AI calculates the nim-sum and always takes the winning move when one exists.
- **Strategy hints**: before each move, the game tells human players whether they are in a winning position.
- **Custom setup**: choose the number of piles and coins, or press Enter to use the defaults (3 piles: 5, 4 and 3 coins).
- **Input checking**: rejects invalid pile numbers and moves of fewer than one coin.

## How the AI works

The AI uses the **nim-sum**: the bitwise XOR of all the pile sizes.

- If the nim-sum is **not 0**, the current player can force a win. The AI finds a pile whose size gets smaller when XORed with the nim-sum. It then removes just enough coins to leave the opponent with a nim-sum of 0.
- If the nim-sum is **0**, no winning move exists, so the AI takes one coin and waits for the opponent to make a mistake.

## How to run

1. Install the Haskell toolchain using [GHCup](https://www.haskell.org/ghcup/)
2. Download or clone this repository
3. Open a terminal in the project folder and run:

```
ghci NimGame.hs
```

4. Start the game by typing:

```
nim
```

## Team

Built as a group project for CS-205 Declarative Programming at Swansea University by Anna, Maksym and Rhythm.
