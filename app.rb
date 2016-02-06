require "sinatra"
require "sinatra/reloader"

enable :sessions

get "/" do
  erb :index, layout: :app_layout
end

post "/" do
  session[:names] = params["names"].strip.split(",")
  session[:method] = params["method"]
  session[:number] = params["number"].to_i


  # def method_people(names, number)
  #   new_array = names.shuffle.each_slice(number).to_a
  # end

  def method_people(names, number)
    names_array = names.shuffle.map
    teams = (names.length.to_f / number).ceil
    new_array = Array.new(teams) { Array.new }
    count = 0
    names_array.map do |name|
      new_array[count] << name
      count == (teams - 1) ? (count = 0) : (count += 1)
    end
    new_array
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
    session[:results] = "Number of teams must be between 1 and the number of members"
  elsif session[:method] == "team_count"
    session[:results] = method_teams(session[:names], session[:number])
  elsif session[:method] == "per_team"
    session[:results] = method_people(session[:names], session[:number])
  end
  erb :index, layout: :app_layout
end
