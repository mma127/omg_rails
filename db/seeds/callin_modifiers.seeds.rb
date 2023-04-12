after :restrictions do
  ruleset = Ruleset.find_by!(name: "war")

  # Organized Platoons
  blitz = Doctrine.find_by!(name: "blitz")
  unlock = Unlock.find_by!(name: "organized_platoons")
  op = DoctrineUnlock.find_by!(doctrine: blitz, unlock: unlock)
  op_r = Restriction.find_by!(doctrine_unlock: op)
  op_cm = CallinModifier.create!(modifier: 0.25, modifier_type: CallinModifier::modifier_types[:multiplicative],
                                 priority: 1, description: "Callin Modifier x0.25 Volks & Grens")
  EnabledCallinModifier.create!(restriction: op_r, callin_modifier: op_cm, ruleset: ruleset)

  volks = Unit.find_by(name: "volksgrenadiers")
  grens = Unit.find_by(name: "grenadiers")
  CallinModifierAllowedUnit.create!(callin_modifier: op_cm, unit: volks)
  CallinModifierAllowedUnit.create!(callin_modifier: op_cm, unit: grens)

  # Weighted Packs
  airborne = Doctrine.find_by!(name: "airborne")
  unlock = Unlock.find_by!(name: "weighted_packs")
  wp = DoctrineUnlock.find_by!(doctrine: airborne, unlock: unlock)
  wp_r = Restriction.find_by!(doctrine_unlock: wp)
  wp_cm = CallinModifier.create!(modifier: 0.5, modifier_type: CallinModifier::modifier_types[:multiplicative],
                                 priority: 1, description: "Callin Modifier x0.5 Airborne units")
  EnabledCallinModifier.create!(restriction: wp_r, callin_modifier: wp_cm, ruleset: ruleset)

  airborne_unit = Unit.find_by!(name: "airborne")
  assault_airborne = Unit.find_by!(name: "assault_airborne")
  airborne_hmg = SupportTeam.find_by!(name: "airborne_hmg")
  airborne_mortar = SupportTeam.find_by!(name: "airborne_mortar")
  airborne_atg = SupportTeam.find_by!(name: "airborne_atg")
  airborne_sniper = SupportTeam.find_by!(name: "airborne_sniper")
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: airborne_unit)
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: assault_airborne)
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: airborne_hmg)
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: airborne_mortar)
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: airborne_atg)
  CallinModifierAllowedUnit.create!(callin_modifier: wp_cm, unit: airborne_sniper)

  # Quick Reaction Force
  commandos = Doctrine.find_by!(name: "commandos")
  unlock = Unlock.find_by!(name: "quick_reaction_force")
  qrf = DoctrineUnlock.find_by!(doctrine: commandos, unlock: unlock)
  qrf_r = Restriction.find_by!(doctrine_unlock: qrf)
  qrf_cm = CallinModifier.create!(modifier: 0.25, modifier_type: CallinModifier::modifier_types[:multiplicative],
                                  priority: 1, description: "Callin Modifier x0.25, Commando units")
  EnabledCallinModifier.create!(restriction: qrf_r, callin_modifier: qrf_cm, ruleset: ruleset)

  commandos_unit = Unit.find_by!(name: "commandos")
  piat_commandos = Unit.find_by!(name: "piat_commandos")
  polish_commandos = Unit.find_by!(name: "polish_commandos")
  commando_2pdr = Unit.find_by!(name: "commando_2pdr")
  commando_hmg = Unit.find_by!(name: "commando_hmg")
  commando_mortar = Unit.find_by!(name: "commando_mortar")
  infantry_glider = Unit.find_by!(name: "infantry_glider")
  armor_glider = Unit.find_by!(name: "armor_glider")
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: commandos_unit)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: piat_commandos)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: polish_commandos)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: commando_2pdr)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: commando_hmg)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: commando_mortar)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: infantry_glider)
  CallinModifierAllowedUnit.create!(callin_modifier: qrf_cm, unit: armor_glider)

  # Glider Army
  unlock = Unlock.find_by!(name: "glider_army")
  ga = DoctrineUnlock.find_by!(doctrine: commandos, unlock: unlock)
  ga_r = Restriction.find_by!(doctrine_unlock: ga)
  ga_cm = CallinModifier.create!(modifier: 0.5, modifier_type: CallinModifier::modifier_types[:multiplicative],
                                  priority: 1, description: "Callin Modifier x0.5, Gliders + any")
  EnabledCallinModifier.create!(restriction: ga_r, callin_modifier: ga_cm, ruleset: ruleset)

  infantry_glider = Unit.find_by!(name: "infantry_glider")
  armor_glider = Unit.find_by!(name: "armor_glider")
  CallinModifierRequiredUnit.create!(callin_modifier: qrf_cm, unit: infantry_glider)
  CallinModifierRequiredUnit.create!(callin_modifier: qrf_cm, unit: armor_glider)

  # Patton's War
  armor = Doctrine.find_by!(name: "armor")
  unlock = Unlock.find_by!(name: "patton_s_war")
  pw = DoctrineUnlock.find_by!(doctrine: armor, unlock: unlock)
  pw_r = Restriction.find_by!(doctrine_unlock: pw)
  pw_cm = CallinModifier.create!(modifier: 0.1, modifier_type: CallinModifier::modifier_types[:multiplicative],
                                 priority: 1, description: "Callin Modifier x0.1, Vehicle/Tank + any")
  EnabledCallinModifier.create!(restriction: pw_r, callin_modifier: pw_cm, ruleset: ruleset)

  halftrack_allied = Unit.find_by!(name: "halftrack_allied")
  quad_halftrack = Unit.find_by!(name: "quad_halftrack")
  greyhound = Unit.find_by!(name: "greyhound")
  t17 = Unit.find_by!(name: "t17")
  sherman = Unit.find_by!(name: "sherman")
  sherman_croc = Unit.find_by!(name: "sherman_croc")
  m10 = Unit.find_by!(name: "m10")
  m18 = Unit.find_by!(name: "m18")
  sherman_105 = Unit.find_by!(name: "sherman_105")
  calliope = Unit.find_by!(name: "calliope")
  easy_eight = Unit.find_by!(name: "easy_eight")
  jackson = Unit.find_by!(name: "jackson")
  pershing = Unit.find_by!(name: "pershing")
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: halftrack_allied)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: quad_halftrack)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: greyhound)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: t17)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: sherman)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: sherman_croc)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: m10)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: m18)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: sherman_105)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: calliope)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: easy_eight)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: jackson)
  CallinModifierRequiredUnit.create!(callin_modifier: pw_cm, unit: pershing)
end
