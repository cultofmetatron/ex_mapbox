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



    def retrieve() do
        
    end

    @doc """
    corrdinates: [{lat, lng}...],
    profile: profile in @profile_types : [:driving, :walking, :cycling]
    """
    def raw_url({coordinates, params}, profile) when is_list(coordinates) do
        params = extract_params(params)
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
    defp extract_params(params) when is_map(params) do
       query_string = ""
           |> process_param(:alternatives, Map.get(params, :alternatives))       
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
    defp process_param(query_string, :raiduses, [], _), do: query_string
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
        Used to filter the road segment the waypoint will be placed on by direction and 
        dictates the angle of approach. This option should always be used in conjunction 
        with the  radiuses parameter. The parameter takes two values per waypoint: 
        the first is an angle clockwise from true north between 0 and 360. 
        The second is the range of degrees the angle can deviate by. 
        We recommend a value of 45° or 90° for the range, as bearing measurements tend to be inaccurate. 
        This is useful for making sure we reroute vehicles on new routes that continue traveling in 
        their current direction. A request that does this would provide bearing and 
        radius values for the first waypoint and leave the remaining values empty. 
        If provided, the list of bearings must be the same length as the list of waypoints, 
        but you can skip a coordinate and show its position with the  ; separator.

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
            raise ArgumentError, message: "number of coordinates must match number of coordinates!"
        end
    end

    #helper function for bearings
    defp process_bearing({theta, deviation}), do: "#{theta}#{@comma}#{deviation}"
    defp process_bearing(nil), do: ""



end