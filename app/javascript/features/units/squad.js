export const createAvailableUnit = (unitId, availableUnitId, unitName, pop, man, mun, fuel, image, index, tab) => ({
  unitId: unitId,
  availableUnitId: availableUnitId,
  unitName: unitName,
  pop: pop,
  man: man,
  mun: mun,
  fuel: fuel,
  image: image,
})

export const createSquad = (uuid, id, unitId, availableUnitId, unitName, unitDisplayName, pop, man, mun, fuel, image, index, tab, vet=0) => ({
  uuid: uuid,
  id: id,
  unitId: unitId,
  availableUnitId: availableUnitId,
  unitName: unitName,
  unitDisplayName: unitDisplayName,
  pop: pop,
  man: man,
  mun: mun,
  fuel: fuel,
  image: image,
  index: index,
  tab: tab,
  vet: vet
})