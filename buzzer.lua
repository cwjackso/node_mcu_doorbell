local module = {}

buzzerPin = 2
gpio.mode(buzzerPin, gpio.OUTPUT)

tones = {}

tones["aS"] = 880
tones["cS"] = 523
tones["eS"] = 659

tune = tmr.create()
tune:register(1000, tmr.ALARM_AUTO, function() play() end )

function beep(pin, tone, duration)
    local freq = tones[tone]
    print ("Frequency:" .. freq)
    pwm.setup(pin, freq, 512)
    pwm.start(pin)
    -- delay in uSeconds
    tmr.delay(duration * 1000)
    pwm.stop(pin)
    --20ms pause
    tmr.wdclr()
    tmr.delay(20000)
end

function play()
    beep(buzzerPin, "cS", 100)
    beep(buzzerPin, "eS", 100)
    beep(buzzerPin, "aS", 100)
end

function module.start()

    tune:start()
    
    tmr.create():alarm(5000, tmr.ALARM_SINGLE, function() 
        tune:stop()
      end
    )
end

return module