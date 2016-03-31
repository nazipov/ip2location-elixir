defmodule IP2Location.Reader do
  def read(row_offset, data, offsets) do
    [:country_long | Map.keys(offsets)]
    |> List.foldl(%IP2Location.Result{}, fn (key, acc) ->
      value = read_field(key, row_offset, offsets, data)
      Map.put(acc, key, value)
    end)
  end

  defp read_field(:latitude, row_offset, %{ :latitude => offset }, data) do
    read_float(row_offset + offset - 1, data)
  end

  defp read_field(:longitude, row_offset, %{ :longitude => offset }, data) do
    read_float(row_offset + offset - 1, data)
  end

  defp read_field(:country_long, row_offset, %{ :country => offset }, data) do
    read_uint32(row_offset + offset - 1, data)
    |> (&(&1 + 3)).()
    |> read_string(data)
  end

  defp read_field(field, row_offset, offsets, data) do
    offsets
    |> Map.fetch!(field)
    |> (&(&1 + row_offset - 1)).()
    |> read_uint32(data)
    |> read_string(data)
  end

  defp read_uint32(offset, data) do
    << _ :: size(offset)-binary, result :: little-size(32), _ :: binary >> = data
    result
  end

  defp read_float(offset, data) do
    << _ :: size(offset)-binary, result :: little-size(32)-float, _ :: binary >> = data
    result
  end

  defp read_string(offset, data) do
    << _ :: size(offset)-binary, length :: size(8), result :: size(length)-binary, _ :: binary >> = data
    result
  end
end