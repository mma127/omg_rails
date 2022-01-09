import { unitImageMapping as americanUnitImageMapping } from "./americans";
import { unitImageMapping as britishUnitImageMapping } from "./british";
import { unitImageMapping as panzerEliteUnitImageMapping } from "./panzer_elite";
import { unitImageMapping as wehrmachtUnitImageMapping } from "./wehrmacht";

export const INFANTRY = 'Infantry'
export const SUPPORT_TEAM = 'SupportTeam'
export const LIGHT_VEHICLE = 'LightVehicle'
export const TANK = 'Tank'
export const EMPLACEMENT = 'Emplacement'
export const GLIDER = 'Glider'

export const unitTypes = [INFANTRY, SUPPORT_TEAM, LIGHT_VEHICLE, TANK, EMPLACEMENT, GLIDER]

export const unitImageMapping = {
  ...americanUnitImageMapping,
  ...britishUnitImageMapping,
  ...panzerEliteUnitImageMapping,
  ...wehrmachtUnitImageMapping,
}
