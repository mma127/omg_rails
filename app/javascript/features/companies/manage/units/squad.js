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
                            companyId,
                            transportUuid = null
) => {
  return {
    uuid: nanoid(),
    id: null,
    companyId: companyId,
    unitId: unit.id,
    availableUnitId: availableUnit.id,
    unitName: unit.name,
    unitDisplayName: unit.displayName,
    unitType: unit.type,
    pop: parseFloat(availableUnit.pop), // Squad pop = unit pop + upgrades pop
    popWithTransported: parseFloat(availableUnit.pop), // Combination of transport's pop and passenger pops
    man: availableUnit.man,
    mun: availableUnit.mun,
    fuel: availableUnit.fuel,
    image: unitImageMapping[unit.name],
    index: index,
    tab: tab,
    vet: 0,
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

export const shallowCopySquad = (squad) => {
  return {
    uuid: nanoid(),
    id: null,
    unitId: squad.unitId,
    availableUnitId: squad.availableUnitId,
    unitName: squad.unitName,
    unitDisplayName: squad.unitDisplayName,
    unitType: squad.unitType,
    pop: squad.pop, // Squad pop = unit pop + upgrades pop
    popWithTransported: squad.pop, // Combination of transport's pop and passenger pops
    man: squad.man,
    mun: squad.mun,
    fuel: squad.fuel,
    image: squad.image,
    index: squad.index,
    tab: squad.tab,
    vet: 0,
    totalModelCount: squad.totalModelCount, // How many models this squad contains, inclusive of upgrades
    usedSquadSlots: 0,
    usedModelSlots: 0,
    transportSquadSlots: squad.transportSquadSlots, // How many squads this squad could transport
    transportModelSlots: squad.transportModelSlots, // How many models this squad could transport
    transportUuid: squad.transportUuid, // The transport this squad was created in
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
    companyId: squad.companyId,
    availableUnitId: squad.availableUnitId,
    unitName: squad.unitName,
    unitDisplayName: squad.unitDisplayName,
    unitType: squad.unitType,
    pop: parseFloat(squad.pop),
    popWithTransported: parseFloat(squad.pop),
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