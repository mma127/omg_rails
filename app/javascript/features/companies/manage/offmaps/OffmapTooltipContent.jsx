import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Grid, Typography } from "@mui/material";
import HourglassEmptyIcon from '@mui/icons-material/HourglassEmpty';
import HistoryToggleOffIcon from '@mui/icons-material/HistoryToggleOff';

// Bad hack for formatting buffs/debuffs
const BUFF_CATEGORIES = ["Infantry:", "Vehicles:", "Tanks:"]

const useStyles = makeStyles(() => ({
  tooltipHeader: {
    fontWeight: 'bold'
  },
  description: {
    fontStyle: "italic"
  }
}))
export const OffmapTooltipContent = ({ offmap }) => {
  const classes = useStyles()

  let duration
  if (!_.isNull(offmap.duration)) {
    duration = (
      <Grid item xs={4}>
        <Typography variant="subtitle2">Duration</Typography>
        <Typography variant="caption">{offmap.duration}s</Typography>
      </Grid>
    )
  }

  let buffs
  if (!_.isNull(offmap.buffs)) {
    buffs = (
      <Grid item container spacing={1}>
        <Grid item xs={12}>
          <Typography variant="subtitle2" color="success.dark">Buffs</Typography>
          {offmap.buffs.split(",").map(b => {
            const variant = BUFF_CATEGORIES.includes(b) ? "subtitle2" : "caption"
            return <Box><Typography variant={variant}>{b}</Typography></Box>
          })}
        </Grid>
      </Grid>
    )
  }
  let debuffs
  if (!_.isNull(offmap.debuffs)) {
    debuffs = (
      <Grid item container spacing={1}>
        <Grid item xs={12}>
          <Typography variant="subtitle2" color="error.main">Debuffs</Typography>
          {offmap.debuffs.split(",").map(d => {
            const variant = BUFF_CATEGORIES.includes(d) ? "subtitle2" : "caption"
            return <Box><Typography variant={variant}>{d}</Typography></Box>
          })}
        </Grid>
      </Grid>
    )
  }

  return (
    <>
      <Typography variant="subtitle2"
                  className={classes.tooltipHeader}>
        {offmap.displayName}
      </Typography>
      <Box><Typography variant="body" className={classes.description}>{offmap.description}</Typography></Box>
      <Box><Typography variant="body"><b>Cooldown:</b> {offmap.cooldown}s</Typography></Box>
      <Box><Typography variant="body"><b>Unlimited Uses?:</b> {offmap.unlimitedUses ? "Yes" : "No"}</Typography></Box>
      <Box><Typography variant="body"><b>Max:</b> {offmap.max}</Typography></Box>
    </>
  )

  // return (
  //   <Grid container spacing={1}>
  //     <Grid item container spacing={1}>
  //       <Grid item xs={12}>
  //         <Typography variant="h6">
  //           {offmap.displayName}
  //         </Typography>
  //       </Grid>
  //     </Grid>
  //     <Grid item container spacing={1}>
  //       <Grid item xs={12}>
  //         <Typography variant="caption">
  //           {offmap.description}
  //         </Typography>
  //       </Grid>
  //     </Grid>
  //     <Grid item container spacing={1}>
  //       <Grid item xs={4}>
  //         <Typography variant="subtitle2">
  //           Cooldown
  //         </Typography>
  //         <Typography variant="caption">
  //           {offmap.cooldown}s
  //         </Typography>
  //       </Grid>
  //       {duration}
  //       <Grid item xs={4}>
  //         <Typography variant="subtitle2">Unlimited?</Typography>
  //         <Typography variant="caption">{offmap.unlimitedUses ? "Yes" : "No"}</Typography>
  //       </Grid>
  //     </Grid>
  //     {buffs}
  //     {debuffs}
  //   </Grid>
  // )
}