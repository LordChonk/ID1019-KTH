defmodule Train do

    def test1() do
      front = [:a]
      rest = [:b, :c, :d, :e]
      split([front | rest], :d)
    end

    def test2() do
      front = [:a, :b, :c]
      rest = [:d]
      main([:a, :b, :c, :d], 3)
    end

    def take(_, 0) do [] end
    def take([front|rest], wgns) when wgns > 0 do [front|take(rest, wgns-1)] end

    def drop(front, 0) do front end
    def drop([_front|rest], wgns) when wgns > 0 do drop(rest, wgns-1) end

    def append([], train2) do train2 end
    def append([front|rest], train2) do [front|append(rest, train2)] end

    def member([], _wgns) do false end
    def member([wgn|_], wgn) do true end
    def member([_front|rest], wgn) do member(rest, wgn) end

    def position([iWgn|_rest], iWgn) do 1 end
    def position([_front|rest], iWgn) do position(rest, iWgn) + 1 end

    def split([iWgn|rest], iWgn) do {[], rest} end
    def split([front|rest], iWgn) do
      {rest, drop} = split(rest, iWgn)
      {[front|rest], drop}
    end

    def main([], wgns) do {wgns, [], []} end
    def main([front|rest], wgns) do
        case main(rest, wgns) do
          {0, drop, take} -> {0, [front|drop], take}
          {wgns, drop, take} -> {wgns-1, drop, [front|take]}
        end
    end
end
