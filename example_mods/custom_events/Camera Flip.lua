-- Event created by GatitoDev!
-- Enjoy this event :3

StartStop = 0
Speed = 0 --This is not used

function onUpdate()

    if StartStop == 1 then
        doTweenAngle('rotate', 'camera', 180, 0.2, 'linear')
    end

    if StartStop == 2 then
        doTweenAngle('rotate', 'camera', 0, 0.2, 'linear')
    end
end

function onEvent(name, value1, value2)
    if name == 'Camera Flip' then
        StartStop = tonumber(value1)
        Speed = tonumber(value2)
    end
end