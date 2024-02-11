import React from 'react'
import { makeStyles } from "@mui/styles";
import { CallinModifierTooltipContent } from "./CallinModifierTooltipContent";
import { CallinModifierTooltip } from "./CallinModifierTooltip";
import { Box } from "@mui/material";
import SpeedIcon from "@mui/icons-material/Speed";
import { nanoid } from "@reduxjs/toolkit";

const useStyles = makeStyles(() => ({
  placementBox: {
    display: 'flex',
    flexDirection: 'row'
  }
}))

// Check RequiredUnitIds
// If not empty, then must have one of the requiredUnitIds in the unitIds
const validateRequired = (requiredUnitIds, unitIds) => {
  if (requiredUnitIds.length > 0) {
    return !_.isNil(unitIds.find(unitId => requiredUnitIds.includes(unitId)))
  } else {
    return true
  }
}

// Check allowedUnitIds
// If empty, skip verifying unitIds as any unit is allowed
// If not empty, every element of unitIds must be in allowedUnitIds
const validateAllowed = (allowedUnitIds, unitIds) => {
  if (allowedUnitIds.length > 0) {
    return unitIds.every(unitId => allowedUnitIds.includes(unitId))
  } else {
    return true
  }
}

export const CallinModifierIcon = ({ callinModifiers, unitIds }) => {
  const classes = useStyles()

  if (callinModifiers.length === 0 || unitIds.length === 0) {
    return null
  }
  const uniqueUnitIds = [...new Set(unitIds)]
  let tooltips = []

  // Have callin modifiers and unit ids to check against them
  for (const cm of callinModifiers) {
    // Validate required units and allowed units conditions
    if (!validateRequired(cm.requiredUnitIds, uniqueUnitIds) || !validateAllowed(cm.allowedUnitIds, uniqueUnitIds)) {
      continue
    }

    // At this point, this callin modifier is active
    tooltips.push(<CallinModifierTooltipContent callinModifier={cm} key={cm.id}/>)
  }

  if (tooltips.length === 0) {
    // No callin modifiers active
    return null
  } else {
    return (
      <CallinModifierTooltip
        key={nanoid()}
        title={<Box className={classes.placementBox}>{tooltips}</Box>}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box>
          <SpeedIcon sx={{ width: "0.9em" }}/>
        </Box>
      </CallinModifierTooltip>
    )
  }
}
