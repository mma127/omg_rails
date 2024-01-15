import React from 'react'
import { useSelector } from "react-redux";
import {
  selectEmplacementAvailableUnits, selectGliderAvailableUnits,
  selectInfantryAvailableUnits,
  selectLightVehicleAvailableUnits,
  selectSupportTeamAvailableUnits, selectTankAvailableUnits
} from "./availableUnitsSlice";
import { Accordion, AccordionDetails, AccordionSummary, Box, Tooltip, Typography } from "@mui/material";
import { AvailableUnitTooltipContent } from "./AvailableUnitTooltipContent";
import { UnitCard } from "../squads/UnitCard";
import { makeStyles } from "@mui/styles";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";

const useStyles = makeStyles(theme => ({
  container: {
    display: "flex",
    flexGrow: 1
  },
  unitCountWrapper: {
    display: "flex",
    alignItems: "center",
    padding: "0.5rem"
  },
  unitIconWrapper: {
    marginRight: '0.5rem'
  },
  unitCountText: {
    width: "30px"
  },
  detailsContainer: {
    display: 'flex',
    flexWrap: "wrap"
  }
}))

const AvailableUnitCount = ({ availableUnit }) => {
  const classes = useStyles()
  const notAvailable = availableUnit.available <= 0

  return (
    <Box className={classes.unitCountWrapper}>
      <Tooltip
        key={availableUnit.id}
        title={<AvailableUnitTooltipContent availableUnit={availableUnit}/>}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box className={classes.unitIconWrapper}>
          <UnitCard unitId={availableUnit.unitId} availableUnitId={availableUnit.id}
                    disabled={notAvailable} height={35}/>
        </Box>
      </Tooltip>
      <Typography variant="h6" color="text.secondary"
                  className={classes.unitCountText}>{availableUnit.available}</Typography>
    </Box>
  )
}

const generateContentForUnitType = (availableUnits) => availableUnits.map(
  au => <AvailableUnitCount availableUnit={au} key={au.id}/>
)

/**
 * Shows a list of units to their available count for easy reference.
 */
export const AvailableCounts = ({}) => {
  const classes = useStyles()

  const infantry = useSelector(selectInfantryAvailableUnits)
  const supportTeams = useSelector(selectSupportTeamAvailableUnits)
  const lightVehicles = useSelector(selectLightVehicleAvailableUnits)
  const tanks = useSelector(selectTankAvailableUnits)
  const emplacements = useSelector(selectEmplacementAvailableUnits)
  const gliders = useSelector(selectGliderAvailableUnits)

  return (
    <Box p={2} className={classes.container}>
      <Accordion sx={{ flexGrow: 1 }}>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon/>}
          sx={{ margin: "0" }}
        >
          <Typography variant="h6" color="text.secondary">Available Units</Typography>
        </AccordionSummary>
        <AccordionDetails sx={{ paddingTop: 0, paddingBottom: 0 }}>
          <Box className={classes.detailsContainer}>
            {infantry.length > 0 ? generateContentForUnitType(infantry) : null}
            {supportTeams.length > 0 ? generateContentForUnitType(supportTeams) : null}
            {lightVehicles.length > 0 ? generateContentForUnitType(lightVehicles) : null}
            {tanks.length > 0 ? generateContentForUnitType(tanks) : null}
            {emplacements.length > 0 ? generateContentForUnitType(emplacements) : null}
            {gliders.length > 0 ? generateContentForUnitType(gliders) : null}
          </Box>
        </AccordionDetails>
      </Accordion>
    </Box>
  )
}
