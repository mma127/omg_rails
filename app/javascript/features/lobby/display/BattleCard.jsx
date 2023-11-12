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
import { GENERATING, INGAME } from "../../../constants/battles/states";
import { Link } from "react-router-dom";

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
  },
  headerRow: {
    display: "flex",
    justifyContent: "space-between"
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
  const generatingContent = battle.state === GENERATING ? <Typography>Generating</Typography> : ""
  const ingameContent = battle.state === INGAME ? <Link to={`/api/battles/${id}/battlefiles/zip`} target="_blank" download>Download Battlefile</Link> : ""

  return (
    <Box>
      <Card elevation={3} sx={{ padding: '16px' }}>
        <Box className={classes.headerRow}>
          <Typography variant={"h5"} pl={"9px"} gutterBottom>{battle.name}</Typography>
          <Box className={classes.headerRow}>
            <Typography variant={"h5"} pl={"9px"} gutterBottom>Battle ID: </Typography>
            <Typography variant={"h5"} pl={"9px"} gutterBottom color="secondary">{battle.id}</Typography>
          </Box>
        </Box>
        {generatingContent}
        {ingameContent}
        <Grid container>
          <Grid item xs={1}>
            <Box className={classes.column}>
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
                                                        abandoned={p.abandoned}
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
                                                      abandoned={p.abandoned}
              />)}
            </Box>
          </Grid>

        </Grid>
      </Card>
    </Box>
  )
}
