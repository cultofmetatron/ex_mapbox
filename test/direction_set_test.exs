defmodule ExMapbox.DirectionSetTest do
  use ExUnit.Case
  doctest ExMapbox, async: true

  alias ExMapbox.DirectionSet

  describe "directions set" do
      test "retrieves a set of directions between two cordinates" do
          resp = DirectionSet.retrieve([{-73.989, 40.733}, {-74, 40.733}], :driving, [])
          IO.puts("response")
          IO.inspect(resp)
      end
  end

end