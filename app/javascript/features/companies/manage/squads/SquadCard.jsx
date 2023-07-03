import React from 'react'
import {UnitCard} from "./UnitCard";
import {Box, Card, Tooltip, Typography} from "@mui/material";
import {makeStyles} from "@mui/styles";
import {DragDropContainer} from "react-drag-drop-container";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import {formatResourceCost} from "../../../../utils/company";
import {useSelector} from "react-redux";
import {selectUnitById} from "../units/unitsSlice";
import {
  selectSelectedSquadUuid,
  selectSquadInTabIndexTransportUuid,
  selectSquadInTabIndexUuid
} from "../units/squadsSlice";
import {TransportSlots} from "./TransportSlots";
import {TransportDropTarget} from "./TransportDropTarget";
import {SquadUpgrades} from "../squad_upgrades/SquadUpgrades";
import {selectSquadUpgradesForSquad} from "../squad_upgrades/squadUpgradesSlice";

const useStyles = makeStyles(() => ({
  squadCard: {
    display: 'inline-flex',
    backgroundColor: "#303030",
    margin: '0.125rem',
    '&.selected': {
      backgroundColor: "#606060"
    }
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
  slotsDeleteWrapper: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    alignItems: "center",
    justifyContent: "space-between"
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
 * @param onSquadClick: callback fired when the squad card is clicked anywhere except the destroy icon
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
    onSquadClick,
    onDestroyClick,
    enabled,
    onTransportedSquadCreate,
    onSquadMove,
    onSquadUpgradeDestroyClick,
  }
) => {
  const classes = useStyles()
  let squad
  if (_.isNil(transportUuid)) {
    squad = useSelector(state => selectSquadInTabIndexUuid(state, tab, index, uuid))
  } else {
    squad = useSelector(state => selectSquadInTabIndexTransportUuid(state, tab, index, transportUuid, uuid))
  }
  const unit = useSelector(state => selectUnitById(state, squad.unitId))
  const squadUpgrades = useSelector(state => selectSquadUpgradesForSquad(state, tab, index, uuid))
  const selectedSquadUuid = useSelector(selectSelectedSquadUuid)

  const isSelected = selectedSquadUuid === uuid

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
    onDestroyClick(deleteSquad, squadUpgrades, uuid)
  }

  const onUnitClick = (availableUnitId) => {
    onSquadClick(availableUnitId, squad.tab, squad.index, squad.uuid, transportUuid)
  }

  let deleteContent = ""
  if (enabled) {
    deleteContent = <DeleteOutlineIcon
      onClick={() => onDestroyClick(squad, squadUpgrades, null)}
      className={classes.deleteIcon}
      color="error"/>
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
    transportContent = <TransportDropTarget transportedSquads={transportedSquads}
                                            unitCreateOnHit={unitCreateOnHit}
                                            squadMoveOnHit={squadMoveOnHit}
                                            index={index} tab={tab}
                                            transportUuid={uuid}
                                            onSquadClick={onSquadClick}
                                            transportSquadDelete={transportSquadDelete}
                                            onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                            enabled={enabled}/>

    transportSlotsContent = <TransportSlots usedSquadSlots={usedSquadSlots}
                                            usedModelSlots={usedModelSlots}
                                            maxSquadSlots={unit.transportSquadSlots}
                                            maxModelSlots={unit.transportModelSlots}/>
  }

  // Use a specific drag handle class so the entire card doesn't drag. This allows nesting SquadCards of transported units
  let dragHandleClassName = `unit-card-drag-handle-${uuid}`
  return (
    <DragDropContainer targetKey="squad"
                       onDragStart={() => onSquadClick(squad.availableUnitId, squad.tab, squad.index, squad.uuid, transportUuid)}
                       noDragging={!enabled}
                       dragHandleClassName={dragHandleClassName}
                       dragData={
                         {
                           squad,
                           unit
                         }
                       }
    >
      <Card className={`${classes.squadCard} ${isSelected ? 'selected' : null}`}>
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
                      onUnitClick={onUnitClick} dragHandleClassName={dragHandleClassName}/>
            <SquadUpgrades tab={tab} index={index} squadUuid={squad.uuid} onUpgradeClick={onSquadUpgradeDestroyClick}
                           enabled={enabled}/>
            {transportContent}
            <Box className={classes.slotsDeleteWrapper}>
              {deleteContent}
              {transportSlotsContent}
            </Box>
          </Box>
        </Tooltip>
      </Card>
    </DragDropContainer>
  )
}