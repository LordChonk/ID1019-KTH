defmodule Der do

  @type literal() :: {:num , number()}
  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:rt, expr()}
  | {:sin, expr()}
  | {:cos, expr()}
  | literal()

  def test0() do
    e = {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}
    d = der(e, :x)
    s = simp(d)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(s)}\n")
    #IO.write("derivative ns:\n")

    :ok
  end
  def test1() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d = der(e, :x)
    s = simp(d)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(s)}\n")
    :ok
  end

  def test2() do
    e = {:add, {:mul, {:num, 2}, {:mul, {:var, :x}, {:var, :x}}}, {:add, {:mul, {:num, 4}, {:var, :x}}, {:num, 5}}}
    d = der(e, :x)
    c = calc(d, :x, 5)
    s = simp(c)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("calculated: #{printStr(c)}\n")
    IO.write("simplified: #{printStr(s)}\n")
    :ok
  end

  def test3() do
    e = {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:add, {:mul, {:num, 4}, {:var, :x}}, {:num, 5}}}
    d = der(e, :x)
    c = calc(d, :x, 4)
    s = simp(c)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("calculated: #{printStr(c)}\n")
    IO.write("simplified: #{printStr(s)}\n")
    :ok
  end

  def test4() do
    e = {:sin, {:mul, {:num, 2}, {:var, :x}}}
    d = der(e, :x)
    #s = simp(d)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(simp(d))}\n")
    :ok
  end

  #---------test ln---------
  def test5() do
    e = {:ln, {:mul, {:num, 4}, {:var, :x}}}
    d = der(e, :x)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(simp(d))}\n")
    :ok
  end

  #-------test div------
  def test6() do
    e = {:div, {:num, 3}, {:mul, {:num, 9}, {:var, :x}}}
    d = der(e, :x)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(simp(d))}\n")
    :ok
  end #-- takes the correct derivative but doesnt simplify it quite well... ---> maybe fixed now

  def test7() do
    e = {:rt, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}}
    d = der(e, :x)
    IO.write("expression: #{printStr(e)}\n")
    IO.write("derivative: #{printStr(d)}\n")
    IO.write("simplified: #{printStr(simp(d))}\n")
    :ok
  end

  def der({:num, _}, _) do
    {:num, 0}
  end
  def der({:var, v}, v) do
    {:num, 1}
  end
  def der({:var, _}, _) do
    {:num, 0}
  end

  def der({:add, e1, e2}, v) do
    {:add, der(e1, v), der(e2, v)}
  end


  def der({:mul, e1, e2}, v) do
    {:add, {:mul, der(e1, v), e2},
      {:mul, der(e2, v), e1}
    }
  end
 #--------x^n = nx^n-1----------
  def der({:exp, e, {:num, n}}, v) do
    {:mul,
    {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
    der(e, v)}
  end

 #--------(sin(x))' = cos(x)----------
  def der({:sin, e}, v) do
    {:mul, der(e, v), {:cos, e}}
  end

#-------(ln x)' = 1/x-----
def der({:ln, e}, v) do
  {:mul, der(e, v), {:div, {:num, 1}, e}}
end

#-------(1/x)' = -n(1/x^(n+1))----------
def der({:div, e1, e2}, v) do
  {:div, {:sub, {:mul, der(e1, v), e2}, {:mul, e1, der(e2, v)}}, {:exp, e2, {:num, 2}}} end

#--------(root(x))'-----
def der({:rt, e}, v) do
  {:div, der(e, v), {:mul, {:num, 2}, {:rt, e}}} end

  def simp({:num, n}) do {:num, n} end
  def simp({:var, v}) do {:var, v} end
  def simp({:add, e1, e2}) do
    simp_add(simp(e1), simp(e2))
  end
  def simp({:mul, e1, e2}) do
    simp_mul(simp(e1), simp(e2))
  end
  def simp({:exp, e1, e2}) do
    simp_exp(simp(e1), simp(e2))
  end

  def simp({:sub, e1, e2}) do simp_sub(simp(e1), simp(e2)) end

#----------simplifying sin and cos-------
  def simp({:sin, e}) do simp_sin(simp(e)) end
  def simp({:cos, e}) do simp_cos(simp(e)) end
  def simp(e) do e end

  #--------simplifying ln-----
  def simp({:ln, e}) do simp_ln(simp(e)) end

  #------simplifying div----
  def simp({:div, e1, e2}) do simp_div(simp(e1), simp(e2)) end

  #----simplifying roots----
  def simp({:rt, e}) do simp_rt(simp(e)) end

  def simp_add({:num, 0}, e2) do e2 end
  def simp_add(e1, {:num, 0}) do e1 end
  def simp_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simp_add(e1, e2) do {:add, e1, e2} end

  def simp_sub({:num, 0}, e2) do {:mul, {:num, -1}, e2} end
  def simp_sub(e1, {:num, 0}) do e1 end
  def simp_sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end
  def simp_sin(e1, e2) do {:sub, e1, e2} end

  def simp_mul({:num, 0}, _) do {:num, 0} end
  def simp_mul(_, {:num, 0}) do {:num, 0} end
  def simp_mul({:num, 1}, e2) do e2 end
  def simp_mul(e1, {:num, 1}) do e1 end
  def simp_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simp_mul(e1, e2) do {:mul, e1, e2} end



  def simp_exp(_, {:num, 0}) do {:num, 1} end
  def simp_exp(e1, {:num, 1}) do e1 end
  def simp_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simp_exp({:num, 1}, _) do {:num, 1} end
  def simp_exp({:num, 0}, _) do {:num, 0} end
  def simp_exp(e1, e2) do {:exp, e1, e2} end

#----------edge cases sin and cos--------
  def simp_sin({:num, 0}) do {:num, 0} end
  def simp_sin(e) do {:sin, e} end
  def simp_cos({:num, 0}) do {:num, 1} end
  def simp_cos(e) do {:cos, e} end

  #---------simplifying ln-------
  def simp_ln({:num, 1}) do {:num, 0} end
 # def simp_ln({:num, 0}) do "NAN" end
  def simp_ln(e) do {:ln, e} end

  #--------simplifying div-------
  def simp_div(_, {:num, 0}) do "NAN" end
  def simp_div({:num, 0}, _) do {:num, 0} end
  def simp_div(e1, {:num, 1}) do e1 end
  def simp_div(e1, e2) do {:div, e1, e2} end

  #---------simplifying root-----
  def simp_rt({:num, 1}) do {:num, 1} end
  def simp_rt({:num, 0}) do {:num, 0} end
  def simp_rt(e) do {:rt, e} end




  def printStr({:num, n}) do "#{n}" end
  def printStr({:var, v}) do "#{v}" end
  def printStr({:add, e1, e2}) do
    "(#{printStr(e1)} + #{printStr(e2)})"
  end
  def printStr({:sub, e1, e2}) do
    "(#{printStr(e1)} - #{printStr(e2)})"
  end
  def printStr({:mul, e1, e2}) do
    "(#{printStr(e1)} * #{printStr(e2)})"
  end
  def printStr({:exp, e1, e2}) do
    "(#{printStr(e1)} ^ #{printStr(e2)})" end

#-----printing sin and cos----
  def printStr({:sin, e}) do "sin(#{printStr(e)}})" end
  def printStr({:cos, e}) do "cos(#{printStr(e)}}" end

#------printing ln and divisions--------
    def printStr({:ln, e}) do "ln(#{printStr(e)})" end
    def printStr({:div, e1, e2}) do "(#{printStr(e1)}/#{printStr(e2)})" end

#-------printing roots------
    def printStr({:rt, e}) do "sqrt(#{printStr(e)})" end



#--------Calculating-------
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end

  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
   {:mul, calc(e1, v, n), calc(e2, v, n)}
  end

  def calc({:exp, e, {:num, n}}, v, c) do
   {:exp, calc(e, v, c), {:num, n}}
  end



end
