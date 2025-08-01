defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  #The main function where the war game will be played."
  def deal(shuf) do
    #get player 1's card from shuf deck (cards are split every other card)
    p1 = shuf
    |> Enum.take_every(2)
    |> Enum.reverse()
    |> Enum.map(fn x -> if x == 1, do: 14, else: x end)

    #get player 2's card from shuf deck (cards are split every other card)
    p2 = shuf
    |> Enum.drop_every(2)
    |> Enum.reverse()
    |> Enum.map(fn x -> if x == 1, do: 14, else: x end)

    play(p1, p2) #call play function which plays the war game
  end

  #function to start off game (sets the wPile as an empty list)
  def play(p1, p2) do
    play(p1, p2, [])
  end

  #helper function for when both player 1's and player 2's pile are empty it will return the win pile (for when there's a war throughout the whole game) sorting the pile from greatest to least
  defp play([], [], wPile) do
    Enum.map(Enum.sort(wPile, &(&1 >= &2)), fn x -> if x == 14, do: 1, else: x end)
  end

  #helper function for when player 1 wins checks if there's any remaining cards in wPile and add to player 1's pile
  defp play(p1, [], wPile) do
    cond do
      (length wPile) == 0 ->
        Enum.map(p1, fn x -> if x == 14, do: 1, else: x end)
      (length wPile) != 0 ->
        Enum.map(p1 ++ Enum.sort(wPile, &(&1 >= &2)), fn x -> if x == 14, do: 1, else: x end)
    end
  end

  #helper function for when player 2 wins checks if there's any remaining cards in wPile and add to player 2's pile
  defp play([], p2, wPile) do
    cond do
      (length wPile) == 0 ->
        Enum.map(p2, fn x -> if x == 14, do: 1, else: x end)
      (length wPile) != 0 ->
        Enum.map(p2 ++ Enum.sort(wPile, &(&1 >= &2)), fn x -> if x == 14, do: 1, else: x end)
    end
  end

  #helper function for when player 1's top card is larger than player 2's card add both card's to player 1's pile and sort those 2 cards from largest to smallest
  defp play([h1 | t1], [h2 | t2], wPile) when h1 > h2 do
    play(t1 ++ Enum.sort([h1, h2] ++ wPile, &(&1 >= &2)), t2, [])
  end

  #helper function for when player 2's top card is larger than player 1's card add both card's to player 2's pile and sort those 2 cards from largest to smallest
  defp play([h1 | t1], [h2 | t2], wPile) when h2 > h1 do
    play(t1, t2 ++ Enum.sort([h2, h1] ++ wPile, &(&1 >= &2)), [])
  end

  #helper function for when there's a war meaning player 1's and player 2's card are the same
  defp play([h1 | t1], [h2 | t2], wPile) when (h1 == h2) do
    if (length t1) == 0 || (length t2) == 0 do
      play(t1, t2, wPile ++ [h1, h2])
    else
      play(tl(t1), tl(t2), wPile ++ [h1, h2, hd(t1), hd(t2)])
    end
  end
end