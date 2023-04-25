defmodule Moves do

  def test1() do
    seq([{:one, 1}, {:two, 2}, {:one, -1}, {:two, -1}], {[:a,:b, :c], [:d], [:e, :g]})
  end

  def single({_, 0}, state) do state end
  def single({:one, dir}, {main, one, two}) when dir > 0 do
    {0, rem, wgns} = Train.main(main, dir)
    {rem, Train.append(wgns, one), two}
  end
  def single({:one, dir}, {main, one, two}) when dir < 0 do
    wgns = Train.take(one, -dir)
    {Train.append(main, wgns), Train.drop(one, -dir), two}
  end
  def single({:two, dir}, {main, one, two}) when dir < 0 do
    wgns = Train.take(two, -dir)
    {Train.append(main, wgns), one, Train.drop(two, -dir)}
  end

def single({:two, dir}, {main, one, two}) when dir > 0 do
  {0, rem, wgns} = Train.main(main, dir)
  {rem, one, Train.append(wgns, two)}
end


  def seq([], state) do [state] end
  def seq([move|rest], state) do
    [state|seq(rest, single(move, state))]
  end

end
