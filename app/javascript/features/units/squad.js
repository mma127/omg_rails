export const createAvailableUnit = (unitId, unitName, pop, man, mun, fuel, image, index, tab) => ({
  unitId: unitId,
  unitName: unitName,
  pop: pop,
  man: man,
  mun: mun,
  fuel: fuel,
  image: image,
})

export const createSquad = (uuid, id, unitId, unitName, pop, man, mun, fuel, image, index, tab) => ({
  uuid: uuid,
  id: id,
  unitId: unitId,
  unitName: unitName,
  pop: pop,
  man: man,
  mun: mun,
  fuel: fuel,
  image: image,
  index: index,
  tab: tab
})