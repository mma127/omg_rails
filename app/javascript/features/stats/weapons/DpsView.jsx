import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsWeaponByReference } from "./statsWeaponsSlice";
import { makeStyles } from "@mui/styles";
import { Box, Paper, Tooltip as MuiTooltip, Typography } from "@mui/material";
import InfoIcon from "@mui/icons-material/Info";
import { calculateRawDps } from "../../../helpers/stats/dpsCalculator";
import { LONG, MEDIUM, SHORT } from "../../../constants/stats/ranges";
import { WeaponBag } from "../../../helpers/stats/WeaponBag";

import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import { Line } from 'react-chartjs-2';
import { createChartDatapoints } from "../../../helpers/stats/chartDatapoints";
import { HighchartDpsChart } from "./charts/HighchartDpsChart";
import { ChartJsDpsChart } from "./charts/ChartJsDpsChart";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);


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

export const DpsView = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data
  const weaponBag = new WeaponBag(data)

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        <Box className={classes.infoRow}>
          <MuiTooltip title="DPS calculated without taking into account target modifiers." placement={"top"} arrow followCursor>
            <InfoIcon/>
          </MuiTooltip>
        </Box>
        {/*<Box>*/}
        {/*  <Typography variant="h6">Raw DPS</Typography>*/}
        {/*</Box>*/}
        {/*<Box>*/}
        {/*  <Typography>Short</Typography>*/}
        {/*  <Typography>{weaponBag.rangeShort}</Typography>*/}
        {/*  <Typography>{dpsValues[SHORT]}</Typography>*/}
        {/*</Box>*/}
        {/*<Box>*/}
        {/*  <Typography>Medium</Typography>*/}
        {/*  <Typography>{weaponBag.rangeMedium}</Typography>*/}
        {/*  <Typography>{dpsValues[MEDIUM]}</Typography>*/}
        {/*</Box>*/}
        {/*<Box>*/}
        {/*  <Typography>Long</Typography>*/}
        {/*  <Typography>{weaponBag.rangeLong}</Typography>*/}
        {/*  <Typography>{dpsValues[LONG]}</Typography>*/}
        {/*</Box>*/}

        <ChartJsDpsChart weaponBag={weaponBag} />
      </Paper>
    </Box>
  )
}
