import React from 'react'
import { buildVetBonuses } from "./unit_vet";
import { Box } from "@mui/material";
import { SquadVetIcon } from "../squads/SquadVetIcon";
import { makeStyles } from "@mui/styles";


const useStyles = makeStyles(() => ({
  vetItems: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    paddingTop: "0.125rem",
    paddingBottom: "0.125rem"
  },
  xp: {
    minWidth: "2.75rem"
  },
  desc: {
    lineHeight: ".75rem"
  }
}))

export const UnitVetDescriptions = ({ vet, level, side }) => {
  const classes = useStyles()

  const vetBonuses = buildVetBonuses(level, vet)

  return (
    vetBonuses.map(vb =>
      <Box key={vb.level} className={classes.vetItems}>
        <SquadVetIcon level={vb.level} side={side}/>
        <strong className={classes.xp}>{vb.exp} XP</strong>
        <Box className={classes.desc}>{vb.desc}</Box>
      </Box>)
  )
}
