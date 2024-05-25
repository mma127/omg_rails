export class WeaponBag {
  constructor(data) {
    this.data = data
  }

  get damageMin() {
    return parseFloat(_.get(this.data, "damage.min", "0"))
  }

  get damageMax() {
    return parseFloat(_.get(this.data, "damage.max", "0"))
  }

  get damage() {
    return (this.damageMin + this.damageMax) / 2
  }

  get reloadFrequencyMin() {
    return parseFloat(_.get(this.data, "reload.frequency.min", "0"))
  }

  get reloadFrequencyMax() {
    return parseFloat(_.get(this.data, "reload.frequency.max", "0"))
  }

  get reloadFrequency() {
    return (this.reloadFrequencyMin + this.reloadFrequencyMax) / 2
  }

  get reloadDurationMin() {
    return parseFloat(_.get(this.data, "reload.duration.min", "0"))
  }

  get reloadDurationMax() {
    return parseFloat(_.get(this.data, "reload.duration.max", "0"))
  }

  get reloadDuration() {
    return (this.reloadDurationMin + this.reloadDurationMax) / 2
  }

  get windUp() {
    return parseFloat(_.get(this.data, "fire.wind_up", "0"))
  }

  get windDown() {
    return parseFloat(_.get(this.data, "fire.wind_down", "0"))
  }

  get windUpWindDown() {
    return this.windUp + this.windDown
  }

  get cooldownDurationMin() {
    return parseFloat(_.get(this.data, "cooldown.duration.min", "0"))
  }

  get cooldownDurationMax() {
    return parseFloat(_.get(this.data, "cooldown.duration.max", "0"))
  }

  get cooldownDurationRaw() {
    return (this.cooldownDurationMin + this.cooldownDurationMax) / 2
  }

  get cooldownDurationMultiplierShort() {
    return parseFloat(_.get(this.data, "cooldown.duration_multiplier.short", "1"))
  }

  get cooldownDurationMultiplierMedium() {
    return parseFloat(_.get(this.data, "cooldown.duration_multiplier.medium", "1"))
  }

  get cooldownDurationMultiplierLong() {
    return parseFloat(_.get(this.data, "cooldown.duration_multiplier.long", "1"))
  }

  get cooldownDurationShort() {
    return this.cooldownDurationRaw * this.cooldownDurationMultiplierShort
  }

  get cooldownDurationMedium() {
    return this.cooldownDurationRaw * this.cooldownDurationMultiplierMedium
  }

  get cooldownDurationLong() {
    return this.cooldownDurationRaw * this.cooldownDurationMultiplierLong
  }


  get fireAimTimeMin() {
    return parseFloat(_.get(this.data, "aim.fire_aim_time.min", "0"))
  }

  get fireAimTimeMax() {
    return parseFloat(_.get(this.data, "aim.fire_aim_time.max", "0"))
  }

  get fireAimTimeRaw() {
    return (this.fireAimTimeMin + this.fireAimTimeMax) / 2
  }

  get fireAimTimeMultiplierShort() {
    return parseFloat(_.get(this.data, "aim.fire_aim_time_multiplier.short", "1"))
  }

  get fireAimTimeMultiplierMedium() {
    return parseFloat(_.get(this.data, "aim.fire_aim_time_multiplier.medium", "1"))
  }

  get fireAimTimeMultiplierLong() {
    return parseFloat(_.get(this.data, "aim.fire_aim_time_multiplier.long", "1"))
  }

  get fireAimTimeShort() {
    return this.fireAimTimeRaw * this.fireAimTimeMultiplierShort
  }

  get fireAimTimeMedium() {
    return this.fireAimTimeRaw * this.fireAimTimeMultiplierMedium
  }

  get fireAimTimeLong() {
    return this.fireAimTimeRaw * this.fireAimTimeMultiplierLong
  }

  get readyAimTimeMin() {
    return parseFloat(_.get(this.data, "aim.ready_aim_time.min", "0"))
  }

  get readyAimTimeMax() {
    return parseFloat(_.get(this.data, "aim.ready_aim_time.max", "0"))
  }

  get readyAimTime() {
    return (this.readyAimTimeMin + this.readyAimTimeMax) / 2
  }

  get canBurst() {
    return _.get(this.data, "burst.can_burst", "false") === "true"
  }

  get burstDurationMin() {
    return parseFloat(_.get(this.data, "burst.duration.min", "0"))
  }

  get burstDurationMax() {
    return parseFloat(_.get(this.data, "burst.duration.max", "0"))
  }

  get burstDuration() {
    return (this.burstDurationMin + this.burstDurationMax) / 2
  }

  get rateOfFireMin() {
    return parseFloat(_.get(this.data, "burst.rate_of_fire.min", "0"))
  }

  get rateOfFireMax() {
    return parseFloat(_.get(this.data, "burst.rate_of_fire.max", "0"))
  }

  get rateOfFire() {
    return (this.rateOfFireMin + this.rateOfFireMax) / 2
  }

  get accuracyShort() {
    return parseFloat(_.get(this.data, "accuracy.short", "0"))
  }

  get accuracyMedium() {
    return parseFloat(_.get(this.data, "accuracy.medium", "0"))
  }

  get accuracyLong() {
    return parseFloat(_.get(this.data, "accuracy.long", "0"))
  }

  get rangeShort() {
    return parseFloat(_.get(this.data, "range.mid.short", "0"))
  }
  get rangeMedium() {
    return parseFloat(_.get(this.data, "range.mid.medium", "0"))
  }
  get rangeLong() {
    return parseFloat(_.get(this.data, "range.mid.long", "0"))
  }
  get rangeMin() {
    return parseFloat(_.get(this.data, "range.min", "0"))
  }
  get rangeMax() {
    return parseFloat(_.get(this.data, "range.max", "0"))
  }

  get movingAccuracyMultiplier() {
    return parseFloat(_.get(this.data, "moving.accuracy_multiplier", "0"))
  }
}