defmodule Shunt do

  def test() do
    start = [:a, :b, :c, :d]
    fin =  [:d, :a, :b, :c]
    find(start, fin)
  end

  def find([], []) do [] end
  def find(xs, [y|ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn+1}, {:two, hn}, {:one, -(tn+1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
  end

  def few([], []) do [] end
  def few([h|hs], [y | ys]) when h == y do
    few(hs, ys)
  end
  def few(hs, [y | ys]) do
    {hs, ts} = Train.split(hs, y)
    [{:one, length(ts) + 1}, {:two, length(hs)}, {:one, -(length(ts) + 1 )}, {:two, -(length(hs))} | few(Train.append(hs, ts), ys)]
  end

  def rules([]) do [] end
  def rules([{_, 0} | rest]) do rules(rest) end
  def rules([{:one, n}, {:one, m} | rest]) do rules([{:one, n+m} | rest]) end
  def rules([{:two, n}, {:two, m} | rest]) do rules([{:two, n+m} | rest]) end
  def rules([front | rest]) do [front | rules(rest)] end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
    ms
    else
    compress(ns)
    end
    end
end
