require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'

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

#スペース、改行、タブ、全角を半角にして返す
def mtrim(text)
        text.gsub!(/\\n|\\r|\\t/," ")
        text.gsub!(/[[:space:]]/," ")
        text.tr!("　"," ")
        text.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
        text.gsub!(/\s+/,SEPALATER)
        text.gsub!(/^\t/,"")
        #text = text.split(" ")
        return text
end

#データを整える
def adjust_data(xpath,doc) 
  boat = doc.xpath(xpath)
  boat.each do |boat|
    xpath = mtrim(boat.text)
  end
  
  return xpath
end


#URLからHTMLファイル取得,Nokogiriの形式にする
#doc = Nokogiri::HTML(open("https://www.boatrace.jp/owpc/pc/race/raceresult?rno=12&jcd=01&hd=20170827"))

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
weather = weather.split(SEPALATER)
weather_s = weather[1] + SEPALATER + weather[2] + SEPALATER + weather[4] + SEPALATER + weather[6] + SEPALATER + weather[8]

#決まり手
win_tec = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[2]/table/tbody/tr/td",doc)

#出力
#puts get_url.class
query = get_url.query
#puts query.class
query.tr!('a-z',"")
query.tr!("=","")
query = query.split("&")

#puts("レース場\tラウンド\t日時")
puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]


#puts URI.split(get_url)

puts("結果")
puts("順位\t艇番\t登録No\t名前\t\tタイム")
puts boat1
puts boat2
puts boat3
puts boat4
puts boat5
puts boat6

puts("\nスタート\n進入\t艇番\tスタートタイム")
puts start_s1
puts start_s2
puts start_s3
puts start_s4
puts start_s5
puts start_s6

puts("\n天気\n気温\t天気\t風速\t水温\t波")
puts weather_s

puts("\n払い戻し\n勝式\t組番\t払戻金\t人気")
puts(p3tan + "\n" + p3puku + "\n" + p2tan + "\n" + p2puku + "\n" + ptan + "\n" + ppuku)

puts "\n決まり手\n" + win_tec

end

myurl = ""
#mdate = `date "+%Y%m%d"`
mdate = `env TZ=JST+15 date +%Y%m%d`
#puts mdate.class
mdate = mdate.to_i
puts mdate


Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index", :depth_limit => 2, :delay => 1) do |anemone|
  anemone.focus_crawl do |page|
    page.links.keep_if { |link|
      link.to_s.match(/(\/raceresult)(.)*hd=#{mdate}$/)
      #link.to_s.match(/(\/raceresult)(.)*20170830$/)
    }
  end

  anemone.on_pages_like(/\/raceresult/) do |page|
    puts "\n" + page.url.to_s
    #myurl = myurl + SEPALATER + page.url.to_s
    #Nokogiri形式にしてget_resultに渡す
    get_result(page.doc,page.url)
  end
end


=begin
url = myurl.split(SEPALATER)

url.each do |url|
  puts url
end
=end

=begin
#レース結果とスタートタイミングをひっつけようかと思ったが断念
def addstart(boat1,boat2,boat3,boat4,boat5,boat6,start)
 case start[0]
 when "1" then
  boat1 = boat1 + "1" + SEPALATER + start[1]
 when "2" then
  boat2 = boat2 + "2" + SEPALATER + start[1]
 when "3" then
  boat3 = boat3 + "3" + SEPALATER + start[1]
 when "4" then
  boat4 = boat4 + "4" + SEPALATER + start[1]
 when "5" then
  boat5 = boat5 + "5" + SEPALATER + start[1]
 when "6" then
  boat6 = boat6 + "6" + SEPALATER + start[1]
 else
  puts "------------error----------------" 
 end
end

puts start_c1[2]
if start_c1[0] == "1" then
 b = boat1 + SEPALATER + start_c1[1]
 puts start_c1
 puts "thorough"
else
 puts "not"
end

puts b
=end


#はじめの検討、どうデータ取り出すか


=begin
rank = doc.xpath("//td[@class='is-fs14']")
cource = doc.xpath("//td[@class='is-fs14 is-fBold is-boatColor1']")
racer_num = doc.xpath("//span[@class='is-fs12']")
racer_name = doc.xpath("//span[@class='is-fs18 is-fBold']")
racetime = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody/tr/td[4]")
=end



=begin
boat1 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[1]")
boat2 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[2]")
boat3 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[3]")
boat4 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[4]")
boat5 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[5]")
boat6 = doc.xpath("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[6]")


boat1.each do |boat1|
  boat1_result =  mtrim(boat1.text)
end

boat2.each do |boat2|
  boat2_result = mtrim(boat2.text)
end

boat3.each do |boat3|
  boat3_result = mtrim(boat3.text)
end


=end



=begin
rank.each do |rank|
  puts mtrim(rank.text)
end

racetime.each do |racetime|
  puts mtrim(racetime.text)
end

result = doc.xpath("//div[@class='grid_unit']")

result.each do |result|
  puts mtrim(result.text)
end
=end


