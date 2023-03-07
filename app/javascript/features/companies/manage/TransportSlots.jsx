import React from 'react'
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  wrapper: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: "center"
  },
  text: {
    fontSize: '0.75rem'
  }
}))

export const TransportSlots = ({ usedSquadSlots, usedModelSlots, maxSquadSlots, maxModelSlots }) => {
  const classes = useStyles()

  return (
    <Box className={classes.wrapper}>
      <Box className={classes.text}>
        {usedSquadSlots}/{maxSquadSlots}
      </Box>
      <Box className={classes.text}>
        {usedModelSlots}/{maxModelSlots}
      </Box>
    </Box>
  )
}
