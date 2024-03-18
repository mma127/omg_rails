import React from 'react'
import { Box } from "@mui/material";
import { DoctrineIcon } from "../../doctrines/DoctrineIcon";
import { makeStyles } from "@mui/styles";
import { Stat } from "./Stat";

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

export const DoctrineStats = ({ doctrineStats }) => {
  const classes = useStyles()

  return (
    <Box className={classes.row}>
      <Box className={classes.icon}><DoctrineIcon doctrineName={doctrineStats.name}/></Box>
      <Stat value={doctrineStats.wins} label="Wins"/>
      <Stat value={doctrineStats.losses} label="Losses"/>
      <Stat value={doctrineStats.losses + doctrineStats.wins} label="Total"/>
      <Stat value={doctrineStats.ratingsAvg} label="Avg Rating"/>
      <Stat value={doctrineStats.winRate} label="Win Rate" isRate={true}/>
    </Box>
  )
}
