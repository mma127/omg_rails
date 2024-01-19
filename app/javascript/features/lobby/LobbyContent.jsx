import React, { useEffect } from "react";
import { Box } from "@mui/material";
import { BattleCard } from "./display/BattleCard";
import { CreateBattleAccordion } from "./creation/CreateBattleAccordion";
import { useDispatch, useSelector } from "react-redux";
import { fetchActiveBattles, fetchChatMessages, selectAllActiveBattles } from "./lobbySlice";
import { selectIsAuthed, selectPlayer } from "../player/playerSlice";
import { LOBBY_CHAT } from "../../constants/chat";
import { ChatContainer } from "./chat/ChatContainer";

export const LobbyContent = ({ rulesetId }) => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(fetchActiveBattles())
    dispatch(fetchChatMessages({chatName: LOBBY_CHAT}))
  }, [])
  const battles = useSelector(selectAllActiveBattles)
  const isAuthed = useSelector(selectIsAuthed)

  let chatContent = isAuthed ? <Box pt={1} pb={1}><ChatContainer /></Box> : null
  let accordionContent = isAuthed ? <Box pt={1} pb={1}><CreateBattleAccordion rulesetId={rulesetId} /></Box> : null

  return (
    <Box pt={1}>
      {chatContent}
      {accordionContent}
      {battles.map(b => (
        <Box key={b.id} pt={1} pb={1}><BattleCard id={b.id} rulesetId={rulesetId} isAuthed={isAuthed} /></Box>))}
    </Box>
  )
}
