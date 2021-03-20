local lastDotTime = nil
local lastDotID = nil

local pinNames =
{

    -- aiming candidates
    "CustomPositionVariant",    -- white icon you get when you right click on the map, strobing
    "DistractVariant",          -- roundabout arrows

    -- pull and rigid candidates
    "AimVariant",               -- cross hair
    "TakeControlVariant",       -- (*)

    "OffVariant",               -- power symbol


    -------------------------------


    -- shield
    "AllowVariant",     -- checkmark (looks like a virus scan logo)
    "BackOutVariant",   -- circle with strikemark

    -- person
    "ChangeToFriendlyVariant",      -- checkmark
    "GunSuicideVariant",

    -- yellow truck icon
    "ConvoyVariant",        -- $
    "CourierVariant",

    "ConversationVariant",      -- speech balloon
    "SpeechVariant",            -- speech balloon
    "GrenadeVariant",           -- grenade thrown icon

    -- yellow quest go heres
    "GetInVariant",     --  ->]
    "GetUpVariant",     -- car seat with upright arrow
    "SitVariant",       -- car seat with downleft arrow



    -- other yellows
    "HitVariant",               -- fist strike
    "NonLethalTakedownVariant", -- arrow strike
    "JackInVariant",            -- usb plugging in
    "JamWeaponVariant",         -- gun with a no
    "OffVariant",               -- power symbol
    "TakeDownVariant",          -- same as light blue skull, but yellow
    "UseVariant",               -- pointing finger
    "WanderingMerchantVariant", -- yellow shopping cart
    "AimVariant",               -- cross hair
    "DistractVariant",          -- roundabout arrows
    "TakeControlVariant",       -- (*)



    -- white map icons
    "ApartmentVariant", -- v's apt
    "CustomPositionVariant",        -- icon you get when you right click on the map, strobing
    "ServicePointBarVariant",
    "ServicePointClothesVariant",
    "ServicePointDropPointVariant",
    "ServicePointFoodVariant",
    "ServicePointGunsVariant",
    "ServicePointJunkVariant",
    "ServicePointMedsVariant",
    "ServicePointMeleeTrainerVariant",
    "ServicePointNetTrainerVariant",
    "ServicePointProstituteVariant",
    "ServicePointRipperdocVariant",
    "VehicleVariant",                   -- v's vehicle


    -- yellow map icons
    "BountyHuntVariant",
    "ClientInDistressVariant",
    "DefaultInteractionVariant",    -- main quest
    "DefaultVariant",               -- main quest
    "ExclamationMarkVariant",       -- main quest
    "GPSPortalVariant",             -- main quest
    "DefaultQuestVariant",
    "DropboxVariant",               -- dropbox, but yellow
    "EffectDropPointVariant",       -- dropbox, but yellow
    "ResourceVariant",              -- three dropboxes, yellow
    "LifepathCorpoVariant",
    "LifepathNomadVariant",
    "LifepathStreetKidVariant",
    "OpenVendorVariant",
    "RetrievingVariant",
    "SabotageVariant",
    "ServicePointTechVariant",      -- yellow wrench
    "SmugglersDenVariant",
    "ThieveryVariant",


    -- royal blue map icons
    "FastTravelVariant",


    -- light blue map icons
    "FixerVariant",
    "GangWatchVariant",
    "HiddenStashVariant",
    "HuntForPsychoVariant",
    "MinorActivityVariant",
    "OutpostVariant",
    "QuestGiverVariant",        -- person with !  (havn't seen this one)
    "TarotVariant",



    "PhoneCallVariant",     -- big red breaching icon
    "QuickHackVariant",     -- big red breaching icon

}

local currentPinIndex = 999

function Test_Raycast_Mappin(o, state, debug)
    if lastDotID and (o.timer - lastDotTime > 2) then
        o:RemovePin(lastDotID)
        lastDotID = nil
    end

    if state.startStopTracker:ShouldStop() then
        o:GetCamera()

        local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 1.5, 1)

        local result, tries = RayCast_HitPoint(from, o.lookdir_forward, 144, 0.5, o)

        if result then
            debug.tries = tries
            debug.hitDist = Round(math.sqrt(GetVectorDiffLengthSqr(from, result)), 1)

            if lastDotID then
                o:MovePin(lastDotID, result)
            else
                currentPinIndex = currentPinIndex + 1

                if currentPinIndex > #pinNames then
                    currentPinIndex = 1
                end

                debug.mappin = pinNames[currentPinIndex]

                lastDotID = o:CreatePin(result, pinNames[currentPinIndex])
            end

            lastDotTime = o.timer
        end
    end
end

