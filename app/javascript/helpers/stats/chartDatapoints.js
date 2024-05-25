import { LONG, MEDIUM, SHORT } from "../../constants/stats/ranges";

export const createDpsDatapoints = (weaponBag, dpsValues) => {
  // From min to range short
  // from range short + 1 to range med
  // From range med + 1 to range long
  // Increments of 1
  const result = []
  if (weaponBag.rangeMin !== 0) {
    for (let i = 0; i < weaponBag.rangeMin; i++) {
      result.push(0)
    }
  }
  for (let i = weaponBag.rangeMin; i <= weaponBag.rangeShort; i++) {
    result.push([i, dpsValues[SHORT]])
  }
  for (let i = weaponBag.rangeShort + 1; i <= weaponBag.rangeMedium; i++) {
    result.push([i, dpsValues[MEDIUM]])
  }
  for (let i = weaponBag.rangeMedium + 1; i <= weaponBag.rangeLong; i++) {
    result.push([i, dpsValues[LONG]])
  }
  return result
}
