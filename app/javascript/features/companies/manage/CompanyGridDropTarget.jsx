import React from 'react'
import { DropTarget } from 'react-drag-drop-container';
import { nanoid } from "@reduxjs/toolkit";
import { Box, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";
import '../../../../assets/stylesheets/CompanyGridDropTarget.css'
import { SquadCard } from "./SquadCard";
import { createSquad } from "../../units/squad";

const useStyles = makeStyles(() => ({
  placementBox: {
    minHeight: '15rem',
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
 * @param gridIndex: position of the box within the Company builder grid of drop targets
 * @param currentTab
 * @param squads
 * @param onHitCallback: Callback fired when this company grid drop target receives a hit and has an unit dropped in
 * @param onUnitClick: Callback fired when the unit icon is clicked. Expect to pass squad identifier
 * @param onSquadDestroy
 * @param enabled: Flag for whether the drop target and any squad cards contained within are editable
 */
export const CompanyGridDropTarget = ({
                                        gridIndex,
                                        currentTab,
                                        squads,
                                        onHitCallback,
                                        onUnitClick,
                                        onSquadDestroy,
                                        enabled
                                      }) => {
  const classes = useStyles()


  // Is it necessary to maintain total cost of the drop target/platoon?

  const onHit = (e) => {
    if (!enabled) {
      console.log("Drop target is not enabled")
      return
    }
    const dragData = e.dragData
    console.log(`${dragData.unitName} dropped into target ${gridIndex}`)
    if (Object.keys(dragData).includes("uuid")) {
      // Moved an existing squad into this drop target
      const { uuid, id, unitId, unitName, pop, man, mun, fuel, image, index, tab } = dragData

      // Remove it from its previous platoon index
      onSquadDestroy(uuid, id, unitId, pop, man, mun, fuel, index, tab)

      // Need to add this squad to the current platoon index
      onHitCallback({ ...dragData, vet: 0, index: gridIndex, tab: currentTab })
    } else if (dragData.index !== gridIndex) {
      const uuid = nanoid()
      const newSquad = createSquad(uuid, null, dragData.unitId, dragData.unitName, dragData.unitDisplayName,
        dragData.pop, dragData.man, dragData.mun, dragData.fuel, dragData.image, gridIndex, currentTab)
      onHitCallback(newSquad)
    } else {
      console.log(`skipping onHit for the same index ${gridIndex}`)
    }
  }

  const onDestroyClick = (uuid, squadId, unitId, pop, man, mun, fuel) => {
    console.log(`Destroy squad: ${uuid}, ${squadId}, ${pop} with costs ${man}, ${mun}, ${fuel}`)
    onSquadDestroy(uuid, squadId, unitId, pop, man, mun, fuel, gridIndex, currentTab)
  }

  let gridPop = 0
  let squadCards = []
  if (squads) {
    for (const squad of Object.values(squads)) {
      gridPop += parseFloat(squad.pop)
      squadCards.push(<SquadCard key={squad.uuid}
                                 uuid={squad.uuid} squadId={squad.id} unitId={squad.unitId} unitName={squad.unitName}
                                 unitDisplayName={squad.unitDisplayName}
                                 pop={squad.pop} man={squad.man} mun={squad.mun} fuel={squad.fuel} image={squad.image}
                                 index={squad.index} tab={squad.tab} vet={squad.vet}
                                 onUnitClick={onUnitClick} onDestroyClick={onDestroyClick} enabled={enabled} />)
    }
  }

  return (
    <DropTarget targetKey="unit" onHit={onHit}>
      <Paper key={gridIndex} className={classes.placementBox}>
        <Box sx={{ position: 'relative', p: 1 }}>
          {squadCards}
          <Box component="span" sx={{ position: 'absolute', right: '2px', top: '-1px' }}>{gridPop}</Box>
        </Box>
      </Paper>
    </DropTarget>
  )
}