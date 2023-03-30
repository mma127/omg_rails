import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Typography } from "@mui/material";
import { formatResourceCost } from "../../../../utils/company";

const useStyles = makeStyles(() => ({
  tooltipHeader: {
    fontWeight: 'bold'
  }
}))
export const AvailableUnitTooltipContent = ({ availableUnit }) => {
  const classes = useStyles()

  const cost = formatResourceCost({ man: availableUnit.man, mun: availableUnit.mun, fuel: availableUnit.fuel })

  return (
    <>
      <Typography variant="subtitle2"
                  className={classes.tooltipHeader}>
        {availableUnit.unitDisplayName}
      </Typography>
      <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
      <Box><Typography variant="body"><b>Pop:</b> {parseFloat(availableUnit.pop)}</Typography></Box>
      <Box><Typography variant="body"><b>Available:</b> {availableUnit.available}</Typography></Box>
      <Box><Typography variant="body"><b>Resupply:</b> {availableUnit.resupply}</Typography></Box>
    </>
  )
}