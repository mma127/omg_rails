import React from 'react'
import { useSelector } from "react-redux";
import { selectAllAvailableOffmaps } from "./availableOffmapsSlice";
import { Box, Typography } from "@mui/material";
import { AvailableOffmapClickable } from "./AvailableOffmapClickable";

const generateContent = (ao, onSelect, enabled) =>
  <AvailableOffmapClickable
    key={ao.id}
    availableOffmapId={ao.id}
    onOffmapClick={onSelect}
    enabled={enabled}
  />

/**
 * Show all available offmaps for the given company
 * @constructor
 */
export const AvailableOffmaps = ({ onSelect, enabled }) => {
  const availableOffmaps = useSelector(selectAllAvailableOffmaps)

  return (
    <>
      {availableOffmaps.length > 0 ? <Box>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom>Offmaps</Typography>
        {availableOffmaps.map(ao => generateContent(ao, onSelect, enabled))}
      </Box> : null}
    </>
  )
}
