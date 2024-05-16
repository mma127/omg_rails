import React from 'react'
import { Box, Button, createTheme, Popover, Stack, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import CheckIcon from '@mui/icons-material/Check';
import LogoutIcon from '@mui/icons-material/Logout';
import CancelIcon from '@mui/icons-material/Cancel';
import { TeamBalanceIcon } from '../../resources/TeamBalanceIcon';
import { useDispatch, useSelector } from "react-redux";
import { abandonBattle, kickPlayer, leaveBattle, readyPlayer, selectIsPending, unreadyPlayer } from "../lobbySlice";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId } from "../../player/playerSlice";
import { ALLIED_SIDE } from "../../../constants/doctrines";
import { JoinBattlePopover } from "./JoinBattlePopover";
import { ABANDONABLE_STATES, FULL, OPEN } from "../../../constants/battles/states";
import { FactionIcon } from "../../factions/FactionIcon";

const useStyles = makeStyles(theme => ({
  wrapperRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    height: '60px',
    paddingTop: '5px',
    paddingBottom: '5px',
    width: "100%"
  },
  balanceTeam: {
    marginRight: '10px',
  },
  playerRow: {
    display: 'flex',
    flexGrow: 1,
    height: '60px',
    paddingTop: '5px',
    paddingBottom: '5px'
  },
  optionImage: {
    height: '60px',
    width: '120px'
  },
  factionImage: {
    height: "50px",
    width: "66.66px"
  },
  clickableIcon: {
    cursor: 'pointer',
    marginLeft: '20px'
  },
  joinText: {
    cursor: 'pointer'
  },
  PlayerElo: {
    marginLeft: '0.25rem'
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
                                   companyFaction,
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
  console.log(`Current Battle ID: ${currentBattleId}`)
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

  const handleKickClick = () => {
    if (isAdmin) {
      dispatch(kickPlayer({ battleId: battleId, kickPlayerId: playerId }))
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

  let factionIcon
  if (companyFaction) {
    factionIcon = (
      <Box sx={{ display: "flex", justifyContent: 'center' }} pl={1} pr={1}>
        <FactionIcon factionName={companyFaction} alt={companyFaction} height={50}/>
      </Box>
    )
  } else {
    factionIcon =
      <Box sx={{ display: "flex", justifyContent: 'center' }} pl={1} pr={1}>
        <Box ml={1} mr={1} className={classes.factionImage}/>
      </Box>
  }

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
        {side === ALLIED_SIDE ? null : factionIcon}
        <Stack className={classes.playerRow} sx={{ display: "flex", justifyContent: 'center' }}>
          <Box className={classes.wrapperRow}>
            <TeamBalanceIcon team={teamBalance} isFull={isFull}/>
            <Typography variant="h5" color="secondary" className={classes.selfPlayerName}>{playerName}</Typography>
            {isAdmin ? <Typography variant="h5" color="darkgrey" theme={eloTheme}
                                   className={classes.PlayerElo}> <sup>{playerElo}</sup></Typography> : null}
            {readyContent}
            {leavable ? <LogoutIcon className={classes.clickableIcon} color="error" onClick={leaveGame}/> : ""}
            {isAdmin && leavable ?
              <CancelIcon className={classes.clickableIcon} color="error" onClick={handleKickClick}/> : null}
          </Box>


        </Stack>
        {side === ALLIED_SIDE ? factionIcon : null}
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
        {side === ALLIED_SIDE ? null : factionIcon}
        <Stack className={classes.playerRow} sx={{ display: "flex", justifyContent: 'center' }}>
          <Box className={classes.wrapperRow}>
            <TeamBalanceIcon team={teamBalance} isFull={isFull}/>
            <Typography variant="h5" className={classes.playerName}> {playerName}</Typography>
            {isAdmin ? <Typography variant="h5" color="darkgrey" theme={eloTheme}
                                   className={classes.PlayerElo}><sup>{playerElo}</sup></Typography> : null}
            {readyContent}
            {isAdmin && leavable ?
              <CancelIcon className={classes.clickableIcon} color="error" onClick={handleKickClick}/> : null}
          </Box>

        </Stack>
        {side === ALLIED_SIDE ? factionIcon : null}
      </>
    )
  } else if (isAuthed && !currentBattleId) {
    // Empty spot, Player is logged in but not in a battle
    content = (
      <>
        {side === ALLIED_SIDE ? null : factionIcon} {/*Used for spacing*/}
        <Typography variant="h6" color="primary" className={classes.joinText} onClick={handleClick}>Join Battle</Typography>
        <Popover id={id}
                 open={open}
                 anchorEl={anchorEl}
                 onClose={handleClose}
                 anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}>
          <JoinBattlePopover battleId={battleId} side={side} handleClose={handleClose}/>
        </Popover>
        {side === ALLIED_SIDE ? factionIcon : null} {/*Used for spacing*/}
      </>
    )
  } else {
    // Empty spot, Player is either logged in but already in a battle, or is not logged in. Either way, show read only
    content = (
      <>
        {side === ALLIED_SIDE ? null : factionIcon} {/*Used for spacing*/}
        <Typography variant="h6" color="text.secondary">Available</Typography>
        {side === ALLIED_SIDE ? factionIcon : null} {/*Used for spacing*/}
      </>)
  }

  return (
    <Box className={classes.wrapperRow}>
      {content}
    </Box>
  )
}
