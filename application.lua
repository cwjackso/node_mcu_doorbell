-- file : application.lua
local module = {} 
m = nil

triggered = false

-- Sends my id to the broker for registration
local function send_message()  
    m:publish(config.ENDPOINT,"on", 0, 0, function(conn)
        print("Successfully sent message")

        buzzer.start();
        
        tmr.create():alarm(5000, tmr.ALARM_SINGLE, function() 
            triggered = false
          end
        )
    end)
end

local function mqtt_start()
    -- m = mqtt.Client(config.ID, 120, config.USER, config.PASSWORD)
    m = mqtt.Client(config.ID, 120, config.USER, config.PASSWORD)
    print("client setup")
    
-- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 0, function(con) 
        print("connected to mqtt broker")
        send_message()
    end,
    function(con, reason) 
        print("failed to connect " .. reason)
    end) 

end

local function debounce()
    if triggered == false then
        triggered = true
        mqtt_start()
    end
end

function module.start()  

  print("Starting app")
  
  gpio.mode(1,gpio.INT, gpio.PULLUP)

  print("Setting up trig event")
  gpio.trig(1, "both", debounce)
  
end

return module  
