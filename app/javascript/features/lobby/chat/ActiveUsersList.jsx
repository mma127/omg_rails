import React from 'react'
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectActiveUsers } from "../lobbySlice";
import { Box, Paper, Typography } from "@mui/material";

const useStyles = makeStyles(theme => ({
  namesPaper: {
    padding: "0.5rem",
    flexGrow: 1
  },
  namesList: {
    maxHeight: "250px",
    overflowY: "auto",
    display: "flex",
    flexDirection: "column",
  },
  onlinePlayersLabel: {
    fontStyle: "italic",
    fontSize: "0.75rem"
  },
  nameItem: {
    fontWeight: "bold",
    textOverflow: "ellipsis"
  }
}))

const ActiveUser = ({ name }) => {
  const classes = useStyles()
  return (
    <Typography className={classes.nameItem} color="text.secondary">{name}</Typography>
  )
}

export const ActiveUsersList = ({}) => {
  const classes = useStyles()
  const activeUsers = useSelector(selectActiveUsers)

  return (
    <Paper className={classes.namesPaper}>
      <Typography className={classes.onlinePlayersLabel} color="text.secondary">Online Players</Typography>
      <Box className={classes.namesList}>
        {activeUsers.map(au => <ActiveUser key={au} name={au}/>)}
      </Box>
    </Paper>
  )
}
