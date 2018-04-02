#出走表から
#https://www.boatrace.jp/owpc/pc/race/racelist?rno=12&jcd=04&hd=20180315

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'
require './param.rb'

#class Get_preinfo

  SEPALATER = "\t"

  #スペース、改行、タブ、全角を半角にして返す。スペース改行、複数タブ区切りで配列にする
  def mtrim(text)
          text.tr!("　","")
          text.gsub!(/[[:space:]]/," ")
          text.gsub!(/\\n|\\r|\\t/,"aaa")
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
      if data.nil? == false then
        print(data + SEPALATER)
      end
    }
    puts()
  end
  
  
  
  #それぞれのwebページに行うデータを抜き出す処理
  def get_preinfo(doc,query)
   
    cup_name = adjust_data("/html/body/main/div/div/div/div[1]/div/div[2]/h2",doc)#大会名

    race_type = adjust_data("/html/body/main/div/div/div/div[1]/div/div[2]/span",doc)#レース種類(ex.一般戦、優勝戦)
    stabilizer = adjust_data("/html/body/main/div/div/div/div[1]/div/div[2]/div",doc)#安定板使用してるか
    what_day = adjust_data("/html/body/main/div/div/div/div[2]/div[1]/ul/li[@class = \"is-active2\"]/span/span",doc)#開催何日目か
    race_rank = adjust_data("/html/body/main/div/div/div/div[1]/div/div[2]/@class",doc)#レース階級(ex.SG,G1,G2,G3,一般)
    host_time = adjust_data("/html/body/main/div/div/div/div[2]/div[2]/table/tbody/tr[1]",doc)#レース開始時間

    for i in 1..6 do
      eval("@motor_no#{i.to_s} = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/table/tbody[#{i.to_s}]/tr[1]/td[7]\",doc)")#モーター番号
      eval("@boat_no#{i.to_s} = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/table/tbody[#{i.to_s}]/tr[1]/td[8]\",doc)")#ボート番号
      eval("@reg_no#{i.to_s} = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/table/tbody[#{i.to_s}]/tr[1]/td[3]/div[1]\",doc)")#登録番号
      eval("@fl#{i.to_s} = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/table/tbody[#{i.to_s}]/tr[1]/td[4]\",doc)")#フライング出遅れ
      eval("@fl#{i.to_s}.delete_at(2)")
      eval("@fl#{i.to_s}[0].delete!(\"F\")")
      eval("@fl#{i.to_s}[1].delete!(\"L\")")
      puts(eval("@reg_no#{i.to_s}[0]"))
    end



    host_time.slice!(0,2)
    #puts(host_time[query[3].to_i - 1])#ラウンド毎のレースの時間を代入

    race_rank[1] = Param::race_grade(race_rank[1])

    output_sep(Array["大会名","レース種類","距離","安定板","何日目","レース階級","開始時間"])
    output_sep(Array[ cup_name[0],race_type[0],race_type[1],stabilizer[0],what_day[0],race_rank[1],host_time[query[3].to_i - 1] ])

    output_sep(Array[ "何号艇","モーター番号","ボート番号","フライング","出遅れ" ])

    for i in 1..6 do
      eval("output_sep(Array[ \"#{i.to_s}\",@motor_no#{i.to_s}[0],@boat_no#{i.to_s}[0],@fl#{i.to_s}[0],@fl#{i.to_s}[1]  ])")
    end



        #データベースアクセス
    connection = Mysql::connect("localhost", "root", "root", "boat") 
    # 文字コードをUTF8に設定
    connection.query("set character set utf8") 

    for i in 1..6 do
       puts(" insert into race_info(race_id,boat_no,reg_no,f,l,motor_no,body_no) values( \"#{query[1]+query[0]+query[2]}\" , \"#{i}\" , #{eval("@reg_no#{i.to_s}[0]")} , #{eval("@fl#{i.to_s}[0]")} , #{eval("@fl#{i.to_s}[1]")} , #{eval("@motor_no#{i.to_s}[0]")} , #{eval("@boat_no#{i.to_s}[0]")}) ")

       connection.query(" insert into race_info(race_id,boat_no,reg_no,f,l,motor_no,body_no) values( \"#{query[1]+query[0]+query[2]}\" , \"#{i}\" , #{eval("@reg_no#{i.to_s}[0]")} , #{eval("@fl#{i.to_s}[0]")} , #{eval("@fl#{i.to_s}[1]")} , #{eval("@motor_no#{i.to_s}[0]")} , #{eval("@boat_no#{i.to_s}[0]")}) ")
    end

    puts("insert into round_info(race_id,host_time,race_type,race_grade,stabilizer) values( \"#{query[1]+query[0]+query[2]}\" , \"#{host_time[query[3].to_i-1]}\" , \"#{race_type[0]}\" , \"#{race_rank[1]}\" , \"#{stabilizer[0]}\") ")

    connection.query("insert into round_info(race_id,host_time,race_type,race_grade,stabilizer) values( \"#{query[1]+query[0]+query[2]}\" , \"#{host_time[query[3].to_i-1]}\" , \"#{race_type[0]}\" , \"#{race_rank[1]}\" , \"#{stabilizer[0]}\") ")

    connection.close

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
  



  
#ruby_ver 日付 開催場指定
from_date = Param::From_date
to_date = Param::To_date


race_place = Param::Place

print("\n\n\n\n\n\n\nget_race_table.rb-----------------\n\n\n\n\n\n\n")

while from_date != to_date + 1 do
  
  date =  from_date.iso8601
  date.tr!("-","")
  mdate = date.to_i
  puts date

  Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index?" + "hd=" + date , :depth_limit => 2, :delay => 1) do |anemone|
    anemone.focus_crawl do |page|
      page.links.keep_if { |link|
        link.to_s.match(/(\/racelist)(.)*jcd=#{race_place}(.)*hd=#{mdate}$/)
      }
    end
  
    anemone.on_pages_like(/\/racelist/) do |page|
      puts "\n\n-------------------------------------------------------------------\n\n" 
      puts page.url.to_s
      #urlから場、ラウンド、日時を抜き出す。
      query = page.url.query #URI::Generic#query
      query.tr!('a-z',"")
      query.tr!("=","")
      query = query.split("&") 
      #数字の先頭に0
      query << query[0]
      query[0] = format("%02d", query[0]) 
      #puts("レース場\tラウンド\t日時")
      puts "#" + query[1] + Param::prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]

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

#終了時アラームをならす
for i in 1..5 do
  `afplay /System/Library/Sounds/Ping.aiff`
end

