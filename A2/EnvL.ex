defmodule EnvL do

  #adds empty list to which we map stuff
  def new() do [] end

  #add stuff to the map/list
  def add([], key, val) do [{key, val}] end
  def add([{key, _} | map], key, val) do [{key, val} | map] end
  #wtf is ass? ~Plato, probably
  def add([ass | map], key, value) do
    [ass | add(map, key, val)]
  end

  #lookup stuff in the map/list
  def lookup([], _key) do nil end
  def lookup([{key, _} = ass|_], key) do ass end
  def lookup([_|map,], key) do lookup(map, key) end

  #take things away from map/list
  #_key is just "_" but it tells the reader that we mean key
  def remove([], _key) do [] end
  #removes head
  def remove([{key, _} | map], key) do map end
  #kv = key value
  def remove([kv | map], key) do [kv | remove(map, key)] end

end
