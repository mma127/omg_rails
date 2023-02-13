import React from 'react'
import { Card, CardMedia } from "@mui/material";
import { unitImageMapping } from "../../../../constants/units/all_factions";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  unitCard: {
    display: 'inline-flex'
  }
}))

const DEFAULT_HEIGHT = "45px";
export const StaticUnitIcon = ({ name, height }) => {
  const classes = useStyles()
  const image = unitImageMapping[name]
  if (!height) {
    height = DEFAULT_HEIGHT
  }
  return (
    <Card className={classes.unitCard} sx={{ height: height, width: height }}>
      <CardMedia component="img" height={height} image={image} alt={name} />
    </Card>
  )
}