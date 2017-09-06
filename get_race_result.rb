require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'

SEPALATER = "\t"

#番号からレース場の名前を返す
def prace_name(num)
  case num
  when "01" then
    return "桐生"
  when "02" then
    return "戸田"
  when "03" then
    return "江戸川"
  when "04" then
    return "平和島"
  when "05" then
    return "多摩川"
  when "06" then
    return "浜名湖"
  when "07" then
    return "蒲郡"
  when "08" then
    return "常滑"
  when "09" then
    return "津"
  when "10" then
    return "三国"
  when "11" then
    return "びわこ"
  when "12" then
    return "住之江"
  when "13" then
    return "尼崎"
  when "14" then
    return "鳴門"
  when "15" then
    return "丸亀"
  when "16" then
    return "児島"
  when "17" then
    return "宮島"
  when "18" then
    return "徳山"
  when "19" then
    return "下関"
  when "20" then
    return "若松"
  when "21" then
    return "芦屋"
  when "22" then
    return "福岡"
  when "23" then
    return "唐津"
  when "24" then
    return "大村"
  else
    return "そんなわけはない"
  end
end

#スペース、改行、タブ、全角を半角にして返す。スペース改行、複数タブはタブに置換
def mtrim(text)
        text.gsub!(/\\n|\\r|\\t/," ")
        text.gsub!(/[[:space:]]/," ")
        text.tr!("　"," ")
        text.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
        text.gsub!(/\s+/,SEPALATER)
        text.gsub!(/^\t/,"")
        text.gsub!("\"","\'")
        return text
end

#データを整える
def adjust_data(xpath,doc) 
  boat = doc.xpath(xpath)
  if boat.text != "" then
    boat.each do |boat|
      xpath = mtrim(boat.text)
    end
  else
    xpath =  ""
  end
  return xpath
end


#それぞれのwebページに行うデータを抜き出す処理
def get_result(doc,get_url)
#レース結果
boat1 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[1]",doc)
boat2 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[2]",doc)
boat3 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[3]",doc)
boat4 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[4]",doc)
boat5 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[5]",doc)
boat6 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[6]",doc)

#スタート
start_s1 = "1" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[1]",doc)
start_s2 = "2" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[2]",doc)
start_s3 = "3" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[3]",doc)
start_s4 = "4" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[4]",doc)
start_s5 = "5" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[5]",doc)
start_s6 = "6" + SEPALATER + adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[6]",doc)

#払い戻し
p3tan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[1]",doc)
p3puku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[2]",doc)
p2tan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[3]",doc)
p2puku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[4]",doc)
p2puku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[5]",doc)
ptan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[6]",doc)
ppuku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[7]",doc)


#天気
weather = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[1]/div/div[1]",doc)

if weather != "" then
  weather = weather.split(SEPALATER)
  weather_s = weather[1] + SEPALATER + weather[2] + SEPALATER + weather[4] + SEPALATER + weather[6] + SEPALATER + weather[8]
else
  weather_s = ""
end

#決まり手
win_tec = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[2]/table/tbody/tr/td",doc)

#返還
return_money = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[1]/table/tbody",doc)

#出力
#urlから場、ラウンド、日時を抜き出す。
query = get_url.query #URI::Generic#query
query.tr!('a-z',"")
query.tr!("=","")
query = query.split("&")

#puts("レース場\tラウンド\t日時")
puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]


if boat1 != "" then

  puts("結果")
  puts("順位\t艇番\t登録No\t名前\t\tタイム")
  puts boat1
  puts boat2
  puts boat3
  puts boat4
  puts boat5
  puts boat6

  puts("\nスタート")
  puts("進入\t艇番\tスタートタイム")
  puts start_s1
  puts start_s2
  puts start_s3
  puts start_s4
  puts start_s5
  puts start_s6

  puts("\n水面気象情報")
  puts("気温\t天気\t風速\t水温\t波")
  puts weather_s

  puts("\n払い戻し")
  puts("勝式\t組番\t払戻金\t人気")
  puts(p3tan + "\n" + p3puku + "\n" + p2tan + "\n" + p2puku + "\n" + ptan + "\n" + ppuku)

  puts "\n決まり手\n" + win_tec

  puts"\n返還\n" + return_money
end



#データベースアクセス
connection = Mysql::connect("localhost", "root", "root", "boat")

# 文字コードをUTF8に設定
connection.query("set character set utf8")

# DBに問い合わせ
boat1 = boat1.split(SEPALATER)
boat2 = boat2.split(SEPALATER)
boat3 = boat3.split(SEPALATER)
boat4 = boat4.split(SEPALATER)
boat5 = boat5.split(SEPALATER)
boat6 = boat6.split(SEPALATER)

weather_s = weather_s.split(SEPALATER)
weather_s[0].tr!("℃","")
weather_s[2].tr!("m","")
weather_s[3].tr!("℃","")
weather_s[4].tr!("cm","")


#出力確認用
puts("insert into round_info(race_id, place, round_no, day, temp, sky, wind, water_temp, wave, kimarite, return_money) values(\"#{query[1]+query[0]+query[2]}\", \"#{prace_name(query[1])}\", #{query[0].to_i}, \"#{query[2]}\", #{weather_s[0]}, \"#{weather_s[1]}\", #{weather_s[2]}, #{weather_s[3]}, #{weather_s[4]}, \"#{win_tec}\", \"#{return_money}\")")

connection.query("insert into round_info(race_id, place, round_no, day, temp, sky, wind, water_temp, wave, kimarite, return_money) values(\"#{query[1]+query[0]+query[2]}\", \"#{prace_name(query[1])}\", #{query[0].to_i}, \"#{query[2]}\", #{weather_s[0]}, \"#{weather_s[1]}\", #{weather_s[2]}, #{weather_s[3]}, #{weather_s[4]}, \"#{win_tec}\", \"#{return_money}\")")

puts("insert into race_info(race_id, boat_no, race_rank, racer_no, race_time) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat1[1]}\", \"#{boat1[0]}\", \"#{boat1[2]}\", \"#{boat1[5]}\")")

connection.query("insert into race_info(race_id, boat_no, race_rank, racer_no, race_time) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat1[1]}\", \"#{boat1[0]}\", \"#{boat1[2]}\", \"#{boat1[5]}\")")


rs = connection.query("SELECT * FROM round_info")

puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]
# 検索結果を表示
rs.each do |r|
  puts r.join ", "
end

# コネクションを閉じる
connection.close

end








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
today = Date.today
date =  today.iso8601
date.tr!("-","")
mdate = date.to_i
puts date

#test用
mdate = 20170905
date = mdate.to_s

Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index?" + "hd=" + date , :depth_limit => 2, :delay => 1) do |anemone|
  anemone.focus_crawl do |page|
    page.links.keep_if { |link|
      link.to_s.match(/(\/raceresult)(.)*hd=#{mdate}$/)#実行時の日時のデータを取得
    }
  end

  anemone.on_pages_like(/\/raceresult/) do |page|
    puts "\n" + page.url.to_s
    #Nokogiri形式にしてget_resultに渡す
    get_result(page.doc,page.url)
  end
end

