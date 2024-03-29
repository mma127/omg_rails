import React from 'react'
import { DropTarget } from "react-drag-drop-container";
import { Box, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";

import { SquadCard } from "./SquadCard";

const useStyles = makeStyles(() => ({
  wrapper: {
    display: 'flex'
  },
  transportHitBox: {
    minHeight: 'calc(45px + 0.25rem + 16px)', // UnitCard height + 0.125rem margin x2 + 8px padding x2
    minWidth: '4rem',
    marginLeft: '0.5em',
    marginRight: '0.25em'
  }
}))

export const TransportDropTarget = ({
                                      transportedSquads,
                                      unitCreateOnHit,
                                      squadMoveOnHit,
                                      index,
                                      tab,
                                      transportUuid,
                                      onSquadClick,
                                      onSquadMove,
                                      onSquadCopy,
                                      transportSquadDelete,
                                      onSquadUpgradeDestroyClick,
                                      enabled,
                                      isSnapshot,
                                    }) => {
  const classes = useStyles()

  const squadContent = (
    <Paper key={`${transportUuid}-transport`} className={classes.transportHitBox}>
      <Box>
        {transportedSquads.map(ts => <SquadCard key={ts.uuid}
                                                uuid={ts.uuid} index={index} tab={tab}
                                                transportUuid={transportUuid}
                                                onSquadClick={onSquadClick}
                                                onDestroyClick={transportSquadDelete}
                                                onSquadMove={onSquadMove}
                                                onSquadCopy={onSquadCopy}
                                                onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                                enabled={enabled}
                                                isSnapshot={isSnapshot}/>)}
      </Box>
    </Paper>
  )

  if (isSnapshot) {
    return (
      <Box className={classes.wrapper}>
        {squadContent}
      </Box>
    )
  }

  return (
    <Box className={classes.wrapper}>
      <DropTarget targetKey="unit" onHit={unitCreateOnHit}>
        <DropTarget targetKey="squad" onHit={squadMoveOnHit}>
          {squadContent}
        </DropTarget>
      </DropTarget>
    </Box>
  )
}
