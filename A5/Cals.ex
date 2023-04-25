defmodule Cals do

  def cals do
     Stream.chunk_while(File.stream!("cals.txt"),
      0, fn "\n", acc ->
        {:cont, acc, 0} #0 is the initial value of the accumulation
      str, acc ->
        {:cont, String.to_integer(String.trim(str, "\n")) + acc}
      end, fn _acc -> {:cont, []} end
    )
  |> Enum.sort(:desc)
  |> IO.inspect()
  |> Enum.take(3)
  #|> Enum.sum()

  #70116 is correct

end



end
