function GetDefault_Player(playerID)
    return
    {
        playerID = playerID,
        name = "default",
        energy_tank = GetDefault_EnergyTank(),

        --TODO: Action Mappings

        grapple1 = GetDefault_Pull(),
        grapple2 = GetDefault_Rigid(),
        --grapple3 = GetDefault_WebSwing(),

        experience = 0,
    }
end

function GetDefault_EnergyTank()
    return
    {
        max_energy = 12,
        recovery_rate = 1,

        experience = 0,
    }
end

function GetDefault_Pull()
    return nil
end

function GetDefault_Rigid()
    return nil
end