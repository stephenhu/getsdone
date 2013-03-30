module Getsdone

  class GoogleHelper
    include Singleton

    attr_reader :config, :auth, :login

    def initialize

      @config =
        YAML.load_file(File.join( Sinatra::Application.root,
        "../conf/config.yml" ) )["google"]

      @auth = OAuth2::Client.new( config["client_id"], config["client_secret"],
        { :site => AUTH_ENDPOINT, :authorize_url => AUTH_RESOURCE,
        :token_url => TOKEN_RESOURCE } )

    end

    def establish_login

      return @auth.auth_code.authorize_url( :scope => SCOPE,
        :access_type => "offline", :redirect_uri => REDIRECT_URI,
        :approval_prompt => "force" )

    end

    def get_token(code)

      return @auth.auth_code.get_token( code, { :redirect_uri => REDIRECT_URI,
        :token_method => :post } )
 
    end

  end

end

