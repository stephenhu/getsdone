module Getsdone 

  class Api < App

#TODO: api_key
    post "/actions" do

#TODO: validation

      AppHelper.validate(params)

      if AppHelper.add_action(params)
        return "{ \"status\": 200, \"msg\": \"ok\" }"
      else
        return { :status => "401", 
                 :msg => "User not found" }.to_json
      end

    end

  end

end

