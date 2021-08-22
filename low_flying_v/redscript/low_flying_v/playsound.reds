// These are some more advanced audio functions
//SoundParameterEvent  (wrapped in a function GameObject.SetAudioParameter)
//SoundSwitchEvent  (this is only used in a few spots for damage.  damageSwitch.switchName = n"SW_Impact_Velocity"; and then a value, one of: damageSwitch.switchValue = n"SW_Impact_Velocity_Hi";  n"SW_Impact_Velocity_Med" n"SW_Impact_Velocity_Low")

@addMethod(PlayerPuppet)
public func LowFlyingV_QueueSound(sound: CName) -> Void {
    if !IsNameValid(sound) {
        //Log("Invalid Name: " + NameToString(sound));
        return;
    }

    //Log("Queuing: " + NameToString(sound));

    let audioEvent: ref<SoundPlayEvent>;
    audioEvent = new SoundPlayEvent();
    audioEvent.soundName = sound;
    this.QueueEvent(audioEvent);

    //Log("Queued: " + NameToString(sound));
}

@addMethod(PlayerPuppet)
public func LowFlyingV_StopQueuedSound(sound: CName) -> Void {
    if !IsNameValid(sound) {
        //Log("Invalid Name: " + NameToString(sound));
        return;
    }

    //Log("Stopping: " + NameToString(sound));

    let evt: ref<SoundStopEvent>;
    evt = new SoundStopEvent();
    evt.soundName = sound;
    this.QueueEvent(evt);

    //Log("Stopped: " + NameToString(sound));
}


// It seems like the queued way of playing sounds is better.  Sounds played through this method probably
// aren't meant to come from a particlar spot.  Not sure if different sounds are meant for one method or
// the other
// @addMethod(PlayerPuppet)
// public func LowFlyingV_PlaySound(sound: CName) -> Void {
//     if !IsNameValid(sound) {
//         Log("Invalid Name: " + NameToString(sound));
//         return;
//     }

//     Log("Playing: " + NameToString(sound));

//     GameInstance.GetAudioSystem(this.GetGame()).Play(sound);

//     Log("Played: " + NameToString(sound));
// }

// @addMethod(PlayerPuppet)
// public func LowFlyingV_StopSound(sound: CName) -> Void {
//     if !IsNameValid(sound) {
//         Log("Invalid Name: " + NameToString(sound));
//         return;
//     }

//     Log("Stopping: " + NameToString(sound));

//     GameInstance.GetAudioSystem(this.GetGame()).Stop(sound);

//     Log("Stopped: " + NameToString(sound));
// }
