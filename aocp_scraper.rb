require 'selenium-webdriver'
require 'httparty'
require 'pdf-reader'

def update_local_pdf_files(fetched)
  fetched.each do |pdf|
    file_name = pdf.split('/').last

    next if File.exist?(file_name)

    pp "saving #{file_name}"

    file = File.open(file_name, 'wb')

    response = HTTParty.get(pdf)
    sleep(1)
    file.write(response.body)
    file.close
  end
end

def read_pdfs_content(fetched)
  require_attention = []
  fetched.each do |pdf|
    file_name = pdf.split('/').last

    pp "processing #{file_name}"

    File.open(file_name, 'rb') do |f|
      reader = PDF::Reader.new(f)
      pp 'first 1000 chars'
      puts reader.pages[0].text.gsub('  ', '')[0..1000]
      pp ''

      reader.pages.each do |page|
        if page.text.include?('Fernandes Moreira')
          5.times { pp "mentioned on page #{page.number} of #{file_name}" }
          require_attention << [file_name, page.number]
        end
      end
      pp "end of #{file_name}"
      pp ''
    end
  end
  require_attention
end

def fetch_new_pdf_links
  options = Selenium::WebDriver::Chrome::Options.new
  # options.add_argument('--headless')
  driver = Selenium::WebDriver.for(:chrome, options:)

  driver.navigate.to 'https://www.institutoaocp.org.br/concursos/612'

  sleep(2)

  anchors = driver.find_elements(:css, 'a')
  urls = anchors.map { |a| a.attribute('href') }
  pdfs = urls.filter { |url| url.end_with?('.pdf') }

  driver.close

  pdfs[0..5]
end

local_pdfs = File.open('aocp_pdfs.txt', 'a+')
pdfs_readed = JSON.parse(local_pdfs.eof? ? '[]' : local_pdfs.read)

# if pdfs_readed != []
fetched = fetch_new_pdf_links
if pdfs_readed != fetched
  local_pdfs.flush
  local_pdfs.write(fetched.to_json)

  update_local_pdf_files(fetched)
  result = read_pdfs_content(fetched)
  pp 'pay attention to:'
  pp result
else
  pp 'No new pdf file'
end
# else
#   pp 'No content, fetching the initial data'
#   local_pdfs.flush
#   local_pdfs.write(fetch_new_pdf_links.to_json)
# end
