import React from 'react'
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectSquadUpgradesForSquad } from "./squadUpgradesSlice";
import { Box } from "@mui/material";
import { SquadUpgradeClickable } from "./SquadUpgradeClickable";

const useStyles = makeStyles(() => ({
  wrapper: {
    display: 'flex',
    flexDirection: "row",
    flexWrap: "wrap"
  }
}))
export const SquadUpgrades = ({ tab, index, squadUuid, onUpgradeClick, enabled, isSnapshot }) => {
  const classes = useStyles()
  const squadUpgrades = useSelector(state => selectSquadUpgradesForSquad(state, tab, index, squadUuid))

  return (
    <Box className={classes.wrapper}>
      {squadUpgrades.map(su => <SquadUpgradeClickable squadUpgrade={su} onUpgradeClick={onUpgradeClick}
                                                      enabled={enabled} isSnapshot={isSnapshot} key={su.uuid}/>)}
    </Box>
  )
}
