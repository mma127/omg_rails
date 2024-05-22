import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsWeaponByReference } from "./statsWeaponsSlice";
import { makeStyles } from "@mui/styles";
import { Box, Paper, Tooltip, Typography } from "@mui/material";
import InfoIcon from "@mui/icons-material/Info";
import { calculateRawDps } from "../../../helpers/stats/dpsCalculator";
import { LONG, MEDIUM, SHORT } from "../../../constants/stats/ranges";
import { WeaponBag } from "../../../helpers/stats/WeaponBag";

const useStyles = makeStyles(theme => ({
  contentContainer: {
    display: 'flex',
    flexDirection: "column",
    rowGap: "1rem",
    width: '100%',
    marginLeft: '1rem',
    marginRight: '1rem'
  },
  paper: {
    width: "100%",
    padding: '1rem'
  },
  coverType: {
    fontWeight: "bold"
  },
  infoRow: {
    display: "flex",
    flexDirection: "row-reverse"
  }
}))

export const DpsView = ({reference}) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data
  const weaponBag = new WeaponBag(data)

  const dpsValues = calculateRawDps(weaponBag)

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        <Box className={classes.infoRow}>
          <Tooltip title="Multipliers applied when the target is in cover." placement={"top"} arrow followCursor>
            <InfoIcon/>
          </Tooltip>
        </Box>
        <Box>
          <Typography variant="h6">Raw DPS</Typography>
        </Box>
        <Box>
          <Typography>Short</Typography>
          <Typography>{weaponBag.rangeShort}</Typography>
          <Typography>{dpsValues[SHORT]}</Typography>
        </Box>
        <Box>
          <Typography>Medium</Typography>
          <Typography>{weaponBag.rangeMedium}</Typography>
          <Typography>{dpsValues[MEDIUM]}</Typography>
        </Box>
        <Box>
          <Typography>Long</Typography>
          <Typography>{weaponBag.rangeLong}</Typography>
          <Typography>{dpsValues[LONG]}</Typography>
        </Box>
      </Paper>
    </Box>
  )
}
