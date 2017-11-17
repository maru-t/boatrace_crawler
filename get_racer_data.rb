
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
  def get_racer_data(doc,query)
    name_kanzi = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/div/div/p[1]",doc)#名前漢字
    name_kana = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/div/div/p[2]",doc)#名前カナ
    reg_no = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[1]",doc)#登録番号
    birthday = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[2]",doc)#生年月日
    height = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[3]",doc)#身長
    weight = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[4]",doc)#体重
    bloodtype = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[5]",doc)#血液型
    sibu = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[6]",doc)#支部
    pref = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[7]",doc)#出身県
    generation = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[8]",doc)#登録期
    rank = adjust_data("/html/body/main/div/div/div/div[2]/div/div[1]/dl/dd[9]",doc)#級別

    if name_kanzi !=  [] then
      print("名前漢字:" + name_kanzi.to_s)
      print("名前カナ:" + name_kana.to_s)
      print("登録番号:" + reg_no.to_s)
      print("生年月日:" + birthday.to_s)
      print("身長:" + height.to_s)
      print("体重:" + weight.to_s)
      print("血液型:" + bloodtype.to_s)
      print("支部:" + sibu.to_s)
      print("出身県:" + pref.to_s)
      print("登録期:" + generation.to_s)
      print("級別:" + rank.to_s)
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

=begin    
#ruby_ver 日付 開催場指定
from_date = Param::From_date
to_date = Param::To_date
=end


#race_place = ""

from_toban = 3000;
to_toban = 3100;

print("\n\n\n\n\n\n\nget_racer_data.rb-----------------\n\n\n\n\n\n\n")

while from_toban != to_toban + 1 do
  
  Anemone.crawl("https://www.boatrace.jp/owpc/pc/data/racersearch/profile?" + "toban=" + from_toban.to_s , :depth_limit => 0, :delay => 1) do |anemone|
      
    anemone.on_every_page do |page|
      puts "\n\n-------------------------------------------------------------------\n\n" 
      puts page.url.to_s
      #urlから場、ラウンド、日時を抜き出す。
      query = page.url.query #URI::Generic#query
      query.tr!('a-z',"")
      query.tr!("=","")
      query = query.split("&") 

      get_racer_data(page.doc,query)
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

  from_toban = from_toban + 1
end

#終了時アラームをならす
for i in 1..5 do
  `afplay /System/Library/Sounds/Ping.aiff`
end

