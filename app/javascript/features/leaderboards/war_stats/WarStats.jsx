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
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";


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
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    if (activeRuleset) {
      dispatch(fetchWarStats({ ruleset_id: activeRuleset.id }))
    }
  }, [activeRuleset]);

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
          <Box className={classes.doctrineStatsWrapper} key={d.id}>
            <DoctrineStats doctrineStats={d}/>
          </Box>))}
      </Box>
      <Box className={classes.column} sx={{ paddingTop: "1rem" }}>
        {factions.map(f => (
          <Box className={classes.doctrineStatsWrapper} key={f.id}>
            <FactionStats factionStats={f}/>
          </Box>
        ))}
      </Box>
    </Box>
  )
}
