#main.rb ボートレースクローラ中心部

require 'open-uri'
require 'nokogiri'
require 'anemone'
require 'uri'
require 'date'
require 'mysql'
require '/Users/taka/boatrace_crawler/ruby/get_race_result.rb'
require './param.rb'

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
mdate = 20170912
date = mdate.to_s 
=end



#ruby_ver
from_date = Param::From_date
to_date = Param::To_date

race_place = ""
result = Get_result.new()


while from_date != to_date + 1 do
  
  date =  from_date.iso8601
  date.tr!("-","")
  mdate = date.to_i
  puts date



  from_date = from_date + 1
end


#終わったら音をならす
for i in 1..5 do
  `afplay /System/Library/Sounds/Ping.aiff`
end
 

