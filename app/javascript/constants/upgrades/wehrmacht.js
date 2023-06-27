import assault_grenades from '../../../assets/images/doctrines/wehrmacht/upgrades/assault_grenades.png'
import bundle_grenade from '../../../assets/images/doctrines/wehrmacht/upgrades/bundle_grenade.png'
import bunker from '../../../assets/images/doctrines/wehrmacht/upgrades/bunker.png'
import camo_smocks from '../../../assets/images/doctrines/wehrmacht/upgrades/camo_smocks.png'
import goliath from '../../../assets/images/doctrines/wehrmacht/upgrades/goliath.png'
import grenade from '../../../assets/images/doctrines/wehrmacht/upgrades/grenade.png'
import listening_post from '../../../assets/images/doctrines/wehrmacht/upgrades/listening_post.png'
import lmg42 from '../../../assets/images/doctrines/wehrmacht/upgrades/lmg42.png'
import medic_bunker from '../../../assets/images/doctrines/wehrmacht/upgrades/medic_bunker.png'
import medpack from '../../../assets/images/doctrines/wehrmacht/upgrades/medpack.png'
import mg42_gunner from '../../../assets/images/doctrines/wehrmacht/upgrades/mg42_gunner.png'
import mg_bunker from '../../../assets/images/doctrines/wehrmacht/upgrades/mg_bunker.png'
import mortar_bunker from '../../../assets/images/doctrines/wehrmacht/upgrades/mortar_bunker.png'
import mp40 from '../../../assets/images/doctrines/wehrmacht/upgrades/mp40.png'
import mp44 from '../../../assets/images/doctrines/wehrmacht/upgrades/mp44.png'
import pantherturm from '../../../assets/images/doctrines/wehrmacht/upgrades/pantherturm.png'
import panzerschreck from '../../../assets/images/doctrines/wehrmacht/upgrades/panzerschreck.png'
import panzerfaust from '../../../assets/images/doctrines/wehrmacht/upgrades/panzerfaust.png'
import puma_upgun from '../../../assets/images/doctrines/wehrmacht/upgrades/puma_upgun.png'
import repair_bunker from '../../../assets/images/doctrines/wehrmacht/upgrades/repair_bunker.png'
import skirts from '../../../assets/images/doctrines/wehrmacht/upgrades/skirts.png'
import smoke_grenade from '../../../assets/images/doctrines/wehrmacht/upgrades/smoke_grenade.png'
import tank_smoke from '../../../assets/images/doctrines/wehrmacht/upgrades/tank_smoke.png'

import charismatic_leaders from '../../../assets/images/doctrines/wehrmacht/unlocks/defensive/charismatic_leaders.png'
import g43 from '../../../assets/images/doctrines/panzer_elite/upgrades/g43.png'

import repair_manuals from '../../../assets/images/doctrines/americans/upgrades/repair_manuals.png'

import flamethrower from '../../../assets/images/doctrines/common/upgrades/flamethrower.png'
import mine_detector from '../../../assets/images/doctrines/common/upgrades/mine_detector.png'
import mines from '../../../assets/images/doctrines/common/upgrades/mines.png'
import timed_demo from '../../../assets/images/doctrines/common/upgrades/timed_demo.png'

export const ASSAULT_GRENADES = 'assault_grenades'
export const AXIS_AT_MINES = 'axis_at_mines'
export const AXIS_FLAMETHROWER = 'axis_flamethrower'
export const AXIS_GOLIATH = 'axis_goliath'
export const AXIS_GRENADE = 'axis_grenade'
export const AXIS_MINE_DETECTOR = 'axis_mine_detector'
export const AXIS_MINES = 'axis_mines'
export const AXIS_PANZERFAUST = 'axis_panzerfaust'
export const AXIS_PANZERSCHRECK = 'axis_panzerschreck'
export const AXIS_SMOKE_GRENADE = 'axis_smoke_grenade'
export const AXIS_TANK_SMOKE = 'axis_tank_smoke'
export const AXIS_TIMED_DEMO = 'axis_timed_demo'

export const BUNDLE_GRENADE = 'bundle_grenade'
export const BUNKER = 'bunker'
export const CAMO_SMOCKS = 'camo_smocks'
export const CHARISMATIC_LEADERS = 'charismatic_leaders'
export const CREW_REPAIR_KIT = 'crew_repair_kit'
export const FOUR_MP44 = 'four_mp44'
export const LISTENING_POST = 'listening_post'
export const LMG42 = 'lmg42'
export const MEDIC_BUNKER = 'medic_bunker'
export const MEDPACK = 'medpack'
export const MEDPACK_KCH = 'medpack_kch'
export const MG_BUNKER = 'mg_bunker'
export const MORTAR_BUNKER = 'mortar_bunker'
export const MP40 = 'mp40'
export const P4_MG42 = 'p4_mg42'
export const P4_SKIRTS = 'p4_skirts'
export const PANTHER_MG42 = 'panther_mg42'
export const PANTHER_SKIRTS = 'panther_skirts'
export const PANTHERTURM = 'pantherturm'
export const PUMA_UPGUN = 'puma_upgun'
export const REPAIR_BUNKER = 'repair_bunker'
export const STUG_MG42 = 'stug_mg42'
export const STUG_SKIRTS = 'stug_skirts'
export const STUH_MG42 = 'stuh_mg42'
export const STUH_SKIRTS = 'stuh_skirts'
export const SUPPORT_KARBINES = 'support_karbines'
export const SUPPORT_KARBINES_PIO = 'support_karbines_pio'
export const ST_SCHRECK = 'st_schreck'
export const TERROR_KARBINES = 'terror_karbines'
export const TWO_MP44 = 'two_mp44'

export const upgradeImageMapping = {
  [ASSAULT_GRENADES]: assault_grenades,
  [AXIS_AT_MINES]: mines,
  [AXIS_FLAMETHROWER]: flamethrower,
  [AXIS_GOLIATH]: goliath,
  [AXIS_GRENADE]: grenade,
  [AXIS_MINE_DETECTOR]: mine_detector,
  [AXIS_MINES]: mines,
  [AXIS_PANZERFAUST]: panzerfaust,
  [AXIS_PANZERSCHRECK]: panzerschreck,
  [AXIS_SMOKE_GRENADE]: smoke_grenade,
  [AXIS_TANK_SMOKE]: tank_smoke,
  [AXIS_TIMED_DEMO]: timed_demo,
  [BUNDLE_GRENADE]: bundle_grenade,
  [BUNKER]: bunker,
  [CAMO_SMOCKS]: camo_smocks,
  [CHARISMATIC_LEADERS]: charismatic_leaders,
  [CREW_REPAIR_KIT]: repair_manuals,
  [FOUR_MP44]: mp44,
  [LISTENING_POST]: listening_post,
  [LMG42]: lmg42,
  [MEDIC_BUNKER]: medic_bunker,
  [MEDPACK]: medpack,
  [MEDPACK_KCH]: medpack,
  [MG_BUNKER]: mg_bunker,
  [MORTAR_BUNKER]: mortar_bunker,
  [MP40]: mp40,
  [P4_MG42]: mg42_gunner,
  [P4_SKIRTS]: skirts,
  [PANTHER_MG42]: mg42_gunner,
  [PANTHER_SKIRTS]: skirts,
  [PANTHERTURM]: pantherturm,
  [PUMA_UPGUN]: puma_upgun,
  [REPAIR_BUNKER]: repair_bunker,
  [STUG_MG42]: mg42_gunner,
  [STUG_SKIRTS]: skirts,
  [STUH_MG42]: mg42_gunner,
  [STUH_SKIRTS]: skirts,
  [SUPPORT_KARBINES]: g43,
  [SUPPORT_KARBINES_PIO]: g43,
  [ST_SCHRECK]: panzerschreck,
  [TERROR_KARBINES]: g43,
  [TWO_MP44]: mp44,
}
