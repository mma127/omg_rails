import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import {
  fetchWarStats,
  selectDoctrinesWarStats, selectFactionsWarStats,
  selectWarStatsGeneratedAt
} from "./warStatsSlice";
import { DateTime } from "luxon";
import { DoctrineStats } from "./DoctrineStats";
import { AlliedAxisStats } from "./AlliedAxisStats";
import { FactionStats } from "./FactionStats";


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
  column: {
    display: "flex",
    flexDirection: "column",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  },
  generatedAtRow: {
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end",
  },
  generatedAt: {
    fontStyle: "italic"
  },
  doctrineStatsWrapper: {
    padding: "0.25rem"
  }
}))

export const WarStats = ({}) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(fetchWarStats({ ruleset_id: 1 }))
  }, []);

  const generatedAt = useSelector(selectWarStatsGeneratedAt)
  const date = DateTime.fromISO(generatedAt)

  const doctrines = useSelector(selectDoctrinesWarStats)
  const factions = useSelector(selectFactionsWarStats)

  return (
    <Box className={classes.wrapper}>
      <Box className={classes.generatedAtRow}>
        <Typography variant="caption" color="text.secondary" className={classes.generatedAt}>Generated
          At: {date.toLocaleString(DateTime.DATETIME_MED)}</Typography>
      </Box>
      <AlliedAxisStats/>
      <Box className={classes.column} sx={{ paddingTop: "1rem", paddingBottom: "1rem" }}>
        {doctrines.map(d => (
          <Box className={classes.doctrineStatsWrapper}>
            <DoctrineStats doctrineStats={d} key={d.id}/>
          </Box>))}
      </Box>
      <Box className={classes.column} sx={{ paddingTop: "1rem" }}>
        {factions.map(f => (
          <Box className={classes.doctrineStatsWrapper}>
            <FactionStats factionStats={f} key={f.id}/>
          </Box>
        ))}
      </Box>
    </Box>
  )
}
