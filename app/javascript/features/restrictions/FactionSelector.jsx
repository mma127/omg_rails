import React from 'react'
import { selectAllFactions } from "../factions/factionsSlice";
import { useSelector } from "react-redux";
import { Grid, Tooltip } from "@mui/material";
import { FactionIcon } from "../factions/FactionIcon";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  wrapper: {
    display: "flex",
    justifyContent: "center"
  }
}))

export const FactionSelector = ({ currentFactionName, handleFactionSelect }) => {
  const classes = useStyles()

  const factions = useSelector(selectAllFactions)

  return (
    <Grid container className={classes.wrapper}>
      {factions.map(faction => (
        <Tooltip title={faction.displayName} placement="top" arrow key={faction.id}>
          <Grid item sx={{ cursor: "pointer" }}>
            <FactionIcon factionName={faction.name} alt={faction.name} height={50}
                         factionId={faction.id} onFactionClick={handleFactionSelect}
                         isActive={currentFactionName === faction.name || currentFactionName === null}/>
          </Grid>
        </Tooltip>
      ))}
    </Grid>
  )
}
