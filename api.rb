# coding: utf-8
# api.rb

require 'sinatra'
require 'sinatra/reloader'
require 'mysql2'
require 'json'

get '/racedata/n/:name' do |n|
  #"hello #{n}"

  # DB接続
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "boat")
  # DBにクエリを送る
  query = client.query("select grade,count(grade) from boatracer group by grade order by count(grade)")
  retjson = Hash.new()
  query.each do |result|
    retjson[result["grade"]] = result["count(grade)"]
  end
  # 接続終了
  str = JSON.generate(retjson)
  "#{str}"
end


