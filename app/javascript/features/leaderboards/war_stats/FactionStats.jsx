import React from 'react'
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { Stat } from "./Stat";
import { FactionIcon } from "../../factions/FactionIcon";

const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  row: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  },
  icon: {
    paddingRight: "0.5rem"
  }
}))

export const FactionStats = ({ factionStats }) => {
  const classes = useStyles()

  return (
    <Box className={classes.row}>
      <Box className={classes.icon}><FactionIcon factionName={factionStats.name}/></Box>
      <Stat value={factionStats.wins} label="Wins"/>
      <Stat value={factionStats.losses} label="Losses"/>
      <Stat value={factionStats.losses + factionStats.wins} label="Total"/>
      <Stat value={factionStats.ratingsAvg} label="Avg Rating"/>
      <Stat value={factionStats.winRate} label="Win Rate" isRate={true}/>
    </Box>
  )
}
