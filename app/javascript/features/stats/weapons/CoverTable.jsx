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
  TableRow, Tooltip,
  Typography
} from "@mui/material";
import { makeStyles } from "@mui/styles";
import {
  BUNKER_COVER, COVER_TO_DISPLAY_NAME,
  DEFAULT_COVER, EMPLACEMENT_COVER,
  GARRISON_COVER,
  HALFTRACK_COVER,
  HEAVY_COVER,
  LIGHT_COVER, OPEN_COVER,
  SMOKE_COVER, TRENCH_COVER, WATER_COVER
} from "../../../constants/stats/cover";
import { precise } from "../../../utils/numbers";
import InfoIcon from '@mui/icons-material/Info';

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

const COVER_ORDER = [
  DEFAULT_COVER,
  LIGHT_COVER,
  HEAVY_COVER,
  SMOKE_COVER,
  GARRISON_COVER,
  HALFTRACK_COVER,
  TRENCH_COVER,
  WATER_COVER,
  BUNKER_COVER,
  EMPLACEMENT_COVER,
  OPEN_COVER]

const CoverRow = ({ data, type }) => {
  const classes = useStyles()
  const displayName = COVER_TO_DISPLAY_NAME[type]

  const coverData = data?.[type]
  const accuracy = precise(coverData?.['accuracy_multiplier']) || 1
  const damage = precise(coverData?.['damage_multiplier']) || 1
  const suppression = precise(coverData?.['suppression_multiplier']) || 1
  const penetration = precise(coverData?.['penetration_multiplier']) || 1

  return (
    <TableRow>
      <TableCell>
        <Typography color="secondary.dark" className={classes.coverType}>{displayName}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{accuracy}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{damage}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{suppression}</Typography>
      </TableCell>
      <TableCell>
        <Typography>{penetration}</Typography>
      </TableCell>
    </TableRow>
  )
}

export const CoverTable = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data
  const cover = data.cover_table
  console.log(cover)

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        <Box className={classes.infoRow}>
          <Tooltip title="Multipliers applied when the target is in cover." placement={"top"} arrow followCursor>
            <InfoIcon />
          </Tooltip>
        </Box>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>
                  <Typography color="secondary.dark">Cover Type</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Accuracy</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Damage</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Suppression</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Penetration</Typography>
                </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {COVER_ORDER.map(c => <CoverRow data={cover} type={c} key={c}/>)}
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  )
}
