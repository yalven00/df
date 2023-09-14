Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == 'admin'
  password == "t3chr0@M"
end

