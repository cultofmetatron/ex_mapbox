defmodule ExMapbox.GeocodingTest do
  use ExUnit.Case
  doctest ExMapbox, async: true

  describe "ExMapbox.Geocoding.base_req" do
      test "returns a base query" do
          req = %{
              query: "shrewsbury"
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          
          assert Map.get(req, :method) == "GET"
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
      end

      test "works with a single type" do
          req = %{
              query: "shrewsbury",
              params: %{
                  types: [:locality]
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&types=locality"
      end

      test "works with multiple types" do
          req = %{
              query: "shrewsbury",
              params: %{
                  types: [:locality, :address]
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&types=locality%2Caddress"
      end

      test "works with one country" do
          req = %{
              query: "shrewsbury",
              params: %{
                  country: ["us"]
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&country=us"
      end

      test "works with multiple countries" do
          req = %{
              query: "shrewsbury",
              params: %{
                  country: ["us", "ae"]
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&country=us%2Cae"
      end

      test "works with bounding_box" do
          req = %{
              query: "shrewsbury",
              params: %{
                  bounding_box: {1, 2, 3, 4}
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&bbox=1%2C2%2C3%2C4"

      end

      test "works with proximity" do
          req = %{
              query: "shrewsbury",
              params: %{
                  proximity: {22, 44}
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&proximity=22%2C%2044"
      end


      test "works with limit" do
          req = %{
              query: "shrewsbury",
              params: %{
                  limit: 2
              }
          } |> ExMapbox.Geocoding.base_req(:places, "GET")
          assert req.url =~ "https://api.mapbox.com/geocoding/v5/mapbox.places/shrewsbury.json"
          assert req.url =~ "&limit=2"
      end
  end

end
