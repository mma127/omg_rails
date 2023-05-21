import React from 'react'
import { Card, CardMedia } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { upgradeImageMapping } from "../../../../constants/upgrades/all_factions";

const useStyles = makeStyles(() => ({
  upgradeCard: {
    display: 'inline-flex',
    '&.disabled': {
      cursor: 'initial',
      filter: 'grayscale(1)'
    }
  }
}))

export const DEFAULT_HEIGHT = "45px";
export const UpgradeIcon = ({ upgrade, disabled, height = DEFAULT_HEIGHT }) => {
  const classes = useStyles()
  const image = upgradeImageMapping[upgrade.name]

  return (
    <Card className={`${classes.upgradeCard} ${disabled ? 'disabled' : ''}`} sx={{ height: height, width: height }}>
      <CardMedia component="img" height={height} image={image} alt={upgrade.name} />
    </Card>
  )
}
