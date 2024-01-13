import React from 'react'
import { useSelector } from "react-redux";
import {
  selectEmplacementAvailableUnits,
  selectGliderAvailableUnits,
  selectInfantryAvailableUnits,
  selectLightVehicleAvailableUnits,
  selectSupportTeamAvailableUnits,
  selectTankAvailableUnits
} from "./availableUnitsSlice";
import { AvailableUnitDroppable } from "./AvailableUnitDroppable";
import { Box, Typography } from "@mui/material";
import { selectIsCompanyManagerCompact } from "../units/squadsSlice";


const generateContentForUnitType = (availableUnits, onUnitSelect, enabled) => availableUnits.map(
  au => (<AvailableUnitDroppable
    key={au.id}
    availableUnitId={au.id}
    onUnitClick={onUnitSelect}
    enabled={enabled}
  />))

/**
 * Show all available units for the given company. Take into account availability
 * @param companyId: company id for which we should display available units
 * @param onUnitSelect
 */
export const AvailableUnits = ({ onUnitSelect, enabled }) => {
  const infantry = useSelector(selectInfantryAvailableUnits)
  const supportTeams = useSelector(selectSupportTeamAvailableUnits)
  const lightVehicles = useSelector(selectLightVehicleAvailableUnits)
  const tanks = useSelector(selectTankAvailableUnits)
  const emplacements = useSelector(selectEmplacementAvailableUnits)
  const gliders = useSelector(selectGliderAvailableUnits)

  const isCompact = useSelector(selectIsCompanyManagerCompact)

  if (isCompact) {
    return (
      <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Units</Typography>
        {infantry.length > 0 ?
          generateContentForUnitType(infantry, onUnitSelect, enabled)
          : null}
        {supportTeams.length > 0 ?
          generateContentForUnitType(supportTeams, onUnitSelect, enabled)
          : null}
        {lightVehicles.length > 0 ?
          generateContentForUnitType(lightVehicles, onUnitSelect, enabled)
          : null}
        {tanks.length > 0 ?
          generateContentForUnitType(tanks, onUnitSelect, enabled)
          : null}
        {emplacements.length > 0 ?
          generateContentForUnitType(emplacements, onUnitSelect, enabled)
          : null}
        {gliders.length > 0 ?
          generateContentForUnitType(gliders, onUnitSelect, enabled)
          : null}
      </Box>
    )
  }

  return (
    <>
      {infantry.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Infantry</Typography>
        {generateContentForUnitType(infantry, onUnitSelect, enabled)}
      </Box> : null}
      {supportTeams.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Support Teams</Typography>
        {generateContentForUnitType(supportTeams, onUnitSelect, enabled)}
      </Box> : null}
      {lightVehicles.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Light Vehicles</Typography>
        {generateContentForUnitType(lightVehicles, onUnitSelect, enabled)}
      </Box> : null}
      {tanks.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Tanks</Typography>
        {generateContentForUnitType(tanks, onUnitSelect, enabled)}
      </Box> : null}
      <Box sx={{ display: 'flex' }}>
        {emplacements.length > 0 ? <Box sx={{ flexGrow: 1 }}>
          <Typography variant="subtitle2" color="text.secondary" gutterBottom>Emplacements</Typography>
          {generateContentForUnitType(emplacements, onUnitSelect, enabled)}
        </Box> : null}
        {gliders.length > 0 ? <Box sx={{ flexGrow: 2 }}>
          <Typography variant="subtitle2" color="text.secondary" gutterBottom>Gliders</Typography>
          {generateContentForUnitType(gliders, onUnitSelect, enabled)}
        </Box> : null}
      </Box>
    </>
  )
}
