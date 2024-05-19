import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Paper, Typography } from "@mui/material";
import { LabelTypography } from "../../../components/LabelTypography";
import { getNameFromReference, getPreciseKey, getTypeName } from "./entity_helper";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    alignItems: "center",
    alignContent: "center"
  },
  columns: {
    display: "flex",
  },
  table: {
    minWidth: "33%"
  },
  // labelCol1: {
  //   width: '11rem'
  // },
  // valueCol1: {
  //   width: '5rem'
  // },
  // labelCol2: {
  //   width: '11rem'
  // },
  // valueCol2: {
  //   width: '5rem'
  // },
  // labelCol3: {
  //   width: '8rem'
  // },
  // valueCol3: {
  //   width: '5rem'
  // }
}))

export const EntityStatsCard = ({statsEntity, count}) => {
  const styles = useStyles()
  console.log(statsEntity)

  const data = statsEntity.data
  const moving = data?.moving


  return (
    <Paper sx={{ width: '100%', padding: '1rem' }}>
      <Typography variant="h6">Entity stats - {statsEntity.displayName}</Typography>
      <Box className={styles.columns}>
        {/*Don't need material ui table styling*/}
        <table className={styles.table}>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>type</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{data.type}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>hitpoints</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{data.hitpoints}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>target type</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'type_target_weapon')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>critical type</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'type_target_critical')}</Typography>
            </td>
          </tr>
          </tbody>
        </table>
        <table className={styles.table}>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>sight radius</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'outer_radius')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>detect radius</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'detect_radius')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>population</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'personnel_pop')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>rear critical type</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getTypeName(data, 'rear_damage_critical_type')}</Typography>
            </td>
          </tr>
          </tbody>
        </table>
        <table className={styles.table}>
          <tbody>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>max speed</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getPreciseKey(moving, 'speed_max')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>rotation</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getPreciseKey(moving, 'rotation_rate')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>acceleration</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getPreciseKey(moving, 'acceleration')}</Typography>
            </td>
          </tr>
          <tr>
            <td>
              <LabelTypography className={styles.labelCol1}>deceleration</LabelTypography>
            </td>
            <td>
              <Typography className={styles.valueCol1}>{getPreciseKey(moving, 'deceleration')}</Typography>
            </td>
          </tr>
          </tbody>
        </table>
      </Box>
    </Paper>
  )
}
