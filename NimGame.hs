import Data.Bits (xor)
import Data.List (elemIndices)
-- Task 8: Documentation

-- C1) Use of AI in coding overall: moderate

-- C2) Explain how you have used AI (if at all):
-- Used for giving test cases in order to check that the program works.
-- Used to help with the logic of calculating the winning move from a winning position.

-- Question 1: for the detailed comments refer to 1-Q1.hs file.

-- Question 2: Implementation of Game of Nim
-- Two players take turns removing any number of coins from a single pile. 
-- The player who takes the last coin wins.
--------------------------------------------------------------------------------------
-- How we solved the problem:
--------------------------------------------------------------------------------------
-- In the 1st task we defined a function so it checks 2 cases:
-- 1) if the list is empty - false; 
-- 2) if there is other - true; 
--------------------------------------------------------------------------------------
-- In the 2nd task we defined a function that takes the current piles and removes 
-- a specified number of coins from a specific pile. If error occurs - return an empty list.
--------------------------------------------------------------------------------------
-- In the 3rd task we defined a function that asks the user their next move.
-- It will return a pair of inputs.
--------------------------------------------------------------------------------------
-- In the 4th task we defined a function that takes the current piles and prints them out 
-- as lists of *. Furthemore, it uses two help functions: displayGameHelp and printRow.
--------------------------------------------------------------------------------------
-- In the 5th task we had to define multiple functions in order to operate everything
-- correctly:

-- 1) nim is a function that asks the users for their names and for an initial configuration
-- of piles.

-- 2) If the player doesn't enter anything for the number of piles, then the helper function
-- askNumberOf will be called and the default number of piles will be set to 3.

-- 3) Function askAllPiles asks the user to enter the number of coins for each of pile, the 
-- the total number of which has been previously defined either by user or by default.

-- 4) If the player doesn't type anything for the number of coins in a pile, then a default number
-- of coins will be set for the pile being in a respective location. F.ex. user doesn't set 
-- a number for the 1st pile, but sets for other piles, then a default number of coins 
-- for the non-defined pile will be set to 5 (alluding to the spec where it is said that the
-- default number of piles and coins would be [5, 4, 3]).

-- 5) nimaux is the game loop that is called by nim. Each call plays exactly one turn, then either ends the game or 
-- calls itself for the other player’s turn. 
-- The nim function asks for the player's name. It is case sensitive. If the current player is "AI", 
-- it calls findMove to choose a move, prints what the AI chose, and produces the return (p, c).
-- Otherwise it calls getMoveWithCheck piles.
-- If won newPiles is true, the current player wins. The function prints a victory message and stops.
-- Otherwise the game continues with a recursive call that swaps the players (b, a), and passes the updated piles.
--------------------------------------------------------------------------------------
-- In the 6th task we defined a function that uses a preexisting getMove function to get user input
-- and checks whether the move is valid. It does not check if the number of coins to pick 
-- is greater than the actual number of coins in a pile, because the takeAway method assumes 
-- that the user just wants to take all the coins form the pile.
--------------------------------------------------------------------------------------
-- In the 7th task we defined a function that takes the current piles and checks whether 
-- the current player has a winning strategy.
-- It uses a support function "recXor" that basically applies xor to every number in the list
-- and returns a result.
-- Also "Data.Bits (xor)" had to be imported for that to work.

-- We decided to develop AI to play with us, so we defined a function findMove that picks a move 
-- for the AI when it is its turn. findMove takes the list of heap sizes and 
-- returns (heapNumber, amountToRemove), with the heap number 1-based (that's why there is + 1). 
-- It also relies on two helper functions: recXor and isWinning. 
-- In addition, "Data.List (elemIndices)" had to be imported for that to work.

-- 1. Function that looks at the current list of piles and checks whether the game is won.
won :: [Int] -> Bool
won [] = True
won xs = False

--2. Function that takes the current piles and removes specified number of coins from a specified pile
-- If error occurs returns an empty list
takeAway :: [Int] -> Int -> Int -> [Int]
takeAway [] _ _ = []
takeAway (x:xs) y z = if length (x:xs) < y then [] 
                        else if y > 1 then x : takeAway xs (y-1) z
                            else if z < x then (x-z):xs
                                else xs

-- 3. Function that asks the user their next move
-- A pair of the two inputs will be returned.
getMove :: [Int] -> IO(Int, Int)
getMove xs = do {putStrLn ("Current piles:");
                displayGame xs;
				if isWinning xs then putStrLn ("Psss, you have a winning strategy")
				  else putStrLn ("You are doing great, no need to worry!");
                putStr "Pick a pile: ";
                x <- readLn;
                putStr "Pick a number of coins to remove: ";
                y <- readLn;
                return (x, y)}


--4.Function that takes the current piles and print them out as lists of *. 
-- Uses 2 help functions "displayGameHelp" and "printRow"
displayGame :: [Int] -> IO()
displayGame xs = displayGameHelp 1 xs

displayGameHelp :: Int -> [Int] -> IO()
displayGameHelp _ [] = putStr ""
displayGameHelp y (x:xs) = do {putStr (show y ++ ": ");
                        printRow x; putStrLn "";
                        displayGameHelp (y+1) xs}

printRow :: Int -> IO()
printRow 1 = putChar '*'
printRow x = do{putChar '*'; printRow (x - 1)}


-- 5. a function nim that asks the users for their names and for an initial configuration
-- of piles. Storing the names and numbers of coins in piles by calling nimaux function.
nim :: IO ()
nim = do putStr "Player 1 name: "
         name1 <- getLine
         putStr "Player 2 name: "
         name2 <- getLine

         putStrLn "Enter a number of piles: "
         pileNum <- askNumberOf 3
         putStrLn "Enter number of coins in the piles: "
         piles <- askAllPiles [] pileNum [5, 4, 3]
         nimaux ((name1, name2), piles)

askAllPiles :: [Int] -> Int -> [Int] -> IO [Int]
askAllPiles xs y [] = askAllPiles xs y [5, 4, 3]
askAllPiles xs y (d:ds) = do putStrLn ("Enter number of coins in pile " ++ show (length xs + 1))
                             pile <- askNumberOf d
                             if length xs < y - 1 then do
                                              rest <- askAllPiles (xs ++ [pile]) y ds
                                              return rest
                                        else return (xs ++ [pile])

-- Helper function to check whether user typed anything for number of piles.
-- If nothing typed, then the default 3 will be entered in nim.
askNumberOf :: Int -> IO (Int)
askNumberOf defaultNumber = do 
                        line <- getLine;
                        return (if null line
                                         then defaultNumber
                                         else read line)

-- Function that pairs each pile with its position number,
-- and runs if-then-else for each pair (pilePosition, currentNumberOfCoins).
playerDoesAMove :: [Int] -> IO [Int]
playerDoesAMove piles = do (pilePicked, numberOfCoinsToRemove) <- getMoveWithCheck piles
                           return [if pilePosition == pilePicked
                                   then currentNumberOfCoins - numberOfCoinsToRemove
                                   else currentNumberOfCoins
                                   | (pilePosition, currentNumberOfCoins) <- zip [1..] piles]

-- Function nimaux that plays the game.
nimaux :: ((String, String), [Int]) -> IO ()
nimaux ((a, b), piles) = do putStrLn (a ++ " turn.")
                            (pile, coins) <- if a == "AI" then do
                                                let (p, c) = findMove piles
                                                putStrLn ("AI takes " ++ show c ++ " from pile " ++ show p)
                                                return (p, c)
                                              else getMoveWithCheck piles
                            -- takeAway is an ordinary function, not an IO action, hence "let" is used 
                            -- instead of <- for assigning a value.
                            -- Passing 3 arguments: piles (current [] of piles), 
                            -- chosen pile from getMove, and coins to remove also from getMove.
                            let newPiles = takeAway piles pile coins 
                            if won newPiles then do 
                                putStrLn (a ++ " wins ;D\nGGs " ++ b ++ "!")
                                else nimaux ((b, a), newPiles)


--6. Function that uses a prexisting getMove function to get user input and checks whether the move is valid. 
--It does not check if the number of coins to pick is greater than the actual number of coins in a pile because the takeAway method assumes that the user just wants to take all the coins form the pile
getMoveWithCheck :: [Int] -> IO(Int, Int)
getMoveWithCheck xs = do {(x, y) <- getMove xs;
                        if x > length xs then do {putStrLn "Error, invalid pile number"; getMoveWithCheck xs}
                        else if y < 1 then do {putStrLn "Error, you cannot remove less than 1 coin"; getMoveWithCheck xs}
                        else return (x,y)}
						
--7. Function that takes the current piles and checks whether the current player has a winning strategy. 
--It uses a support function "recXor" that basically applies xor to every number in the list and returns a result 
--Also "Data.Bits (xor)" had to be imported for that to work
isWinning :: [Int] -> Bool
isWinning xs = recXor xs /= 0

recXor :: [Int] -> Int
recXor [] = 0
recXor (x:xs) = x `xor` (recXor xs)

findMove :: [Int] -> (Int, Int)
findMove xs =
    if isWinning xs then
        let x = head [y | y <- xs, (y `xor` recXor xs) < y]
            toRemove = x - (x `xor` recXor xs)
        in (head (elemIndices x xs) + 1, toRemove)
    else (1, 1)