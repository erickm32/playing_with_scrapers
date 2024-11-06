require 'selenium-webdriver'
require 'nokogiri'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for(:chrome, options:)

pp 'opened, navigating...'
url = "https://www.in.gov.br/leiturajornal?secao=dou3&data=#{Date.today.strftime('%d-%m-%Y')}"
# other_filters = '&org=Minist%C3%A9rio%20da%20Gest%C3%A3o%20e%20da%20Inova%C3%A7%C3%A3o%20em%20Servi%C3%A7os%20P%C3%BAblicos&org_sub=Secretaria%20de%20Servi%C3%A7os%20Compartilhados&ato=Edital'
# driver.navigate.to url + other_filters
driver.navigate.to url

pp 'sleeping...'
sleep(3)

# pp 'clicking stuff'
# # driver.find_element(:css, '#slcOrgs').click
# # sleep(0.5)

# driver.find_element(:css, '#slcOrgs > option[value~=Gestão] ').click
# sleep(0.5)

# pp 'looking for css...'
# # driver.find_elements(:css, '#hierarchy_content > ul > li > div') or
# search_results = driver.find_elements(:css, '.resultado')

# pp search_results.map(&:text)

html = Nokogiri::HTML(driver.page_source)
script_tag = html.css('script#params')
data = JSON.parse(script_tag.text)['jsonArray']
related_data = data
               .filter { |d| d['hierarchyStr'].include?('Ministério da Gestão e da Inovação') }
               .map { |d| d['content'] }
pp related_data

5.times { pp '' }

related_data.filter { |d| d.include?('Convocação') }.each { |d| pp d }

driver.close
