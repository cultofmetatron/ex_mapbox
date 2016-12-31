defmodule ExMapbox.Route do
    alias ExMapbox.Route
    defstruct distance: nil,
        duration: nil,
        geometry: nil,
        geometry_type: nil,
        overview: :simplified,
        legs: []

    def create(%{distance: distance, duration: duration, geometry: geometry, legs: legs, }, geometry_type, overview) do
        
    end
end