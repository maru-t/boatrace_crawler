#get_race_result.rb 結果を取得し、データベースに格納する
#https://www.boatrace.jp/owpc/pc/race/beforeinfo?rno=12&jcd=04&hd=20180315

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'
require './param.rb'

#class Get_preinfo
  
  #スペース、改行、タブ、全角を半角にして返す。スペース改行、複数タブ区切りで配列にする
  def mtrim(text)
          text.gsub!(/\\n|\\r|\\t/," ")
          text.gsub!(/[[:space:]]/," ")
          text.tr!("　"," ")
          text.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
          text.gsub!(/\s+/,Param::SEPALATER)
          text.gsub!(/^\t/,"")
          text.gsub!("\"","\'")
          text = text.split(Param::SEPALATER)
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
      print(data + Param::SEPALATER) 
    }
    puts
  end
  
  
  
  #それぞれのwebページに行うデータを抜き出す処理
  def get_preinfo(doc,query)
   
     
    output_sep(Array["体重","展示タイム","チルト","ペラ交換","部品交換"])
    for i in 1..6 do
      weight = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[4]",doc)
      tenji_time = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[5]",doc)
      tilt = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[6]",doc)
      pera = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[7]",doc)
      parts_change = adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[1]/div[1]/table/tbody[#{i.to_s}]/tr[1]/td[8]/ul",doc)

      if weight[0].nil? then

      elsif
        weight[0].tr!("kg","")
      end

      if pera.to_s == "ヤ→ヤ(新)" then
        perae = "新"
        puts("a")
      else
        perae = pera
        puts("b")
      end
      puts(pera)

      eval("@weight#{i.to_s} = weight")
      eval("@tenji_time#{i.to_s} = tenji_time")
      eval("@tilt#{i.to_s} = tilt")
      eval("@pera#{i.to_s} = perae")
      eval("@parts_change#{i.to_s} = parts_change")

      output_sep(Array[weight.to_s,tenji_time.to_s,tilt.to_s,perae.to_s,parts_change.to_s])
    end

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #puts(adjust_data("/html/body/main/div/div/div/div[2]/div[4]/div[2]/div[1]/table/tbody/tr[1]",doc))


    for i in 1..6 do 
      eval("@st_tmp = adjust_data(\"/html/body/main/div/div/div/div[2]/div[4]/div[2]/div[1]/table/tbody/tr[#{i.to_s}]\",doc)")
      for j in 1..6 do
        if @st_tmp[0] == j.to_s then
          eval("@t_course#{j} = i")#iコースはj号艇 t_course1=1号艇の進入コース
          if @st_tmp[1].include?("F") then
            eval("@t_st#{j} = @st_tmp[1].tr(\"F\",\"-\")")
          else
            eval("@t_st#{j} = @st_tmp[1]")
          end
        end
      end
      output_sep(@st_tmp)
    end

=begin 何のためかわからん
    for i in 1..6 do
      eval("@t_st#{i}.trim")
    end
=end

=begin スタート順 sort
    stNo = Array[@t_st1,@t_st2,@t_st3,@t_st4,@t_st5,@t_st6]
    for i in 2..6 do
      if eval("@t_course#{i}") > max then
        max = eval("@t_course#{i}.tr!(\"\",\"\")") 
      elsif eval("@t_course#{i}") == max then

      end
    end
=end

    output_sep(Array["展示進入コース","スタートタイミング"])

    for i in 1..6 do
      eval("puts(@t_course#{i})")
      eval("puts(@t_st#{i})")
    end


    #データベースアクセス
    connection = Mysql::connect("localhost", "root", "root", "boat") 
    # 文字コードをUTF8に設定
    connection.query("set character set utf8") 

    for i in 1..6 do
      if eval("@weight#{i}[0].nil?") then
      elsif
        eval("@weight#{i}[0].tr!('kg','')")
      end

      #connection.query("insert into race_info(race_id,boat_no,weight,tilt,t_time,pera_change,parts_change) values(\"#{query[1]+query[0]+query[2]}\",\"#{i}\",#{eval("@weight#{i}[0].to_i")},#{eval("@tilt#{i}[0].to_f")},#{eval("@tenji_time#{i}[0].to_f")},\"#{eval("@pera#{i}[0]")}\",\"#{eval("@parts_change#{i}[0]")}\"   )")

      puts("update race_info set weight = #{eval("@weight#{i}[0].to_i")} , tilt = #{eval("@tilt#{i}[0].to_f")} ,t_course = \"#{eval("@t_course#{i}")}\" ,t_st = \"#{eval("@t_st#{i}")}\", t_time = #{eval("@tenji_time#{i}[0].to_f")} , pera_change = \"#{eval("@pera#{i}[0]")}\" , parts_change = \"#{eval("@parts_change#{i}[0]")}\"  where race_id = \"#{query[1]+query[0]+query[2]}\" AND boat_no = \"#{i}\" ")

      connection.query("update race_info set weight = #{eval("@weight#{i}[0].to_i")} , tilt = #{eval("@tilt#{i}[0].to_f")} ,t_course = \"#{eval("@t_course#{i}")}\" ,t_st = \"#{eval("@t_st#{i}")}\", t_time = #{eval("@tenji_time#{i}[0].to_f")} , pera_change = \"#{eval("@pera#{i}[0]")}\" , parts_change = \"#{eval("@parts_change#{i}[0]")}\"  where race_id = \"#{query[1]+query[0]+query[2]}\" AND boat_no = \"#{i}\" ")
    end
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
  



  
#ruby_ver
from_date = Param::From_date
to_date = Param::To_date

race_place = Param::Place

print("\n\n\n\n\n\n\nget_pre_info.rb-----------------\n\n\n\n\n\n\n")

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
      puts "#" + query[1] + Param::prace_name(query[1]) + Param::SEPALATER + query[0] + "R" + Param::SEPALATER + query[2]


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

