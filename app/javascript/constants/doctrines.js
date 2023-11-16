import americans from "../../assets/images/factions/flags_usa.png"
import british from "../../assets/images/factions/flags_british.png"
import wehrmacht from "../../assets/images/factions/flags_german.png"
import panzer_elite from "../../assets/images/factions/flags_panzer.png"
import soviets from "../../assets/images/factions/flags_ussr.png"
import ostheer from "../../assets/images/factions/flags_ostheer.png"

import airborne from "../../assets/images/doctrine_banners/airborne.png";
import armor from "../../assets/images/doctrine_banners/armor.png";
import canadians from "../../assets/images/doctrine_banners/canadians.png";
import blitz from "../../assets/images/doctrine_banners/blitz.png";
import commandos from "../../assets/images/doctrine_banners/commandos.png";
import defensive from "../../assets/images/doctrine_banners/defensive.png";
import engineers from "../../assets/images/doctrine_banners/engineers.png";
import infantry from "../../assets/images/doctrine_banners/infantry.png";
import luftwaffe from "../../assets/images/doctrine_banners/luftwaffe.png";
import scorched_earth from "../../assets/images/doctrine_banners/scorched_earth.png";
import tank_hunters from "../../assets/images/doctrine_banners/tank_hunters.png";
import terror from "../../assets/images/doctrine_banners/terror.png";

// Sides
export const ALLIED_SIDE = 'allied';
export const AXIS_SIDE = 'axis';

// Factions
export const AMERICANS = 'americans';
export const BRITISH = 'british';
export const WEHRMACHT = 'wehrmacht';
export const PANZER_ELITE = 'panzer_elite';
export const SOVIETS = 'soviets';
export const OSTHEER = 'ostheer';

export const factionImgMapping = {
  [AMERICANS]: americans,
  [BRITISH]: british,
  [WEHRMACHT]: wehrmacht,
  [PANZER_ELITE]: panzer_elite,
  [SOVIETS]: soviets,
  [OSTHEER]: ostheer
}

// Doctrines
export const AIRBORNE = 'airborne';
export const ARMOR = 'armor';
export const INFANTRY = 'infantry';
export const CANADIANS = 'canadians';
export const COMMANDOS = 'commandos';
export const ENGINEERS = 'engineers';
export const DEFENSIVE = 'defensive';
export const BLITZ = 'blitz';
export const TERROR = 'terror';
export const SCORCHED_EARTH = 'scorched_earth';
export const LUFTWAFFE = 'luftwaffe';
export const TANK_HUNTERS = 'tank_hunters';

export const doctrineImgMapping = {
  [AIRBORNE]: airborne,
  [ARMOR]: armor,
  [CANADIANS]: canadians,
  [BLITZ]: blitz,
  [COMMANDOS]: commandos,
  [DEFENSIVE]: defensive,
  [ENGINEERS]: engineers,
  [INFANTRY]: infantry,
  [LUFTWAFFE]: luftwaffe,
  [SCORCHED_EARTH]: scorched_earth,
  [TANK_HUNTERS]: tank_hunters,
  [TERROR]: terror,
}