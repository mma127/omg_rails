function each_file(rgd)
    if rgd.GameData.weapon_bag then
        local weapon = rgd.GameData.weapon_bag

        local damage = (weapon.damage.min + weapon.damage.max) / 2
        local reloadFrequency = (weapon.reload.frequency.max + weapon.reload.frequency.min) / 2
        local reloadDuration = (weapon.reload.duration.max + weapon.reload.duration.min) / 2 + weapon.fire.wind_up + weapon.fire.wind_down
        local cooldownShort = (weapon.cooldown.duration.max + weapon.cooldown.duration.min) / 2 * weapon.cooldown.duration_multiplier.short
        local cooldownMedium = (weapon.cooldown.duration.max + weapon.cooldown.duration.min) / 2 * weapon.cooldown.duration_multiplier.medium
        local cooldownLong = (weapon.cooldown.duration.max + weapon.cooldown.duration.min) / 2 * weapon.cooldown.duration_multiplier.long
        local fireAimTimeShort = (weapon.aim.fire_aim_time.max + weapon.aim.fire_aim_time.min) / 2 * weapon.aim.fire_aim_time_multiplier.short
        local fireAimTimeMedium = (weapon.aim.fire_aim_time.max + weapon.aim.fire_aim_time.min) / 2 * weapon.aim.fire_aim_time_multiplier.medium
        local fireAimTimeLong = (weapon.aim.fire_aim_time.max + weapon.aim.fire_aim_time.min) / 2 * weapon.aim.fire_aim_time_multiplier.long
        local readyAimTime = (weapon.aim.ready_aim_time.max + weapon.aim.ready_aim_time.min) / 2
        local WindUpWindDown = weapon.fire.wind_up + weapon.fire.wind_down
        local ZaxisDPSShort
        local ZaxisDPSMedium
        local ZaxisDPSLong

        if weapon.burst.can_burst == true then
            local burstDuration = (weapon.burst.duration.max + weapon.burst.duration.min) / 2
            local rateOfFire = (weapon.burst.rate_of_fire.max + weapon.burst.rate_of_fire.min) / 2

            ZaxisDPSShort = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracy.short * damage) /
                    (readyAimTime + (fireAimTimeShort + cooldownShort + WindUpWindDown) * reloadFrequency + reloadDuration + burstDuration * (reloadFrequency + 1))

            ZaxisDPSMedium = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracy.medium * damage) /
                    (readyAimTime + (fireAimTimeMedium + cooldownMedium + WindUpWindDown) * reloadFrequency + reloadDuration + burstDuration * (reloadFrequency + 1))

            ZaxisDPSLong = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracy.long * damage) /
                    (readyAimTime + (fireAimTimeLong + cooldownLong + WindUpWindDown) * reloadFrequency + reloadDuration + burstDuration * (reloadFrequency + 1))


        else
            ZaxisDPSShort = ((reloadFrequency + 1) * weapon.accuracy.short * damage) /
                    (readyAimTime + (fireAimTimeShort + cooldownShort + WindUpWindDown) * reloadFrequency + reloadDuration)

            ZaxisDPSMedium = ((reloadFrequency + 1) * weapon.accuracy.medium * damage) /
                    (readyAimTime + (fireAimTimeMedium + cooldownMedium + WindUpWindDown) * reloadFrequency + reloadDuration)

            ZaxisDPSLong = ((reloadFrequency + 1) * weapon.accuracy.long * damage) /
                    (readyAimTime + (fireAimTimeLong + cooldownLong + WindUpWindDown) * reloadFrequency + reloadDuration)
        end

        print("# " .. rgd.name .. "")
        print("  | Zaxis S DPS = " .. (math.floor(ZaxisDPSShort * 100 + 0.005) / 100))
        print("  | Zaxis M DPS = " .. (math.floor(ZaxisDPSMedium * 100 + 0.005) / 100))
        print("  | Zaxis L DPS = " .. (math.floor(ZaxisDPSLong * 100 + 0.005) / 100))
        print("")
    end
end
