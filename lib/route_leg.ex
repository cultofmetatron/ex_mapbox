defmodule ExMapbox.RouteLeg do
    defstruct distance: nil, duration: nil, steps: []
    @enforce_keys [:distance, :duration]
    

    def create(%{}) do
        
    end
end