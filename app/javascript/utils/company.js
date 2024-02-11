export const formatResourceCost = ({man, mun, fuel}) => {
  let cost = ""
  if (man && man !== 0) {
    cost += `${man}MP `
  }
  if (mun && mun !== 0) {
    cost += `${mun}MU `
  }
  if (fuel && fuel !== 0) {
    cost += `${fuel}FU`
  }

  if (cost.length === 0) {
    cost += "Free"
  }
  return cost
}