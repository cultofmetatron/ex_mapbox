defmodule ExMapbox.Request do
    defstruct method: "GET", url: "/", body: ""
    @moduledoc """

    """
    #/geocoding/v5/{mode}/{query}.json
    def url(method, url, body \\ "") do
        %ExMapbox.Request{
            method: method,
            url: "#{Application.get_env(:ex_mapbox, :base_url)}#{url}",
            body: body
        }
    end

    def make_request(%ExMapbox.Request{} = req) do
        #make call here
        false
    end


end