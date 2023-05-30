defmodule EnvT do

  def new() do nil end

#------adds a node with a key and a value--------------
  def add(nil, key, val) do {:node, key, val, nil, nil} end
  def add({:node, key, _, left, right}, key, val) do {:node, key, val, left, right} end
  def add({:node, k, v, left, right}, key, val) when key < k do {:node, k, v, add(left, key, val), right} end
  def add({:node, k, v, left, right}, key, val) do {:node, k, v, left, add(right, key, val)} end
  #^^^^^^^^is this O(log n) or O(n*log n)??


#----------looksup the value of a given key-------
  def lookup(nil, _key) do nil end
  def lookup({:node, key, val, _left, _right}, key) do {key, val} end
  def lookup({:node, k, _, left, _right}, key) when key < k do lookup(left, key) end
  def lookup({:node, _, _, _left, right}, key) do lookup(right, key) end

  #----------removes a key/value pair---------
  def remove(nil, _key) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do
    {key, val, rest} = leftmost(right)
    {:node, key, val, left, rest}
  end

  def remove({:node, k, v, left, right}, key) when key < k do {:node, k, v, remove(left, key), right} end
  def remove({:node, k, v, left, right}, key) do {:node, k, v, left, remove(right, key)} end

  #---------sets a node to go left then recurses back---------?
  def leftmost({:node, key, val, nil, rest}) do {key, val, rest} end
  def leftmost({:node, k, v, left, right}) do
    {key, val, rest} = leftmost(left)
    {key, val, {:node, k, v, rest, right}}
  end

end
