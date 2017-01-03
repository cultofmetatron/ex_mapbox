defmodule ExMapbox.Geometry do
    defstruct [:format, :value]
    @valid_formats [:geojson, :polyline]
    @enforce_keys [:format, :value]
    
    alias ExMapbox.Geometry

    @doc """
        creates a Geometry
        format: :geojson or polyline
    """
    def create(%{format: format, value: value}) do
        if format in @valid_formats do
            %Geometry{ format: format, value: value }            
        else
            raise KeyError, message: "invalid format attribute"
        end
    end
end