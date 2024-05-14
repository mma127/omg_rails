export const TOTAL_COUNT = "totalCount"

export const getLoadoutModelCounts = (loadout) => {
  const result = {}
  let totalCount = 0
  for (const [key, value] of Object.entries(loadout)) {
    const modelCount = parseInt(value)
    result[key] = modelCount
    totalCount += modelCount
  }
  result[TOTAL_COUNT] = totalCount
  return result
}
