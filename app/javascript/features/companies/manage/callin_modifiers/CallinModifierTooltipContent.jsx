import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Typography } from "@mui/material";
import { nanoid } from "@reduxjs/toolkit";
import { useSelector } from "react-redux";
import { selectAllByIds, selectUnitsByIds } from "../units/unitsSlice";

// Bad hack for formatting buffs/debuffs
const BUFF_CATEGORIES = ["Infantry:", "Vehicles:", "Tanks:"]

const useStyles = makeStyles((theme) => ({
  wrapper: {
    minWidth: '142px' // Fits 2 max
  },
  tooltipHeader: {
    fontWeight: 'bold'
  },
  description: {
    fontStyle: "italic"
  },
  buff: {
    color: theme.palette.success.dark
  },
  modifier: {
    paddingLeft: "8px"
  }
}))
export const CallinModifierTooltipContent = ({ callinModifier }) => {
  const classes = useStyles()
  const requiredUnitIds = callinModifier.requiredUnitIds
  const requiredUnitNames = callinModifier.requiredUnitNames
  const allowedUnitIds = callinModifier.allowedUnitIds
  const allowedUnitNames = callinModifier.allowedUnitNames
  const modifier = callinModifier.modifier
  const modifierType = callinModifier.modifierType

  // Select units for names

  let requiredUnitsContent
  if (requiredUnitIds.length > 0) {
    requiredUnitsContent = (
      <Box><Typography variant="body"><b>Requires One Of:</b> {requiredUnitNames} </Typography></Box>
    )
  }

  let allowedUnitsContent
  if (allowedUnitIds.length > 0) {
    allowedUnitsContent = (
      <Box><Typography variant="body"><b>Platoon Can Only Contain:</b> {allowedUnitNames} </Typography></Box>
    )
  }

  return (
    <Box key={callinModifier.id} className={classes.wrapper}>
      <Box><Typography variant="body" className={classes.description}>{callinModifier.unlockName}</Typography></Box>
      <Box><Typography variant="body"><b>Callin Modifier:</b> x{modifier}</Typography></Box>
      {requiredUnitsContent}
      {allowedUnitsContent}
    </Box>
  )
}