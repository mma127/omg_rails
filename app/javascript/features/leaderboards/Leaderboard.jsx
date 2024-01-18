import React from 'react'
import { useDispatch } from "react-redux";
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";


const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  cell: {
    border: "none"
  },
  narrowCell: {
    maxWidth: "87px"
  }
}))

export const Leaderboard = ({}) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  return (
    <Box className={classes.wrapper}>

    </Box>
  )
}