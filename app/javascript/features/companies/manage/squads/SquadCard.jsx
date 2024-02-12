import React, { useEffect, useRef, useState } from 'react'
import { UnitCard } from "./UnitCard";
import { Box, Card, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { DragDropContainer } from "react-drag-drop-container";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { formatResourceCost } from "../../../../utils/company";
import { useDispatch, useSelector } from "react-redux";
import { selectUnitById } from "../units/unitsSlice";
import {
  clearHighlightedUuid, copySquad, deepCopySquad,
  selectHighlightedUuid,
  selectSelectedSquadUuid,
  selectSquadInTabIndexTransportUuid,
  selectSquadInTabIndexUuid,
  setHighlightedUuid,
  setSelectedSquadAccess
} from "../units/squadsSlice";
import { TransportSlots } from "./TransportSlots";
import { TransportDropTarget } from "./TransportDropTarget";
import { SquadUpgrades } from "../squad_upgrades/SquadUpgrades";
import { selectSquadUpgradesForSquad } from "../squad_upgrades/squadUpgradesSlice";
import { SquadVetIcon } from "./SquadVetIcon";
import {
  selectAvailableByAvailableUnitId,
  selectAvailableUnitById,
  setSelectedAvailableUnitId
} from "../available_units/availableUnitsSlice";
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { selectCurrentCompany } from "../../companiesSlice";
import { buildVetBonuses, getVetLevel } from "../units/unit_vet";
import _ from "lodash";
import { selectCurrentSnapshotCompany } from "../../snapshotCompaniesSlice";

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
    alignItems: 'center',
    // paddingRight: '2px' // The delete icon has spacing built into it, so we don't need this as wide on the right
  },
  actionIcons: {
    marginRight: '-6px',
    display: "flex",
    flexDirection: "column",
    alignItems: "center"
  },
  icon: {
    cursor: 'pointer'
  },
  copyIcon: {
    fontSize: "1rem",
    marginTop: "0.25rem"
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
    onSquadCopy,
    onSquadUpgradeDestroyClick,
    isSnapshot = false
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
  const squadUpgrades = useSelector(state => selectSquadUpgradesForSquad(state, tab, index, uuid))
  const selectedSquadUuid = useSelector(selectSelectedSquadUuid)
  let company
  if (isSnapshot) {
    company = useSelector(selectCurrentSnapshotCompany)
  } else {
    company = useSelector(selectCurrentCompany)
  }

  const [isTooltipOpen, setIsTooltipOpen] = useState(false)
  const elementRef = useRef()

  const highlightedUuid = useSelector(selectHighlightedUuid)
  const isHighlighted = squad.uuid === highlightedUuid
  useEffect(() => {
    // Need this check as react-drag-drop-container creates a ghost element copy of the child of the dragdropcontainer
    const hasGhost = !!elementRef.current && !!elementRef.current.closest(".ddcontainerghost")

    if (isHighlighted && !hasGhost) {
      setIsTooltipOpen(true)
    } else if (isTooltipOpen) {
      setIsTooltipOpen(false)
    }
  }, [isHighlighted]);

  const isSelected = selectedSquadUuid === uuid

  // Must have unit loaded to continue
  if (!unit || !squad || !company) {
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
    const squadSlotsDiff = (unit.transportSquadSlots - squad.usedSquadSlots) - 1
    if (squadSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient squad slots ${squadSlotsDiff}`)
      return
    }
    const modelSlotsDiff = (unit.transportModelSlots - squad.usedModelSlots) - dragUnit.modelCount
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
    const dropUnitId = dragUnit.id
    if (!_.includes(unit.transportableUnitIds, dropUnitId)) {
      console.log(`${unit.name} cannot transport squad with unit ${dragUnit.name}`)
      return
    }

    // Check if the transport has sufficient squad and model slots to fit the dropped squad
    const squadSlotsDiff = (unit.transportSquadSlots - squad.usedSquadSlots) - 1
    if (squadSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient squad slots ${squadSlotsDiff}`)
      return
    }
    const modelSlotsDiff = (unit.transportModelSlots - squad.usedModelSlots) - dragUnit.modelCount
    if (modelSlotsDiff < 0) {
      console.log(`Cannot transport ${dragUnit.name}, insufficient model slots ${modelSlotsDiff}`)
      return
    }
    onSquadMove(dragSquad, dragUnit, index, tab, uuid)

    e.stopPropagation()
  }

  const transportSquadDelete = (deleteSquad, squadUpgrades) => {
    onDestroyClick(deleteSquad, squadUpgrades, deleteSquad.transportUuid)
  }

  const selectSquad = (availableUnitId, tab, index, uuid, transportUuid) => {
    dispatch(setSelectedSquadAccess({ tab, index, uuid, transportUuid }))
    dispatch(setSelectedAvailableUnitId(availableUnitId))
  }

  const onUnitClick = (availableUnitId) => {
    // Don't need onSquadClick for anything at the SquadBuilder level
    selectSquad(squad.availableUnitId, squad.tab, squad.index, squad.uuid, squad.transportUuid)
  }

  const onSquadUpgradeClick = (squadUpgrade) => {
    selectSquad(squad.availableUnitId, squad.tab, squad.index, squad.uuid, squad.transportUuid)
    onSquadUpgradeDestroyClick(squadUpgrade)
  }

  const onCopyClick = () => {
    selectSquad(squad.availableUnitId, squad.tab, squad.index, squad.uuid, squad.transportUuid)
    dispatch(deepCopySquad({ squad, squadUpgrades }))
  }

  // Vet
  const [level, nextLevel] = getVetLevel(parseFloat(squad.vet), unit.vet)
  let nextLevelContent = ""
  if (nextLevel) {
    nextLevelContent = `(Next: ${nextLevel})`
  }
  const vetBonuses = buildVetBonuses(level, unit.vet)


  let actionsContent
  if (enabled && !isSnapshot) {
    actionsContent = <Box className={classes.actionIcons}>
      <DeleteOutlineIcon
        onClick={() => onDestroyClick(squad, squadUpgrades, null)}
        className={classes.icon}
        color="error"/>
      <ContentCopyIcon onClick={onCopyClick} className={`${classes.icon} ${classes.copyIcon}`}/>
    </Box>
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
                                            onSquadMove={onSquadMove}
                                            onSquadCopy={onSquadCopy}
                                            transportSquadDelete={transportSquadDelete}
                                            onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                            enabled={enabled}
                                            isSnapshot={isSnapshot}/>

    transportSlotsContent = <TransportSlots usedSquadSlots={usedSquadSlots}
                                            usedModelSlots={usedModelSlots}
                                            maxSquadSlots={unit.transportSquadSlots}
                                            maxModelSlots={unit.transportModelSlots}/>
  }

  const handleTooltipOpen = () => {
    dispatch(setHighlightedUuid({ uuid: squad.uuid }))
  }
  const handleTooltipClose = () => {
    dispatch(clearHighlightedUuid())
  }

  // Use a specific drag handle class so the entire card doesn't drag. This allows nesting SquadCards of transported units
  let dragHandleClassName = `unit-card-drag-handle-${uuid}`
  const cardContent = (
    <Card className={`${classes.squadCard} ${isSelected ? 'selected' : null}`}>
      <Tooltip
        key={uuid}
        open={isTooltipOpen}
        onMouseLeave={handleTooltipClose}
        onMouseEnter={handleTooltipOpen}
        title={
          <>
            <Typography variant="subtitle2" className={classes.tooltipHeader}>{unit.displayName}</Typography>
            <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
            <Box><Typography variant="body"><b>Pop:</b> {parseFloat(squad.pop)}</Typography></Box>
            <Box><Typography variant="body"><b>Exp:</b> {squad.vet} {nextLevelContent}</Typography></Box>
            {vetBonuses.map(vb => <Box key={vb.level} className={classes.squadCardItems}><SquadVetIcon
              level={vb.level}/> {vb.desc}</Box>)}
          </>
        }
        // TransitionComponent={Zoom}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box sx={{ p: 1 }} className={classes.squadCardItems} ref={elementRef}>
          <UnitCard unitId={squad.unitId} availableUnitId={squad.availableUnitId}
                    onUnitClick={onUnitClick} dragHandleClassName={dragHandleClassName}/>
          <SquadVetIcon level={level}/>
          <SquadUpgrades tab={tab} index={index} squadUuid={squad.uuid} onUpgradeClick={onSquadUpgradeClick}
                         enabled={enabled}/>
          {transportContent}
          <Box className={classes.slotsDeleteWrapper}>
            {actionsContent}
            {transportSlotsContent}
          </Box>
        </Box>
      </Tooltip>
    </Card>
  )


  if (isSnapshot) {
    return cardContent
  }

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
      // Need a custom drag element to avoid duplicating the controlled tooltip of the non-ghost (custom drag element) card
                       customDragElement={
                         <Card className={`${classes.squadCard} 'selected'`}>
                           <Tooltip
                             key={uuid}
                             title={
                               <>
                                 <Typography variant="subtitle2"
                                             className={classes.tooltipHeader}>{unit.displayName}</Typography>
                                 <Box><Typography variant="body"><b>Cost:</b> {cost}</Typography></Box>
                                 <Box><Typography variant="body"><b>Pop:</b> {parseFloat(squad.pop)}</Typography></Box>
                                 <Box><Typography variant="body"><b>Exp:</b> {squad.vet} {nextLevelContent}</Typography></Box>
                                 {vetBonuses.map(vb => <Box key={vb.level}
                                                            className={classes.squadCardItems}><SquadVetIcon
                                   level={vb.level} side={company.side}/> {vb.desc}</Box>)}
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
                               <SquadVetIcon level={level} side={company.side}/>
                               <SquadUpgrades tab={tab} index={index} squadUuid={squad.uuid}
                                              onUpgradeClick={onSquadUpgradeDestroyClick}
                                              enabled={enabled}/>
                               {transportContent}
                               <Box className={classes.slotsDeleteWrapper}>
                                 {actionsContent}
                                 {transportSlotsContent}
                               </Box>
                             </Box>
                           </Tooltip>
                         </Card>
                       }
    >
      {cardContent}
    </DragDropContainer>
  )
}