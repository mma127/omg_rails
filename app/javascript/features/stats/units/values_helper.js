/** Some sbps files are not dumped to LUA correctly by Corsix and so can contain missing values that exist in the
 * original RGD */
const SUPPRESSED_RECOVER_THRESHOLD = {
  "sbps/races/allies_commonwealth/soldiers/tommy_squad": 0.2,
  "sbps/races/allies_commonwealth/soldiers/recon_tommy_squad": 0.2,
  "sbps/races/allies_commonwealth/soldiers/sapper_squad": 0.2,
  "sbps/races/allies_commonwealth/soldiers/sapper_repair_squad": 0.2,
  "sbps/races/allies_commonwealth/soldiers/mortar_section": 0.2,
  "sbps/races/allies_commonwealth/soldiers/tommy_squad_canadian": 0.2,
  "sbps/races/allies_commonwealth/soldiers/ssf_squad": 0.2,
}

const PIN_DOWN_ACTIVATE_THRESHOLD = {
  "sbps/races/allies_commonwealth/soldiers/lieutenant": 0.8,
  "sbps/races/allies_commonwealth/soldiers/captain": 0.8,
  "sbps/races/allies_commonwealth/soldiers/vickers_mmg_section_mobile": 0.8,
  "sbps/races/allies_commonwealth/soldiers/commando_squad": 0.8,
  "sbps/races/allies_commonwealth/soldiers/commando_piat_squad": 0.8,
  "sbps/races/allies_commonwealth/soldiers/commando_piat_squad_4_man": 0.8,
  "sbps/races/allies_commonwealth/soldiers/polish_commando_squad": 0.8,
  "sbps/races/allies_commonwealth/soldiers/commando_hmg_squad": 0.8,
  "sbps/races/allies_commonwealth/soldiers/commando_mortar_squad": 0.8,
}

const PIN_DOWN_RECOVER_THRESHOLD = {
  "sbps/races/allies/soldiers/rifleman_squad": 0.5,
  "sbps/races/allies/soldiers/rifleman_squad_heavy": 0.5,
  "sbps/races/allies/soldiers/engineer_infantry": 0.5,
  "sbps/races/allies/soldiers/sniper_squad": 0.5,
  "sbps/races/allies/soldiers/heavy_machine_gun_section": 0.5,
  "sbps/races/allies/soldiers/mortar_section": 0.5,
  "sbps/races/allies/soldiers/ambush_rifleman_squad": 0.5,
  "sbps/races/allies/soldiers/spotter_squad": 0.5,
  "sbps/races/allies/soldiers/allied_officer_squad": 0.5,
  "sbps/races/allies/soldiers/airborne_infantry": 0.5,
  "sbps/races/allies/soldiers/airborne_ heavy_machine_gun_section": 0.5,
  "sbps/races/allies/soldiers/airborne_mortar_section": 0.5,
  "sbps/races/allies/soldiers/walter": 0.5, // Airborne sniper
  "sbps/races/allies/soldiers/mech_infantry_squad": 0.5,
  "sbps/races/axis/soldiers/volksgrenadier_squad": 0.5,
  "sbps/races/axis/soldiers/grenadier_squad": 0.5,
  "sbps/races/axis/soldiers/pioneer_squad": 0.5,
  "sbps/races/axis/soldiers/knights_cross_holder": 0.5,
  "sbps/races/axis/soldiers/medic_squad": 0.5,
  "sbps/races/axis/soldiers/heavy_machine_gun_section": 0.5,
  "sbps/races/axis/soldiers/mortar_section": 0.5,
  "sbps/races/axis/soldiers/sniper": 0.5,
  "sbps/races/axis/soldiers/officer_squad": 0.5,
  "sbps/races/axis/soldiers/stormtrooper_squad": 0.5,
  "sbps/races/axis/soldiers/Flametruppen": 0.5,
  "sbps/races/axis/soldiers/officer_blitz_squad": 0.5,
  "sbps/races/axis/soldiers/sturmpioneer_squad": 0.5,
  "sbps/races/axis/soldiers/saboteur_squad": 0.5,
  "sbps/races/axis/soldiers/officer_terror_squad": 0.5,
  "sbps/races/axis/soldiers/terror_mortar_new": 0.5,
  "sbps/races/axis_panzer_elite/soldiers/heavy_machine_gun_section": 0.5,
  "sbps/races/axis_panzer_elite/soldiers/luftwaffe_squad": 0.5,
  "sbps/races/axis_panzer_elite/soldiers/ost_truppen_squad": 0.5,
}

const VALUES_MAPPER = {
  "suppressed_activate_threshold": {},
  "suppressed_recover_threshold": SUPPRESSED_RECOVER_THRESHOLD,
  "pin_down_activate_threshold": PIN_DOWN_ACTIVATE_THRESHOLD,
  "pin_down_recover_threshold": PIN_DOWN_RECOVER_THRESHOLD,
}

export const getStatsValueWithFallback = (reference, type, data, precision = 2) => {
  if (Object.keys(data).includes(type)) {
    return precise(data[type], precision)
  } else if (Object.keys(VALUES_MAPPER).includes(type)) {
    const fallbackMap = VALUES_MAPPER[type]
    if (Object.keys(fallbackMap).includes(reference)) {
      return precise(fallbackMap[reference], precision)
    } else {
      return "UNKNOWN VALUE - REPORT BUG"
    }
  } else {
    return "UNKNOWN VALUE - REPORT BUG"
  }
}

export const precise = (value, precision) => {
  return Number(parseFloat(value).toFixed(precision))
}
