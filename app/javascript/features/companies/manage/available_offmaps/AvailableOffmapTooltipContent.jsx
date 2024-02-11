import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Typography } from "@mui/material";
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

export const AvailableOffmapTooltipContent = ({ availableOffmap, skipBuffs = false }) => {
  const classes = useStyles()
  const offmap = availableOffmap.offmap
  const cost = formatResourceCost({ man: 0, mun: availableOffmap.mun, fuel: 0 })

  let available, unlimited, cooldown,
    duration,
    buffs,
    debuffs
  if (!skipBuffs) {
    available = <Box><Typography variant="body"><b>Available:</b> {availableOffmap.available}</Typography></Box>
    unlimited =
      <Box><Typography variant="body"><b>Unlimited Uses?:</b> {offmap.unlimitedUses ? "Yes" : "No"}</Typography></Box>
    cooldown = <Box><Typography variant="body"><b>Cooldown:</b> {offmap.cooldown}s</Typography></Box>

    if (!_.isNull(offmap.duration)) {
      duration = (
        <Box><Typography variant="body"><b>Duration:</b> {offmap.duration}s</Typography></Box>
      )
    }

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
  }


  return (
    <>
      <Typography variant="subtitle2"
                  className={classes.tooltipHeader}>
        {offmap.displayName}
      </Typography>
      <Box><Typography variant="body" className={classes.description}>{offmap.description}</Typography></Box>
      <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
      {available}
      {unlimited}
      {cooldown}
      {duration}
      {buffs}
      {debuffs}
    </>
  )
}