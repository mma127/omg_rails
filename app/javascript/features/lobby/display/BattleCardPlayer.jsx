import React, { useEffect, useState } from 'react'
import {
  Box,
  Button,
  Card,
  Grid, Popover,
  Typography
} from "@mui/material";
import { makeStyles } from "@mui/styles";
import CheckIcon from '@mui/icons-material/Check';
import LogoutIcon from '@mui/icons-material/Logout';
import { useDispatch, useSelector } from "react-redux";
import { createBattle, leaveBattle, readyPlayer } from "../lobbySlice";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId } from "../../player/playerSlice";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { JoinBattlePopover } from "./JoinBattlePopover";
import { FULL, GENERATING, INGAME, OPEN } from "../../../constants/battles/states";

const useStyles = makeStyles(theme => ({
  wrapperRow: {
    display: 'flex',
    alignItems: 'center',
    height: '60px',
    paddingTop: '5px',
    paddingBottom: '5px'
  },
  optionImage: {
    height: '60px',
    width: '120px'
  },
  clickableIcon: {
    cursor: 'pointer',
    marginLeft: '20px'
  },
  joinText: {
    cursor: 'pointer'
  },
  selfPlayerName: {
    overflowX: 'clip',
    maxWidth: '62%',
    textOverflow: 'ellipsis'
  },
  playerName: {
    overflowX: 'clip',
    maxWidth: '80%',
    textOverflow: 'ellipsis'
  },
  readyBtn: {
    marginLeft: '20px',
    lineHeight: '1'
  }
}))

export const BattleCardPlayer = ({ battleId, playerId, playerName, companyDoctrine, side, battleState, ready }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  // const companies = useSelector(selectAllCompanies)
  const [anchorEl, setAnchorEl] = React.useState(null);

  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)

  const isCurrentPlayer = player ? player.id === playerId : false

  const leavable = battleState === OPEN || battleState === FULL

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const open = Boolean(anchorEl);
  const id = open ? 'simple-popover' : undefined;

  const handleReadyClick = () => {
    dispatch(readyPlayer({ battleId: battleId, playerId: playerId }))
  }

  const leaveGame = () => {
    if (isCurrentPlayer) {
      dispatch(leaveBattle({ battleId: battleId, playerId: player.id }))
    }
  }

  let content
  if (playerId && isCurrentPlayer) {
    // Filled spot by logged in player
    let readyContent
    if ((battleState === FULL && ready) || battleState === GENERATING) {
      readyContent = <CheckIcon className={classes.clickableIcon} color="success" />
    } else if (battleState === FULL && !ready) {
      readyContent = <Button variant="contained" type="submit" color="secondary" size="small"
                             className={classes.readyBtn} onClick={handleReadyClick}>Ready</Button>
    } else if (battleState === INGAME) {
      // TODO Abandon

    }

    content = (
      <>
        <Box sx={{ display: "flex", justifyContent: 'center' }} pr={1}>
          <img src={doctrineImgMapping[companyDoctrine]} alt={companyDoctrine}
               className={classes.optionImage} />
        </Box>
        <Typography variant={"h5"} color="secondary" className={classes.selfPlayerName}>{playerName}</Typography>
        {readyContent}
        {leavable ? <LogoutIcon className={classes.clickableIcon} color="error" onClick={leaveGame} /> : ""}
      </>
    )
  } else if (playerId) {
    // Filled spot
    content = (
      <>
        <Box sx={{ display: "flex", justifyContent: 'center' }} pr={1}>
          <img src={doctrineImgMapping[companyDoctrine]} alt={companyDoctrine}
               className={classes.optionImage} />
        </Box>
        <Typography variant={"h5"} className={classes.playerName}>{playerName}</Typography>
        {(battleState === FULL && ready) || battleState === GENERATING ?
          <CheckIcon className={classes.clickableIcon} color="success" /> : null}
      </>
    )
  } else if (isAuthed && !currentBattleId) {
    // Empty spot, Player is logged in but not in a battle
    content = (
      <>
        <Box mr={1} className={classes.optionImage} /> {/*Used for spacing*/}
        <Typography variant={"h6"} color="primary" className={classes.joinText} onClick={handleClick}>Join
          Battle</Typography>
        <Popover id={id}
                 open={open}
                 anchorEl={anchorEl}
                 onClose={handleClose}
                 anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}>
          <JoinBattlePopover battleId={battleId} side={side} handleClose={handleClose} />
        </Popover>
      </>
    )
  } else {
    // Empty spot, Player is either logged in but already in a battle, or is not logged in. Either way, show read only
    content = (
      <>
        <Box mr={1} className={classes.optionImage} /> {/* Used for spacing*/}
        <Typography variant={"h6"} color="text.secondary">Available</Typography>
      </>)
  }

  return (
    <Box className={classes.wrapperRow}>
      {content}
    </Box>
  )
}
