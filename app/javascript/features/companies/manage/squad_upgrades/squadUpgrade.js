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
    upgradeSlots: upgrade.upgradeSlots,
    unitwideUpgradeSlots: upgrade.unitwideUpgradeSlots,
    modelCount: upgrade.modelCount,
    addModelCount: upgrade.additionalModelCount
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
    upgradeSlots: upgrade.upgradeSlots,
    unitwideUpgradeSlots: upgrade.unitwideUpgradeSlots,
    modelCount: upgrade.modelCount,
    addModelCount: upgrade.additionalModelCount
  }
}
