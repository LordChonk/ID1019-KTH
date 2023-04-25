defmodule MCarlo do


  def dart(r) do
    x = :rand.uniform()
    y = :rand.uniform()
    :math.pow(r, 2) > (:math.pow(x, 2) + :math.pow(y, 2))
  end

  def round(0, _r, hits) do hits end
  def round(rds, r, hits) do
      if dart(r) do
  round(rds-1, r, hits+1)
else
  round(rds-1, r, hits)
  end
  end

  def rounds(rds, ttr, r) do
    rounds(rds, ttr, 0, r, 0)
    end
    def rounds(0, _ttr, total, _r, hits) do IO.puts(" Estimate: #{4.0 * hits/total}") end

    def rounds(rds, ttr, total, r, hits) do
    hits = round(ttr, r, hits)
    total = total + ttr
    pi = 4.0 * hits/total
    :io.format("  total = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [total, pi, (pi - :math.pi()), (pi - 22/7), (pi- 355/113)])

    rounds(rds-1, ttr*2, total, r, hits)
    end

    def liebniz do
      4 * Enum.reduce(0..10000000, 0,
      fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
    end

  end
