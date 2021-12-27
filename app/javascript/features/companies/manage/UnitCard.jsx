import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";

const useStyles = makeStyles(() => ({
  unitCard: {
    width: '45px',
    height: '45px',
    display: 'inline-flex'
  }
}))

/**
 * Display component to show an unit image
 * @param unitId
 * @param label: image label
 * @param image
 * @param onUnitClick
 */
export const UnitCard = ({ unitId, label, image, onUnitClick }) => {
  const classes = useStyles()

  /** TODO onUnitClick needs to be squad aware */
  return (
    <Card className={classes.unitCard} onClick={() => onUnitClick(unitId, label)}>
      <CardMedia component="img" height="45" image={image} alt={label} />
    </Card>
  )
}