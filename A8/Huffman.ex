defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do
    codes(tree, [])
    #Enum.sort()
  end

  def codes({a, b}, curNode) do
    left = codes(a, [0 | curNode])
    right = codes(b, [1| curNode])
    left ++ right
  end
  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end

  def decode_table(tree), do: codes(tree, [])

  def encode([], _table) do [] end
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

  def decode([], _table) do [] end
  def decode(seq, table) do
   {char, rest} = decode_char(seq, 1, table)
   [char | decode(rest, table)]
  end

  def decode_char(seq, i, table) do
    {code, rest} = Enum.split(seq, i)
    case List.keyfind(table, code, 1) do
      {char, _rest} ->
        {char, rest}

        nil ->
          decode_char(seq, i + 1, table)
    end
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq), do: freq
  def freq([char | rest], freq) do
    freq(rest, update(char, freq))
  end

  def update(char, []), do: [{char, 1}]
  def update(char, [{char, n} | freq]) do
    [{char, n + 1} | freq]
  end
  def update(char, [elem | freq]) do
    [elem | update(char, freq)]
  end

  def huffman(freq) do
    sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    huffman_tree(sorted)
  end

  def huffman_tree([{tree, _}]), do: tree

  def huffman_tree([{left, leftF}, {right, rightF} | rest]) do
    huffman_tree(insert({{left, right}, leftF + rightF}, rest))
  end


  def insert({left, leftF}, []), do: [{left, leftF}]
  def insert({left, leftF}, [{right, rightF} | rest]) when leftF < rightF do
    [{left, leftF}, {right, rightF} | rest]
  end
  def insert({left, leftF}, [{right, rightF} | rest]) do
    [{right, rightF} | insert({left, leftF}, rest)]
  end

  def read(file, n) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, n)
    File.close(file)

    len = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, len - byte_size(rest)}
      chars ->
        {chars, len}
    end
  end


  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end


end

 # Tree has chars as leafs, low freq -> long branch, high -> short
  # Leaf represented as single char and a node as {left, right}
  # New node, {{c1, c2}, f1 + f2}
