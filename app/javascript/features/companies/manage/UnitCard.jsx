import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";

const useStyles = makeStyles(() => ({
  unitCard: {
    width: '45px',
    height: '45px',
    display: 'inline-flex',
    '&.disabled': {
      cursor: 'initial',
      filter: 'grayscale(1)'
    }
  }
}))

/**
 * Display component to show an unit image
 * @param unitId
 * @param label: image label
 * @param image
 * @param onUnitClick
 * @param disabled: Flag to show the disabled state for the unit card
 */
export const UnitCard = ({ unitId, availableUnitId, label, image, onUnitClick, disabled }) => {
  const classes = useStyles()

  /** TODO onUnitClick needs to be squad aware */
  return (
    <Card className={`${classes.unitCard} ${disabled ? 'disabled' : ''}`} onClick={() => onUnitClick(unitId, availableUnitId, image, label)}>
      <CardMedia component="img" height="45" image={image} alt={label} />
    </Card>
  )
}