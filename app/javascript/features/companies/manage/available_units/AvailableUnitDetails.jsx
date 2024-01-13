import React, { useEffect } from 'react'
import { Box, Grid, Paper, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { fetchUnitById, selectUnitById } from "../units/unitsSlice";
import { selectAvailableUnitById, selectSelectedAvailableUnitId } from "./availableUnitsSlice";
import { unitImageMapping } from "../../../../constants/units/all_factions";
import { AvailableUpgrades } from "../available_upgrades/AvailableUpgrades";
import { selectIsCompanyManagerCompact, selectSelectedSquad } from "../units/squadsSlice";
import { ResourcesCost } from "../../../resources/ResourcesCost";
import { POP } from "../../../../constants/resources";
import { ResourceQuantity } from "../../../resources/ResourceQuantity";


const useStyles = makeStyles(theme => ({
  statsBox: {
    minHeight: '10rem',
  },
  detailTitle: {
    fontWeight: 'bold'
  },
  detailHeroIcon: {
    height: '45px'
  }
}))

export const AvailableUnitDetails = ({ onAvailableUpgradeClick }) => {
  const availableUnitId = useSelector(selectSelectedAvailableUnitId)
  console.log(`AvailableUnitId Details - ${availableUnitId}`)
  const classes = useStyles()
  const dispatch = useDispatch()

  const availableUnit = useSelector(state => selectAvailableUnitById(state, availableUnitId))
  const unitId = availableUnit?.unitId
  const selectedUnitDetails = useSelector(state => selectUnitById(state, unitId))
  const selectedSquad = useSelector(selectSelectedSquad)

  const isCompact = useSelector(selectIsCompanyManagerCompact)

  useEffect(() => {
    // Dispatch a fetch if the unit id is valid and the selector failed to find a matching unit
    if (unitId && !selectedUnitDetails)
      dispatch(fetchUnitById({ unitId }))
  }, [unitId])

  let content
  if (selectedUnitDetails && availableUnit) {
    const cost = <ResourcesCost man={availableUnit.man} mun={availableUnit.mun} fuel={availableUnit.fuel} />
    const pop = <ResourceQuantity resource={POP} quantity={parseFloat(availableUnit.pop)} />

    let squadContent
    if (selectedSquad) {
      squadContent = ( //TODO do we need anything of the squad here?
        <Grid item container spacing={2}>
          <Grid item>
            Selected squad {selectedSquad?.uuid}
          </Grid>
        </Grid>
      )
    }

    if (isCompact) {
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
                <img src={unitImageMapping[selectedUnitDetails.name]} alt={selectedUnitDetails.name} className={classes.detailHeroIcon}/>
              </Grid>
            </Grid>
            <Grid item container spacing={2}>
              <Grid item xs={3}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Cost</Typography>
                {cost}
              </Grid>
              <Grid item xs={2}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Population</Typography>
                {pop}
              </Grid>
              <Grid item xs={2}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Available</Typography>
                <Typography>{availableUnit.available}</Typography>
              </Grid>
            </Grid>
          </Grid>
          <AvailableUpgrades unitId={unitId} onSelect={onAvailableUpgradeClick}/>
        </Box>
      )
    } else {
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
                <img src={unitImageMapping[selectedUnitDetails.name]} alt={selectedUnitDetails.name}/>
              </Grid>
            </Grid>
            <Grid item container spacing={2}>
              <Grid item xs={3}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Cost</Typography>
                {cost}
              </Grid>
              <Grid item xs={2}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Population</Typography>
                {pop}
              </Grid>
              <Grid item xs={2}>
                <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                            pr={1}>Available</Typography>
                <Typography>{availableUnit.available}</Typography>
              </Grid>
            </Grid>
            <Grid item container spacing={2}>
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
            <Grid item container>
              <Grid item>
                <AvailableUpgrades unitId={unitId} onSelect={onAvailableUpgradeClick}/>
              </Grid>
            </Grid>
          </Grid>

        </Box>
      )
    }
  }

  return (
    <Paper key='statsBox' className={classes.statsBox}>
      {/*TODO connect selectedUnit to stats*/}
      {content}
    </Paper>
  )
}
