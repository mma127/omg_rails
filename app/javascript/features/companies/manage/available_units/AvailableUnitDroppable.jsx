import React from 'react'
import { useSelector } from "react-redux";
import { DragDropContainer } from "react-drag-drop-container";
import { makeStyles } from "@mui/styles";
import { Box, Tooltip } from "@mui/material";

import { UnitCard } from "../squads/UnitCard";
import { selectAvailableUnitById } from "./availableUnitsSlice";
import { selectUnitById } from "../units/unitsSlice";
import { AvailableUnitTooltipContent } from "./AvailableUnitTooltipContent";

const useStyles = makeStyles(() => ({
  dragDropContainer: {
    padding: '2px',
    display: 'inline-block'
  }
}))

/**
 * DragDrop container component to wrap an available unit card, populating dragData for the drop target
 *
 * @param availableUnitId
 * @param onUnitClick: callback fired when the unit card is clicked
 * @param enabled
 */
export const AvailableUnitDroppable = ({
                                         availableUnitId,
                                         onUnitClick,
                                         enabled
                                       }) => {
  const classes = useStyles()
  const availableUnit = useSelector(state => selectAvailableUnitById(state, availableUnitId))
  const unit = useSelector(state => selectUnitById(state, availableUnit.unitId))
  const notAvailable = availableUnit.available <= 0

  /** When dragging, we want to treat the current unit as selected for the details pane */
  const onDragStart = () => {
    onUnitClick(availableUnit.id)
  }

  return (
    <DragDropContainer targetKey="unit"
                       noDragging={notAvailable || !enabled}
                       onDragStart={onDragStart}
                       dragData={{
                         availableUnit: availableUnit,
                         unit: unit
                       }}>
      <Tooltip
        key={availableUnitId}
        title={<AvailableUnitTooltipContent availableUnit={availableUnit} />}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box className={classes.dragDropContainer}>
          <UnitCard unitId={availableUnit.unitId} availableUnitId={availableUnit.id}
                    onUnitClick={onUnitClick} disabled={notAvailable} />
        </Box>
      </Tooltip>
    </DragDropContainer>
  )
}
