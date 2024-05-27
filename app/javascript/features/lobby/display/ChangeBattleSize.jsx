import React from 'react'
import { Box, Button } from "@mui/material";
import { useDispatch, useSelector } from "react-redux";
import { changeBattleSize, selectBattleById } from "../lobbySlice";
import { makeStyles } from "@mui/styles";
import { selectPlayer } from "../../player/playerSlice";

const useStyles = makeStyles(theme => ({
  wrapper: {
    display: "flex"
  },
  readyBtn: {
    marginLeft: '20px',
    lineHeight: '1'
  }
}))

const MIN_SIZE = 1
const MAX_SIZE = 4

export const ChangeBattleSize = ({ battleId }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const battle = useSelector(state => selectBattleById(state, battleId))
  const player = useSelector(selectPlayer)
  const isAdmin = player ? player.role === "admin" : false

  const handleReduceClick = () => {
    dispatch(changeBattleSize({ battleId, newSize: battle.size - 1 }))
  }
  const handleIncreaseClick = () => {
    dispatch(changeBattleSize({ battleId, newSize: battle.size + 1 }))
  }

  if (!isAdmin) {
    return null
  }

  return (
    <Box className={classes.wrapper}>
      <Button variant="contained" type="submit" color="secondary" size="small"
              className={classes.readyBtn} disabled={battle.size === MIN_SIZE} onClick={handleReduceClick}>
        Reduce Size
      </Button>
      <Button variant="contained" type="submit" color="secondary" size="small"
              className={classes.readyBtn} disabled={battle.size === MAX_SIZE} onClick={handleIncreaseClick}>
        Increase Size
      </Button>
    </Box>
  )
}
