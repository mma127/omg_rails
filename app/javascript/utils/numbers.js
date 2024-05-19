export const precise = (value, precision=4) => {
  return Number(parseFloat(value).toFixed(precision))
}
