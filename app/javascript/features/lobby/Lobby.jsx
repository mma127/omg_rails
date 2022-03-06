import React, { useEffect } from 'react'
import { Box, Container, Typography, Accordion, AccordionSummary, AccordionDetails } from "@mui/material";
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';

import { ActionCableConsumer, ActionCableProvider } from 'react-actioncable-provider';
import { CreateBattleForm } from "./creation/CreateBattleForm";
import { fetchActiveBattles, addNewBattle, selectAllActiveBattles, updateBattle, removeBattle } from "./lobbySlice";
import { useDispatch, useSelector } from "react-redux";
import { fetchCompanies } from "../companies/companiesSlice";
import { CreateBattleAccordion } from "./creation/CreateBattleAccordion";
import { BattleCard } from "./display/BattleCard";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId, setCurrentBattle } from "../player/playerSlice";
import { isPlayerInBattle } from "../../utils/battle";
import { LobbyContent } from "./LobbyContent";

const rulesetId = 1
const CREATED_BATTLE = "created_battle"
const PLAYER_JOINED = "player_joined"
const PLAYER_LEFT = "player_left"
const REMOVE_BATTLE = "removed_battle"

export const Lobby = () => {
  // Lobby page container
  // TODO:
  //    Chat
  //    List of active players
  //    List of games
  //    Joined game

  const dispatch = useDispatch()
  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)

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
      case PLAYER_LEFT: {
        dispatch(updateBattle({ battle: message.battle }))
        break
      }
      case REMOVE_BATTLE: {
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
      <LobbyContent rulesetId={rulesetId}/>
    </Container>
  )
}
