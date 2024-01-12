require 'net/http'
require 'json'

class HomeController < ApplicationController
  def index
  end

  def search
 
    if params[:category].present?
      selected_category_id = params[:category]
      selected_category = Category.find(selected_category_id)
      @category_name = selected_category.name

      api_key = ENV['API_KEY']
      url = URI("https://api.pexels.com/v1/search?query=#{@category_name}")
        
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = api_key

      response = http.request(request)

      if response.code == '200'
        photos_data = JSON.parse(response.body)
        @photos = photos_data['photos']
      else
        @error_message = "Error: #{response.code}, #{response.message}"
        puts @error_message
      end
    end
      respond_to do |format|
        format.html { render 'index' } 
    end
  end 

end
