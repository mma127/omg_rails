import {nanoid} from "@reduxjs/toolkit";

export const createSquadUpgrade = (availableUpgrade, upgrade, squad) => {
  return {
    uuid: nanoid(), // for squad upgrades newly created in the UI, this is the only identifier we have
    id: null,
    upgradeId: availableUpgrade.upgradeId,
    availableUpgradeId: availableUpgrade.id,
    upgradeName: upgrade.name,
    upgradeDisplayName: upgrade.displayName,
    upgradeType: upgrade.type,
    pop: parseFloat(availableUpgrade.pop),
    man: availableUpgrade.man,
    mun: availableUpgrade.mun,
    fuel: availableUpgrade.fuel,
    max: availableUpgrade.max,
    squadId: squad.id,
    squadUuid: squad.uuid,
    index: squad.index,
    tab: squad.tab,
    upgradeSlots: availableUpgrade.upgradeSlots,
    unitwideUpgradeSlots: availableUpgrade.unitwideUpgradeSlots,
    modelCount: upgrade.modelCount,
    addModelCount: upgrade.additionalModelCount
  }
}

export const copySquadUpgrade = (oldSquadUpgrade, targetSquad) => {
  return {
    uuid: nanoid(), // for squad upgrades newly created in the UI, this is the only identifier we have
    id: null,
    upgradeId: oldSquadUpgrade.upgradeId,
    availableUpgradeId: oldSquadUpgrade.availableUpgradeId,
    upgradeName: oldSquadUpgrade.upgradeName,
    upgradeDisplayName: oldSquadUpgrade.upgradeDisplayName,
    upgradeType: oldSquadUpgrade.upgradeType,
    pop: oldSquadUpgrade.pop,
    man: oldSquadUpgrade.man,
    mun: oldSquadUpgrade.mun,
    fuel: oldSquadUpgrade.fuel,
    max: oldSquadUpgrade.max,
    squadId: targetSquad.id,
    squadUuid: targetSquad.uuid,
    index: targetSquad.index,
    tab: targetSquad.tab,
    upgradeSlots: oldSquadUpgrade.upgradeSlots,
    unitwideUpgradeSlots: oldSquadUpgrade.unitwideUpgradeSlots,
    modelCount: oldSquadUpgrade.modelCount,
    addModelCount: oldSquadUpgrade.addModelCount
  }
}

export const loadSquadUpgrade = (squadUpgrade, upgrade, availableUpgrade, squad) => {
  return {
    uuid: nanoid(),
    id: squadUpgrade.id,
    upgradeId: upgrade.id,
    availableUpgradeId: availableUpgrade.id,
    upgradeName: upgrade.name,
    upgradeDisplayName: upgrade.displayName,
    upgradeType: upgrade.type,
    pop: parseFloat(availableUpgrade.pop),
    man: availableUpgrade.man,
    mun: availableUpgrade.mun,
    fuel: availableUpgrade.fuel,
    max: availableUpgrade.max,
    squadId: squad.id,
    squadUuid: squad.uuid,
    index: squad.index,
    tab: squad.tab,
    upgradeSlots: availableUpgrade.upgradeSlots,
    unitwideUpgradeSlots: availableUpgrade.unitwideUpgradeSlots,
    modelCount: upgrade.modelCount,
    addModelCount: upgrade.additionalModelCount
  }
}
