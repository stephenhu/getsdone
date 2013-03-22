module Getsdone 

  class Api < App

#TODO: api_key
    post "/actions" do

#TODO: validation

      add_action(params)

      return "{ \"status\": 200, \"msg\": \"ok\" }"

    end

  end

end

