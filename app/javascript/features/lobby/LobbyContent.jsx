import React, { useEffect } from "react";
import { Box } from "@mui/material";
import { BattleCard } from "./display/BattleCard";
import { CreateBattleAccordion } from "./creation/CreateBattleAccordion";
import { useDispatch, useSelector } from "react-redux";
import { fetchActiveBattles, selectAllActiveBattles } from "./lobbySlice";
import { selectIsAuthed, selectPlayer } from "../player/playerSlice";

export const LobbyContent = ({ rulesetId }) => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(fetchActiveBattles())
  }, [])
  const battles = useSelector(selectAllActiveBattles)
  const isAuthed = useSelector(selectIsAuthed)

  let accordionContent = isAuthed ? <Box pt={1} pb={1}><CreateBattleAccordion rulesetId={rulesetId} /></Box> : ""

  return (
    <Box pt={1}>
      {accordionContent}
      {battles.map(b => (
        <Box key={b.id} pt={1} pb={1}><BattleCard id={b.id} rulesetId={rulesetId} isAuthed={isAuthed} /></Box>))}
    </Box>
  )
}
