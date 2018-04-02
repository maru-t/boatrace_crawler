

class Param
  SEPALATER = "\t"

  From_date = Date.today
  To_date = Date.today

#  From_date = Date.new(2018,3,17)
#  To_date = Date.new(2018,3,20)

  #2017/01/01 ~ 2017/02/07
  #2018/01/01 ~ 2018/01/15
  #2018/03/14 ~ 2018/03/16

  #2018/04/01 ~ cronでやってる

  Place = ""

  #2014~5019 (2017-12-13)
  From_toban = 3553
  To_toban = 5050

  #番号からレース場の名前を返す
  def self.prace_name(num)
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
  


  def self.race_grade(text)
    case text
    when "is-ippan" then
      return "一般"
    when "is-G3b" then
      return "G3"
    when "is-G2b" then
      return "G2"
    when "is-G1b" then
      return "G1"
    when "is-SGa" then
      return "SG"
    else
      return "何かがおかしい"
    end
  end


end
