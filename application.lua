-- file : application.lua
local module = {} 
m = nil

triggered = false

-- Sends a simple ping to the broker
local function send_ping()  
    m:publish(config.ENDPOINT .. "ping","id=" .. config.ID,0,0)
end

-- Sends my id to the broker for registration
local function send_message()  
    m:publish(config.ENDPOINT,"on", 0, 0, function(conn)
        print("Successfully sent message")

        beep(2)
        
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

function beep(pin)
    local freq = 523
    print ("Beeping")
    a=1

    local high = true
    
    while( a < 50 )
    do
        if high == true then 
            tmr.delay(5000)
            gpio.write(pin, gpio.HIGH)
            tmr.delay(30000)
            gpio.write(pin, gpio.LOW)
            high = false  
        else
            tmr.delay(30000)
            gpio.write(pin, gpio.HIGH)
            tmr.delay(5000)
            gpio.write(pin, gpio.LOW)
            high = true
        end
        --tmr.delay(20000)
        a = a+1
    end
    print ("Beeping done")

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

  
  gpio.mode(2,gpio.OUTPUT)

  print("Setting up trig event")
  gpio.trig(1, "both", debounce)
  
end

return module  
