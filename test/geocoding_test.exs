defmodule ExMapbox.GeocodingTest do
  use ExUnit.Case
  doctest ExMapbox, async: true

  test "the truth" do
    assert 1 + 1 == 2
  end

  describe "ExMapbox.Geocoding.base_req" do
      test "returns a base query" do
          req = %{
              query: "shrewsbury"
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          IO.inspect(req)
          assert Map.get(req, :method) == "GET"
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
      end
  end

end
