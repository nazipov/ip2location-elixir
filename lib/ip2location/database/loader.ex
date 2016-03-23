defmodule IP2Location.Database.Loader do
  use GenServer
  use Bitwise

  alias IP2Location.Database.Storage

  @positions_matrix %{
    country:            [0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,  2, 2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2],
    region:             [0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3,  3, 3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3,  3],
    city:               [0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4,  4, 4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4],
    isp:                [0, 0, 3, 0, 5, 0, 7, 5, 7, 0, 8, 0,  9, 0,  9,  0,  9,  0,  9,  7,  9,  0,  9,  7,  9],
    latitude:           [0, 0, 0, 0, 0, 5, 5, 0, 5, 5, 5, 5,  5, 5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5],
    longitude:          [0, 0, 0, 0, 0, 6, 6, 0, 6, 6, 6, 6,  6, 6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6],
    domain:             [0, 0, 0, 0, 0, 0, 0, 6, 8, 0, 9, 0, 10, 0, 10,  0, 10,  0, 10,  8, 10,  0, 10,  8, 10],
    zipcode:            [0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7,  7, 0,  7,  7,  7,  0,  7,  0,  7,  7,  7,  0,  7],
    timezone:           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,  8, 7,  8,  8,  8,  7,  8,  0,  8,  8,  8,  0,  8],
    netspeed:           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 8, 11,  0, 11,  8, 11,  0, 11,  0, 11,  0, 11],
    iddcode:            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  9, 12,  0, 12,  0, 12,  9, 12,  0, 12],
    areacode:           [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0, 10, 13,  0, 13,  0, 13, 10, 13,  0, 13],
    weatherstationcode: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  9, 14,  0, 14,  0, 14,  0, 14],
    weatherstationname: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0, 10, 15,  0, 15,  0, 15,  0, 15],
    mcc:                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  0,  0,  9, 16,  0, 16,  9, 16],
    mnc:                [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  0,  0, 10, 17,  0, 17, 10, 17],
    mobilebrand:        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  0,  0, 11, 18,  0, 18, 11, 18],
    elevation:          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  0,  0,  0,  0, 11, 19,  0, 19],
    usagetype:          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 12, 20]
  }

  def start_link(databases \\ []) do
    GenServer.start_link(__MODULE__, databases, name: __MODULE__)
  end

  def init(database) do
    load_database(database)
    { :ok, database }
  end

  defp load_database(database) do
    case File.regular?(database) do
      false -> { :error, "Given file '#{database}' does not exists?!" }
      true ->
        database
        |> read_database()
        |> save_data()
    end
  end

  def read_database(filename) do
    IO.puts "Reading file #{filename}"

    data = File.read!(filename)

    <<db_type     :: size(8),
      column      :: size(8),
      year        :: size(8),
      month       :: size(8),
      day         :: size(8),
      ipv4_count  :: little-size(32),
      ipv4_offset :: little-size(32),
      ipv6_count  :: little-size(32),
      ipv6_offset :: little-size(32),
      _           :: binary >> = data

    # TODO: Add database file validator

    meta = %IP2Location.Metadata{
      db_type: db_type,
      version: { year, month, day },
      ipv4:    { ipv4_count, ipv4_offset, column <<< 2 },
      ipv6:    { ipv6_count, ipv6_offset, 16 + ((column - 1) <<< 2) },
      offsets: calc_offsets(db_type)
    }

    { meta, data }
  end

  def save_data({ meta, data }) do
    Storage.set(:meta, meta)
    Storage.set(:data, data)

    :ok
  end

  defp calc_offsets(db_type) do
    for { field, positions } <- @positions_matrix,
        position = Enum.at(positions, db_type),
        position > 0 do
      { field, (position - 1) <<< 2 }
    end |> Map.new
  end

end