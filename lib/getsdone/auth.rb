module Getsdone 

  class Auth < App

    get "/oauth2callback" do

      puts "hello getsdone #{params[:code]}"
      g = GoogleHelper.instance

      token = g.get_token(params[:code])

      puts token.token
      puts token.refresh_token
      puts token.inspect

      # store token to cookie, redirect to homepage, store token in db

      response.set_cookie( "getsdone.io",
        :value => Base64.encode64(token.token), :path => "/",
        :expires => Time.now + (60*60*24*30) )

      #u = User.create( :token => token.token )

      redirect "/home"

    end

    post "/login" do

      # add some validation
      u = User.find_by_name(params[:name])

      if u.nil?
        halt 401, {:msg => "invalid login credentials"}.to_json
      else

        if u.raw_password == params[:password]

          encrypted = create_token(u.uuid)

          response.set_cookie( "getsdone", { :value => encrypted,
            :path => "/" } )

          return {:msg => "logged in"}.to_json

        else
          halt 401, {:msg => "invalid login credentials"}.to_json
        end

      end

    end

    get "/google/login" do

      g = GoogleHelper.instance

      url = g.establish_login

      #r = RestClient.get(GOOGLE_EMAIL + "&access_token=ya29.AHES6ZT0w-8b2eOc6aMCAE65Ux090JJjsp7A7fI2-rBZ")
      #puts r
      return { :status => "200",
               :msg => url }.to_json

    end

    put "/logout" do

      u = authenticate

      if u.nil?
        halt 404, "something's wrong"
      else
        response.delete_cookie( "getsdone", :path => "/" )
      end

      return { :status => "200", :msg => "logged out" }.to_json

    end

  end

end

