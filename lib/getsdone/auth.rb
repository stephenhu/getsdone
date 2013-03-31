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

    get "/login" do

      g = GoogleHelper.instance

      url = g.establish_login

      #r = RestClient.get(GOOGLE_EMAIL + "&access_token=ya29.AHES6ZT0w-8b2eOc6aMCAE65Ux090JJjsp7A7fI2-rBZ")
      #puts r
      return { :status => "200",
               :msg => url }.to_json

    end

    put "/logout" do

      authenticate

      u = User.find_by_id(session[:user][:id])

      if u.nil?
        halt 404
      else
        u.token = ""
        u.save
      end

    end

  end

end

