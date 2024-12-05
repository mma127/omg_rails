import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsWeaponByReference } from "./statsWeaponsSlice";
import { Box, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { Accuracy } from "./components/Accuracy";
import { Range } from "./components/Range";
import { Aim } from "./components/Aim";
import { Damage } from "./components/Damage";
import { Reload } from "./components/Reload";
import { Cooldown } from "./components/Cooldown";
import { Penetration } from "./components/Penetration";
import { Burst } from "./components/Burst";
import { Moving } from "./components/Moving";
import { Suppression } from "./components/Suppression";
import { Suppressed } from "./components/Suppressed";
import { AreaOfEffect } from "./components/AreaOfEffect";
import { Scatter } from "./components/Scatter";
import { Setup } from "./components/Setup";
import { Tracking } from "./components/Tracking";

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
  columns: {
    display: "flex",
  },
  table: {
    minWidth: "33%",
    height: "fit-content",
    "& td": {
      verticalAlign: "top"
    }
  },
  spacerRow: {
    height: "1rem"
  }
}))

export const WeaponStats = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        <Box className={classes.columns}>
          <table className={classes.table}>
            <tbody>
            <Damage data={data}/>
            <Accuracy data={data}/>
            <Range data={data}/>
            <Aim data={data}/>
            <Moving data={data}/>
            <Setup data={data}/>
            </tbody>
          </table>
          <table className={classes.table}>
            <tbody>
            <Reload data={data}/>
            <Burst data={data}/>
            <Cooldown data={data}/>
            <Suppression data={data}/>
            </tbody>
          </table>
          <table className={classes.table}>
            <tbody>
            <Penetration data={data}/>
            <Suppressed data={data}/>
            <AreaOfEffect data={data}/>
            <Scatter data={data}/>
            <Tracking data={data}/>
            </tbody>
          </table>
        </Box>
      </Paper>
    </Box>
  )
}
