defmodule ExMapbox.DirectionSet do
    @moduledoc """
    Takes care of directions for great justice
    impliments:
        https://www.mapbox.com/api-documentation/#retrieve-directions
    """
    @profile_types %{
        driving: "mapbox/driving",
        walking: "mapbox/walking",
        cycling: "mapbox/cycling"
    }

    @semicolon "%3B"
    @comma "%2C"

    alias ExMapbox.Waypoint
    alias ExMapbox.Route

    defstruct [
        {:alternatives, false},
        {:profile, :driving},
        {:geometries, :geojson},
        {:overview, :simplified},
        {:radiuses, []},
        {:continue_straight: true},
        {:bearings, []},
        {:waypoints, []},
        {:routes, routes}
    ]



    def retrieve() do
        
    end

    @doc """
        takes the types comming in an returns a map of the raw output
        without any post processing
    """
    def retrieve_raw(coordinates, params, profile) do
        if profile in Map.keys(@profile_types) do
            raw_url({coordinates, params}, Map.get(@profile_types, profile))
                |> HTTPoison.get()
        else
            raise ArgumentError, message: "invalid profile type"
        end
        
    end

    @doc """
    corrdinates: [{lat, lng}...],
    profile: profile in @profile_types : [:driving, :walking, :cycling]
    """
    def raw_url({coordinates, params}, profile) when is_list(coordinates) do
        params = extract_params(params, coordinates)
        token = Application.get_env(:ex_mapbox, :access_token)
        coordinates = coordinates 
            |> Enum.map(&process_coordinate/1)
            |> Enum.join(@semicolon)
        "https://api.mapbox.com/directions/v5/#{@profile_types[profile]}/#{coordinates}?&access_token=#{token}"
    end

    defp process_coordinate({lat, lng}) when is_number(lat) and is_number(lng) do
        "#{lat}#{@comma}#{lng}"
    end

        #takes the list and extracts them
    defp extract_params(params, coordinates) when is_map(params) do
       query_string = ""
           |> process_param(:alternatives, Map.get(params, :alternatives))
           |> process_param(:geometries,   Map.get(params, :geometries))
           |> process_param(:overview,     Map.get(params, :overview))
           |> process_param(:radiuses,     Map.get(params, :radiuses), coordinates)
           |> process_param(:steps,        Map.get(params, :steps))
           |> process_param(:continue_straight, Map.get(params, :continue_straight))
           |> process_param(:bearings,    Map.get(params, :bearings), coordinates)       
    end

    defp process_param(query_string, :alternatives, nil),   do: query_string
    defp process_param(query_string, :alternatives, true),  do: "#{query_string}&alternatives=true"
    defp process_param(query_string, :alternatives, false), do: "#{query_string}&alternatives=false"

    defp process_param(query_string, :geometries, nil), do: query_string
    defp process_param(query_string, :geometries, :polyline), do: "#{query_string}&geometries=polyline"
    defp process_param(query_string, :geometries, :geojson),  do: "#{query_string}&geometries=geojson"
    
    defp process_param(query_string, :overview, nil), do: query_string
    defp process_param(query_string, :overview, false), do: "#{query_string}&overview=false"
    defp process_param(query_string, :overview, :false), do: "#{query_string}&overview=false"
    defp process_param(query_string, :overview, :simplified), do: "#{query_string}&overview=simplified"
    defp process_param(query_string, :overview, :full), do: "#{query_string}&overview=full"

    defp process_param(query_string, :radiuses, nil, _), do: query_string
    defp process_param(query_string, :radiuses, [], _), do: query_string
    defp process_param(query_string, :radiuses, radiuses, coordinates) do
        if Enum.count(radiuses) == Enum.count(coordinates) do
            rads = radiuses
                |> Enum.map(&("#{&1}")) #coerce into a string
                |> Enum.join(@semicolon)
            "#{query_string}&radiuses=#{rads}"
        else
            raise ArgumentError, message: "number of radiuses must match number of coordinates!"        
        end
    end

    defp process_param(query_string, :steps, nil), do: query_string
    defp process_param(query_string, :steps, false), do: "#{query_string}&steps=false"
    defp process_param(query_string, :steps, true), do: "#{query_string}&steps=true"

    defp process_param(query_string, :continue_straight, nil), do: query_string
    defp process_param(query_string, :continue_straight, false), do: "#{query_string}&continue_straight=false"
    defp process_param(query_string, :continue_straight, true),  do: "#{query_string}&continue_straight=true"

    @docp """
    each bearing is a tuple {theta, deviation} or nil
    where
        theta: the angle from north we want the direction to go in. useful for 
               moving vehcles goign in a direction already
        deviation: allowed deviation. 45 or 90 degrees reccomended

    bearings : [({theta, deviation} or nil)..]  


    *!!length of bearings must equal length of coordinates!!*
    """
    defp process_param(query_string, :bearings, nil, coordinates), do: query_string
    defp process_param(query_string, :bearings, [], coordinates), do: query_string
    defp process_param(query_string, :bearings, bearings, coordinates) when is_list(bearings) do
        if Enum.count(bearings) == Enum.count(coordinates) do
            bearings = bearings
                |> Enum.map(&process_bearing/1)
                |> Enum.join(@semicolon)
            "#{query_string}&bearings=#{bearings}"
        else
            raise ArgumentError, message: "number of bearings must match number of coordinates!"
        end
    end

    #helper function for bearings
    defp process_bearing(nil), do: ""
    defp process_bearing({theta, deviation}) when is_number(theta) and is_number(deviation) do
         "#{theta}#{@comma}#{deviation}"
    end


end