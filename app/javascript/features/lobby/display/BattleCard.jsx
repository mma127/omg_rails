import React, { useEffect, useState } from 'react'
import {
  Alert, AlertTitle,
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
import { selectIsAuthed, selectPlayer } from "../../player/playerSlice";
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
    justifyContent: 'center',
    alignItems: "inherit",
    flex: 1
  },
  vcColumn: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%'
  },
  row: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  },
  battleId: {
    textAlign: "center",
    display: "flex"
  },
  battleName: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-start"
  },
  balanceText: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end"
  },
  balanceAlertContainer: {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    paddingBottom: "1rem"
  },
  balanceAlert: {
    alignItems: "center",
    justifyContent: "center"
  },
  balanceAlertTitle: {
    margin: 0
  },
  border: {
    borderColor: theme.palette.secondary.dark,
    borderWidth: '4px',
    borderStyle: 'solid'
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
        companyDoctrine: null,
        playerElo: null
      })
    }
  }
  return battlePlayersCopy
}

export const BattleCard = ({ id, rulesetId }) => {
  const classes = useStyles()
  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const battle = useSelector(state => selectBattleById(state, id))
  const size = battle.size
  const alliedPlayers = addPlaceholders(battle.battlePlayers.filter(p => p.side === 'allied'), size)
  const axisPlayers = addPlaceholders(battle.battlePlayers.filter(p => p.side === 'axis'), size)
  const generatingContent = battle.state === GENERATING ? <Typography>Generating</Typography> : ""
  const ingameContent = battle.state === INGAME ?
    <Link to={`/api/battles/${id}/battlefiles/zip`} target="_blank" download>Download Battlefile</Link> : ""
  const isFull = battle.battlePlayers.length === size * 2

  const playerInThisBattle = player ? battle.battlePlayers.some(bp => bp.playerId === player?.id) : false

  const balanceColor = (balance) => {
    switch (balance) {
      case "Perfect":
        return "gold";
      case "Balanced":
        return "green";
      case "Allied Stomp":
        return "blue";
      case "Axis Stomp":
        return "red";
      case "Allied Favoured":
        return "teal";
      case "Axis Favoured":
        return "pink";
      default:
        return "white";
    }
  }

  const minDiff = (size) => {
    if (size === 4)
      return 50
    else
      return 35
  }

  const balanceState = (balance) => {
    const min = minDiff(battle.size)
    const val = Math.abs(balance)
    if (!balance)
      return "Pending"

    if (balance < (0 - 100))
      return "Allied Stomp"
    else if (balance > 100)
      return "Axis Stomp"
    else if (balance < (0 - min))
      return "Allied Favoured"
    else if (balance > min)
      return "Axis Favoured"
    else if (balance < 10)
      return "Perfect"

    else
      return "Balanced"
  };

  let optimumBalance = false;
  const k = axisPlayers.reduce((accumulator, currentValue) => accumulator + currentValue.teamBalance, 0)
  if (k === size || k === size * 2) {
    optimumBalance = false;
  }

  const calculatedBalanceState = balanceState(battle.eloDifference)

  let optimumBalanceContent
  if (!optimumBalance && isFull) {
    optimumBalanceContent = (
      <Box className={classes.balanceAlertContainer}>
        <Alert severity="warning" className={classes.balanceAlert}>
          <AlertTitle className={classes.balanceAlertTitle}>
            Warning: Balance not optimum, rearrange teams into matching colours for optimum balance
          </AlertTitle>
        </Alert>
      </Box>
    )
  }

  const showBorder = isFull && playerInThisBattle
  return (
    <Card elevation={3} sx={{ padding: '16px' }} className={showBorder ? classes.border : null}>
      <Box className={classes.row}>
        <Box className={classes.battleName}>
          <Typography variant="h5" pl="9px" gutterBottom>{battle.name}</Typography>
        </Box>
        <Box className={classes.battleId}>
          <Typography variant="h5" pl="9px" gutterBottom>Battle ID: </Typography>
          <Typography variant="h5" pl="9px" gutterBottom color="secondary">{battle.id}</Typography>
        </Box>
        <Box className={classes.balanceText}>
          <Typography variant="h5" pl="9px" gutterBottom>Balance: </Typography>
          <Typography variant="h5" pl="9px" gutterBottom
                      color={balanceColor(calculatedBalanceState)}>{calculatedBalanceState}</Typography>
        </Box>
      </Box>
      {/*{fullBanner}*/}
      {optimumBalanceContent}
      {generatingContent}
      {ingameContent}
      <Box className={classes.row}>
        <Box className={classes.column}>
          {alliedPlayers.map(p => <BattleCardPlayer key={p.playerId || nanoid()}
                                                    battleId={id}
                                                    playerId={p.playerId}
                                                    playerName={p.playerName}
                                                    teamBalance={p.teamBalance}
                                                    playerElo={p.playerElo}
                                                    companyDoctrine={p.companyDoctrine}
                                                    side={ALLIED_SIDE}
                                                    battleState={battle.state}
                                                    ready={p.ready}
                                                    abandoned={p.abandoned}
                                                    isFull={isFull}
          />)}
        </Box>
        <Box pt={2} pb={2} className={classes.vsColumn}>
          vs
        </Box>
        <Box className={classes.column}>
          {axisPlayers.map(p => <BattleCardPlayer key={p.playerId || nanoid()}
                                                  battleId={id}
                                                  playerId={p.playerId}
                                                  playerName={p.playerName}
                                                  teamBalance={p.teamBalance}
                                                  playerElo={p.playerElo}
                                                  companyDoctrine={p.companyDoctrine}
                                                  side={AXIS_SIDE}
                                                  battleState={battle.state}
                                                  ready={p.ready}
                                                  abandoned={p.abandoned}
                                                  isFull={isFull}
          />)}
        </Box>
      </Box>
    </Card>
  )
}
