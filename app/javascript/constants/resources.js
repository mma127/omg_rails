import man_icon from '../../assets/images/common/manpower.png'
import mun_icon from '../../assets/images/common/munitions.png'
import fuel_icon from '../../assets/images/common/fuel.png'
import pop_icon from '../../assets/images/common/population.png'

export const MAN = "man"
export const MUN = "mun"
export const FUEL = "fuel"
export const POP = "pop"

export const RESOURCE_TO_NAME = {
  [MAN]: "Manpower",
  [MUN]: "Munitions",
  [FUEL]: "Fuel",
  [POP]: "Population"
}

export const RESOURCE_TO_ICON = {
  [MAN]: man_icon,
  [MUN]: mun_icon,
  [FUEL]: fuel_icon,
  [POP]: pop_icon
}
