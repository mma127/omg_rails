import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";
import { useSelector } from "react-redux";
import { selectUnitById } from "../units/unitsSlice";
import { unitImageMapping } from "../../../../constants/units/all_factions";

const useStyles = makeStyles(() => ({
  unitCard: {
    width: props => `${props.height}px`,
    minWidth: props => `${props.height}px`,
    height: props => `${props.height}px`,
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
export const UnitCard = ({ unitId, availableUnitId, onUnitClick, disabled, dragHandleClassName, height=45 }) => {
  const classes = useStyles({height: height})
  const unit = useSelector(state => selectUnitById(state, unitId))
  const image = unitImageMapping[unit.name]

  const handleClick = () => {
    if (onUnitClick) {
      onUnitClick(availableUnitId)
    }
  }

  /** TODO onUnitClick needs to be squad aware */
  return (
    <Card className={`${classes.unitCard} ${disabled ? 'disabled' : ''} ${dragHandleClassName}`} onClick={handleClick}>
      <CardMedia component="img" height={`${height}px`} image={image} alt={unit.name} />
    </Card>
  )
}