class WebBox < Liza::WebBox

  configure :rack do
    # Configure your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
    
    # servers (pick one, check gemfile)
    server :puma

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  configure :request do
    # Configure your request panel per the DSL in http://guides.lizarb.org/panels/request.html

    router :simple
  end

end
