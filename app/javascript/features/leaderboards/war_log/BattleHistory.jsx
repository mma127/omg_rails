import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Card, Typography } from "@mui/material";
import { ALLIED_SIDE, AXIS_SIDE } from "../../../constants/doctrines";
import { Link } from "react-router-dom";

const useStyles = makeStyles(theme => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  row: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  },
  battleName: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-start",
    overflowWrap: "normal"
  },
  battleId: {
    textAlign: "center",
    display: "flex"
  },
  datetime: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end"
  },
  alliedPlayers: {
    flexGrow: 1,
    display: "flex",
    flexDirection: "column",
    width: "50%",
    paddingTop: "0.25rem",
    '&.winner': {
      borderColor: theme.palette.secondary.light,
      borderWidth: '2px',
      borderStyle: 'solid',
      borderRadius: '2px'
    }
  },
  alliedPlayer: {
    display: "flex",
    justifyContent: "flex-end",
    paddingRight: "1rem"
  },
  axisPlayers: {
    flexGrow: 1,
    display: "flex",
    flexDirection: "column",
    paddingLeft: "1rem",
    width: "50%",
    paddingTop: "0.25rem",
    '&.winner': {
      borderColor: theme.palette.secondary.light,
      borderWidth: '2px',
      borderStyle: 'solid',
      borderRadius: '2px'
    }
  }
}))

export const BattleHistory = ({ battle }) => {
  const classes = useStyles()
  const allied = battle.battlePlayers.filter(bp => bp.side === ALLIED_SIDE)
  const axis = battle.battlePlayers.filter(bp => bp.side === AXIS_SIDE)
  const alliedWinner = battle.winner === ALLIED_SIDE

  return (
    <Box sx={{ margin: "1rem" }}>
      <Card elevation={3} sx={{ padding: "1rem" }}>
        <Box className={classes.row}>
          <Box className={classes.battleName}>
            <Typography variant="h5" pl="9px" gutterBottom color="text.secondary">{battle.name}</Typography>
          </Box>
          <Box className={classes.battleId}>
            <Typography variant="h5" pl="9px" gutterBottom color="text.secondary">Battle ID: </Typography>
            <Typography variant="h5" pl="9px" gutterBottom color="secondary">{battle.id}</Typography>
          </Box>
          <Box className={classes.datetime}>
            <Typography pl="9px" gutterBottom color="text.secondary">{battle.datetime}</Typography>
          </Box>
        </Box>
        <Box className={classes.row} pb={1}>
          <Box className={classes.battleName}>
            <Typography variant="h6" pl="9px" gutterBottom color="text.secondary">{battle.map}</Typography>
          </Box>
          <Box className={classes.battleId}>
            <Link to={`/api/battles/${battle.id}/battlefiles/zip`} target="_blank" download>Download Battlefile</Link>
          </Box>
        </Box>
        <Box className={classes.row}>
          <Box className={`${classes.alliedPlayers} ${alliedWinner ? 'winner' : ''}`}>
            {allied.map(p => <Typography className={classes.alliedPlayer} key={p.playerId}
                                         color="text.secondary">{p.playerName}</Typography>)}
          </Box>
          <Box className={`${classes.axisPlayers} ${!alliedWinner ? 'winner' : ''}`}>
            {axis.map(p => <Typography key={p.playerId} color="text.secondary">{p.playerName}</Typography>)}
          </Box>
        </Box>
      </Card>
    </Box>
  )
}
