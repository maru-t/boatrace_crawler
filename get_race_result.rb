require 'open-uri'

require 'nokogiri'

SEPALATER = "\t"

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
doc = Nokogiri::HTML(open("https://www.boatrace.jp/owpc/pc/race/raceresult?rno=12&jcd=01&hd=20170827"))

puts doc.title

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
weather = weather[1] + SEPALATER + weather[2] + SEPALATER + weather[4] + SEPALATER + weather[6] + SEPALATER + weather[8]

#決まり手
win_tec = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[2]/table/tbody/tr/td",doc)

#出力
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
puts weather

puts(p3tan + "\n" + p3puku + "\n" + p2tan + "\n" + p2puku + "\n" + ptan + "\n" + ppuku)

puts "\n決まり手\n" + win_tec

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


