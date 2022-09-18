import React, { useEffect, useState } from 'react'
import {
  Box,
  Button,
  Card,
  Grid,
  Typography
} from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { createBattle, selectBattleById } from "../lobbySlice";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { selectIsAuthed } from "../../player/playerSlice";
import { BattleCardPlayer } from "./BattleCardPlayer";
import { nanoid } from "@reduxjs/toolkit";
import { ALLIED_SIDE, AXIS_SIDE } from "../../../constants/doctrines";

const useStyles = makeStyles(theme => ({
  textInput: {
    '& .MuiOutlinedInput-input': {
      padding: "10px 5px"
    }
  },
  wrapperRow: {
    display: 'flex'
  },
  column: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center'
  }
}))

const addPlaceholders = (battlePlayers, size) => {
  const battlePlayersCopy = battlePlayers.slice()
  if (battlePlayersCopy.length < size) {
    const difference = size - battlePlayersCopy.length
    for (let i = 0; i < difference; i++) {
      battlePlayersCopy.push({
        playerId: null,
        playerName: null,
        companyDoctrine: null
      })
    }
  }
  return battlePlayersCopy
}

export const BattleCard = ({ id, rulesetId }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  // const companies = useSelector(selectAllCompanies)
  const isAuthed = useSelector(selectIsAuthed)
  const battle = useSelector(state => selectBattleById(state, id))
  const size = battle.size
  const alliedPlayers = addPlaceholders(battle.battlePlayers.filter(p => p.side === 'allied'), size)
  const axisPlayers = addPlaceholders(battle.battlePlayers.filter(p => p.side === 'axis'), size)
  const generatingContent = battle.state === "generating" ? <Typography>Generating</Typography> : ""

  return (
    <Box>
      <Card elevation={3} sx={{ padding: '16px' }}>
        <Typography variant={"h5"} pl={"9px"} gutterBottom>{battle.name}</Typography>
        {generatingContent}
        <Grid container>
          <Grid item xs={1}>
            <Box className={classes.column}>
              {/*{battle.size}v{battle.size}*/}
            </Box>
          </Grid>
          <Grid item xs={5}>
            <Box className={classes.column}>
              {alliedPlayers.map(p => <BattleCardPlayer key={p.playerId || nanoid()}
                                                        battleId={id}
                                                        playerId={p.playerId}
                                                        playerName={p.playerName}
                                                        companyDoctrine={p.companyDoctrine}
                                                        side={ALLIED_SIDE}
                                                        battleState={battle.state}
                                                        ready={p.ready}
              />)}
            </Box>
          </Grid>
          <Grid item xs={1}>
            <Box pt={2} pb={2} className={classes.column} sx={{alignItems: 'center', height: '100%'}}>
              vs
            </Box>
          </Grid>

          <Grid item xs={5}>
            <Box className={classes.column}>
              {axisPlayers.map(p => <BattleCardPlayer key={p.playerId || nanoid()}
                                                      battleId={id}
                                                      playerId={p.playerId}
                                                      playerName={p.playerName}
                                                      companyDoctrine={p.companyDoctrine}
                                                      side={AXIS_SIDE}
                                                      battleState={battle.state}
                                                      ready={p.ready}
              />)}
            </Box>
          </Grid>

        </Grid>
      </Card>
    </Box>
  )
}
