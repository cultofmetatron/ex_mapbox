defmodule ExMapbox.Directions do
    @moduledoc """
    Takes care of directions for great justice
    """
    @profile_types %{
        driving: "mapbox/driving",
        walking: "mapbox/walking",
        cycling: "mapbox/cycling"
    }

    @doc """
    corrdinates: [{lat, lng}...],
    profile: profile in @profile_types
    """
    def raw_url(coordinates, profile) when is_list(coordinates) do
        
        "https://api.mapbox.com/directions/v5/#{profile}/#{coordinates}"
    end


end