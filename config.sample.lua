-- file : config.lua
local module = {}

module.wifi = {}
module.wifi.ssid = "wifi"
module.wifi.pwd = "password"
  
module.HOST = "mqtthost"  
module.USER = "mqttuser"
module.PASSWORD = "mqttpass"
module.PORT = 9999
module.ID = node.chipid()

module.ENDPOINT = "mqtt/topic"  
return module  
