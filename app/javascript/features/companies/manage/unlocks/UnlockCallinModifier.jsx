import React from 'react'
import { Box } from "@mui/material";
import SpeedIcon from '@mui/icons-material/Speed';
import { CallinModifierTooltipContent } from "../callin_modifiers/CallinModifierTooltipContent";
import { CallinModifierTooltip } from "../callin_modifiers/CallinModifierTooltip";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles((theme) => ({
  icon: {
    fontSize: 'xx-large'
  }
}))

export const UnlockCallinModifier = ({ enabledCallinModifier }) => {
  const classes = useStyles()
  const callinModifier = enabledCallinModifier.callinModifier

  return (
    <CallinModifierTooltip
      key={callinModifier.id}
      title={<CallinModifierTooltipContent callinModifier={callinModifier} key={callinModifier.id} />}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box>
        <SpeedIcon className={classes.icon} />
      </Box>
    </CallinModifierTooltip>
  )
}
