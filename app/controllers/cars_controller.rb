class CarsController < ApplicationController
	def index

		
	
		@hash = {}
		if params['url'].present?

		begin
		require 'nokogiri'
		require 'open-uri'
		# url = 'https://uae.yallamotor.com/new-cars/toyota'
		url = params['url']
		car_type = url.split('/')[url.split('/').size - 1]
		doc = Nokogiri::HTML(open(url))
		counter = 0
			(0..((doc.search('div#'+car_type+'2020 div div.list-models').count) - 1)).each do |index|
			
				href = doc.search('div#'+car_type+'2020 div div.list-models h3.pro-name')[index].children[1].attributes['href'].value rescue ""
				name = doc.search('div#'+car_type+'2020 div div.list-models h3.pro-name')[index].children[1].children[0].text rescue ""
				price = doc.search('div#'+car_type+'2020 div div.list-models div.pro-pice')[index].children[2].text rescue ""
				
				href = href.split('/')
				
				ver = Nokogiri::HTML(open('https://uae.yallamotor.com/new-cars/'+car_type+'/'+href[href.size - 1]))
				
				@hash[counter] = ["Car Model", name, price]
				counter = counter + 1
				(0..((ver.search("div.panel-white div.gutter-5 div.col-md-9 div.match-version").count) - 1)).each do |i|
					ver_name = ver.search("div.panel-white div.gutter-5 div.col-md-9 div.match-version div.version-head h3.pro-name")[i].children[1].text
					ver_price = ver.search("div.panel-white div.gutter-5 div.col-md-9 div.match-version div.version-head span.pro-pice")[i].text
					@hash[counter] = ["Car Version", ver_name, price]
					counter = counter + 1
				end
				
			end
		rescue => ex
			@hash[0] = ["No Data","No Data","No Data"]
		end
		end
		puts "fefef"
	end
end
