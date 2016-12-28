defmodule ExMapbox.Geocoding do
    @moduledoc """

    This is the geolocation api for accessing geolocations

    """
    
    alias ExMapbox.Request

    #modes used by mapbox
    @modes %{ places: "mapbox.places",  places_permanent: "mapbox.places-permanent" }
    
    @doc """

    """
    def base_req(query, mode, method) do
        token = Application.get_env(:ex_mapbox, :access_token)
        url = "/geocoding/v5/#{@modes[mode]}/#{URI.encode(query)}.json?access_token=#{token}"
        Request.url method, url
    end







end