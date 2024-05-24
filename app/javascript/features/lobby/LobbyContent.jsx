import React, { useEffect } from "react";
import { Box, Grid } from "@mui/material";
import { BattleCard } from "./display/BattleCard";
import { CreateBattleAccordion } from "./creation/CreateBattleAccordion";
import { useDispatch, useSelector } from "react-redux";
import { fetchActiveBattles, fetchChatMessages, selectAllActiveBattles } from "./lobbySlice";
import { selectIsAuthed, selectPlayer } from "../player/playerSlice";
import { LOBBY_CHAT } from "../../constants/chat";
import { ChatContainer } from "./chat/ChatContainer";
import { ActiveUsersList } from "./chat/ActiveUsersList";

export const LobbyContent = () => {
  const dispatch = useDispatch()
  const player = useSelector(selectPlayer)
  useEffect(() => {
    dispatch(fetchChatMessages({ chatName: LOBBY_CHAT }))
  }, [])
  useEffect(() => {
    dispatch(fetchActiveBattles())
  }, [player])
  const battles = useSelector(selectAllActiveBattles)
  const isAuthed = useSelector(selectIsAuthed)

  let chatContent = (
    <Grid container pt={1} spacing={1}>
      <Grid item sm={10}>
        <ChatContainer/>
      </Grid>
      <Grid item sm={2} sx={{ display: "flex" }}>
        <ActiveUsersList/>
      </Grid>
    </Grid>)
  let accordionContent = isAuthed ? <Box pt={1} pb={1}><CreateBattleAccordion/></Box> : null

  return (
    <Box pt={1}>
      {chatContent}
      {accordionContent}
      {battles.map(b => (
        <Box key={b.id} pt={1} pb={1}><BattleCard id={b.id} isAuthed={isAuthed}/></Box>))}
    </Box>
  )
}
