#get_race_result.rb 結果を取得し、データベースに格納する

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'

#class Get_preinfo

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
  
  
  
  #スペース、改行、タブ、全角を半角にして返す。スペース改行、複数タブ区切りで配列にする
  def mtrim(text)
          text.gsub!(/\\n|\\r|\\t/," ")
          text.gsub!(/[[:space:]]/," ")
          text.tr!("　"," ")
          text.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
          text.gsub!(/\s+/,SEPALATER)
          text.gsub!(/^\t/,"")
          text.gsub!("\"","\'")
          text = text.split(SEPALATER)
          return text
  end
  
  
  
  #¥と,を削除
  def yencomdel(text)
          if text != nil then
                  text.tr!("¥","")
                  text.tr!(",","")
          else
             text = ""
          end
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
      xpath = Array.new
    end
    return xpath
  end
  
  
  
  #SEPALATER区切りで出力
  def output_sep(out)
    out.each{|data|
      print(data + SEPALATER) 
    }
    puts
  end
  
  
  
  #それぞれのwebページに行うデータを抜き出す処理
  def get_preinfo(doc,query)
    
    for i in 1..6 do
      weight = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[4]",doc)
      tenji_time = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[5]",doc)
      tilto = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[6]",doc)
      pera = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[7]",doc)
      parts_change = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[8]/ul",doc)
      eval("@weight" + "#{i.to_s}" + "= weight")
      eval("@tenji_time#{i.to_s} = tenji_time")
      eval("@tilto#{i.to_s} = tilto")
      eval("@pera#{i.to_s} = pera")
      eval("@parts_change#{i.to_s} = parts_change")

      output_sep(Array[weight.to_s,tenji_time.to_s,tilto.to_s,pera.to_s,parts_change.to_s])
    end


   for i in 1..6 do 
    eval("@tenji_st#{i} = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/div[2]/div[1]/table/tbody/tr[#{i.to_s}]\",doc)")
   end

 end
  
#end#class end
  
  
  
  
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
  date = 20170912
  date = mdate.to_s
=end 
  



  
#ruby_ver
from_date = Date.new(2017, 9,13)
to_date = Date.new(2017, 9, 13)

race_place = ""

while from_date != to_date + 1 do
  
  date =  from_date.iso8601
  date.tr!("-","")
  mdate = date.to_i
  puts date

  Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index?" + "hd=" + date , :depth_limit => 2, :delay => 1) do |anemone|
    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        link.to_s.match(/(\/beforeinfo)(.)*jcd=#{race_place}(.)*hd=#{mdate}$/)
      }
    end
  
    anemone.on_pages_like(/\/beforeinfo/) do |page|
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
      puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]


      get_preinfo(page.doc,query)
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
          get_result(page.doc,query) 
        end
      ensure
        statement.close
      end 
=end
 
    end
  end

  from_date = from_date + 1
end

for i in 1..5 do
  `afplay /System/Library/Sounds/Ping.aiff`
end

