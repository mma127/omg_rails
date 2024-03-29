import React from 'react'
import { useSelector } from "react-redux";
import { selectAvailableUpgradesByUnitId } from "./availableUpgradesSlice";
import { Box, Typography } from "@mui/material";
import { AvailableUpgradeClickable } from "./AvailableUpgradeClickable";
import { selectSelectedSquad } from "../units/squadsSlice";
import { makeStyles } from "@mui/styles";
import { useParams } from "react-router-dom";
import { selectCompanyActiveBattleId } from "../../companiesSlice";

const generateContent = (au, onSelect, enabled) =>
  <AvailableUpgradeClickable
    key={au.id}
    availableUpgradeId={au.id}
    onUpgradeClick={onSelect}
    enabled={enabled}
  />

const useStyles = makeStyles(() => ({
  title: {
    fontWeight: 'bold'
  },
  placeholder: {
    minHeight: "54px" // 54px instead of 49px because when there are upgrades, we get 5px extra on the bottom for some reason
  }
}))
/**
 * Show all available upgrades for the given company
 * @constructor
 */
export const AvailableUpgrades = ({ unitId, onSelect }) => {
  const classes = useStyles()
  const availableUpgrades = useSelector(state => selectAvailableUpgradesByUnitId(state, unitId))
  const selectedSquad = useSelector(selectSelectedSquad)

  let params = useParams()
  const companyId = params.companyId
  const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))
  const battleLocked = !!activeBattleId

  const enabled = !!selectedSquad && !battleLocked

  let content
  if (availableUpgrades.length > 0) {
    content = availableUpgrades.map(au => generateContent(au, onSelect, enabled))
  } else {
    content = <Box className={classes.placeholder} />
  }

    return (
    <>
      <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.title}>Available Upgrades</Typography>
        {content}
      </Box>
    </>
  )
}
