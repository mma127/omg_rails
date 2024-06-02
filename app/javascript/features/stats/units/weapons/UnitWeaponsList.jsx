import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { useSelector } from "react-redux";
import { selectUnitById } from "../../../companies/manage/units/unitsSlice";
import { selectSortedUpgradeWeaponsForStatsUnitConst, selectStatsUnitByConstName } from "../statsUnitsSlice";
import { selectWeaponsForStatsEntitiesByReference } from "../../entities/statsEntitiesSlice";
import { WeaponStatsSummary } from "../../weapons/WeaponStatsSummary";
import { UpgradeWeapons } from "./UpgradeWeapons";

const useStyles = makeStyles(theme => ({
  contentContainer: {
    display: 'flex',
    flexDirection: "column",
    rowGap: "1rem",
    width: '100%',
    marginLeft: '1rem',
    marginRight: '1rem'
  }
}))

export const UnitWeaponsList = ({}) => {
  const classes = useStyles()
  let params = useParams()
  const unitId = params.unitId

  const unit = useSelector(state => selectUnitById(state, unitId))
  const statsUnit = useSelector(state => selectStatsUnitByConstName(state, unit?.constName))
  // const weaponReferencesSet = useSelector((state) => selectWeaponsForStatsEntitiesByReference(state, statsUnit.data.entities))
  // const weaponReferences = Array.from(weaponReferencesSet).concat(Object.keys(statsUnit.data.squad_upgrade_apply_weapons))
  const defaultWeapons = statsUnit.defaultWeapons
  const upgradeWeapons = useSelector(state => selectSortedUpgradeWeaponsForStatsUnitConst(state, unit?.constName))

  return (
    <Box className={classes.contentContainer}>
      <Typography variant="h6">Default Loadout</Typography>
      {defaultWeapons.map(dw => <WeaponStatsSummary reference={dw.reference} count={dw.count} key={dw.reference}/>)}
      <Typography variant="h6">Upgrades</Typography>
      {upgradeWeapons.map(uw => <UpgradeWeapons upgradeId={uw.upgradeId} key={uw.upgradeId}
                                                weaponCount={uw.weaponCount} slotItemCount={uw.slotItemCount}/>)}
    </Box>
  )
}
