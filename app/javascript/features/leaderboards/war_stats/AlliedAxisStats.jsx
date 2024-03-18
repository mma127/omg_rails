import React from 'react'
import { Box, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectWarStatsAlliedAxisWins } from "./warStatsSlice";
import { Stat } from "./Stat";

const useStyles = makeStyles(theme => ({
  wrapper: {
    marginLeft: '1rem',
    marginRight: "1rem",
    padding: "0.5rem",
    borderColor: theme.palette.secondary.light,
    borderWidth: '2px',
    borderStyle: 'solid',
    borderRadius: '4px'
  },
  row: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  }
}))

const SideStats = ({ wins, rate, label }) => {
  const classes = useStyles()


  return (
    <Box className={classes.wrapper}>
      <Typography variant="h4" color="text.secondary">{label}</Typography>
      <Box className={classes.row}>
        <Stat value={rate} label="Win Rate" isRate={true} variant={"h5"} />
        <Stat value={wins} label="Wins" />
      </Box>
    </Box>
  )
}

export const AlliedAxisStats = ({}) => {
  const classes = useStyles()

  const [alliedWins, axisWins] = useSelector(selectWarStatsAlliedAxisWins)
  const totalGames = alliedWins + axisWins
  const alliedWinRate = totalGames > 0 ? (alliedWins / totalGames) : 0
  const axisWinRate = totalGames > 0 ? (axisWins / totalGames) : 0

  return (
    <Box className={classes.row}>
      <SideStats rate={alliedWinRate} wins={alliedWins} label="Allied"/>
      <SideStats rate={axisWinRate} wins={axisWins} label="Axis"/>
    </Box>
  )
}