defmodule IdenticonGenerator do
  @moduledoc """
  Rules for generating an identicon.
  250x250px image composed by 25 50x50px squares.
  The left side of the identicon is always mirrored to the right side.
  """

  def main(input) do
    input
    |> create_seed
    |> pick_color
    |> build_grid
    |> filter_odds
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Saves the `image` with the `filename` given.
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @doc """

  """
  def draw_image(%IdenticonGenerator.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%IdenticonGenerator.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      x = rem(index, 5) * 50
      y = div(index, 5) * 50

      start_point = {x, y}
      end_point = {x+50, y+50}

      {start_point, end_point}
    end
    %IdenticonGenerator.Image{image | pixel_map: pixel_map}
  end

  def filter_odds(%IdenticonGenerator.Image{grid: grid} = image) do
    grid =
      Enum.filter grid, fn({code, _index}) ->
        rem(code, 2) == 0 #if true Enum.filter will keep
      end

    %IdenticonGenerator.Image{image | grid: grid}
  end

  @doc """
  Returns a list of lists representing a grid.
  """
  def build_grid(%IdenticonGenerator.Image{seed: seed} = image) do
    grid =
      seed
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %IdenticonGenerator.Image{image | grid: grid}
  end

  @doc """
  Returns a list. The second index of `row` is appended as the third index. The first index of `row` is appended as the fourth index.
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  @doc """
    Returns a new struct from `image` and `color`.
  """
  def pick_color(%IdenticonGenerator.Image{seed: [r, g, b | _tail]} = image) do
    %IdenticonGenerator.Image{image | color: {r, g, b}}
  end

  @doc """
  Returns a list generated from the `input` given.

  ## Examples

      iex> IdenticonGenerator.create_hash("John")
      [97, 64, 154, 161, 253, 71, 212, 165, 51, 45, 226, 60, 191, 89, 163, 111]

  """
  def create_seed(input) do
    seed =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %IdenticonGenerator.Image{seed: seed}
  end
end
