module War (deal) where

import Data.List

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}

deal :: [Int] -> [Int]
-- gets the shuf (deck of cards which is a list of ints) and splits it into 2 piles (player 1 and player 2)
-- it'll go through player 1's and player 2's pile and turn every 1 into 14 so that it becomes the highest card then it will call the play function where the actual game will be played
deal shuf = let (player1, player2) = split shuf
                p1 = map (\x -> if x == 1 then 14 else x) (reverse player1)
                p2 = map (\x -> if x == 1 then 14 else x) (reverse player2)
            -- will use the 2 piles that was just split in the play function where the actual game will be played
            in play p1 p2 []

-- function for playing the War game
play :: [Int] -> [Int] -> [Int] -> [Int]
play p1 p2 wPile
  -- case for if either player's pile is empty, then the game is over and the winner's pile will be returned
  | (length p1 == 0) && (length p2 == 0) = sortWPile wPile

  -- case for if player 2's pile is empty, then player 1's pile will be added to the win pile and then the win pile will be sorted from greatest to least
  | (length p2 == 0) = if (length wPile == 0)
                       then map (\x -> if x == 14 then 1 else x) p1
                       else map (\x -> if x == 14 then 1 else x) (p1 ++ sortWPile wPile)

  -- case for if player 1's pile is empty, then player 2's pile will be added to the win pile and then the win pile will be sorted from greatest to least
  | (length p1 == 0) = if (length wPile == 0)
                       then map (\x -> if x == 14 then 1 else x) p2
                       else map (\x -> if x == 14 then 1 else x) (p2 ++ sortWPile wPile)
  
  -- case for if player 1's card is greater than player 2's card, then player 1's card will be added to the win pile and then the win pile will be sorted from greatest to least
  | h1 > h2 = play (t1 ++ sortDescending (h1 : h2 : wPile)) t2 []

  -- case for if player 2's card is greater than player 1's card, then player 2's card will be added to the win pile and then the win pile will be sorted from greatest to least
  | h2 > h1 = play t1 (t2 ++ sortDescending (h2 : h1 : wPile)) []

  -- case for if player 1's card is equal to player 2's card (there's a war), then the cards will be added to the win pile and then the win pile will be sorted from greatest to least
  | otherwise = if (length t1 == 0) || (length t2 == 0)
                then play t1 t2 (wPile ++ [h1, h2]) -- when there are multiple wars in a row
                else play (tail t1) (tail t2) (wPile ++ [h1, h2, head t1, head t2]) -- first war occurance 

  where
    h1 = head p1
    h2 = head p2
    t1 = tail p1
    t2 = tail p2

-- helper function for splitting a list into two piles (takes in the deck of cards and returns player 1's and player 2's pile in a tuple)
split :: [a] -> ([a], [a])
split [] = ([], [])
split [x] = ([x], [])
split (x:y:xs) = (x:ys, y:zs)
  where (ys, zs) = split xs

-- helper function for sorting a list in descending order
sortDescending :: Ord a => [a] -> [a]
sortDescending = reverse . sort

-- helper function for sorting the win pile from greatest to least while turning all the 14s back to 1s
sortWPile :: [Int] -> [Int]
sortWPile = map (\x -> if x == 14 then 1 else x) . sortDescending
