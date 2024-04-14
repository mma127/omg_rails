import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { fetchBattlesHistory } from "./warLogSlice";
import { BattlesHistory } from "./BattlesHistory";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";


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

export const WarLog = ({}) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    if (activeRuleset) {
      dispatch(fetchBattlesHistory({ ruleset_id: activeRuleset.id }))
    }
  }, [activeRuleset]);

  return (
    <Box className={classes.wrapper}>
      <BattlesHistory/>
    </Box>
  )
}