require 'selenium-webdriver'
require 'httparty'
require 'pdf-reader'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for(:chrome, options:)

url = "https://www.in.gov.br/leiturajornal?secao=dou3&data=#{Date.today.strftime('%d-%m-%Y')}"
other_filters = '&org=Minist%C3%A9rio%20da%20Gest%C3%A3o%20e%20da%20Inova%C3%A7%C3%A3o%20em%20Servi%C3%A7os%20P%C3%BAblicos&org_sub=Secretaria%20de%20Servi%C3%A7os%20Compartilhados&ato=Edital'
driver.navigate.to url + other_filters

pp 'sleeping...'
sleep(5)

pp 'looking for css...'
# driver.find_elements(:css, '#hierarchy_content > ul > li > div') or
search_results = driver.find_elements(:css, '.resultado')

pp search_results.map(&:text)

driver.close
