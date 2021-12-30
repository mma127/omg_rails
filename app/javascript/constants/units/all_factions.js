import { unitImageMapping as americanUnitImageMapping } from "./americans";

export const INFANTRY = 'Infantry'
export const SUPPORT_TEAM = 'SupportTeam'
export const LIGHT_VEHICLE = 'LightVehicle'
export const TANK = 'Tank'
export const EMPLACEMENT = 'Emplacement'

export const unitTypes = [INFANTRY, SUPPORT_TEAM, LIGHT_VEHICLE, TANK, EMPLACEMENT]

export const unitImageMapping = {
  ...americanUnitImageMapping
}
