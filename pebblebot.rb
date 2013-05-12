#!/usr/bin/env ruby
require 'faraday'
require 'json'
require 'time'
require "twitter"

class Send

  def initialize(info, user="adambird")
    @info = info
    @user = user
  end

  def execute
    Twitter.update("D #{user} #{@info} #{Time.now}") rescue Twitter::Error
    puts "sent message to #{@user}"
  end
end

class WeatherForecast

  def api_key
    ENV['MET_OFFICE_API_KEY']
  end

  def forecast_path(location)
    "/public/data/val/wxfcs/all/json/#{location}?res=daily&key=#{api_key}"
  end

  def get_forecast(location)
    conn = Faraday.new(url: "http://datapoint.metoffice.gov.uk")
    response = conn.get(forecast_path(location))
    Report.new(JSON.parse(response.body, symbolize_names: true)[:SiteRep][:DV])
  end

  def to_message
    # 350299 is Met office location for Beeston
    forecast = get_forecast(350299)
    [ 
      "#{forecast.today_date} - #{forecast.location_name}",
      "#{forecast.today_temp} #{forecast.today_weather_type}",
      "#{forecast.today_wind}",
      "#{forecast.today_rain}"
    ].join("\n")
  end

  class Report
    def initialize(data)
      @data = data
    end

    def today
      @data[:Location][:Period][0]
    end

    def today_date
      Date.parse(today[:value]).strftime("%a %d")
    end

    def today_day_report
      today[:Rep][0]
    end

    def today_wind
      "#{today_day_report[:S]}mph #{today_day_report[:D]}"
    end

    def today_temp
      "#{today_day_report[:Dm]}C"
    end

    def today_rain
      "Rain #{today_day_report[:PPd]}%"
    end

    def today_weather_type
      "#{resolve_weather_type(today_day_report[:W])}"
    end

    def location_name
      @data[:Location][:name].split[0]
    end

    def resolve_weather_type(code)
      {
        "NA" => "Not available",
        "0" => "Clear night",
        "1" => "Sunny day",
        "2" => "Partly cloudy (night)",
        "3" => "Partly cloudy (day)",
        "4" => "Not used",
        "5" => "Mist",
        "6" => "Fog",
        "7" => "Cloudy",
        "8" => "Overcast",
        "9" => "Light rain shower (night)",
        "10" => "Light rain shower (day)",
        "11" => "Drizzle",
        "12" => "Light rain",
        "13" => "Heavy rain shower (night)",
        "14" => "Heavy rain shower (day)",
        "15" => "Heavy rain",
        "16" => "Sleet shower (night)",
        "17" => "Sleet shower (day)",
        "18" => "Sleet",
        "19" => "Hail shower (night)",
        "20" => "Hail shower (day)",
        "21" => "Hail",
        "22" => "Light snow shower (night)",
        "23" => "Light snow shower (day)",
        "24" => "Light snow",
        "25" => "Heavy snow shower (night)",
        "26" => "Heavy snow shower (day)",
        "27" => "Heavy snow",
        "28" => "Thunder shower (night)",
        "29" => "Thunder shower (day)",
        "30" => "Thunder"
      }[code]
    end
  end
end


case ARGV[0]
when "weather" || "w"
  Send.new(WeatherForecast.new.to_message).execute
else
  puts <<-EOF
Unrecognosed command

Usage: 
  pebblebot w | weather
EOF
end


