defmodule Morse do

     #@tyespec node() :: {:node, char(), node(), node()} | :nil

    def msg1() do
      str = '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ...'
      decode(str)
    end
    def msg2() do
      str = '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----'
    decode(str)
    end

    def encName() do
      str = 'adrian'
      encode(str)
    end

    def decName() do
      str = '.- -.. .-. .. .- -.'
      decode(str)
    end


    def test1() do
    str = 'one jack daniels please'
    encode(str)
  end

      ### setup....
      def encode(str) do
        encode(str, encode_table(), [])
      end

      def encode_table() do
        Enum.reduce((codes(morse(), [])), %{}, fn({char, code}, acc) ->  #tree to map
          Map.put(acc, char, code)
        end)
     end
     def lookup(char, map) do Map.get(map, char) end

     def codes(:nil, _) do [] end
     def codes({:node, :na, da, di}, code) do
       codes(da, [?- | code]) ++ codes(di, [?. | code])
     end
     def codes({:node, char, da, di}, code) do
       [{char, code}] ++ codes(da, [?- | code]) ++ codes(di, [?. | code])
     end
      ### .....setup

      ### actual stuff......
      ### encoding(
      def encode([], _table) do [] end
      def encode([char | rest], table) do
        lookup(char, table) ++ [32] ++ encode(rest,table)
      end
      def encode([], _, code) do Enum.reverse(code) end
      def encode([char | rest], table, curr) do
        encode(rest, table, lookup(char, table) ++ [32] ++ curr)
      end
      ### )

      ### decoding(
      def decode(str), do: decode(str, morse())

      def decode(morse, table) do
       case morse do
        [] -> []
        _ ->        #anything that isn't an empty list
          {char, rest} = decode_char(morse, table)
          [char | decode(rest, table)]
       end
      end


      def decode_char([], {:node, char, _, _}), do: {char, []}
      def decode_char([?- | morse], {:node, _na, da, _di}) do
        decode_char(morse, da)
      end
      def decode_char([?. | morse], {:node, _na, _da, di}) do
        decode_char(morse, di)
      end
      def decode_char([?\s | morse], {:node, :na, _da, _di}) do
        {?*, morse}
      end
      def decode_char([?\s | morse], {:node, char, _da, _di}) do
        {char, morse}
      end
      def decode_table() do
        morse()
      end
      ### )
      ### ... actual stuff

      def morse() do
        {:node, :na,
        {:node, 116,
        {:node, 109,
        {:node, 111,
        {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103,
        {:node, 113, nil, nil},
        {:node, 122,
        {:node, :na, {:node, 44, nil, nil}, nil},
        {:node, 55, nil, nil}}}},
        {:node, 110,
        {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
        {:node, 100,
        {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
        {:node, 101,
        {:node, 97,
        {:node, 119,
        {:node, 106,
        {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
        nil},
        {:node, 112,
        {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
        nil}},
        {:node, 114,
        {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
        {:node, 105,
        {:node, 117,
        {:node, 32,
        {:node, 50, nil, nil},
        {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
        {:node, 115,
        {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
        end
end
