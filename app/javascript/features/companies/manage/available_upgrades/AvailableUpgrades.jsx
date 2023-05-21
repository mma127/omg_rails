import React from 'react'
import { useSelector } from "react-redux";
import { selectAllAvailableUpgrades, selectAvailableUpgradesByUnitId } from "./availableUpgradesSlice";
import { Box, Typography } from "@mui/material";
import { AvailableUpgradeClickable } from "./AvailableUpgradeClickable";

const generateContent = (au, onSelect, enabled) =>
  <AvailableUpgradeClickable
    key={au.id}
    availableUpgradeId={au.id}
    onUpgradeClick={onSelect}
    enabled={enabled}
  />

/**
 * Show all available upgrades for the given company
 * @constructor
 */
export const AvailableUpgrades = ({ unitId, onSelect, enabled }) => {
  const availableUpgrades = useSelector(state => selectAvailableUpgradesByUnitId(state, unitId))

  return (
    <>
      {availableUpgrades.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Available Upgrades</Typography>
        {availableUpgrades.map(au => generateContent(au, onSelect, enabled))}
      </Box> : null}
    </>
  )
}
