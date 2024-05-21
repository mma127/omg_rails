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
import {
  CRITICAL_ORDER, CRITICAL_TABLE_01, CRITICAL_TABLE_02, CRITICAL_TABLE_03,
  CRITICAL_TABLE_TO_DAMAGE_RANGE,
  CRITICAL_TO_DISPLAY_NAME
} from "../../../constants/stats/criticals";
import { titleCase } from "title-case";

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

const formatCritical = (critical) => {
  return titleCase(_.trim(_.replace(_.replace(critical, "critical_combo/", ""), "critical/", "").replaceAll("_", " ")))
}

const CriticalValue = ({ critical, weight, idx, rowCount, rangeDisplayName, typeFirstRowContent }) => {
  let firstRowContent
  if (idx === 0) {
    firstRowContent = (
      <>
        {typeFirstRowContent}
        <TableCell rowSpan={rowCount}><Typography>{rangeDisplayName}</Typography></TableCell>
      </>
    )
  }
  return (
    <TableRow>
      {firstRowContent}
      <TableCell><Typography>{weight}</Typography></TableCell>
      <TableCell><Typography>{formatCritical(critical)}</Typography></TableCell>
    </TableRow>
  )
}

const CriticalRange = ({ criticalData, tableKey, rowCount, totalRows, criticalType }) => {
  const classes = useStyles()
  const rangeDisplayName = CRITICAL_TABLE_TO_DAMAGE_RANGE[tableKey]

  let firstRowContent
  if (tableKey === CRITICAL_TABLE_01) {
    const displayName = CRITICAL_TO_DISPLAY_NAME[criticalType]

    firstRowContent = (
      <TableCell rowSpan={totalRows}>
        <Typography color="secondary.dark" className={classes.type}>{displayName}</Typography>
      </TableCell>)
  }

  if (_.has(criticalData, tableKey) && _.size(criticalData[tableKey]) > 0) {
    return (
      <>
        {_.entries(criticalData[tableKey]).map(([k, v], idx) =>
          <CriticalValue critical={k} weight={v} idx={idx} rowCount={rowCount} rangeDisplayName={rangeDisplayName}
                         typeFirstRowContent={firstRowContent}/>)}
      </>
    )
  } else {
    return (
      <TableRow>
        {firstRowContent}
        <TableCell rowSpan={rowCount}><Typography>{rangeDisplayName}</Typography></TableCell>
        <TableCell><Typography>100</Typography></TableCell>
        <TableCell><Typography>No Critical</Typography></TableCell>
      </TableRow>
    )
  }
}

const calculateCriticalRangeRowspan = (typeData, rangeId) => {
  let rows = 0
  if (_.has(typeData, rangeId)) {
    let criticalTableCount = _.size(typeData[rangeId])
    if (criticalTableCount === 0) { // Sometimes there are empty critical tables
      rows += 1
    } else {
      rows += criticalTableCount
    }
  } else {
    rows += 1 // No critical row
  }
  return rows
}

const CriticalTypeRow = ({ data, type }) => {
  const criticalData = data?.[type]
  const greenRowCount = calculateCriticalRangeRowspan(criticalData, CRITICAL_TABLE_01)
  const yellowRowCount = calculateCriticalRangeRowspan(criticalData, CRITICAL_TABLE_02)
  const redRowCount = calculateCriticalRangeRowspan(criticalData, CRITICAL_TABLE_03)
  const totalRows = greenRowCount + yellowRowCount + redRowCount

  return (
    <>
      <CriticalRange criticalData={criticalData} tableKey={CRITICAL_TABLE_01} rowCount={greenRowCount}
                     totalRows={totalRows} criticalType={type}/>
      <CriticalRange criticalData={criticalData} tableKey={CRITICAL_TABLE_02} rowCount={yellowRowCount}
                     totalRows={totalRows}/>
      <CriticalRange criticalData={criticalData} tableKey={CRITICAL_TABLE_03} rowCount={redRowCount}
                     totalRows={totalRows}/>
    </>
  )
}

export const CriticalTable = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const data = weapon.data
  const criticals = data.critical_table

  return (
    <Box className={classes.contentContainer}>
      <Paper className={classes.paper}>
        {/*<Box className={classes.infoRow}>*/}
        {/*  <Tooltip title="Multipliers applied based on target type." placement={"top"} arrow followCursor>*/}
        {/*    <InfoIcon/>*/}
        {/*  </Tooltip>*/}
        {/*</Box>*/}
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell>
                  <Typography color="secondary.dark">Critical Type</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Damage Range</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Weight</Typography>
                </TableCell>
                <TableCell>
                  <Typography color="secondary.dark">Critical Effect</Typography>
                </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {CRITICAL_ORDER.map(c => <CriticalTypeRow data={criticals} type={c} key={c}/>)}
            </TableBody>
          </Table>
        </TableContainer>
      </Paper>
    </Box>
  )
}
