import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Grid, Typography } from "@mui/material";
import HourglassEmptyIcon from '@mui/icons-material/HourglassEmpty';
import HistoryToggleOffIcon from '@mui/icons-material/HistoryToggleOff';
import { formatResourceCost } from "../../../../utils/company";
import { nanoid } from "@reduxjs/toolkit";

// Bad hack for formatting buffs/debuffs
const BUFF_CATEGORIES = ["Infantry:", "Vehicles:", "Tanks:"]

const useStyles = makeStyles((theme) => ({
  tooltipHeader: {
    fontWeight: 'bold'
  },
  description: {
    fontStyle: "italic"
  },
  buff: {
    color: theme.palette.success.dark
  },
  debuff: {
    color: theme.palette.error.main
  },
  modifier: {
    paddingLeft: "8px"
  }
}))
export const UnlockOffmapTooltipContent = ({ enabledOffmap }) => {
  const classes = useStyles()
  const offmap = enabledOffmap.offmap

  let duration
  if (!_.isNull(offmap.duration)) {
    duration = (
      <Box><Typography variant="body"><b>Duration:</b> {offmap.duration}s</Typography></Box>
    )
  }

  let buffs
  if (!_.isNull(offmap.buffs)) {
    buffs = (
      <Box>
        <Typography variant="body"><b className={classes.buff}>Buffs:</b> {offmap.buffs.split(",").map(b => {
          if (BUFF_CATEGORIES.includes(b)) {
            return <Box key={nanoid()}><b>{b}</b></Box>
          } else {
            return <Box key={nanoid()} className={classes.modifier}>{b}</Box>
          }
        })}
        </Typography>
      </Box>
    )
  }
  let debuffs
  if (!_.isNull(offmap.debuffs)) {
    debuffs = (
      <Box>
        <Typography variant="body"><b className={classes.debuff}>Debuffs:</b> {offmap.debuffs.split(",").map(d => {
          if (BUFF_CATEGORIES.includes(d)) {
            return <Box key={nanoid()}><b>{d}</b></Box>
          } else {
            return <Box key={nanoid()} className={classes.modifier}>{d}</Box>
          }
        })}
        </Typography>
      </Box>
    )
  }
  const cost = formatResourceCost({ mun: enabledOffmap.mun })

  return (
    <>
      <Typography variant="subtitle2"
                  className={classes.tooltipHeader}>
        {offmap.displayName}
      </Typography>
      <Box><Typography variant="body" className={classes.description}>{offmap.description}</Typography></Box>
      <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
      <Box><Typography variant="body"><b>Max:</b> {enabledOffmap.max}</Typography></Box>
      <Box><Typography variant="body"><b>Unlimited Uses?:</b> {offmap.unlimitedUses ? "Yes" : "No"}</Typography></Box>
      <Box><Typography variant="body"><b>Cooldown:</b> {offmap.cooldown}s</Typography></Box>
      {duration}
      {buffs}
      {debuffs}
    </>
  )
}