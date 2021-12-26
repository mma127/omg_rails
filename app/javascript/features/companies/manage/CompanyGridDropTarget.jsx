import React, { useState } from 'react'
import { DropTarget } from 'react-drag-drop-container';
import { nanoid } from "@reduxjs/toolkit";
import { Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";

import { UnitCard } from "./UnitCard";
import './CompanyGridDropTarget.css'

const useStyles = makeStyles(() => ({
  placementBox: {
    minHeight: '10rem',
    minWidth: '4rem'
  }
}))

/**
 * Represents a single drop target grid box in the Company builder.
 * Must know its position index and the current selected category of the company
 * builder. With this, is able to get the corresponding squads for the company for
 * this category and index, if any exist.
 *
 * When a change involving this grid box is saved, the squads of this grid box are
 * assigned the category tab and tab position index so they appear correctly in the
 * future and ingame.
 *
 * @param index: position of the box within the Company builder grid of drop targets
 * @param onHitCallback: Callback fired when this company grid drop target receives a hit and has an unit dropped in
 * @param onUnitClick: Callback fired when the unit icon is clicked. Expect to pass squad identifier
 */
export const CompanyGridDropTarget = ({ index, onHitCallback, onUnitClick }) => {
  const classes = useStyles()

  const [content, setContent] = useState([])

  const onHit = (e) => {
    const dragData = e.dragData
    console.log(`${dragData.unitName} dropped into target ${index}`)
    const existing = content.slice()
    existing.push(<UnitCard key={nanoid()} unitId={dragData.unitId} label={dragData.unitName}
                            image={dragData.image} onUnitClick={onUnitClick} />)
    setContent(existing)

    onHitCallback(dragData.unitName, dragData.image, index)
  }

  return (
    <DropTarget targetKey="unit" onHit={onHit} >
      <Paper key={index} className={classes.placementBox}>
        {index}
        {content}
      </Paper>
    </DropTarget>
  )
}