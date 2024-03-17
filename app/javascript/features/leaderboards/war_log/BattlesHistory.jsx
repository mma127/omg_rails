import React from 'react'
import { useSelector } from "react-redux";
import { selectBattlesHistory } from "../warLogSlice";
import { makeStyles } from "@mui/styles";
import { Box } from "@mui/material";
import { BattleHistory } from "./BattleHistory";

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

export const BattlesHistory = () => {
  const classes = useStyles()
  const battlesHistory = useSelector(selectBattlesHistory)

  return (
    <Box>
      {battlesHistory.map(bh => <BattleHistory battle={bh} key={bh.id}/>)}
    </Box>
  )
}
