defmodule IP2Location.Reader do
  alias IP2Location.Database.Storage

  def read(row_offset, data, offsets) do
    read(row_offset, data, offsets, [:country_long | Map.keys(offsets)])
  end

  def read(row_offset, data, offsets, fields) do
    fields |> List.foldl(%IP2Location.Result{}, fn (key, acc) ->
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

  defp read_field(field, row_offset, offsets, data) 
  do
    { :ok, offset } = Map.fetch(offsets, field)
    read_uint32(row_offset + offset - 1, data)
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