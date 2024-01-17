import React from 'react'
import { Box, Stack, Button, Popover, Typography, Divider, createTheme } from "@mui/material";
import { makeStyles } from "@mui/styles";
import CheckIcon from '@mui/icons-material/Check';
import LogoutIcon from '@mui/icons-material/Logout';
import { TeamBalanceIcon } from '../../resources/TeamBalanceIcon';
import { useDispatch, useSelector } from "react-redux";
import {
  abandonBattle,
  fetchActiveBattles,
  leaveBattle,
  readyPlayer,
  unreadyPlayer,
  selectIsPending
} from "../lobbySlice";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId } from "../../player/playerSlice";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { JoinBattlePopover } from "./JoinBattlePopover";
import { ABANDONABLE_STATES, FULL, GENERATING, INGAME, OPEN } from "../../../constants/battles/states";

const useStyles = makeStyles(theme => ({
  wrapperRow: {
    display: 'flex',
    alignItems: 'center',
    height: '60px',
    paddingTop: '5px',
    paddingBottom: '5px',
  },
  balanceTeam: {
    marginRight: '10px',
  },
  playerRow: {
    display: 'flex',
    alignItems: 'left',
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
    maxWidth: '100%',
    textOverflow: 'ellipsis'
  },
  readyBtn: {
    marginLeft: '20px',
    lineHeight: '1'
  }
}))

export const BattleCardPlayer = ({
                                   battleId,
                                   playerId,
                                   playerName,
                                   playerElo,
                                   teamBalance,
                                   companyDoctrine,
                                   side,
                                   battleState,
                                   ready,
                                   abandoned,
                                   isFull
                                 }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  // const companies = useSelector(selectAllCompanies)
  const [anchorEl, setAnchorEl] = React.useState(null);

  const isAuthed = useSelector(selectIsAuthed)
  const player = useSelector(selectPlayer)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)
  const isPending = useSelector(selectIsPending)

  const isCurrentPlayer = player ? player.id === playerId : false
  const isAdmin = player ? player.role === "admin" : false

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

  const handleUnreadyClick = () => {
    dispatch(unreadyPlayer({ battleId: battleId, playerId: playerId }))
  }

  const leaveGame = () => {
    if (isCurrentPlayer && !isPending) {
      dispatch(leaveBattle({ battleId: battleId, playerId: player.id }))
    }
  }

  const handleAbandonClick = () => {
    dispatch(abandonBattle({ battleId, playerId }))
  }

  const eloTheme = createTheme({
    typography: {
      // In Chinese and Japanese the characters are usually larger,
      // so a smaller fontsize may be appropriate.
      fontSize: 8,
    },
  });

  let content
  if (playerId && isCurrentPlayer) {
    // Filled spot by logged in player
    let readyContent
    if (battleState === FULL && ready) {
      readyContent =
        <CheckIcon className={classes.clickableIcon} onClick={handleUnreadyClick} disabled={isPending} color="success"/>
    } else if (battleState === FULL && !ready) {
      readyContent = <Button variant="contained" type="submit" color="secondary" size="small"
                             className={classes.readyBtn} onClick={handleReadyClick} disabled={isPending}>Ready</Button>
    } else if (_.includes(ABANDONABLE_STATES, battleState)) {
      if (abandoned) {
        // Already abandoned
        readyContent = <Button variant="contained" type="submit" color="error" size="small"
                               className={classes.readyBtn} disabled={true}>Abandoning</Button>
      } else {
        readyContent = <Button variant="contained" type="submit" color="error" size="small"
                               className={classes.readyBtn} onClick={handleAbandonClick}
                               disabled={isPending}>Abandon</Button>
      }
    }


    content = (
      <>

        <Box sx={{ display: "flex", justifyContent: 'center' }} pr={1}>
          <img src={doctrineImgMapping[companyDoctrine]} alt={companyDoctrine}
               className={classes.optionImage}/>
        </Box>
        <Stack className={classes.playerRow} sx={{ display: "flex", justifyContent: 'center' }}>


          <Box className={classes.wrapperRow}>
            <TeamBalanceIcon team={teamBalance} isFull={isFull}/>
            <Typography variant={"h5"} color="secondary" className={classes.selfPlayerName}>{playerName}</Typography>
            {readyContent}
            {leavable ? <LogoutIcon className={classes.clickableIcon} color="error" onClick={leaveGame}/> : ""}
          </Box>

          {isAdmin ? <Typography variant={"h6"} color="darkgrey" theme={eloTheme}
                                 className={classes.PlayerElo}>{playerElo}</Typography> : null}

        </Stack>
      </>
    )
  } else if (playerId) {
    // Filled spot
    let readyContent
    if (battleState === FULL && ready) {
      readyContent = <CheckIcon className={classes.clickableIcon} color="success"/>
    } else if (_.includes(ABANDONABLE_STATES, battleState) && abandoned) {
      readyContent = <Button variant="contained" type="submit" color="error" size="small"
                             className={classes.readyBtn} disabled={true}>Abandoning</Button>
    }
    content = (
      <>
        <Box sx={{ display: "flex", justifyContent: 'center' }} pr={1}>
          <img src={doctrineImgMapping[companyDoctrine]} alt={companyDoctrine}
               className={classes.optionImage}/>
        </Box>
        <Stack className={classes.playerRow} sx={{ display: "flex", justifyContent: 'center' }}>

          <Box className={classes.wrapperRow}>
            <TeamBalanceIcon team={teamBalance} isFull={isFull}/>
            <Typography variant={"h5"} className={classes.playerName}> {playerName}</Typography>
            {readyContent}
          </Box>
          {isAdmin ? <Typography variant={"h6"} color="darkgrey" theme={eloTheme}
                                 className={classes.PlayerElo}>{playerElo}</Typography> : null}
        </Stack>

      </>
    )
  } else if (isAuthed && !currentBattleId) {
    // Empty spot, Player is logged in but not in a battle
    content = (
      <>
        <Box mr={1} className={classes.optionImage}/> {/*Used for spacing*/}
        <Typography variant={"h6"} color="primary" className={classes.joinText} onClick={handleClick}>Join
          Battle</Typography>
        <Popover id={id}
                 open={open}
                 anchorEl={anchorEl}
                 onClose={handleClose}
                 anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}>
          <JoinBattlePopover battleId={battleId} side={side} handleClose={handleClose}/>
        </Popover>
      </>
    )
  } else {
    // Empty spot, Player is either logged in but already in a battle, or is not logged in. Either way, show read only
    content = (
      <>
        <Box mr={1} className={classes.optionImage}/> {/* Used for spacing*/}
        <Typography variant={"h6"} color="text.secondary">Available</Typography>
      </>)
  }

  return (
    <Box className={classes.wrapperRow}>
      {content}
    </Box>
  )
}
