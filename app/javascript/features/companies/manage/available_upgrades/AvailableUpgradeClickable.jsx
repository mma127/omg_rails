import React from 'react'
import {useSelector} from "react-redux";
import {Box, Tooltip} from "@mui/material";
import {makeStyles} from "@mui/styles";

import {selectAvailableUpgradeById} from "./availableUpgradesSlice";
import {AvailableUpgradeTooltipContent} from "./AvailableUpgradeTooltipContent";
import {UpgradeIcon} from "../upgrades/UpgradeIcon";
import {selectUpgradeById} from "../upgrades/upgradesSlice";
import {selectSelectedSquad, selectSquadInTabIndexUuid} from "../units/squadsSlice";
import {selectUnitById} from "../units/unitsSlice";
import {selectSquadUpgradesForSquad} from "../squad_upgrades/squadUpgradesSlice";

const sumSlotsAndExistingUses = (squadUpgrades, upgrade) => {
  let slotsUsed = 0,
    unitwideSlotsUsed = 0,
    squadExistingCount = 0

  squadUpgrades.forEach(su => {
    slotsUsed += su.upgradeSlots
    unitwideSlotsUsed += su.unitwideUpgradeSlots
    if (su.upgradeId === upgrade.id) {
      squadExistingCount += 1
    }
  })
  return {slotsUsed, unitwideSlotsUsed, squadExistingCount}
}

// TODO this is getting called multiple times on purchase and for each available upgrade clickable. can we make this more perf?
const calculateDisabled = (enabled, selectedUnit, availableUpgrade, upgrade, selectedSquad, squadUpgrades, transportSquad) => {
  if (enabled && !_.isNil(selectedUnit)) {
    const {slotsUsed, unitwideSlotsUsed, squadExistingCount} = sumSlotsAndExistingUses(squadUpgrades, upgrade)

    if (!_.isNil(availableUpgrade.max) && availableUpgrade.max <= squadExistingCount) {
      // At or exceeded max number of this upgrade that the squad can have
      return true
    }
    if (availableUpgrade.upgradeSlots > 0) {
      // Calc upgrade slots/unitwide slots against squad's unit's slots/unitwide slots
      const availableSlots = selectedUnit?.upgradeSlots - slotsUsed
      if (availableUpgrade.upgradeSlots > availableSlots) {
        // We don't have enough slots to fit this upgrade that uses slots
        return true
      }
    }
    if (availableUpgrade.unitwideUpgradeSlots > 0) {
      const availableUnitwideSlots = selectedUnit?.unitwideUpgradeSlots - unitwideSlotsUsed
      if (availableUpgrade.unitwideUpgradeSlots > availableUnitwideSlots) {
        // We don't have enough unitwide slots to fit this upgrade that uses unitwide slots
        return true
      }
    }

    if (transportSquad) {
      // If transport exists, check that there is space for the model slots of the upgrade
      const availableTransportModelSlots = transportSquad.transportModelSlots - transportSquad.usedModelSlots
      if (!_.isNil(upgrade.additionalModelCount) && upgrade.additionalModelCount > availableTransportModelSlots) {
        // We don't have enough transport model slots to fit this upgrade that increases model count
        return true
      }
    }

    // At this stage, we know
    // 1. Not at max for the squad for this upgrade
    // 2. Doesn't exceed upgrade slots
    // 3. Doesn't exceed unitwide upgrade slots
    // 4. Doesn't exceed transport total model slots
    // Allow the upgrade (may still not have the resources but we don't care about that here)
    return false
  }
  return true
}

const useStyles = makeStyles(() => ({
  container: {
    display: "inline-flex",
    padding: "2px"
  },
  wrapperEnabled: {
    cursor: 'pointer'
  }
}))
export const AvailableUpgradeClickable = ({availableUpgradeId, onUpgradeClick, enabled}) => {
  const classes = useStyles()
  const availableUpgrade = useSelector(state => selectAvailableUpgradeById(state, availableUpgradeId))
  const upgrade = useSelector(state => selectUpgradeById(state, availableUpgrade?.upgradeId))

  // Need the squad to determine if purchased this upgrade
  const selectedSquad = useSelector(selectSelectedSquad)
  const transportSquad = useSelector(state => selectSquadInTabIndexUuid(state, selectedSquad?.tab, selectedSquad?.index, selectedSquad?.transportUuid))
  // Need the unit to determine if squad has slots for the upgrade
  const selectedUnit = useSelector(state => selectUnitById(state, selectedSquad?.unitId))
  const squadUpgrades = useSelector(state => selectSquadUpgradesForSquad(state, selectedSquad?.tab, selectedSquad?.index, selectedSquad?.uuid))

  const disabled = calculateDisabled(enabled, selectedUnit, availableUpgrade, upgrade, selectedSquad, squadUpgrades, transportSquad)

  const onUpgradeBoxClick = () => {
    if (!disabled) {
      onUpgradeClick(availableUpgrade, upgrade, selectedSquad)
    }
  }

  return (
    <Tooltip
      key={upgrade.id}
      title={<AvailableUpgradeTooltipContent availableUpgrade={availableUpgrade} key={availableUpgrade.id}/>}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box onClick={onUpgradeBoxClick} className={`${classes.container} ${disabled ? null : classes.wrapperEnabled}`}>
        <UpgradeIcon upgrade={upgrade} key={availableUpgradeId} disabled={disabled}/>
      </Box>
    </Tooltip>
  )
}
