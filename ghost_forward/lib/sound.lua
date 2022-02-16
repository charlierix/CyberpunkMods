function PlaySound(name)
    local audioEvent = SoundPlayEvent.new()
    audioEvent.soundName = name
    Game.GetPlayer():QueueEvent(audioEvent)
end

function StopSound(name)
    local audioEvent = SoundStopEvent.new()
    audioEvent.soundName = name
    Game.GetPlayer():QueueEvent(audioEvent)
end