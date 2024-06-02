export const INFANTRY = "tp_infantry"
export const INFANTRY_AIRBORNE = 'tp_infantry_airborne'
export const INFANTRY_AIRBORNE_INFLIGHT = 'tp_infantry_airborne_inflight'
export const INFANTRY_RIFLEMEN_ELITE = 'tp_infantry_riflemen_elite'
export const INFANTRY_HEROIC = 'tp_infantry_heroic'
export const INFANTRY_SNIPER = 'tp_infantry_sniper'
export const INFANTRY_SOLDIER = 'tp_infantry_soldier'
export const INFANTRY_SP_M01 = 'tp_infantry_sp_m01'

export const TEAM_WEAPON = 'tp_team_weapon'
export const VEHICLE_ALLIES_57MM_TOWED_GUN = 'tp_vehicle_allies_57mm_towed_gun'
export const VEHICLE_ALLIES_105MM_HOWITZER = 'tp_vehicle_allies_105mm_howitzer'
export const VEHICLE_AXIS_88MM = 'tp_vehicle_axis_88mm'

export const VEHICLE = 'tp_vehicle'
export const VEHICLE_ALLIES_JEEP = 'tp_vehicle_allies_jeep'
export const ARMOUR_AXIS_MOTORCYCLE = 'tp_armour_axis_motorcycle'

export const VEHICLE_UNIVERSAL_CARRIER = 'tp_vehicle_universal_carrier'
export const VEHICLE_ALLIES_M3_HALFTRACK = 'tp_vehicle_allies_m3_halftrack'
export const VEHICLE_ALLIES_M8_GREYHOUND = 'tp_vehicle_allies_m8_greyhound'

export const VEHICLE_AXIS_SDKFZ_234 = 'tp_vehicle_axis_sdkfz_234_heavy_armoured_car'
export const VEHICLE_AXIS_SDKFZ_251 = 'tp_vehicle_axis_sdkfz_251_halftrack'
export const VEHICLE_AXIS_SDKFZ_22X = 'tp_vehicle_sdkfz_22x_light_armoured_car'
export const VEHICLE_AXIS_SDKFZ_22X_IMPROVED = '0x7F36CAFB'

export const ARMOUR_ALLIES_M10_TD = 'tp_armour_allies_m10_td'
export const ARMOUR_ALLIES_SHERMAN = 'tp_armour_allies_sherman'
export const ARMOUR_ALLIES_M26_PERSHING = 'tp_armour_m26_pershing'

export const ARMOUR_AXIS_STUG = 'tp_armour_axis_stug'
export const ARMOUR_AXIS_STUG_SKIRTS = 'tp_armour_axis_stug_skirts'
export const ARMOUR_AXIS_OSTWIND = 'tp_armour_axis_ostwind'
export const ARMOUR_AXIS_PANZERIV = 'tp_armour_axis_panzeriv'
export const ARMOUR_AXIS_PANZERIV_SKIRTS = 'tp_armour_axis_panzeriv_skirts'
export const ARMOUR_AXIS_PANTHER = 'tp_armour_axis_panther'
export const ARMOUR_AXIS_PANTHER_SKIRTS = 'tp_armour_axis_panther_skirts'
export const ARMOUR_AXIS_TIGER = 'tp_armour_axis_tiger'

export const ARMOUR_CW_STUART = 'tp_armour_cw_stuart'
export const ARMOUR_CW_CROMWELL = 'tp_armour_cw_cromwell'
export const ARMOUR_CW_CHURCHILL = 'tp_armour_cw_churchill'
export const ARMOUR_CW_PRIEST = 'tp_armour_cw_priest'

export const ARMOUR_MARDERIII = 'tp_armour_marderiii'
export const ARMOUR_PE_HETZER = 'tp_armour_pe_hetzer'
export const ARMOUR_PE_JAGDPANTHER = 'tp_armour_pe_jagdpanther'
export const ARMOUR_PE_HUMMEL = 'tp_armour_pe_hummel'

export const P47_THUNDERBOLT = 'tp_p47_thunderbolt'
export const BUILDING = 'tp_building'
export const BUILDING_ALLIES_CHECKPOINT = 'tp_building_allies_checkpoint'
export const BUILDING_AXIS_BUNKER_LITE = 'tp_building_axis_bunker_lite'
export const BUILDING_BUNKER_EMPLACEMENT = 'tp_building_bunker_emplacement'
export const BUILDING_UNDER_CONSTRUCTION = 'tp_building_under_construction'
export const CW_EMPLACEMENTS = 'tp_cw_emplacements'
export const DEFENSES = 'tp_defenses'
export const DEFENSES_UNDER_CONSTRUCTION = 'tp_defenses_under_construction'
export const SLIT_TRENCH = 'tp_slit_trench'
export const OBJECT_WOOD = 'tp_object_wood'
export const OBJECT_METAL_STONE = 'tp_object_metal_stone'
export const OBJECT_DETECTOR_RADIO = 'tp_object_detector_radio'
export const MINE = 'tp_mine'
export const MINE_AIRDROP = 'tp_mine_airdrop'
export const VEHICLE_CIVILIAN = 'tp_vehicle_civilian'

export const TARGET_TO_DISPLAY_NAME = {
  [INFANTRY]: 'Infantry',
  [INFANTRY_AIRBORNE]: 'Infantry Airborne',
  [INFANTRY_AIRBORNE_INFLIGHT]: 'Infantry Airborne Inflight',
  [INFANTRY_RIFLEMEN_ELITE]: 'Infantry Elite',
  [INFANTRY_HEROIC]: 'Infantry Heroic',
  [INFANTRY_SNIPER]: 'Infantry Sniper',
  [INFANTRY_SOLDIER]: 'Infantry Soldier',
  [INFANTRY_SP_M01]: 'Infantry SP M01',
  [TEAM_WEAPON]: 'Team Weapon',
  [VEHICLE_ALLIES_57MM_TOWED_GUN]: 'Vehicle Allies 57mm Towed Gun',
  [VEHICLE_ALLIES_105MM_HOWITZER]: 'Vehicle Allies 105mm Howitzer',
  [VEHICLE_AXIS_88MM]: 'Vehicle Axis 88mm',
  [VEHICLE]: 'Vehicle',
  [VEHICLE_ALLIES_JEEP]: 'Vehicle Allies Jeep',
  [ARMOUR_AXIS_MOTORCYCLE]: 'Armour Axis Motorcycle',
  [VEHICLE_UNIVERSAL_CARRIER]: 'Vehicle Universal Carrier',
  [VEHICLE_ALLIES_M3_HALFTRACK]: 'Vehicle Allies M3 Halftrack',
  [VEHICLE_ALLIES_M8_GREYHOUND]: 'Vehicle Allies M8 Greyhound',
  [VEHICLE_AXIS_SDKFZ_234]: 'Vehicle Axis Sdkfz 234 Heavy Armoured Car',
  [VEHICLE_AXIS_SDKFZ_251]: 'Vehicle Axis Sdkfz 251 Halftrack',
  [VEHICLE_AXIS_SDKFZ_22X]: 'Vehicle Axis Sdkfz 22x Light Armoured Car',
  [VEHICLE_AXIS_SDKFZ_22X_IMPROVED]: 'Vehicle Axis Sdkfz 22x Light Armoured Car Improved',
  [ARMOUR_ALLIES_M10_TD]: 'Armour Allies M10 TD',
  [ARMOUR_ALLIES_SHERMAN]: 'Armour Allies Sherman',
  [ARMOUR_ALLIES_M26_PERSHING]: 'Armour M26 Pershing',
  [ARMOUR_AXIS_STUG]: 'Armour Axis StuG',
  [ARMOUR_AXIS_STUG_SKIRTS]: 'Armour Axis StuG Skirts',
  [ARMOUR_AXIS_OSTWIND]: 'Armour Axis Ostwind',
  [ARMOUR_AXIS_PANZERIV]: 'Armour Axis PanzerIV',
  [ARMOUR_AXIS_PANZERIV_SKIRTS]: 'Armour Axis PanzerIV Skirts',
  [ARMOUR_AXIS_PANTHER]: 'Armour Axis Panther',
  [ARMOUR_AXIS_PANTHER_SKIRTS]: 'Armour Axis Panther Skirts',
  [ARMOUR_AXIS_TIGER]: 'Armour Axis Tiger',
  [ARMOUR_CW_STUART]: 'Armour CW Stuart',
  [ARMOUR_CW_CROMWELL]: 'Armour CW Cromwell',
  [ARMOUR_CW_CHURCHILL]: 'Armour CW Churchill',
  [ARMOUR_CW_PRIEST]: 'Armour CW Priest',
  [ARMOUR_MARDERIII]: 'Armour Marder III',
  [ARMOUR_PE_HETZER]: 'Armour PE Hetzer',
  [ARMOUR_PE_JAGDPANTHER]: 'Armour PE JadgPanther',
  [ARMOUR_PE_HUMMEL]: 'Armour PE Hummel',

  [P47_THUNDERBOLT]: 'P47 Thunderbolt',
  [BUILDING]: 'Building',
  [BUILDING_ALLIES_CHECKPOINT]: 'Building Allies Checkpoint',
  [BUILDING_AXIS_BUNKER_LITE]: 'Building Axis Bunker Lite',
  [BUILDING_BUNKER_EMPLACEMENT]: 'Building Bunker Emplacement',
  [BUILDING_UNDER_CONSTRUCTION]: 'Building Under Construction',
  [CW_EMPLACEMENTS]: 'CW Emplacements',
  [DEFENSES]: 'Defenses',
  [DEFENSES_UNDER_CONSTRUCTION]: 'Defenses Under Construction',
  [SLIT_TRENCH]: 'Slit Trench',
  [OBJECT_WOOD]: 'Object Wood',
  [OBJECT_METAL_STONE]: 'Object Metal Stone',
  [OBJECT_DETECTOR_RADIO]: 'Object Detector Radio',
  [MINE]: 'Mine',
  [MINE_AIRDROP]: 'Mine Airdrop',
  [VEHICLE_CIVILIAN]: 'Vehicle Civilian',
}

export const TARGET_ORDER = [
  INFANTRY,
  INFANTRY_AIRBORNE,
  INFANTRY_AIRBORNE_INFLIGHT,
  INFANTRY_RIFLEMEN_ELITE,
  INFANTRY_HEROIC,
  INFANTRY_SNIPER,
  INFANTRY_SOLDIER,
  INFANTRY_SP_M01,

  TEAM_WEAPON,
  VEHICLE_ALLIES_57MM_TOWED_GUN,
  VEHICLE_ALLIES_105MM_HOWITZER,
  VEHICLE_AXIS_88MM,

  VEHICLE,
  VEHICLE_ALLIES_JEEP,
  ARMOUR_AXIS_MOTORCYCLE,

  VEHICLE_UNIVERSAL_CARRIER,
  VEHICLE_ALLIES_M3_HALFTRACK,
  VEHICLE_ALLIES_M8_GREYHOUND,

  VEHICLE_AXIS_SDKFZ_234,
  VEHICLE_AXIS_SDKFZ_251,
  VEHICLE_AXIS_SDKFZ_22X,
  VEHICLE_AXIS_SDKFZ_22X_IMPROVED,

  ARMOUR_ALLIES_M10_TD,
  ARMOUR_ALLIES_SHERMAN,
  ARMOUR_ALLIES_M26_PERSHING,

  ARMOUR_AXIS_STUG,
  ARMOUR_AXIS_STUG_SKIRTS,
  ARMOUR_AXIS_OSTWIND,
  ARMOUR_AXIS_PANZERIV,
  ARMOUR_AXIS_PANZERIV_SKIRTS,
  ARMOUR_AXIS_PANTHER,
  ARMOUR_AXIS_PANTHER_SKIRTS,
  ARMOUR_AXIS_TIGER,

  ARMOUR_CW_STUART,
  ARMOUR_CW_CROMWELL,
  ARMOUR_CW_CHURCHILL,
  ARMOUR_CW_PRIEST,

  ARMOUR_MARDERIII,
  ARMOUR_PE_HETZER,
  ARMOUR_PE_JAGDPANTHER,
  ARMOUR_PE_HUMMEL,

  P47_THUNDERBOLT,
  BUILDING,
  BUILDING_ALLIES_CHECKPOINT,
  BUILDING_AXIS_BUNKER_LITE,
  BUILDING_BUNKER_EMPLACEMENT,
  BUILDING_UNDER_CONSTRUCTION,
  CW_EMPLACEMENTS,
  DEFENSES,
  DEFENSES_UNDER_CONSTRUCTION,
  SLIT_TRENCH,
  OBJECT_WOOD,
  OBJECT_METAL_STONE,
  OBJECT_DETECTOR_RADIO,
  MINE,
  MINE_AIRDROP,
  VEHICLE_CIVILIAN,
]
