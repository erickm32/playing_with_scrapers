require 'json'
require 'httparty'
require 'nokogiri'

puts 'navigating...'
url = "https://www.in.gov.br/leiturajornal?secao=dou3&data=#{Time.now.strftime('%d-%m-%Y')}"
response = HTTParty.get(url)

if response.success?
  html = Nokogiri::HTML(response.body)
  script_tag = html.css('script#params')
  data = JSON.parse(script_tag.text)['jsonArray']
  related_data = data
                 .filter { |d| d['hierarchyStr'].include?('Ministério da Gestão e da Inovação') }
                 .map { |d| d['content'] }
  pp related_data

  5.times { pp '' }

  puts 'looking for Convocação'
  filtered = related_data.filter { |d| d.include?('Convocação') }
  puts "found #{filtered.length} matches"
  filtered.each { |d| pp d }

else
  pp 'failed to reach'
  pp response.inspect
end
