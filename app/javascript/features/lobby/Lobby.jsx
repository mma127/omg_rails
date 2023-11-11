import React, { useEffect, useState } from 'react'
import { Box, Container, Typography, Accordion, AccordionSummary, AccordionDetails, Alert } from "@mui/material";

import { ActionCableConsumer } from '@thrash-industries/react-actioncable-provider';
import { addNewBattle, updateBattle, removeBattle } from "./lobbySlice";
import { useDispatch, useSelector } from "react-redux";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId, setCurrentBattle } from "../player/playerSlice";
import { isPlayerInBattle } from "../../utils/battle";
import { LobbyContent } from "./LobbyContent";
import {
  BATTLEFILE_GENERATED,
  CREATED_BATTLE,
  PLAYER_ALL_READY,
  PLAYER_JOINED,
  PLAYER_JOINED_FULL,
  PLAYER_LEFT,
  PLAYER_READY,
  REMOVE_BATTLE,
  BATTLE_FINALIZED
} from "../../constants/battles/events";
import { AlertSnackbar } from "../companies/AlertSnackbar";

const rulesetId = 1

export const Lobby = () => {
  // Lobby page container
  // TODO:
  //    Chat
  //    List of active players

  const dispatch = useDispatch()
  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)

  const error = useSelector(state => state.lobby.errorMessage)
  const notifySnackbar = error?.length > 0
  const [ openSnackbar, setOpenSnackbar ] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [ notifySnackbar ])

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity
  let snackbarContent
  let errorAlert
  if (error?.length > 0) {
    errorAlert = <Alert severity="error" sx={{marginTop: "1rem"}}>{ error }</Alert>
    snackbarSeverity = "error"
    snackbarContent = "Lobby operation failed"
  }

  const handleConnectedCable = (message) => {
    console.log(`Connected to cable`)
  }

  const handleReceivedCable = (message) => {
    console.log(`Received cable:`)
    console.log(message)

    switch (message.type) {
      case CREATED_BATTLE: {
        dispatch(addNewBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(player.id, message.battle.battlePlayers)) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
        }
        break
      }
      case PLAYER_JOINED: {
        dispatch(updateBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(player.id, message.battle.battlePlayers) && currentBattleId !== message.battle.id) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
        }
        break
      }
      case PLAYER_JOINED_FULL: {
        dispatch(updateBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(player.id, message.battle.battlePlayers) && currentBattleId !== message.battle.id) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
        }
        break
      }
      case PLAYER_READY: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYER_ALL_READY: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case BATTLEFILE_GENERATED: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYER_LEFT: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case REMOVE_BATTLE: {
        dispatch(removeBattle({ battle: message.battle }))
        break
      }
      case BATTLE_FINALIZED: {
        dispatch(removeBattle({ battle: message.battle }))
        break
      }
      default: {
        console.log(`Invalid message type ${message.type}`)
        break
      }
    }
  }

  return (
    <Container>
      <ActionCableConsumer channel="BattlesChannel"
                           onConnected={handleConnectedCable}
                           onReceived={handleReceivedCable} />
      <AlertSnackbar isOpen={ openSnackbar }
                     setIsOpen={ setOpenSnackbar }
                     handleClose={ handleCloseSnackbar }
                     severity={ snackbarSeverity }
                     content={ snackbarContent }/>
      { errorAlert }
      <LobbyContent rulesetId={rulesetId} />
    </Container>
  )
}
