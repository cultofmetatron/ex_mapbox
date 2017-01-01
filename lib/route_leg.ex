defmodule ExMapbox.RouteLeg do
    @enforce_keys [:distance, :duration]
    defstruct distance: nil, duration: nil, steps: []

    def create(%{})
end