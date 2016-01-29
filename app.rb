require "sinatra"
require "sinatra/reloader"

enable :sessions

get "/" do
  erb :index, layout: :app_layout
end

post "/" do
  session[:names] = params["names"].strip.split(",")
  method = params["method"]
  session[:number] = params["number"].to_i


  def method_people(names, number)
    new_array = names.shuffle.each_slice(number).to_a
  end

  def method_teams(names, number)
    names_array = names.shuffle.map
    new_array = Array.new(number) { Array.new }
    count = 0
    names_array.each do |name|
      new_array[count] << name
      count == (new_array.length-1) ? (count = 0) : (count += 1)
    end
    new_array
  end

  if session[:number] > session[:names].length
    @results = "Number of teams must be between 1 and the number of members"
  elsif method == "team_count"
    @results = method_teams(session[:names], session[:number])
  elsif method == "per_team"
    @results = method_people(session[:names], session[:number])
  end
  erb :index, layout: :app_layout
end
