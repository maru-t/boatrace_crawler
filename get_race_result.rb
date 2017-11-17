#get_race_result.rb 結果を取得し、データベースに格納する

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'
require './param.rb'

#class Get_result

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
  def get_result(doc,query)
    
    #レース結果
    boat1 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[1]",doc)
    boat2 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[2]",doc)
    boat3 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[3]",doc)
    boat4 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[4]",doc)
    boat5 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[5]",doc)
    boat6 = adjust_data("//html/body/main/div/div/div/div[2]/div[4]/div[1]/div/table/tbody[6]",doc)
    
    #スタート
    start_s1 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[1]",doc).unshift("1")
    start_s2 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[2]",doc).unshift("2")
    start_s3 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[3]",doc).unshift("3")
    start_s4 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[4]",doc).unshift("4")
    start_s5 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[5]",doc).unshift("5")
    start_s6 = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div/table/tbody/tr[6]",doc).unshift("6")
    
    #払い戻し
    p3tan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[1]",doc)
    p3puku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[2]",doc)
    p2tan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[3]",doc)
    p2puku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[4]",doc)
    pkaku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[5]",doc)
    ptan = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[6]",doc)
    ppuku = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[1]/div/table/tbody[7]",doc)
    
    #天気
    weather = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[1]/div/div[1]",doc)
    
    if weather[0] != "" then
      weather_s = [weather[1], weather[2], weather[4], weather[6], weather[8]]
    else
      weather_s = []
    end
    
    #決まり手
    win_tec = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[2]/table/tbody/tr/td",doc)
    
    #返還
    return_money = adjust_data("/html/body/main/div/div/div/div[2]/div[5]/div[2]/div[1]/div[2]/div[1]/table/tbody",doc)
    
    #出力
    #データがあるか(レースが行われたか)
    if boat1 != [] then
    
      puts("結果")
      puts("順位\t艇番\t登録No\t名前\t\tタイム")
      output_sep(boat1)
      output_sep(boat2)
      output_sep(boat3)
      output_sep(boat4)
      output_sep(boat5)
      output_sep(boat6)
     
      puts("\nスタート")
      puts("進入\t艇番\tスタートタイム")
      output_sep(start_s1)
      output_sep(start_s2)
      output_sep(start_s3)
      output_sep(start_s4)
      output_sep(start_s5)
      output_sep(start_s6)
    
      puts("\n水面気象情報")
      puts("気温\t天気\t風速\t水温\t波")
      puts weather_s.join("\t")
    
      puts("\n払い戻し")
      puts("勝式\t組番\t払戻金\t人気")
      output_sep(p3tan)
      output_sep(p3puku)
      output_sep(p2tan)  
      output_sep(p2puku)
      output_sep(pkaku)
      output_sep(ptan)  
      output_sep(ppuku)  
     
      puts "\n決まり手"
      output_sep(win_tec)
    
      puts"\n返還"
      output_sep(return_money)
    
    
    
      #データベースアクセス
      connection = Mysql::connect("localhost", "root", "root", "boat")
    
      # 文字コードをUTF8に設定
      connection.query("set character set utf8")
    
      # DBに問い合わせ
      weather_s[0].tr!("℃","")
      weather_s[2].tr!("m","")
      weather_s[3].tr!("℃","")
      weather_s[4].tr!("cm","")
    
      #start_sとboatの結合処理
      race_rank = [boat1[1], boat2[1], boat3[1], boat4[1], boat5[1], boat6[1]]
      race_sinnyu = [start_s1[0], start_s2[0], start_s3[0], start_s4[0], start_s5[0], start_s6[0]]
      race_cource = [start_s1[1], start_s2[1], start_s3[1], start_s4[1], start_s5[1], start_s6[1]]
      race_sttime = [start_s1[2], start_s2[2], start_s3[2], start_s4[2], start_s5[2], start_s6[2]]
      
      course = Array.new(6)
      st_time = Array.new(6)
      
      for i in 0..5 do
        for j in 0..5 do
          if race_rank[i] == race_cource[j] then
            course[i] = race_sinnyu[j]
            if race_sttime[j].include?("F") then
              st_time[i] = race_sttime[j].tr!("F","-")
            else
              st_time[i] = race_sttime[j]
            end
          end
        end
      end
      
      #払い戻しデータ調整 yencomdel(String);エンマークとコンマを削除
      p3tan[2] = yencomdel(p3tan[2])
      p3puku[2] = yencomdel(p3puku[2])
      p2tan[2] = yencomdel(p2tan[2])
      p2puku[2] = yencomdel(p2puku[2])
      pkaku[2] = yencomdel(pkaku[2])
      pkaku[5] = yencomdel(pkaku[5])
      pkaku[8] = yencomdel(pkaku[8])
      ptan[2] = yencomdel(ptan[2])
      ppuku[2] = yencomdel(ppuku[2])
      ppuku[4] = yencomdel(ppuku[4])
       
      
      #出力確認用
           
      #race_info insert into
=begin
       puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat1[1]}\", \"#{boat1[0]}\", \"#{boat1[2]}\", \"#{boat1[5]}\", \"#{course[0]}\", \"#{st_time[0]}\" )")
      puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat2[1]}\", \"#{boat2[0]}\", \"#{boat2[2]}\", \"#{boat2[5]}\", \"#{course[1]}\", \"#{st_time[1]}\" )")
      puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat3[1]}\", \"#{boat3[0]}\", \"#{boat3[2]}\", \"#{boat3[5]}\", \"#{course[2]}\", \"#{st_time[2]}\" )")
      puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat4[1]}\", \"#{boat4[0]}\", \"#{boat4[2]}\", \"#{boat4[5]}\", \"#{course[3]}\", \"#{st_time[3]}\" )")
      puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat5[1]}\", \"#{boat5[0]}\", \"#{boat5[2]}\", \"#{boat5[5]}\", \"#{course[4]}\", \"#{st_time[4]}\" )")
      puts("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat6[1]}\", \"#{boat6[0]}\", \"#{boat6[2]}\", \"#{boat6[5]}\", \"#{course[5]}\", \"#{st_time[5]}\" )")
      
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat1[1]}\", \"#{boat1[0]}\", \"#{boat1[2]}\", \"#{boat1[5]}\", \"#{course[0]}\", \"#{st_time[0]}\" )")
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat2[1]}\", \"#{boat2[0]}\", \"#{boat2[2]}\", \"#{boat2[5]}\", \"#{course[1]}\", \"#{st_time[1]}\" )")
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat3[1]}\", \"#{boat3[0]}\", \"#{boat3[2]}\", \"#{boat3[5]}\", \"#{course[2]}\", \"#{st_time[2]}\" )")
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat4[1]}\", \"#{boat4[0]}\", \"#{boat4[2]}\", \"#{boat4[5]}\", \"#{course[3]}\", \"#{st_time[3]}\" )")
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat5[1]}\", \"#{boat5[0]}\", \"#{boat5[2]}\", \"#{boat5[5]}\", \"#{course[4]}\", \"#{st_time[4]}\" )")
      connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{boat6[1]}\", \"#{boat6[0]}\", \"#{boat6[2]}\", \"#{boat6[5]}\", \"#{course[5]}\", \"#{st_time[5]}\" )")
      
       #round_info insert into         
      puts("insert into round_info(race_id, place, round_no, day, temp, sky, wind, water_temp, wave, kimarite, 3tan_kumi, 3tan_money, 3tan_pop, 3puku_kumi, 3puku_money, 3puku_pop, 2tan_kumi, 2tan_money, 2tan_pop, 2puku_kumi, 2puku_money, 2puku_pop, kaku1_kumi, kaku1_money, kaku1_pop, kaku2_kumi, kaku2_money, kaku2_pop, kaku3_kumi, kaku3_money, kaku3_pop, tan_kumi, tan_money, fuku1_kumi, fuku1_money, fuku2_kumi, fuku2_money) values(\"#{query[1]+query[0]+query[2]}\", \"#{prace_name(query[1])}\", #{query[0].to_i}, \"#{query[2]}\", #{weather_s[0]}, \"#{weather_s[1]}\", #{weather_s[2]}, #{weather_s[3]}, #{weather_s[4]}, \"#{win_tec[0]}\", \"#{p3tan[1]}\", #{p3tan[2].to_i}, #{p3tan[3].to_i}, \"#{p3puku[1]}\", #{p3puku[2].to_i}, #{p3puku[3].to_i}, \"#{p2tan[1]}\", #{p2tan[2].to_i}, #{p2tan[3].to_i}, \"#{p2puku[1]}\", #{p2puku[2].to_i}, #{p2puku[3].to_i}, \"#{pkaku[1]}\", #{pkaku[2].to_i}, #{pkaku[3].to_i}, \"#{pkaku[4]}\", #{pkaku[5].to_i}, #{pkaku[6].to_i}, \"#{pkaku[7]}\", #{pkaku[8].to_i}, #{pkaku[9].to_i}, \"#{ptan[1]}\", #{ptan[2].to_i}, \"#{ppuku[1]}\", #{ppuku[2].to_i}, \"#{ppuku[3]}\", #{ppuku[4].to_i} )")
            
      connection.query("insert into round_info(race_id, place, round_no, day, temp, sky, wind, water_temp, wave, kimarite, 3tan_kumi, 3tan_money, 3tan_pop, 3puku_kumi, 3puku_money, 3puku_pop, 2tan_kumi, 2tan_money, 2tan_pop, 2puku_kumi, 2puku_money, 2puku_pop, kaku1_kumi, kaku1_money, kaku1_pop, kaku2_kumi, kaku2_money, kaku2_pop, kaku3_kumi, kaku3_money, kaku3_pop, tan_kumi, tan_money, fuku1_kumi, fuku1_money, fuku2_kumi, fuku2_money) values(\"#{query[1]+query[0]+query[2]}\", \"#{prace_name(query[1])}\", #{query[0].to_i}, \"#{query[2]}\", #{weather_s[0]}, \"#{weather_s[1]}\", #{weather_s[2]}, #{weather_s[3]}, #{weather_s[4]}, \"#{win_tec[0]}\", \"#{p3tan[1]}\", #{p3tan[2].to_i}, #{p3tan[3].to_i}, \"#{p3puku[1]}\", #{p3puku[2].to_i}, #{p3puku[3].to_i}, \"#{p2tan[1]}\", #{p2tan[2].to_i}, #{p2tan[3].to_i}, \"#{p2puku[1]}\", #{p2puku[2].to_i}, #{p2puku[3].to_i}, \"#{pkaku[1]}\", #{pkaku[2].to_i}, #{pkaku[3].to_i}, \"#{pkaku[4]}\", #{pkaku[5].to_i}, #{pkaku[6].to_i}, \"#{pkaku[7]}\", #{pkaku[8].to_i}, #{pkaku[9].to_i}, \"#{ptan[1]}\", #{ptan[2].to_i}, \"#{ppuku[1]}\", #{ppuku[2].to_i}, \"#{ppuku[3]}\", #{ppuku[4].to_i} )")
      
=end     

      #race_info insert
=begin
      for i in 1..6 do
        connection.query("insert into race_info(race_id, boat_no, race_rank, reg_no, race_time, h_course, h_st) values(\"#{query[1]+query[0]+query[2]}\", \"#{eval("boat#{i}[1]")}\",\"#{eval("boat#{i}[0]")}\", \"#{eval("boat#{i}[2]")}\", \"#{eval("boat#{i}[5]")}\", \"#{course[i-1]}\", \"#{st_time[i-1]}\" )")
      end
=end
      for i in 1..6 do
        puts("update race_info set race_rank = \"#{eval("boat#{i}[0]")}\", reg_no = \"#{eval("boat#{i}[2]")}\", race_time = \"#{eval("boat#{i}[5]")}\", h_course = \"#{course[i-1]}\", h_st = \"#{st_time[i-1]}\" where race_id = \"#{query[1]+query[0]+query[2]}\" AND boat_no = \"#{eval("boat#{i}[1]")}\" ")

        connection.query("update race_info set race_rank = \"#{eval("boat#{i}[0]")}\", reg_no = \"#{eval("boat#{i}[2]")}\", race_time = \"#{eval("boat#{i}[5]")}\", h_course = \"#{course[i-1]}\", h_st = \"#{st_time[i-1]}\" where race_id = \"#{query[1]+query[0]+query[2]}\" AND boat_no = \"#{eval("boat#{i}[1]")}\" ")
      end

      puts("update round_info set place = \"#{prace_name(query[1])}\", round_no = #{query[0].to_i}, day = \"#{query[2]}\", temp = #{weather_s[0]}, sky = \"#{weather_s[1]}\", wind = #{weather_s[2]}, water_temp = #{weather_s[3]}, wave = #{weather_s[4]}, kimarite = \"#{win_tec[0]}\", 3tan_kumi = \"#{p3tan[1]}\", 3tan_money = #{p3tan[2].to_i}, 3tan_pop = #{p3tan[3].to_i}, 3puku_kumi = \"#{p3puku[1]}\", 3puku_money = #{p3puku[2].to_i}, 3puku_pop = #{p3puku[3].to_i}, 2tan_kumi = \"#{p2tan[1]}\", 2tan_money = #{p2tan[2].to_i}, 2tan_pop = #{p2tan[3].to_i}, 2puku_kumi = \"#{p2puku[1]}\", 2puku_money = #{p2puku[2].to_i}, 2puku_pop = #{p2puku[3].to_i}, kaku1_kumi = \"#{pkaku[1]}\", kaku1_money = #{pkaku[2].to_i}, kaku1_pop = #{pkaku[3].to_i}, kaku2_kumi = \"#{pkaku[4]}\", kaku2_money = #{pkaku[5].to_i}, kaku2_pop = #{pkaku[6].to_i}, kaku3_kumi = \"#{pkaku[7]}\", kaku3_money = #{pkaku[8].to_i}, kaku3_pop = #{pkaku[9].to_i}, tan_kumi = \"#{ptan[1]}\", tan_money = #{ptan[2].to_i}, fuku1_kumi = \"#{ppuku[1]}\", fuku1_money = #{ppuku[2].to_i}, fuku2_kumi = \"#{ppuku[3]}\", fuku2_money = #{ppuku[4].to_i} where race_id = \"#{query[1]+query[0]+query[2]}\" ")

      connection.query("update round_info set place = \"#{prace_name(query[1])}\", round_no = #{query[0].to_i}, day = \"#{query[2]}\", temp = #{weather_s[0]}, sky = \"#{weather_s[1]}\", wind = #{weather_s[2]}, water_temp = #{weather_s[3]}, wave = #{weather_s[4]}, kimarite = \"#{win_tec[0]}\", 3tan_kumi = \"#{p3tan[1]}\", 3tan_money = #{p3tan[2].to_i}, 3tan_pop = #{p3tan[3].to_i}, 3puku_kumi = \"#{p3puku[1]}\", 3puku_money = #{p3puku[2].to_i}, 3puku_pop = #{p3puku[3].to_i}, 2tan_kumi = \"#{p2tan[1]}\", 2tan_money = #{p2tan[2].to_i}, 2tan_pop = #{p2tan[3].to_i}, 2puku_kumi = \"#{p2puku[1]}\", 2puku_money = #{p2puku[2].to_i}, 2puku_pop = #{p2puku[3].to_i}, kaku1_kumi = \"#{pkaku[1]}\", kaku1_money = #{pkaku[2].to_i}, kaku1_pop = #{pkaku[3].to_i}, kaku2_kumi = \"#{pkaku[4]}\", kaku2_money = #{pkaku[5].to_i}, kaku2_pop = #{pkaku[6].to_i}, kaku3_kumi = \"#{pkaku[7]}\", kaku3_money = #{pkaku[8].to_i}, kaku3_pop = #{pkaku[9].to_i}, tan_kumi = \"#{ptan[1]}\", tan_money = #{ptan[2].to_i}, fuku1_kumi = \"#{ppuku[1]}\", fuku1_money = #{ppuku[2].to_i}, fuku2_kumi = \"#{ppuku[3]}\", fuku2_money = #{ppuku[4].to_i} where race_id = \"#{query[1]+query[0]+query[2]}\" ")


      #puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]
            
      # コネクションを閉じる
      connection.close
    end
          
  end
  
#end  
  
  
  
  
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
  



#=begin  
  
#ruby_ver
from_date = Param::From_date
to_date = Param::To_date

race_place = ""

print("\n\n\n\n\n\n\nget_race_result.rb-----------------\n\n\n\n\n\n\n")

while from_date != to_date + 1 do
  
  date =  from_date.iso8601
  date.tr!("-","")
  mdate = date.to_i
  puts date

  Anemone.crawl("https://www.boatrace.jp/owpc/pc/race/index?" + "hd=" + date , :depth_limit => 2, :delay => 1) do |anemone|
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
      puts "#" + query[1] + prace_name(query[1]) + SEPALATER + query[0] + "R" + SEPALATER + query[2]
      
      #データベースアクセス
      connection = Mysql::connect("localhost", "root", "root", "boat") 
      # 文字コードをUTF8に設定
      connection.query("set character set utf8") 


      get_result(page.doc,query)
=begin
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

#=end
