import React from 'react'
import { Card, CardMedia } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { offmapImageMapping } from "../../../../constants/offmaps/all_factions";
import { OffmapTooltip } from "./OffmapTooltip";
import { OffmapTooltipContent } from "./OffmapTooltipContent";

const useStyles = makeStyles(() => ({
  offmapCard: {
    display: 'inline-flex',
    '&.disabled': {
      cursor: 'initial',
      filter: 'grayscale(1)'
    }
  }
}))

export const DEFAULT_HEIGHT = "45px";
export const OffmapIcon = ({ offmap, disabled, height = DEFAULT_HEIGHT }) => {
  const classes = useStyles()
  const image = offmapImageMapping[offmap.name]

  return (
    <Card className={`${classes.offmapCard} ${disabled ? 'disabled' : ''}`} sx={{ height: height, width: height }}>
      <CardMedia component="img" height={height} image={image} alt={offmap.name} />
    </Card>
  )
}
