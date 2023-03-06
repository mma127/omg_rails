import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";
import { useSelector } from "react-redux";
import { selectUnitById } from "../../units/unitsSlice";
import { unitImageMapping } from "../../../constants/units/all_factions";

const useStyles = makeStyles(() => ({
  unitCard: {
    width: '45px',
    minWidth: '45px',
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
 * @param availableUnitId
 * @param onUnitClick
 * @param disabled: Flag to show the disabled state for the unit card
 * @param dragHandleClassName
 */
export const UnitCard = ({ unitId, availableUnitId, onUnitClick, disabled, dragHandleClassName }) => {
  const classes = useStyles()
  const unit = useSelector(state => selectUnitById(state, unitId))
  const image = unitImageMapping[unit.name]

  const handleClick = () => {
    onUnitClick(unitId, availableUnitId, image, unit.name)
  }

  /** TODO onUnitClick needs to be squad aware */
  return (
    <Card className={`${classes.unitCard} ${disabled ? 'disabled' : ''} ${dragHandleClassName}`} onClick={handleClick}>
      <CardMedia component="img" height="45" image={image} alt={unit.name} />
    </Card>
  )
}