import React from 'react'
import { useSelector } from "react-redux";
import {
  selectEmplacementAvailableUnits,
  selectInfantryAvailableUnits,
  selectLightVehicleAvailableUnits,
  selectSupportTeamAvailableUnits,
  selectTankAvailableUnits
} from "../../../units/availableUnitsSlice";
import { AvailableUnitDroppable } from "../AvailableUnitDroppable";
import { unitImageMapping } from "../../../../constants/units/all_factions";
import { Box, Typography } from "@mui/material";


const generateContentForUnitType = (availableUnits, onUnitSelect) => availableUnits.map(
  au => (<AvailableUnitDroppable
    key={au.unitId}
    unitId={au.unitId}
    unitName={au.unitName}
    availableUnit={au}
    label={au.unitDisplayName}
    image={unitImageMapping[au.unitName]}
    available={au.available}
    resupply={au.resupply}
    companyMax={au.companyMax}
    onUnitClick={onUnitSelect}
  />))

/**
 * Show all available units for the given company. Take into account availability
 * @param companyId: company id for which we should display available units
 * @param onUnitSelect
 */
export const AvailableUnits = ({ onUnitSelect }) => {
  const infantry = useSelector(selectInfantryAvailableUnits)
  const supportTeams = useSelector(selectSupportTeamAvailableUnits)
  const lightVehicles = useSelector(selectLightVehicleAvailableUnits)
  const tanks = useSelector(selectTankAvailableUnits)
  const emplacements = useSelector(selectEmplacementAvailableUnits)

  return (
    <>
      {infantry.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Infantry</Typography>
        {generateContentForUnitType(infantry, onUnitSelect)}
      </Box> : null}
      {supportTeams.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Support Teams</Typography>
        {generateContentForUnitType(supportTeams, onUnitSelect)}
      </Box> : null}
      {lightVehicles.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Light Vehicles</Typography>
        {generateContentForUnitType(lightVehicles, onUnitSelect)}
      </Box> : null}
      {tanks.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Tanks</Typography>
        {generateContentForUnitType(tanks, onUnitSelect)}
      </Box> : null}
      {emplacements.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Emplacements</Typography>
        {generateContentForUnitType(emplacements, onUnitSelect)}
      </Box> : null}
    </>
  )
}
