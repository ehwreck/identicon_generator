defmodule IdenticonGenerator do
  @moduledoc """
  Rules for generating an identicon.
  300x300px image composed by 25 50x50px squares.
  The left side of the identicon is always mirrored to the right side.
  """

  def main(input) do
    input
    |> create_hash
  end

  @doc """
  Returns a hash generated from the `input` given.

  ## Examples

      iex> IdenticonGenerator.create_hash("John")
      [97, 64, 154, 161, 253, 71, 212, 165, 51, 45, 226, 60, 191, 89, 163, 111]

  """
  def create_hash(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
