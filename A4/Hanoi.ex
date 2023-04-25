defmodule Hanoi do

  def test0 do
    hanoi(0, :from, :inter, :to)
  end
  def test1 do
    hanoi(1, :from, :inter, :to)
  end
  def test2 do
    hanoi(2, :from, :inter, :to)
  end
  def test3 do
    hanoi(3, :from, :inter, :to)
  end
  def test4 do
    hanoi(4, :from, :inter, :to)
  end
  def test10 do
    hanoi(10, :from, :inter, :to)
  end

def hanoi(0, _, _, _) do [] end

def hanoi(n, from, inter, to) do
  hanoi(n-1, from, to, inter) ++
  [{:move, from, to}] ++
  hanoi(n-1, inter, from, to)

end
end
