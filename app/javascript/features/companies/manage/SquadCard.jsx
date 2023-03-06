import React, { useState } from 'react'
import { UnitCard } from "./UnitCard";
import { Box, Card, Paper, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { DragDropContainer, DropTarget } from "react-drag-drop-container";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { formatResourceCost } from "../../../utils/company";
import { useDispatch, useSelector } from "react-redux";
import { selectUnitById } from "../../units/unitsSlice";
import {
  addTransportedSquad,
  selectSquadById,
  selectSquadInTabIndexTransportUuid,
  selectSquadInTabIndexUuid
} from "../../units/squadsSlice";
import { createSquad } from "../../units/squad";
import { nanoid } from "@reduxjs/toolkit";

const useStyles = makeStyles(() => ({
  squadCard: {
    display: 'inline-flex',
    backgroundColor: "#303030",
    margin: '0.125rem'
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
  },
  transportHitBox: {
    minHeight: 'calc(45px + 0.25rem + 16px)', // UnitCard height + 0.125rem margin x2 + 8px padding x2
    minWidth: '4rem',
    marginLeft: '0.5em',
    marginRight: '0.25em'
  }
}))

/**
 * Represents a concrete squad
 *
 * NOTE: There is a bug with the React Drag Drop Container library with the onDrop callback. It appears to fire
 * increasing numbers of times as a drag container is moved around. Not using onDrop and instead handling updating
 * the old grid with redux. https://github.com/peterh32/react-drag-drop-container/issues/39
 *
 * @param squad
 * @param uuid
 * @param index
 * @param tab
 * @param onUnitClick: callback fired when the squad card is clicked anywhere except the destroy icon
 * @param onDestroyClick: callback fired when the destroy icon is clicked
 * @param enabled: Flag for whether the card is editable
 * @param onTransportedSquadCreate
 * @constructor
 */
export const SquadCard = (
  {
    uuid,
    index,
    tab,
    transportUuid = null,
    onUnitClick,
    onDestroyClick,
    enabled,
    onTransportedSquadCreate,
    onSquadMove,
  }
) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  let squad
  if (_.isNil(transportUuid)) {
    squad = useSelector(state => selectSquadInTabIndexUuid(state, tab, index, uuid))
  } else {
    squad = useSelector(state => selectSquadInTabIndexTransportUuid(state, tab, index, transportUuid, uuid))
  }
  const unit = useSelector(state => selectUnitById(state, squad.unitId))

  // Must have unit loaded to continue
  if (!unit || !squad) {
    return null
  }

  // Total costs for this squad including upgrades
  const cost = formatResourceCost({ man: squad.man, mun: squad.mun, fuel: squad.fuel })

  const unitCreateOnHit = (e) => {
    console.log("transport on hit")
    if (!enabled) {
      console.log("Drop target is not enabled")
      return
    }

    const dragData = e.dragData
    const dragUnit = dragData.unit
    console.log(`${dragUnit.name} dropped into transport target ${uuid}`)

    // Check if the dropped squad is allowed to be transported
    const dropUnitId = dragUnit.id // TODO does this work for moving existing squads
    if (!_.includes(unit.transportableUnitIds, dropUnitId)) {
      console.log(`${unit.name} cannot transport squad with unit ${dragUnit.name}`)
      return
    }

    // Check if the transport has sufficient squad and model slots to fit the dropped squad
    const squadSlotsDiff = (unit.transportSquadSlots - squad.usedSquadSlots) - dragUnit.transportSquadSlots
    if (squadSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient squad slots ${squadSlotsDiff}`)
      return
    }
    const modelSlotsDiff = (unit.transportModelSlots - squad.usedModelSlots) - dragUnit.transportModelSlots
    if (modelSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient model slots ${modelSlotsDiff}`)
      return
    }
    onTransportedSquadCreate(dragData.availableUnit, dragData.unit, index, tab, uuid)

    e.stopPropagation()
  }

  const squadMoveOnHit = (e) => {
    if (!enabled) {
      console.log("Drop target is not enabled")
      return
    }

    const dragData = e.dragData
    console.log(`${dragData.unit.name} squad dropped into transport target ${index} ${uuid}`)

    const dragSquad = dragData.squad,
      dragUnit = dragData.unit

    // Check if the dropped squad is allowed to be transported
    const dropUnitId = dragUnit.id // TODO does this work for moving existing squads
    if (!_.includes(unit.transportableUnitIds, dropUnitId)) {
      console.log(`${unit.name} cannot transport squad with unit ${dragUnit.name}`)
      return
    }

    // Check if the transport has sufficient squad and model slots to fit the dropped squad
    const squadSlotsDiff = (unit.transportSquadSlots - squad.usedSquadSlots) - dragUnit.transportSquadSlots
    if (squadSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient squad slots ${squadSlotsDiff}`)
      return
    }
    const modelSlotsDiff = (unit.transportModelSlots - squad.usedModelSlots) - dragUnit.transportModelSlots
    if (modelSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient model slots ${modelSlotsDiff}`)
      return
    }
    onSquadMove(dragSquad, dragUnit, index, tab, uuid)

    e.stopPropagation()
  }

  const transportSquadDelete = (deleteSquad) => {
    onDestroyClick(deleteSquad, uuid)
  }

  let deleteContent = ""
  if (enabled) {
    deleteContent = <DeleteOutlineIcon
      onClick={() => onDestroyClick(squad)}
      className={classes.deleteIcon}
      color="error" />
  }

  let transportContent
  let transportSlotsContent
  if (unit.transportableUnitIds.length > 0 && unit.transportSquadSlots > 0 && _.isNil(transportUuid)) {
    // Must have transportableUnitIds and transportSquadSlots > 0
    // Optionally, can have transportModelSlots
    const transportedSquadsMapping = squad.transportedSquads || {}
    const transportedSquads = _.values(transportedSquadsMapping)
    const usedSquadSlots = transportedSquads.length
    let usedModelSlots = 0
    if (transportedSquads.length > 0) {
      usedModelSlots = transportedSquads.map(s => s.totalModelCount).reduce((prev, next) => prev + next)
    }
    transportContent = (
      <Box sx={{ display: 'flex' }}>
        <DropTarget targetKey="unit" onHit={unitCreateOnHit}>
          <DropTarget targetKey="squad" onHit={squadMoveOnHit}>
            <Paper key={`${uuid}-transport`} className={classes.transportHitBox}>
              <Box>
                {transportedSquads.map(ts => <SquadCard key={ts.uuid}
                                                        uuid={ts.uuid} index={index} tab={tab}
                                                        transportUuid={uuid}
                                                        onUnitClick={onUnitClick}
                                                        onDestroyClick={transportSquadDelete}
                                                        enabled={enabled} />)}
              </Box>
            </Paper>
          </DropTarget>
        </DropTarget>
      </Box>
    )
    transportSlotsContent = (
      <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: "center" }}>
        <Box sx={{fontSize: '0.75rem'}}>
          {usedSquadSlots}/{unit.transportSquadSlots}
        </Box>
        <Box sx={{fontSize: '0.75rem'}}>
          {usedModelSlots}/{unit.transportModelSlots}
        </Box>
      </Box>
    )
  }

  // Use a specific drag handle class so the entire card doesn't drag. This allows nesting SquadCards of transported units
  let dragHandleClassName = `unit-card-drag-handle-${uuid}`
  return (
    <DragDropContainer targetKey="squad"
                       onDragStart={() => onUnitClick(squad.unitId, squad.availableUnitId, squad.image, unit.name)}
                       noDragging={!enabled}
                       dragHandleClassName={dragHandleClassName}
                       dragData={
                         {
                           squad,
                           unit
                         }
                       }
    >
      <Card className={classes.squadCard}>
        <Tooltip
          key={uuid}
          title={
            <>
              <Typography variant="subtitle2" className={classes.tooltipHeader}>{unit.displayName}</Typography>
              <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
              <Box><Typography variant="body"><b>Pop:</b> {parseFloat(squad.pop)}</Typography></Box>
              <Box><Typography variant="body"><b>Exp:</b> {squad.vet}</Typography></Box>
            </>
          }
          // TransitionComponent={Zoom}
          followCursor={true}
          placement="bottom-start"
          arrow
        >
          <Box sx={{ p: 1 }} className={classes.squadCardItems}>

            <UnitCard unitId={squad.unitId} availableUnitId={squad.availableUnitId}
                      onUnitClick={onUnitClick} dragHandleClassName={dragHandleClassName} />
            {transportContent}
            <Box sx={{display: 'flex', flexDirection: 'column', height: '100%', alignItems: "center", justifyContent: "space-between"}}>
              {deleteContent}
              {transportSlotsContent}
            </Box>
          </Box>
        </Tooltip>
      </Card>
    </DragDropContainer>
  )
}