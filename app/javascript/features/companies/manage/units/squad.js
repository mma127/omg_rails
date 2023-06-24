import { nanoid } from "@reduxjs/toolkit";
import { unitImageMapping } from "../../../../constants/units/all_factions";

export const createAvailableUnit = (unitId, availableUnitId, unitName, pop, man, mun, fuel, image, index, tab) => ({
  unitId: unitId,
  availableUnitId: availableUnitId,
  unitName: unitName,
  pop: parseFloat(pop),
  man: man,
  mun: mun,
  fuel: fuel,
  image: image,
})

// Create a new squad
export const createSquad = (availableUnit,
                            unit,
                            index,
                            tab,
                            transportUuid = null
) => {
  return {
    uuid: nanoid(),
    id: null,
    unitId: unit.id,
    availableUnitId: availableUnit.id,
    unitName: unit.name,
    unitDisplayName: unit.displayName,
    unitType: unit.type,
    pop: parseFloat(availableUnit.pop),
    totalPop: parseFloat(availableUnit.pop), // Squad's total pop including upgrades
    man: availableUnit.man,
    mun: availableUnit.mun,
    fuel: availableUnit.fuel,
    image: unitImageMapping[unit.name],
    index: index,
    tab: tab,
    vet: 0,
    transportTotalPop: parseFloat(availableUnit.pop) // Combination of transport's total pop and passenger total pops
    totalModelCount: unit.modelCount, // How many models this squad contains, inclusive of upgrades
    usedSquadSlots: 0,
    usedModelSlots: 0,
    transportSquadSlots: unit.transportSquadSlots, // How many squads this squad could transport
    transportModelSlots: unit.transportModelSlots, // How many models this squad could transport
    transportUuid: transportUuid, // The transport this squad was created in
    transportedSquadUuids: null,
    transportedSquads: null, // List of squads this squad is transporting
    upgrades: []
  }
}

// Load an existing squad
export const loadSquad = (squad) => {
  return {
    uuid: squad.uuid,
    id: squad.id,
    unitId: squad.unitId,
    availableUnitId: squad.availableUnitId,
    unitName: squad.unitName,
    unitDisplayName: squad.unitDisplayName,
    unitType: squad.unitType,
    pop: parseFloat(squad.pop),
    totalPop: parseFloat(squad.totalPop),
    man: squad.man,
    mun: squad.mun,
    fuel: squad.fuel,
    image: unitImageMapping[squad.unitName],
    index: squad.index,
    tab: squad.tab,
    vet: squad.vet,

    // Transport related
    totalModelCount: squad.totalModelCount,
    usedSquadSlots: 0, // UI only
    usedModelSlots: 0, // UI only
    transportSquadSlots: squad.transportSquadSlots, // How many squads this squad could transport
    transportModelSlots: squad.transportModelSlots,
    transportUuid: squad.transportUuid,
    transportedSquadUuids: squad.transportedSquadUuids,
    transportedSquads: null,

    // Upgrades
    upgrades: squad.upgrades //TODO fix this
  }
}