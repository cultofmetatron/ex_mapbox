defmodule ExMapbox.Waypoint do
    @enforce_keys [:name, :latitude, :longitude]
    defstruct [:name, :latitude, :longitude]
    alias ExMapbox.Waypoint

    def create(%{ name: name, location: [latitude, longitude] }) do
        %Waypoint{
            name: name,
            latitude: latitude,
            longitude: longitude
        }       
    end

end