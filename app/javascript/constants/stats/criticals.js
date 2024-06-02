export const INFANTRY = 'tp_infantry'
export const INFANTRY_ELITE = '0x12232C71'
export const INFANTRY_HEROIC = 'tp_infantry_heroic'
export const WEAPON_CREW = 'tp_weapon_crew'
export const ARMOUR = 'tp_armour'
export const ARMOUR_ELITE = 'tp_armour_elite'
export const ARMOUR_REAR = 'tp_armour_rear'
export const LIGHT_VEHICLE = 'tp_light_vehicle'
export const VEHICLE_HALFTRACK = 'tp_vehicle_halftrack'
export const VEHICLE = 'tp_vehicle'
export const SUPPLY_TRUCK = 'tp_supply_truck'
export const GOLIATH = 'tp_goliath'
export const FLYER = 'tp_flyer'

export const CRITICAL_TO_DISPLAY_NAME = {
  [INFANTRY]: 'Infantry',
  [INFANTRY_ELITE]: 'Infantry Elite',
  [INFANTRY_HEROIC]: 'Infantry Heroic',
  [WEAPON_CREW]: 'Weapon Crew',
  [ARMOUR]: 'Armour',
  [ARMOUR_ELITE]: 'Armour Elite',
  [ARMOUR_REAR]: 'Armour Rear',
  [LIGHT_VEHICLE]: 'Light Vehicle',
  [VEHICLE_HALFTRACK]: 'Vehicle Halftrack',
  [VEHICLE]: 'Vehicle',
  [SUPPLY_TRUCK]: 'Supply Truck',
  [GOLIATH]: 'Goliath',
  [FLYER]: 'Flyer',
}

export const CRITICAL_ORDER = [
  INFANTRY,
  INFANTRY_ELITE,
  INFANTRY_HEROIC,
  WEAPON_CREW,
  ARMOUR,
  ARMOUR_ELITE,
  ARMOUR_REAR,
  LIGHT_VEHICLE,
  VEHICLE_HALFTRACK,
  VEHICLE,
  SUPPLY_TRUCK,
  GOLIATH,
  FLYER,
]

// Critical ranges
export const CRITICAL_TABLE_01 = 'critical_table_01'
export const CRITICAL_TABLE_02 = 'critical_table_02'
export const CRITICAL_TABLE_03 = 'critical_table_03'

export const CRITICAL_TABLE_TO_DAMAGE_RANGE = {
  [CRITICAL_TABLE_01]: "Green",
  [CRITICAL_TABLE_02]: "Yellow",
  [CRITICAL_TABLE_03]: "Red"
}
