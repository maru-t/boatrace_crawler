require 'open-uri'

require 'nokogiri'

#スペース、改行、タブ、全角を半角にして返す
def mtrim(text)
        text.gsub!(/\\n|\\r|\\t/," ")
        text.gsub!(/[[:space:]]/," ")
        text.tr!("　"," ")
        text.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
        text.gsub!(/\s+/," ")
        text = text.split(" ")
        return text
end


doc = Nokogiri::HTML(open("https://www.boatrace.jp/owpc/pc/race/raceresult?rno=12&jcd=01&hd=20170827"))

puts doc.title


rank = doc.xpath("//td[@class='is-fs14']")
cource = doc.xpath("//td[@class='is-fs14 is-fBold is-boatColor1']")
racer_num = doc.xpath("//span[@class='is-fs12']")
racer_name = doc.xpath("//span[@class='is-fs18 is-fBold']")
racetime = doc.xpath("//span[@class='is-fs18 is-fBold']/../td")


puts '着順'

result = doc.xpath("//div[@class='grid_unit']")

result.each do |result|
  puts mtrim(result.text)
end
