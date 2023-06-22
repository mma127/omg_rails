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

export const AvailableUpgradeTooltipContent = ({ availableUpgrade }) => {
  const classes = useStyles()
  const upgrade = useSelector(state => selectUpgradeById(state, availableUpgrade.upgradeId))

  const cost = formatResourceCost({ man: availableUpgrade.man, mun: availableUpgrade.mun, fuel: availableUpgrade.fuel })
  const pop = availableUpgrade.pop
  const uses = availableUpgrade.uses

  return (
    <>
      <Typography variant="subtitle2" className={classes.tooltipHeader}>
        {upgrade.displayName}
      </Typography>
      <Box><Typography variant="body" className={classes.description}>{upgrade.description}</Typography></Box>
      {uses > 0 ? <Box><Typography variant="body"><b>Uses: </b>{uses}</Typography></Box> : null}
      <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
      {pop > 0 ? <Box><Typography variant="body"><b>Pop: </b>{pop}</Typography></Box> : null}
    </>
  )
}
