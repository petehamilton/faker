defmodule CodeTest do
  use ExUnit.Case, async: true

  defp grapheme_to_digit("X"), do: 10
  defp grapheme_to_digit(str), do: String.to_integer(str)

  defp checksum(isbn, calc_function) do
    String.reverse(isbn)
    |> String.graphemes
    |> Stream.with_index
    |> Stream.map(calc_function)
    |> Enum.sum
  end

  defp calc_function10 do
    fn({e, i}) -> grapheme_to_digit(e) * (i + 1) end
  end

  defp calc_function13 do
    fn({e, i}) ->
      if rem(i,2) == 1 do
        grapheme_to_digit(e) * 3
      else
        grapheme_to_digit(e)
      end
    end
  end

  test "isbn/0" do
    assert is_binary(Faker.Code.isbn)
    assert String.length(Faker.Code.isbn) == 10
    checksum10 = checksum(Faker.Code.isbn10, calc_function10)
    assert rem(checksum10, 11) == 0
  end

  test "isbn10/0" do
    assert is_binary(Faker.Code.isbn10)
    assert String.length(Faker.Code.isbn10) == 10
    checksum10 = checksum(Faker.Code.isbn10, calc_function10)
    assert rem(checksum10, 11) == 0
  end

  test "isbn13/0" do
    assert is_binary(Faker.Code.isbn13)
    assert String.length(Faker.Code.isbn13) == 13
    checksum13 = checksum Faker.Code.isbn13, calc_function13
    assert rem(checksum13, 10) == 0
  end

  test "issn/0" do
    assert is_binary(Faker.Code.issn)
    assert String.length(Faker.Code.issn) == 8
    assert Regex.match?(~r/^\d{7}[\dX]$/, Faker.Code.issn)
  end
end
