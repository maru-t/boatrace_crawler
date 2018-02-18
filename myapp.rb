# coding: utf-8
#myapp.rb
#練習

require 'sinatra'
require 'sinatra/reloader'
require 'mysql'
require 'json'

get '/' do
  'hello world'
end

get '/sugihara' do
  'hello sugihara(k5432)'
end

get '/racedata/:name' do
  "hello #{params['name']}"
end

get '/racedata/n/:name' do |n|
  #"hello #{n}"

  # DB接続
  connection = Mysql::connect("localhost", "root", "root", "boat") 
  # 文字コードをUTF8に設定
  connection.query("set character set utf8")
  # DBにクエリを送る
  ret = ""
  retjson = Hash.new()
  connection.query("select grade,count(grade) from boatracer group by grade order by count(grade)").each do |result|
    puts(result.join(","))
    ret += result.join(",") + "<br>"
    puts(result[0].encoding)
    puts(result[1].encoding)
    retjson[result[0]] = result[1]
  end
  # 接続終了
  connection.close
  puts(retjson)
  str = JSON.generate(retjson)
  puts(str)
  "#{ret}"
end

get '/went/*/to/*' do
  "I went to #{params['splat'][0]} and #{params['splat'][1]}"
end

get '/download/*.*' do
  "Download path = #{params['splat'][0]} , fileformat = #{params['splat'][1]}"
end

get '/download/another/*.*' do |path,format|
  "path = #{path} , format = #{format}"
end

get '/posts/:format?' do
  "aaa"
end

get '/racedata' do
  jyo = params['jyo']
  round = params['round']
  date = params['date']
  "開催場No : #{jyo} <br>ラウンド : #{round}<br>日付 : #{date}"
end

get '/foo', :agent => /Songbird (\d\.\d)[\d\/]*?/ do
  "You're using Songbird version #{params['agent'][0]}"
end

get '/foo' do
  "foooooooooooO" 
  # Matches non-songbird browsers
end

not_found do 
  "やーい<br>バーカ<br>バーカ<br>あーほ"
end

set(:probability) { |value| condition { rand <= value } }

get '/win_a_car', :probability => 0.1 do
  "あなたの勝ちです!"
end

get '/win_a_car' do
  "残念、あなたの負けです。"
end

get '/fooa' do
  redirect to('/bar')
end
