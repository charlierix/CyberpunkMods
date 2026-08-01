core of the tester:
```lua
    -- Build WorldTransform with hover position + quaternion orientation
    local gameQuat = Quat.toGameQuat(state.quat)

    local wtOk, wtErr = pcall(function()
        local wt = WorldTransform.new()
        wt:SetPosition(Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1))
        wt:SetOrientation(gameQuat)
        player:SetWorldTransform(wt)
    end)
```

nothing visibly happens.  but that may just be a failure of SetPosition

next tester should hover the player with impulses, then only do rotations


```log
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] FPPCameraComponent locked (sensitivity=0)
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] Active -- player hovering at (-1966.2, -2180.3, 55.5) groundZ=52.5 height=3.0 (camFound=true)
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:50 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=30 pitch=0 yaw=7
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=30.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=30.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=30.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=60 pitch=0 yaw=7
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=60.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:53 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=60.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=60.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:54 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=63 pitch=14 yaw=33
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=63.4 pitch=14.5 yaw=33.1
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=63.4 pitch=14.5 yaw=33.1
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=63.4 pitch=14.5 yaw=33.1
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=74 pitch=26 yaw=63
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=73.9 pitch=25.7 yaw=62.9
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=73.9 pitch=25.7 yaw=62.9
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=73.9 pitch=25.7 yaw=62.9
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:55 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=75 pitch=-3 yaw=71
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=75.5 pitch=-3.3 yaw=70.9
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=75.5 pitch=-3.3 yaw=70.9
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=75.5 pitch=-3.3 yaw=70.9
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:56 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] Rot -> roll=73 pitch=-32 yaw=79
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=72.8 pitch=-32.2 yaw=79.4
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=72.8 pitch=-32.2 yaw=79.4
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG target: roll=72.8 pitch=-32.2 yaw=79.4
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG BEFORE: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] SetWorldTransform SUCCESS
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG AFTER: roll=0.0 pitch=0.0 yaw=6.6
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG pos after: (-1966.2, -2180.3, 52.5) target: (-1966.2, -2180.3, 55.5)
[2026-07-19 12:07:57 UTC-05:00] [28660] [HoverRotTesterPlayer] DIAG CAM: roll=0.0 pitch=0.0 yaw=0.0 | sensX=0.0 sensY=0.0
[2026-07-19 12:07:58 UTC-05:00] [28660] [HoverRotTesterPlayer] Deactivating...
[2026-07-19 12:07:58 UTC-05:00] [28660] [HoverRotTesterPlayer] Deactivated
```