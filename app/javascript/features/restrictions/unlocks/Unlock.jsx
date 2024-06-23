import React from 'react'
import { Box, Button, Paper, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectPlayer } from "../../player/playerSlice";
import { UnlockDetails } from "../../companies/manage/unlocks/UnlockDetails";
import { unlockImageMapping } from "../../../constants/unlocks/all_factions";
import { UnlockCard } from "../../companies/manage/unlocks/UnlockCard";

const useStyles = makeStyles(theme => ({
  unlockContainer: {
    display: 'flex',
    minHeight: '25rem',
    minWidth: '4rem',
    height: '100%'
  },
  unlockInnerContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    flex: 1
  },
  unlockCardBox: {
    display: 'flex',
    justifyContent: 'center',
    marginBottom: '0.35em'
  },
  titleText: {
    minHeight: '4rem'
  },
  constText: {
    fontSize: "0.65rem"
  },
  devOnlyText: {
    fontSize: "0.85rem",
    color: theme.palette.error.light
  },
  button: {
    margin: 'auto',
    marginTop: "8px"
  }
}))

export const Unlock = ({ doctrineUnlock }) => {
  const classes = useStyles()
  const player = useSelector(selectPlayer)
  const unlock = doctrineUnlock.unlock

  const isAdmin = player ? player.role === "admin" : false
  const isDisabled = doctrineUnlock.disabled
  const showDisabledForAdmin = isDisabled && isAdmin

  let innerContent
  if (!isDisabled || isAdmin) {
    innerContent = (
      <Box p={2} className={classes.unlockInnerContainer}>
        <Typography variant="h5" gutterBottom align="center"
                    className={classes.titleText}>
          {unlock.displayName}
        </Typography>
        {/*<Typography className={classes.constText}>{unlock.constName}</Typography>*/}
        <Box className={classes.unlockCardBox}>
          <UnlockCard image={unlockImageMapping[unlock.name]} label={unlock.name}/>
        </Box>
        <Typography variant="body2" gutterBottom align="center">
          {unlock.description}
        </Typography>
        <Box sx={{ marginTop: 'auto', display: 'flex', flexDirection: "column" }}>
          <UnlockDetails doctrineUnlock={doctrineUnlock}/>
          {showDisabledForAdmin ? <Typography className={classes.devOnlyText}>DEV ONLY</Typography> : null}
          <Button variant="contained" color="secondary" size="small" className={classes.button}
                  disabled>
            <Typography variant="button" display="block">
              {doctrineUnlock.vpCost} VP
            </Typography>
          </Button>
        </Box>
      </Box>
    )
  }

  return (
    <Paper key={`${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}
           className={classes.unlockContainer}
           elevation={1}>
      {innerContent}
    </Paper>
  )
}
