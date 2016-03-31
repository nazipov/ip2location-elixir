defmodule IP2Location.Database do
  alias IP2Location.Database.Storage

  def lookup(ip) do
    meta = Storage.get(:meta)
    data = Storage.get(:data)

    case lookup_ip(ip, meta, data) do
      -1  -> nil
      row -> 
        result = IP2Location.Reader.read(row, data, meta.offsets)
        %{ result | ip: ip }
    end
  end

  defp lookup_ip(_, nil, nil), do: -1
  defp lookup_ip({_, _, _, _, _, _, _, _}, %{ipv6: nil}, _), do: -1
  defp lookup_ip({a, b, c, d}, %{ipv4: {hi, offset, column_size}}, data) do
    << a :: size(8), b :: size(8), c :: size(8), d :: size(8) >>
    |> fix_format(32)
    |> binsearch(32, 0, hi, offset, column_size, data)
  end
  defp lookup_ip({a, b, c, d, e, f, g, h}, %{ipv6: {hi, offset, column_size}}, data) do
    << a :: size(16), b :: size(16), c :: size(16), d :: size(16),
       e :: size(16), f :: size(16), g :: size(16), h :: size(16) >>
    |> fix_format(128)
    |> binsearch(128, 0, hi, offset, column_size, data)
    |> fix_ipv6_row_offset
  end

  defp fix_format(bindata, bit_count) do
    << fixed :: size(bit_count) >> = bindata
    fixed
  end

  defp fix_ipv6_row_offset(-1), do: -1
  defp fix_ipv6_row_offset(row_offset), do: row_offset + 12

  defp binsearch(_, _, lo, hi, _, _, _) when lo > hi, do: -1
  defp binsearch(ip, bit_count, lo, hi, offset, column_size, data) do
    mid = div(lo + hi, 2)
    row_offset = offset + mid * column_size
    
    ip_at = read(row_offset, bit_count, data)
    ip_to = read(row_offset + column_size, bit_count, data)

    if ip_at <= ip and ip < ip_to do
      row_offset
    else
      if ip_at > ip do
        binsearch(ip, bit_count, lo, mid - 1, offset, column_size, data)
      else
        binsearch(ip, bit_count, mid + 1, hi, offset, column_size, data)
      end
    end
  end

  defp read(pos, bit_count, data) do
    offset = pos - 1
    << _ :: size(offset)-binary, result :: little-size(bit_count), _ :: binary >> = data
    result
  end
end