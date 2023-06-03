import React from 'react'
import { useSelector } from "react-redux";
import { makeStyles } from "@mui/styles";
import { Box, Typography } from "@mui/material";

import { formatResourceCost } from "../../../../utils/company";
import { selectUpgradeById } from "../upgrades/upgradesSlice";

const useStyles = makeStyles((theme) => ({
  tooltipHeader: {
    fontWeight: 'bold'
  },
  description: {
    fontStyle: "italic"
  },
  modifier: {
    paddingLeft: "8px"
  }
}))

export const SquadUpgradeTooltipContent = ({ squadUpgrade }) => {
  const classes = useStyles()
  const upgrade = useSelector(state => selectUpgradeById(state, squadUpgrade.upgradeId))

  const cost = formatResourceCost({ man: squadUpgrade.man, mun: squadUpgrade.mun, fuel: squadUpgrade.fuel })

  const pop = squadUpgrade.pop

  return (
    <>
      <Typography variant="subtitle2" className={classes.tooltipHeader}>
        {upgrade.displayName}
      </Typography>
      <Box><Typography variant="body" className={classes.description}>{upgrade.description}</Typography></Box>
      <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
      {pop > 0 ? <Box><Typography variant="body"><b>Pop:</b>{pop}</Typography></Box> : null}
    </>
  )
}
