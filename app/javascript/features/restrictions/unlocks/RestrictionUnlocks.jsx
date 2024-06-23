import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { makeStyles } from "@mui/styles";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";
import { fetchDoctrineUnlocksByDoctrineId, selectDoctrineUnlockRowsByDoctrineId } from "../../doctrines/doctrinesSlice";
import { Box, Grid } from "@mui/material";
import { Unlock } from "./Unlock";

const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  cell: {
    border: "none"
  },
  narrowCell: {
    maxWidth: "87px"
  }
}))

const buildUnlock = (doctrineUnlock) => {
  return (
    <Grid item xs={2} key={`grid-${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}>
      <Unlock doctrineUnlock={doctrineUnlock} />
    </Grid>
  )
}

const buildUnlockRow = (i, unlockRow,) => {
  return (
    <Grid item container spacing={2} key={`row-${i}`}>
      {
        unlockRow.map(u => buildUnlock(u))
      }
    </Grid>
  )
}

export const RestrictionUnlocks = ({ currentFactionId, currentDoctrineId, showDisabled }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    if (currentDoctrineId) {
      dispatch(fetchDoctrineUnlocksByDoctrineId({ doctrineId: currentDoctrineId, rulesetId: activeRuleset.id }))
    }
  }, [currentDoctrineId])

  const doctrineUnlockRows = useSelector(state => selectDoctrineUnlockRowsByDoctrineId(state, currentDoctrineId))

  let content
  if (!_.isEmpty(doctrineUnlockRows)) {
    const keys = Object.keys(doctrineUnlockRows).sort()
    content = keys.map(i => buildUnlockRow(i, doctrineUnlockRows[i]))
  } else {
    content = (
      <Box></Box>
    )
  }

  return (
    <Box className={classes.wrapper}>
      <Grid container spacing={2}>
        {content}
      </Grid>
    </Box>
  )
}
