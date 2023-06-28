import advanced_repair from '../../../assets/images/doctrines/panzer_elite/upgrades/advanced_repair.png'
import apcr from '../../../assets/images/doctrines/panzer_elite/upgrades/apcr.png'
import at_grenade from '../../../assets/images/doctrines/panzer_elite/upgrades/at_grenade.png'
import booby_trap from '../../../assets/images/doctrines/panzer_elite/upgrades/booby_trap.png'
import extra_man from '../../../assets/images/doctrines/panzer_elite/upgrades/extra_man.png'
import flame_grenade from '../../../assets/images/doctrines/panzer_elite/upgrades/flame_grenade.png'
import flame_round from '../../../assets/images/doctrines/panzer_elite/upgrades/flame_round.png'
import g43 from '../../../assets/images/doctrines/panzer_elite/upgrades/g43.png'
import g43_suppress from '../../../assets/images/doctrines/panzer_elite/upgrades/g43_suppress.png'
import hotchkiss_stuka from '../../../assets/images/doctrines/panzer_elite/upgrades/hotchkiss_stuka.png'
import hotchkiss_upgun from '../../../assets/images/doctrines/panzer_elite/upgrades/hotchkiss_upgun.png'
import light_armor_upgrade from '../../../assets/images/doctrines/panzer_elite/upgrades/light_armor_upgrade.png'
import overdrive from '../../../assets/images/doctrines/panzer_elite/upgrades/overdrive.png'
import second_schreck from '../../../assets/images/doctrines/panzer_elite/upgrades/second_schreck.png'
import spotting_scope from '../../../assets/images/doctrines/panzer_elite/upgrades/spotting_scope.png'
import veteran_sergeant from '../../../assets/images/doctrines/panzer_elite/upgrades/veteran_sergeant.png'

import goliath from '../../../assets/images/doctrines/wehrmacht/upgrades/goliath.png'
import mg_gunner from '../../../assets/images/doctrines/wehrmacht/upgrades/mg42_gunner.png'
import panzerfaust from '../../../assets/images/doctrines/wehrmacht/upgrades/panzerfaust.png'
import skirts from '../../../assets/images/doctrines/wehrmacht/upgrades/skirts.png'
import smoke_grenade from '../../../assets/images/doctrines/wehrmacht/upgrades/smoke_grenade.png'

import mines from '../../../assets/images/doctrines/common/upgrades/mines.png'

export const ADVANCED_REPAIR = 'advanced_repair'
export const APCR_AT_HT = 'apcr_at_ht'
export const APCR_HETZER = 'apcr_hetzer'
export const APCR_MARDER = 'apcr_marder'
export const APCR_PANTHER = 'apcr_panther'
export const ARMOR_PLATING_AC = 'armored_plating_ac'
export const ARMOR_PLATING_AT_HT = 'armored_plating_at_ht'
export const ARMOR_PLATING_IHT = 'armored_plating_iht'
export const ARMOR_PLATING_MHT = 'armored_plating_mht'
export const ARMOR_PLATING_SC = 'armored_plating_sc'
export const AT_GRENADE = 'at_grenade'
export const AT_HT_MINES = 'at_ht_mines'
export const BOOBY_TRAP = 'booby_trap'
export const EXTRA_MAN_AG = 'extra_man_ag'
export const EXTRA_MAN_PG = 'extra_man_pg'
export const EXTRA_MAN_TB = 'extra_man_tb'
export const FAUSTPATRONE = 'faustpatrone'
export const FIRE_SUPPORT = 'fire_support'
export const FLAME_GRENADE = 'flame_grenade'
export const FLAME_ROUND = 'flame_round'
export const G43 = 'g43'
export const G43_SUPPRESS = 'g43_suppress'
export const HOTCHKISS_STUKA = 'hotchkiss_stuka'
export const HOTCHKISS_UPGUN = 'hotchkiss_upgun'
export const IMPROVED_SCOPES = 'improved_scopes'
export const OVERDRIVE = 'overdrive'
export const P4_IST_MG42 = 'p4_ist_mg42'
export const P4_IST_SKIRTS = 'p4_ist_skirts'
export const PANTHER_PE_MG42 = 'panther_pe_mg42'
export const PANTHER_PE_SKIRTS = 'panther_pe_skirts'
export const PE_GOLIATH = 'pe_goliath'
export const PE_PANZERSCHRECK = 'pe_panzerschreck'
export const PE_SMOKE_GRENADE = 'pe_smoke_grenade'
export const SPOTTING_SCOPE = 'spotting_scope'
export const TELLER_MINES = 'teller_mines'
export const VETERAN_SERGEANT = 'veteran_sergeant'

export const upgradeImageMapping = {
  [ADVANCED_REPAIR]: advanced_repair,
  [APCR_AT_HT]: apcr,
  [APCR_HETZER]: apcr,
  [APCR_MARDER]: apcr,
  [APCR_PANTHER]: apcr,
  [ARMOR_PLATING_AC]: light_armor_upgrade,
  [ARMOR_PLATING_AT_HT]: light_armor_upgrade,
  [ARMOR_PLATING_IHT]: light_armor_upgrade,
  [ARMOR_PLATING_MHT]: light_armor_upgrade,
  [ARMOR_PLATING_SC]: light_armor_upgrade,
  [AT_GRENADE]: at_grenade,
  [AT_HT_MINES]: mines,
  [BOOBY_TRAP]: booby_trap,

  [EXTRA_MAN_AG]: extra_man,
  [EXTRA_MAN_PG]: extra_man,
  [EXTRA_MAN_TB]: extra_man,
  [FAUSTPATRONE]: panzerfaust,
  [FIRE_SUPPORT]: mg_gunner,
  [FLAME_GRENADE]: flame_grenade,
  [FLAME_ROUND]: flame_round,
  [G43]: g43,
  [G43_SUPPRESS]: g43_suppress,
  [HOTCHKISS_STUKA]: hotchkiss_stuka,
  [HOTCHKISS_UPGUN]: hotchkiss_upgun,

  [IMPROVED_SCOPES]: spotting_scope,
  [OVERDRIVE]: overdrive,

  [P4_IST_MG42]: mg_gunner,
  [P4_IST_SKIRTS]: skirts,
  [PANTHER_PE_MG42]: mg_gunner,
  [PANTHER_PE_SKIRTS]: skirts,

  [PE_GOLIATH]: goliath,
  [PE_PANZERSCHRECK]: second_schreck,
  [PE_SMOKE_GRENADE]: smoke_grenade,
  [SPOTTING_SCOPE]: spotting_scope,
  [TELLER_MINES]: mines,
  [VETERAN_SERGEANT]: veteran_sergeant,
}