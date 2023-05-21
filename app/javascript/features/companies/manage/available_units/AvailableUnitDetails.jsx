import React, { useEffect } from 'react'
import { Box, CircularProgress, Grid, Paper, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { fetchUnitById, selectUnitById } from "../units/unitsSlice";
import {
  selectAvailableUnitById, selectSelectedAvailableUnitId
} from "./availableUnitsSlice";
import { unitImageMapping } from "../../../../constants/units/all_factions";
import { formatResourceCost } from "../../../../utils/company";
import { selectAvailableUpgradesByUnitId } from "../available_upgrades/availableUpgradesSlice";
import { AvailableUpgrades } from "../available_upgrades/AvailableUpgrades";


const useStyles = makeStyles(theme => ({
  statsBox: {
    minHeight: '10rem',
    height: '90%'
  },
  detailTitle: {
    fontWeight: 'bold'
  }
}))

export const AvailableUnitDetails = () => {
  const availableUnitId = useSelector(selectSelectedAvailableUnitId)
  console.log(`AvailableUnitId Details - ${availableUnitId}`)
  const classes = useStyles()
  const dispatch = useDispatch()

  const availableUnit = useSelector(state => selectAvailableUnitById(state, availableUnitId))
  const unitId = availableUnit?.unitId
  const selectedUnitDetails = useSelector(state => selectUnitById(state, unitId))

  useEffect(() => {
    // Dispatch a fetch if the unit id is valid and the selector failed to find a matching unit
    if (unitId && !selectedUnitDetails)
      dispatch(fetchUnitById({ unitId }))
  }, [unitId])

  let content
  if (selectedUnitDetails && availableUnit) {
    const cost = formatResourceCost({ man: availableUnit.man, mun: availableUnit.mun, fuel: availableUnit.fuel })
    content = (
      <Box p={2}>
        <Grid container spacing={2}>
          <Grid item container spacing={2}>
            <Grid item xs={10}>
              <Typography variant="h5" gutterBottom className={classes.detailTitle}>
                {selectedUnitDetails.displayName}
              </Typography>
            </Grid>
            <Grid item xs={2}>
              <img src={unitImageMapping[selectedUnitDetails.name]} alt={selectedUnitDetails.name} />
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={6}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Cost</Typography>
              <Typography variant="body2" gutterBottom>{cost}</Typography>
            </Grid>
            <Grid item xs={3}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Population</Typography>
              <Typography variant="body2" gutterBottom>{parseFloat(availableUnit.pop)}</Typography>
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={3}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Available</Typography>
              <Typography variant="body2" gutterBottom>{availableUnit.available}</Typography>
            </Grid>
            <Grid item xs={3}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Resupply</Typography>
              <Typography variant="body2" gutterBottom>{availableUnit.resupply} (per Battle)</Typography>
            </Grid>
            <Grid item xs={6}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Company Max</Typography>
              <Typography variant="body2" gutterBottom>{availableUnit.companyMax}</Typography>
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item>
              <AvailableUpgrades unitId={unitId} enabled={false} />
            </Grid>
          </Grid>
        </Grid>

      </Box>
    )
  }

  return (
    <Paper key='statsBox' className={classes.statsBox}>
      {/*TODO connect selectedUnit to stats*/}
      {content}
    </Paper>
  )
}
