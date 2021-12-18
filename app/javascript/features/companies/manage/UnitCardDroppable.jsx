import React from 'react'
import { DragDropContainer } from "react-drag-drop-container";
import { makeStyles } from "@mui/styles";
import { Box } from "@mui/material";

import { UnitCard } from "./UnitCard";

const useStyles = makeStyles(() => ({
  dragDropContainer: {
    padding: '2px',
    display: 'inline-block'
  }
}))

/**
 * DragDrop container component to wrap an unit card, populating dragData for the drop target
 *
 * @param label: unit label
 * @param image: unit image
 * @param onDrop: callback fired when the drag drop container is dropped into a drop target
 * @param onClick: callback fired when the unit card is clicked
 */
export const UnitCardDroppable = ({ label, image, onDrop, onUnitClick }) => {
  const classes = useStyles()
  return (
    <Box className={classes.dragDropContainer}>
      <DragDropContainer targetKey="unit" onDrop={onDrop} dragData={{ label: label, image: image }}>
        <UnitCard label={label} image={image} onUnitClick={onUnitClick}/>
      </DragDropContainer>
    </Box>
  )
}
