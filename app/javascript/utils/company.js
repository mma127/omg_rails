export const formatResourceCost = ({man, mun, fuel}) => {
  let cost = ""
  if (man !== 0) {
    cost += `${man}MP `
  }
  if (mun !== 0) {
    cost += `${mun}MU `
  }
  if (fuel !== 0) {
    cost += `${fuel}FU`
  }

  if (cost.length === 0) {
    cost += "Free"
  }
  return cost
}