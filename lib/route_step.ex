defmodule ExMapbox.RouteStep do
    @enforce_keys [:name, :distance, :duration, :mode, :geometry, :geometry_type]
    defstruct name: nil, mode: nil, geometry: nil, distance: nil, duration: nil, geometry_type: nil
    alias ExMapbox.RouteStep

    def create(%{name: name, distance: distance, duration: duration, mode: mode, geometry: geometry}, geometry_type) do
        %RouteStep{
            name: name,
            distance: distance,
            duration: duration,
            mode: mode,
            geometry: geometry,
            geometry_type: geometry_type
        }
    end
end