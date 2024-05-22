import { DISTANT, LONG, MEDIUM, SHORT } from "../../constants/stats/ranges";
import { precise } from "../../utils/numbers";

export const calculateRawDps = (weapon) => {
  const windUpWindDown = weapon.windUpWindDown

  const damage = weapon.damage
  const reloadFrequency = weapon.reloadFrequency
  const reloadDurationWithWindUpDown = weapon.reloadDuration + windUpWindDown

  const cooldownShort = weapon.cooldownDurationShort
  const cooldownMedium = weapon.cooldownDurationMedium
  const cooldownLong = weapon.cooldownDurationLong

  const fireAimTimeShort = weapon.fireAimTimeShort
  const fireAimTimeMedium = weapon.fireAimTimeMedium
  const fireAimTimeLong = weapon.fireAimTimeLong

  const readyAimTime = weapon.readyAimTime

  let dpsShort, dpsMedium, dpsLong
  if (weapon.canBurst) {
    const burstDuration = weapon.burstDuration
    const rateOfFire = weapon.rateOfFire

    dpsShort = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracyShort * damage) /
      (readyAimTime + (fireAimTimeShort + cooldownShort + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown + burstDuration * (reloadFrequency + 1))

    dpsMedium = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracyMedium * damage) /
      (readyAimTime + (fireAimTimeMedium + cooldownMedium + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown + burstDuration * (reloadFrequency + 1))

    dpsLong = (rateOfFire * burstDuration * (reloadFrequency + 1) * weapon.accuracyLong * damage) /
      (readyAimTime + (fireAimTimeLong + cooldownLong + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown + burstDuration * (reloadFrequency + 1))
  } else {
    dpsShort = ((reloadFrequency + 1) * weapon.accuracyShort * damage) /
      (readyAimTime + (fireAimTimeShort + cooldownShort + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown)

    dpsMedium = ((reloadFrequency + 1) * weapon.accuracyMedium * damage) /
      (readyAimTime + (fireAimTimeMedium + cooldownMedium + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown)

    dpsLong = ((reloadFrequency + 1) * weapon.accuracyLong * damage) /
      (readyAimTime + (fireAimTimeLong + cooldownLong + windUpWindDown) * reloadFrequency + reloadDurationWithWindUpDown)
  }
  return {
    [SHORT]: precise(dpsShort, 2),
    [MEDIUM]: precise(dpsMedium, 2),
    [LONG]: precise(dpsLong, 2)
  }
}

const getValueForRange = (object, range) => {
  switch (range) {
    case SHORT:
      return object.short
    case MEDIUM:
      return object.medium
    case LONG:
      return object.long
    case DISTANT:
      return object.distant
  }
}
