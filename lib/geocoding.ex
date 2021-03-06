defmodule ExMapbox.Geocoding do
    @moduledoc """

    This is the geolocation api for accessing geolocations

    """
    
    alias ExMapbox.Request

    #modes used by mapbox
    @modes %{ places: "mapbox.places",  places_permanent: "mapbox.places-permanent" }
    @types %{
        poi: "poi",
        landmark: "poi.landmark",
        address: "address",
        neighborhood: "neighborhood",
        locality: "locality",
        place: "place",
        postcode: "postcode",
        region: "region",
        country: "country",
    }

    defstruct mode: @modes[:places], 
        method: "GET"


    def search(params, mode) do
        %{url: url} = search_places_request(params, mode, "GET")
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                {:ok, body}
            {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
                {:error, body }
            {:ok, %HTTPoison.Response{status_code: 404}} ->
                IO.puts "Not found :("
            {:error, %HTTPoison.Error{reason: reason}} ->
                IO.inspect reason
        end
    end
    
    
    @doc """

    """
    def search_places_request(%{ query: query, params: params }, mode, method) do
        token = Application.get_env(:ex_mapbox, :access_token)
        url = "/geocoding/v5/#{@modes[mode]}/#{URI.encode(query)}.json?access_token=#{token}"
            |> add_types(Map.get(params, :types))
            |> add_countries(Map.get(params, :country))
            |> add_proximity(Map.get(params, :proximity))
            |> add_boundingbox(Map.get(params, :bounding_box))
            |> add_autocomplete(Map.get(params, :autocomplete))
            |> add_limit(Map.get(params, :limit))
        Request.url method, url
    end

    def search_places_request(%{lat: lat, lng: lng}, mode, method) do

    end

    @doc """

    """
    def search_places_request(%{ query: query }, mode, method) do
        token = Application.get_env(:ex_mapbox, :access_token)
        url = "/geocoding/v5/#{@modes[mode]}/#{URI.encode(query)}.json?access_token=#{token}"
        Request.url method, url
    end

    defp add_types(url, nil), do: url
    defp add_types(url, []),  do: url
    defp add_types(url, types) do
        str = types 
            |> Enum.map(&(@types[&1]))
            |> Enum.join("%2C")
        "#{url}&types=#{str}"
    end

    defp add_countries(url, nil), do: url
    defp add_countries(url, []),  do: url
    defp add_countries(url, countries) do
        str = countries
            |> Enum.map(&(URI.encode(&1)))
            |> Enum.join("%2C")
        "#{url}&country=#{str}"
    end

    defp add_proximity(url, nil), do: url
    defp add_proximity(url, {lat, lng}) do
        # proximity=20%2C%2033
        str = "#{lat}%2C%20#{lng}"
        "#{url}&proximity=#{str}"
    end

    defp add_boundingbox(url, nil), do: url
    defp add_boundingbox(url, {min_x, min_y, max_x, max_y}) do
        # &bbox=-1%2C-2%2C-3%2C-4
        str = "#{min_x}%2C#{min_y}%2C#{max_x}%2C#{max_y}"
        "#{url}&bbox=#{str}"
    end

    def add_autocomplete(url, nil), do: url
    def add_autocomplete(url, true), do: "#{url}&autocomplete=true"
    def add_autocomplete(url, false), do: "#{url}&autocomplete=false"

    def add_limit(url, nil), do: url
    def add_limit(url, limit) when is_number(limit) do
        "#{url}&limit=#{limit}"
    end







end