#main.rb ボートレースクローラ中心部

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'
require '/Users/taka/boatrace_crawler/ruby/get_race_result.rb'
require './param.rb'

  #シェルver
=begin
#今
date = `date "+%Y%m%d"`
#適当に時間いじる
date = `env TZ=JST-30 date "+%Y%m%d"`
#puts mdate.class
mdate = date.to_i
puts mdate
=end
  
  #ruby_ver
=begin
today = Date.today
date =  today.iso8601
date.tr!("-","")
mdate = date.to_i
puts date
=end

=begin 
#test用
mdate = 20170912
date = mdate.to_s 
=end



#ruby_ver
from_date = Param::From_date
to_date = Param::To_date

race_place = ""
result = Get_result.new()


while from_date != to_date + 1 do
  
  date =  from_date.iso8601
  date.tr!("-","")
  mdate = date.to_i
  puts date

#レース結果取得
  Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index?" + "hd=" + date , :depth_limit => 2, :delay => 2) do |anemone|
    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        link.to_s.match(/(\/raceresult)(.)*jcd=#{race_place}(.)*hd=#{mdate}$/)
      }
    end
  
    anemone.on_pages_like(/\/raceresult/) do |page|
      puts "\n\n-------------------------------------------------------------------\n\n" 
      puts page.url.to_s
      #urlから場、ラウンド、日時を抜き出す。
      query = page.url.query #URI::Generic#query
      query.tr!('a-z',"")
      query.tr!("=","")
      query = query.split("&") 
      #数字の先頭に0
      query[0] = format("%02d", query[0])     
      #puts("レース場\tラウンド\t日時")
      puts "#" + query[1] + result.prace_name(query[1]) + Param::SEPALATER + query[0] + "R" + Param::SEPALATER + query[2]

#突貫工事
      result.get_result(page.doc,query)
=begin      
      #データベースアクセス
      connection = Mysql::connect("localhost", "root", "root", "boat") 
      # 文字コードをUTF8に設定
      connection.query("set character set utf8")

      statement = connection.prepare("SELECT race_id FROM round_info WHERE race_id = ?")
      begin
        tuple = statement.execute(query[1]+query[0]+query[2]).fetch
        if tuple then
          # 行がある場合の処理
          puts "あるよ"
        else
          # 行がない場合の処理
          puts "ないよ"
          #Nokogiri形式にしてget_resultに渡す
          result.get_result(page.doc,query) 
        end
      ensure
        statement.close
      end
=end

    end
  end

  from_date = from_date + 1
end


#終わったら音をならす
for i in 1..5 do
  `afplay /System/Library/Sounds/Ping.aiff`
end
 

