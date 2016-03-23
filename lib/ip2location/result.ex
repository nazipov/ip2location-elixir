defmodule IP2Location.Result do
  defstruct [
    :country,
    :country_long, 
    :region, 
    :city, 
    :isp, 
    :latitude, 
    :longitude, 
    :domain, 
    :zipcode, 
    :timezone, 
    :netspeed, 
    :iddcode, 
    :areacode, 
    :weatherstationcode, 
    :weatherstationname, 
    :mcc, 
    :mnc, 
    :mobilebrand, 
    :elevation, 
    :usagetype
  ]
end