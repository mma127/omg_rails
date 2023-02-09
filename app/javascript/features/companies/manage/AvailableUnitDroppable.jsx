import React from 'react'
import { DragDropContainer } from "react-drag-drop-container";
import { makeStyles } from "@mui/styles";
import { Box, Tooltip, Typography } from "@mui/material";

import { UnitCard } from "./UnitCard";
import { formatResourceCost } from "../../../utils/company";

const useStyles = makeStyles(() => ({
  dragDropContainer: {
    padding: '2px',
    display: 'inline-block'
  },
  tooltipHeader: {
    fontWeight: 'bold'
  }
}))

/**
 * DragDrop container component to wrap an available unit card, populating dragData for the drop target
 *
 * @param label: unit label
 * @param image: unit image
 * @param onClick: callback fired when the unit card is clicked
 */
export const AvailableUnitDroppable = ({
                                         unitId,
                                         unitName,
                                         label,
                                         availableUnit,
                                         image,
                                         onUnitClick,
                                         available,
                                         resupply,
                                         companyMax,
                                         enabled
                                       }) => {
  const classes = useStyles()

  const cost = formatResourceCost({ man: availableUnit.man, mun: availableUnit.mun, fuel: availableUnit.fuel })

  const notAvailable = available <= 0

  const onDragStart = () => {
    onUnitClick(unitId, availableUnit.id, image, unitName)
  }

  return (
    <Tooltip
      key={unitId}
      title={
        <>
          {/*TODO use unit display name */}
          <Typography variant="subtitle2" className={classes.tooltipHeader}>{label}</Typography>
          <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
          <Box><Typography variant="body"><b>Pop:</b> {parseFloat(availableUnit.pop)}</Typography></Box>
          <Box><Typography variant="body"><b>Available:</b> {available}</Typography></Box>
          <Box><Typography variant="body"><b>Resupply:</b> {resupply}</Typography></Box>
        </>
      }
      // TransitionComponent={Zoom}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box className={classes.dragDropContainer}>
        <DragDropContainer targetKey="unit"
                           noDragging={notAvailable || !enabled}
                           onDragStart={onDragStart}
                           dragData={{
                             unitId: unitId, availableUnitId: availableUnit.id, unitName: unitName, unitDisplayName: label,
                             image: image, pop: availableUnit.pop, man: availableUnit.man, mun: availableUnit.mun, fuel: availableUnit.fuel
                           }}>
          <UnitCard unitId={unitId} availableUnitId={availableUnit.id} label={label} image={image} onUnitClick={onUnitClick} disabled={notAvailable} />
        </DragDropContainer>
      </Box>
    </Tooltip>
  )
}
