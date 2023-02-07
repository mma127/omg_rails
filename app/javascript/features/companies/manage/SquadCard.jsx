import React, { useState } from 'react'
import { UnitCard } from "./UnitCard";
import { Box, Card, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { DragDropContainer } from "react-drag-drop-container";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { formatResourceCost } from "../../../utils/company";

const useStyles = makeStyles(() => ({
  squadCard: {
    display: 'inline-flex',
    backgroundColor: "#303030",
    margin: '0.25rem'
  },
  squadCardItems: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center'
  },
  deleteIcon: {
    cursor: 'pointer'
  },
  tooltipHeader: {
    fontWeight: 'bold'
  }
}))

/**
 * Represents a concrete squad
 *
 * NOTE: There is a bug with the React Drag Drop Container library with the onDrop callback. It appears to fire
 * increasing numbers of times as a drag container is moved around. Not using onDrop and instead handling updating
 * the old grid with redux. https://github.com/peterh32/react-drag-drop-container/issues/39
 *
 * @param uuid
 * @param squadId: non null if this represents an existing squad
 * @param unitId: unit id
 * @param unitName: unit name
 * @param unitDisplayName
 * @param vet
 * @param pop
 * @param man
 * @param mun
 * @param fuel
 * @param image: unit image
 * @param index
 * @param tab
 * @param onUnitClick: callback fired when the squad card is clicked anywhere except the destroy icon
 * @param onDestroyClick: callback fired when the destroy icon is clicked
 * @param enabled: Flag for whether the card is editable
 * @constructor
 */
export const SquadCard = (
  {
    uuid,
    squadId,
    unitId,
    availableUnitId,
    unitName,
    unitDisplayName,
    vet,
    pop,
    man,
    mun,
    fuel,
    image,
    index,
    tab,
    onUnitClick,
    onDestroyClick,
    enabled
  }
) => {
  const classes = useStyles()

  // Total costs for this squad including upgrades
  // const [manCost, setManCost] = useState(man)
  // const [munCost, setMunCost] = useState(mun)
  // const [fuelCost, setFuelCost] = useState(fuel)
  const cost = formatResourceCost({ man: man, mun: mun, fuel: fuel })

  let deleteContent = ""
  if (enabled) {
    deleteContent = <DeleteOutlineIcon
      onClick={() => onDestroyClick(uuid, squadId, availableUnitId, pop, man, mun, fuel)}
      className={classes.deleteIcon}
      color="error" />
  }

  return (
    <Tooltip
      key={squadId}
      title={
        <>
          {/*TODO use unit display name */}
          <Typography variant="subtitle2" className={classes.tooltipHeader}>{unitDisplayName}</Typography>
          <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
          <Box><Typography variant="body"><b>Pop:</b> {parseFloat(pop)}</Typography></Box>
          <Box><Typography variant="body"><b>Exp:</b> {vet}</Typography></Box>
        </>
      }
      // TransitionComponent={Zoom}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Card className={classes.squadCard}>
        <DragDropContainer targetKey="unit" onDragStart={() => onUnitClick(unitId, availableUnitId, image, unitName)}
                           noDragging={!enabled}
                           dragData={
                             {
                               uuid: uuid,
                               id: squadId,
                               unitId: unitId,
                               availableUnitId: availableUnitId,
                               unitName: unitName,
                               unitDisplayName: unitDisplayName,
                               pop: pop,
                               man: man,
                               mun: mun,
                               fuel: fuel,
                               image: image,
                               index: index,
                               tab: tab
                             }
                           }
        >
          <Box sx={{ p: 1 }} className={classes.squadCardItems}>
            <UnitCard unitId={unitId} availableUnitId={availableUnitId} label={unitName} image={image} onUnitClick={onUnitClick} />
            {deleteContent}
          </Box>
        </DragDropContainer>
      </Card>
    </Tooltip>
  )
}