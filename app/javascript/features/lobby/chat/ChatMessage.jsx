import React from 'react'
import { Box } from "@mui/material";
import { useSelector } from "react-redux";
import { lobbyChatMessages } from "../lobbySlice";

export const ChatMessage = ({}) => {

  const chatMessages = useSelector(lobbyChatMessages)

  return (
    <Box>

    </Box>
  )
}
