import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsWeaponByReference } from "./statsWeaponsSlice";
import {
  Box,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Tooltip,
  Typography
} from "@mui/material";
import { makeStyles } from "@mui/styles";
import { precise } from "../../../utils/numbers";
import InfoIcon from '@mui/icons-material/Info';
import { TARGET_ORDER, TARGET_TO_DISPLAY_NAME } from "../../../constants/stats/targets";

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
  type: {
    fontWeight: "bold"
  },
  infoRow: {
    display: "flex",
    flexDirection: "row-reverse"
  }
}))

const TargetRow = ({ data, type }) => {
  const classes = useStyles()
  const displayName = TARGET_TO_DISPLAY_NAME[type]

  const coverData = data?.[type]
  const accuracy = precise(coverData?.['accuracy_multiplier']) || 1
  const moving_accuracy = precise(coverData?.['moving_accuracy_multiplier']) || 1
  const damage = precise(coverData?.['damage_multiplier']) || 1
  const penetration = precise(coverData?.['penetration_multiplier']) || 1
  const rear_penetration = precise(coverData?.['rear_penetration_multiplier']) || 1
  const suppression = precise(coverData?.['suppression_multiplier']) || 1
  const priority = precise(coverData?.['priority']) || 0

  return (
    <TableRow>
      <TableCell>
        <Typography color="secondary.dark" className={classes.type}>{displayName}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{accuracy}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{moving_accuracy}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{damage}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{penetration}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{rear_penetration}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{suppression}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{priority}</Typography>
      </TableCell>
    </TableRow>
  )
}

export const TargetTable = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data
  const target = data.target_table

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        <Box className={classes.infoRow}>
          <Tooltip title="Multipliers applied based on target type." placement={"top"} arrow followCursor>
            <InfoIcon/>
          </Tooltip>
        </Box>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>
                  <Typography color="secondary.dark">Target Type</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Accuracy</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Moving Acc</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Damage</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Penetration</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Rear Pen</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Suppression</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Priority</Typography>
                </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {TARGET_ORDER.map(t => <TargetRow data={target} type={t} key={t}/>)}
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  )
}
