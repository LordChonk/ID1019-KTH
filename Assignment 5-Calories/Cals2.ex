defmodule Cals2 do

  def cals do
    File.read!("cals.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort(&>=/2)
    |> Enum.take(3)
    |> Enum.sum()

  end
end
