import React from 'react'
import { useSelector } from "react-redux";
import { selectIsAuthed, selectPlayer } from "./playerSlice";
import { SteamLoginButton } from "./SteamLoginButton";
import { Avatar, Box } from "@mui/material";

export const PlayerAuthStatus = () => {
  // Get current player state
  // If player data exists, is logged in. Display player data
  // Else, player not logged in, show Steam login button
  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)

  let content
  if (isAuthed) {
    content = (
      <Box sx={{ display: 'flex', marginLeft: 'auto' }}>
        <Avatar src={player.avatar} alt={player.name} sx={{ width: 56, height: 56 }} />
      </Box>
    )
  } else {
    content = (
      <Box sx={{ display: 'flex', marginLeft: 'auto' }}>
        <SteamLoginButton />
      </Box>
    )
  }

  return content
}