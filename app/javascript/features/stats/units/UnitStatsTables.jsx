import React from 'react'
import { useSelector } from "react-redux";
import { selectStatsUnitByConstName } from "./statsUnitsSlice";
import { Box, Paper, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { LabelTypography } from "../../../components/LabelTypography";
import { selectStatsEntitiesByReference } from "../entities/statsEntitiesSlice";
import { getStatsValueWithFallback } from "./values_helper";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    alignItems: "center",
    alignContent: "center"
  },
  columns: {
    display: "flex",
  },
  labelCol1: {
    width: '11rem'
  },
  valueCol1: {
    width: '5rem'
  },
  labelCol2: {
    width: '11rem'
  },
  valueCol2: {
    width: '5rem'
  },
  labelCol3: {
    width: '8rem'
  },
  valueCol3: {
    width: '5rem'
  }
}))

const TOTAL_COUNT = "totalCount"

const getLoadoutModelCounts = (loadout) => {
  const result = {}
  let totalCount = 0
  for (const [key, value] of Object.entries(loadout)) {
    const modelCount = parseInt(value)
    result[key] = modelCount
    totalCount += modelCount
  }
  result[TOTAL_COUNT] = totalCount
  return result
}

const calcTotalHealth = (loadoutModelCounts, entitiesByReference) => {
  let totalHealth = 0
  for (const [reference, count] of Object.entries(loadoutModelCounts)) {
    if (reference === TOTAL_COUNT) continue

    const entityData = entitiesByReference[reference].data
    const health = parseInt(entityData.hitpoints) || 0
    totalHealth += health * count
  }
  return totalHealth
}

const COMBAT_BEHAVIOR_SUPPRESSION = "combat_behavior_suppression"

/**
 * Suppress activate threshold
 * Suppress recovery threshold
 */
const SuppressionCol1 = ({ reference, statsData }) => {
  const styles = useStyles()
  if (Object.keys(statsData).includes(COMBAT_BEHAVIOR_SUPPRESSION)) {
    const suppression = statsData[COMBAT_BEHAVIOR_SUPPRESSION]
    return (
      <>
        <tr>
          <td>
            <Tooltip title="Suppression required to suppress the squad" placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol1}>suppressed activation threshold</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol1}>{getStatsValueWithFallback(reference, "suppressed_activate_threshold", suppression)}</Typography>
          </td>
        </tr>
        <tr>
          <td>
            <Tooltip title="Squad must have suppression below this number to recover from suppressed state"
                     placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol1}>suppressed recovery threshold</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol1}>{getStatsValueWithFallback(reference, "suppressed_recover_threshold", suppression)}</Typography>
          </td>
        </tr>
      </>
    )
  } else {
    return null
  }
}

/**
 * Pin down activate threshold
 * Pin down recovery threshold
 */
const SuppressionCol2 = ({ reference, statsData }) => {
  const styles = useStyles()
  if (Object.keys(statsData).includes(COMBAT_BEHAVIOR_SUPPRESSION)) {
    const suppression = statsData[COMBAT_BEHAVIOR_SUPPRESSION]
    return (
      <>
        <tr>
          <td>
            <Tooltip title="Suppression required to pin the squad" placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol2}>pinned activation threshold</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol2}>{getStatsValueWithFallback(reference, "pin_down_activate_threshold", suppression)}</Typography>
          </td>
        </tr>
        <tr>
          <td>
            <Tooltip title="Squad must have suppression below this number to recover from pinned state"
                     placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol2}>pinned recovery threshold</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol2}>{getStatsValueWithFallback(reference, "pin_down_recover_threshold", suppression)}</Typography>
          </td>
        </tr>
      </>
    )
  } else {
    return null
  }
}

/**
 * Recovery rate
 * Noncombat delay
 */
const SuppressionCol3 = ({ reference, statsData }) => {
  const styles = useStyles()
  if (Object.keys(statsData).includes(COMBAT_BEHAVIOR_SUPPRESSION)) {
    const suppression = statsData[COMBAT_BEHAVIOR_SUPPRESSION]
    return (
      <>
        <tr>
          <td>
            <Tooltip title="Suppression recovery per second" placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol3}>recovery rate</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol3}>{getStatsValueWithFallback(reference, "recover_rate", suppression)}</Typography>
          </td>
        </tr>
        <tr>
          <td>
            <Tooltip title="Delay in seconds before out of combat suppression recovery multiplier x50 is applied" placement="bottom-start" arrow>
              <LabelTypography className={styles.labelCol3}>noncombat delay</LabelTypography>
            </Tooltip>
          </td>
          <td>
            <Typography
              className={styles.valueCol3}>{getStatsValueWithFallback(reference, "noncombat_delay", suppression, 0)}</Typography>
          </td>
        </tr>
      </>
    )
  } else {
    return null
  }
}

const UnitStatsCard = ({ statsUnit, statsEntitiesByReference }) => {
  const styles = useStyles()
  const reference = statsUnit.reference
  const statsData = statsUnit.data
  console.log(statsData)
  console.log(reference)

  const loadoutModelCounts = getLoadoutModelCounts(statsData.loadout)
  const totalHealth = calcTotalHealth(loadoutModelCounts, statsEntitiesByReference)


  return (
    <Paper sx={{ width: '100%', padding: '1rem' }}>
      <Typography variant="h6">Unit stats</Typography>
      <Box className={styles.columns}>
        {/*Don't need material ui table styling*/}
        <table>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>type</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{statsData.type}</Typography>
            </td>
          </tr>
          <SuppressionCol1 reference={reference} statsData={statsData}/>
          </tbody>
        </table>
        <table>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>health</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{totalHealth}</Typography>
            </td>
          </tr>
          <SuppressionCol2 reference={reference} statsData={statsData}/>
          </tbody>
        </table>
        <table>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>models</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{loadoutModelCounts[TOTAL_COUNT]}</Typography>
            </td>
          </tr>
          <SuppressionCol3 reference={reference} statsData={statsData}/>
          </tbody>
        </table>
      </Box>
    </Paper>
  )
}

export const UnitStatsTables = ({ constName }) => {
  const statsUnit = useSelector(state => selectStatsUnitByConstName(state, constName))
  const statsEntitiesByReference = useSelector((state) => selectStatsEntitiesByReference(state, statsUnit?.data?.entities))
  return (
    <Box pl={1} pr={1}>
      <UnitStatsCard statsUnit={statsUnit} statsEntitiesByReference={statsEntitiesByReference}/>
    </Box>
  )
}
