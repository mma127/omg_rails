import React, { useEffect, useRef, useState } from 'react'
import { Alert } from "@mui/material";

import { ActionCableConsumer } from '@thrash-industries/react-actioncable-provider';
import {
  addChatMessage,
  addNewBattle,
  fetchActiveBattles,
  removeBattle,
  updateActiveUsers,
  updateBattle
} from "./lobbySlice";
import { useDispatch, useSelector } from "react-redux";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId, setCurrentBattle } from "../player/playerSlice";
import { isPlayerInBattle } from "../../utils/battle";
import { LobbyContent } from "./LobbyContent";
import {
  BATTLE_FINALIZED,
  BATTLEFILE_GENERATED,
  CREATED_BATTLE,
  ELO_UPDATED,
  PLAYER_ABANDONED,
  PLAYER_JOINED,
  PLAYER_JOINED_FULL,
  PLAYER_LEFT,
  PLAYER_READY,
  PLAYER_UNREADY,
  PLAYERS_ALL_ABANDONED,
  PLAYERS_ALL_READY,
  REMOVE_BATTLE,
  SIZE_UPDATED
} from "../../constants/battles/events";
import { AlertSnackbar } from "../companies/AlertSnackbar";
import { PageContainer } from "../../components/PageContainer";
import { selectActiveRuleset } from "../rulesets/rulesetsSlice";

export const Lobby = () => {
  // Lobby page container
  // TODO:
  //    Chat
  //    List of active players
  const stateRef = useRef()
  const dispatch = useDispatch()
  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)
  const activeRuleset = useSelector(selectActiveRuleset)

  // Use stateRef to pass the current value of player to the handleReceivedBattlesCable callback. Otherwise the callback
  // method is created with the original null value for player and never updated
  stateRef.current = player

  const error = useSelector(state => state.lobby.errorMessage)
  const notifySnackbar = error?.length > 0
  const [openSnackbar, setOpenSnackbar] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [notifySnackbar])

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity
  let snackbarContent
  let errorAlert
  if (error?.length > 0) {
    errorAlert = <Alert severity="error" sx={{ marginTop: "1rem" }}>{error}</Alert>
    snackbarSeverity = "error"
    snackbarContent = "Lobby operation failed"
  }

  const handleConnectedCable = (message) => {
  }

  const handleReceivedBattlesCable = (message) => {
    const currentPlayer = stateRef.current
    switch (message.type) {
      case CREATED_BATTLE: {
        dispatch(addNewBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(currentPlayer.id, message.battle.battlePlayers)) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
          dispatch(fetchActiveBattles())
        }
        break
      }
      case PLAYER_JOINED: {
        dispatch(updateBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(currentPlayer.id, message.battle.battlePlayers) && currentBattleId !== message.battle.id) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
          dispatch(fetchActiveBattles())
        }
        break
      }
      case PLAYER_JOINED_FULL: {
        dispatch(updateBattle({ battle: message.battle }))
        if (isAuthed && isPlayerInBattle(currentPlayer.id, message.battle.battlePlayers) && currentBattleId !== message.battle.id) {
          dispatch(setCurrentBattle({ battleId: message.battle.id }))
          dispatch(fetchActiveBattles())
        }
        break
      }
      case ELO_UPDATED: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYER_READY: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYER_UNREADY: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYERS_ALL_READY: {
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
      case PLAYER_ABANDONED: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case PLAYERS_ALL_ABANDONED: {
        dispatch(removeBattle({ battle: message.battle }))
        dispatch(fetchActiveBattles())
        break
      }
      case SIZE_UPDATED: {
        dispatch(fetchActiveBattles())
        break
      }
      default: {
        console.log(`Invalid message type ${message.type}`)
        break
      }
    }
  }

  const handleReceivedChatCable = (message) => {
    dispatch(addChatMessage({ message }))
  }

  const handleReceivedActiveUsersCable = message => {
    dispatch(updateActiveUsers({activeUsers: message}))
  }

  return (
    <PageContainer>
      <ActionCableConsumer channel="BattlesChannel"
                           onConnected={handleConnectedCable}
                           onReceived={handleReceivedBattlesCable}/>
      <ActionCableConsumer channel="LobbyChatChannel"
                           onConnected={handleConnectedCable}
                           onReceived={handleReceivedChatCable}/>
      <ActionCableConsumer channel="ActiveUsersChannel"
                           onConnected={handleConnectedCable}
                           onReceived={handleReceivedActiveUsersCable}/>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent}/>
      {errorAlert}
      <LobbyContent/>
    </PageContainer>
  )
}
