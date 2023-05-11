defmodule Eval do

  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

  @type expr() :: {:add, expr(), expr()}
    | {:sub, expr(), expr()}
    | {:mul, expr(), expr()}
    | {:div, expr(), expr()}
    | literal()


    #-----Use map to make an environment. do this during test()----
    def test  do
      env = %{a: 1, b: 2, c: 3, d: 4}
      expr = {:add, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}}, {:q, 6, 3}}

      eval(expr, env)
    end
      def test0 do
        map = %{:x => 1, :y => 2, :z => 3, :w => 4}
        expr = {:mul, {:add, {:mul, {:num, 2}, {:var, :w}}, {:num, 3}}, {:q, 9, 7}}

        eval(expr, map)
      end
      def test1 do
        map = %{:x => 7, :y => 4, :z => 1, :w => 6}
        expr = {:sub, {:add, {:add, {:num, 2}, {:var, :y}}, {:num, 3}}, {:q, 5, 9}}

        eval(expr, map)
      end
      def test2 do
        map = %{:x => 7, :y => 2, :z => 8, :w => 5}
        expr = {:mul, {:add, {:mul, {:num, 2}, {:var, :z}}, {:q, 6, 5}}, {:q, 9, 7}}

        eval(expr, map)
      end
      def test3 do
        map = %{:x => 9, :y => 6, :z => 18, :w => -2}
        expr = {:mul, {:sub, {:mul, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 9, 7}}, {:num, 7}}, {:var, :w}}

        eval(expr, map)
      end

    #---evaluaiton cases---------
    def eval({:num, num}, _) do num end
    def eval({:var, var}, map) do Map.get(map, var) end
    def eval({:add, e1, e2}, map) do add(eval(e1, map), eval(e2, map)) end
    def eval({:sub, e1, e2}, map) do sub(eval(e1, map), eval(e2, map)) end
    def eval({:mul, e1, e2}, map) do mul(eval(e1, map), eval(e2, map)) end
    def eval({:div, e1, e2}, map) do dv(eval(e1, map), eval(e2, map)) end
    def eval({:q, e1, e2}, _) do rdc(e1, e2) end

   #-----add----
    def add({:q, a, b}, {:q, d, c}) do {:q, a*d + b*c, b*d} end
    def add({:q, a, b}, c) do {:q, a + c*b, b} end
    def add(a, {:q, b, c}) do {:q, a*c + b, c} end
    def add(a, b) do a + b end

   #-----sub----
    def sub({:q, a, b}, {:q, c, d}) do {:q, a*d - c*b, b*d} end
    def sub({:q, a, b}, c) do {:q, a - c*b, b} end
    def sub(a, {:q, b, c}) do {:q, a*c - b, c} end
    def sub(a, b) do a - b end

   #-----mul----
    def mul({:q, a, b}, {:q, c, d}) do {:q, a*c, b*d} end
    def mul(a, {:q, b, c}) do {:q, a*b, c} end
    def mul({:q, a, b}, c) do
      r = rem(a,b)
      case r do
        0 -> if a < 0 || b < 0 do -trunc(a/b)*c
          else
               trunc(a/b)*c end
        _ -> {:q, a*c, b}
      end

      end
    def mul(a, b) do a * b end

   #-----div----
   #-----do I even need trunc?----
   #    yes you do, we dont want to have float/float we want only integers in the division/answer (ex. 13/2 not 13.0/2.0)
   def dv({:num, a}, {:num, b}) do
    if rem(a, b) == 0 do
    {trunc(a/b)}
    else
    {:q, a, b}
    end
    end

    def gcd(n, 0) do n end
    def gcd(a, b) do gcd(b, rem(a, b)) end

    def rdc(e1, e2) do
      if rem(e1,e2) == 0 do
        {:num, trunc((e1/gcd(e1,e2))/(e2/(gcd(e1,e2))))}
      else
    {:q, trunc(e1/gcd(e1,e2)), trunc(e2/gcd(e1,e2))}
    end
  end
  #--------Notes on div---------
  # we use rem() to find the remainder of a division. If it is zero, we return the integer part of the expression otherwise we express it as {:q, a, b}. We use rdc to reduce the expressions by dividing them with the gdc of e1 and e2 and express them as integers using trunc().

end
