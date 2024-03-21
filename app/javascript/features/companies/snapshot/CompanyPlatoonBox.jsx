import React from 'react'
import { useSelector } from "react-redux";
import { selectCallinModifiers, selectSquadsInTabIndex } from "../manage/units/squadsSlice";
import { SquadCard } from "../manage/squads/SquadCard";
import _, { noop } from "lodash";
import { CallinModifierIcon } from "../manage/callin_modifiers/CallinModifierIcon";
import { Box, Grid, Paper, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  placementBox: {
    minHeight: props => props.height,
    minWidth: '4rem',
    flexGrow: 1,
    "&.compact": {
      minHeight: props => props.compactHeight
    }
  },
  popCMBox: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center'
  }
}))

export const CompanyPlatoonBox = ({ tab, index, height = '13.5rem', compactHeight = '10rem' }) => {
  const classes = useStyles({ height: height, compactHeight: compactHeight })
  const isCompact = true

  const squads = useSelector(state => selectSquadsInTabIndex(state, tab, index))
  const callinModifiers = useSelector(selectCallinModifiers)

  const insertSquadUnitIds = (unitIds, squad) => {
    unitIds.push(squad.unitId)
    if (squad.hasOwnProperty("transportedSquads")) {
      getTransportedUnitIds(unitIds, squad)
    }
  }
  const getTransportedUnitIds = (unitIds, transportSquad) => {
    _.values(transportSquad.transportedSquads).forEach(squad => unitIds.push(squad.unitId))
  }

  let gridPop = 0
  const squadCards = []
  const unitIds = []
  if (!_.isEmpty(squads)) {
    for (const squad of Object.values(squads)) {
      insertSquadUnitIds(unitIds, squad)

      if (squad.transportedSquads) {
        // Use popWithTransported to include transported squads' pop
        gridPop += parseFloat(squad.popWithTransported)
      } else {
        gridPop += parseFloat(squad.pop)
      }
      squadCards.push(<SquadCard key={squad.uuid}
                                 uuid={squad.uuid}
                                 index={index} tab={tab}
                                 enabled={true}
                                 isSnapshot={true}
                                 onSquadClick={noop}
                                 onDestroyClick={noop}
                                 onTransportedSquadCreate={noop}
                                 onSquadMove={noop}
                                 onSquadCopy={noop}
                                 onSquadUpgradeDestroyClick={noop}/>)
    }
  } else {
    return null;
  }

  let callinModifierContent
  if (!_.isNil(callinModifiers) && callinModifiers.length > 0) {
    callinModifierContent = <CallinModifierIcon callinModifiers={callinModifiers} unitIds={unitIds}/>
  }

  return (
    <Grid item lg={3} sm={6} xs={12} sx={{ display: "flex" }}>
      <Paper key={index} className={`${classes.placementBox} ${isCompact ? 'compact' : null}`}>
        <Box sx={{ position: 'relative', p: 1, pr: 3 }}>
          {squadCards}
          <Box component="span" sx={{ position: 'absolute', right: '2px', top: '-1px' }}
               className={classes.popCMBox}>
            <Typography variant="subtitle2">{gridPop}</Typography>
            {callinModifierContent}
          </Box>
        </Box>
      </Paper>
    </Grid>
  )
}
