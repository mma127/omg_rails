import React, { useState } from 'react'
import { DropTarget } from 'react-drag-drop-container';
import { Box, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";
import '../../../../../assets/stylesheets/CompanyGridDropTarget.css'
import { SquadCard } from "./SquadCard";
import { useSelector } from "react-redux";
import { selectCallinModifiers, selectSquadsInTabIndex } from "../units/squadsSlice";
import { GLIDER } from "../../../../constants/units/types";
import { AlertSnackbar } from "../../AlertSnackbar";
import { CallinModifierIcon } from "../callin_modifiers/CallinModifierIcon";

const useStyles = makeStyles(() => ({
  placementBox: {
    minHeight: '15rem',
    minWidth: '4rem'
  },
  popCMBox: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center'
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
 * @param onNonTransportSquadCreate: Callback fired when this company grid drop target receives a hit and has an unit dropped in
 * @param onTransportedSquadCreate
 * @param onSquadClick: Callback fired when the squad unit icon is clicked. Expect to pass squad identifier
 * @param onSquadDestroy
 * @param onSquadMove
 * @param enabled: Flag for whether the drop target and any squad cards contained within are editable
 */
export const CompanyGridDropTarget = ({
                                        gridIndex,
                                        currentTab,
                                        onNonTransportSquadCreate,
                                        onTransportedSquadCreate,
                                        onSquadClick,
                                        onSquadDestroy,
                                        onSquadMove,
                                        onSquadUpgradeDestroyClick,
                                        enabled
                                      }) => {
  const classes = useStyles()

  console.log(`Rendering tab ${currentTab} and index ${gridIndex}`)
  const squads = useSelector(state => selectSquadsInTabIndex(state, currentTab, gridIndex))

  const [openSnackbar, setOpenSnackbar] = useState(false)
  const [snackbarContent, setSnackbarContent] = useState("")
  const [snackbarSeverity, setSnackbarSeverity] = useState("success")

  const callinModifiers = useSelector(selectCallinModifiers)

  const handleCloseSnackbar = () => {
    setOpenSnackbar(false)
  }

  // TODO Is it necessary to maintain total cost of the drop target/platoon?

  /** Moved an availableUnit into this drop target for squad creation */
  const onUnitHit = (e) => {
    if (!enabled) {
      console.log("Drop target is not enabled")
      return
    }
    const dragData = e.dragData
    console.log(`${dragData.availableUnit.unitName} new unit dropped into target ${gridIndex}`)

    // Check if glider and no other gliders
    if (dragData.unit.type === GLIDER) {
      // Now check if any gliders in squads
      if (_.values(squads).some(s => s.unitType === GLIDER)) {
        setSnackbarContent("Only 1 Glider is allowed per platoon")
        setSnackbarSeverity("warning")
        setOpenSnackbar(true)
        return
      }
    }

    // Creating a new squad without transport
    onNonTransportSquadCreate(dragData.availableUnit, dragData.unit, gridIndex, currentTab)
  }

  /** Moved an existing squad into this drop target */
  const onSquadMoveHit = (e) => {
    if (!enabled) {
      console.log("Drop target is not enabled")
      return
    }
    const dragData = e.dragData
    console.log(`${dragData.unit.name} squad dropped into target ${gridIndex}`)

    const { squad, unit, } = dragData
    onSquadMove(squad, unit, gridIndex, currentTab)
  }

  const onDestroyClick = (squad, squadUpgrades, transportUuid = null) => {
    onSquadDestroy(squad, squadUpgrades, transportUuid)
  }

  const insertSquadUnitIds = (unitIds, squad) => {
    unitIds.push(squad.unitId)
    if(squad.hasOwnProperty("transportedSquads")) {
      getTransportedUnitIds(unitIds, squad)
    }
  }
  const getTransportedUnitIds = (unitIds, transportSquad) => {
    _.values(transportSquad.transportedSquads).forEach(squad => unitIds.push(squad.unitId))
  }

  let gridPop = 0
  let squadCards = []
  const unitIds = []
  if (squads) {
    for (const squad of Object.values(squads)) {
      insertSquadUnitIds(unitIds, squad)

      if (squad.transportedSquads) {
        // Use popWithTransported to include transported squads' pop
        gridPop += parseFloat(squad.popWithTransported)
      } else {
        gridPop += parseFloat(squad.pop)
      }
      squadCards.push(<SquadCard key={squad.uuid}
                                 uuid={squad.uuid}
                                 index={gridIndex} tab={currentTab}
                                 enabled={enabled}
                                 onSquadClick={onSquadClick}
                                 onDestroyClick={onDestroyClick}
                                 onTransportedSquadCreate={onTransportedSquadCreate}
                                 onSquadMove={onSquadMove}
                                 onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
      />)
    }
  }

  let callinModifierContent
  if (!_.isNil(callinModifiers) && callinModifiers.length > 0) {
    callinModifierContent = <CallinModifierIcon callinModifiers={callinModifiers} unitIds={unitIds} />
  }

  return (
    <>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent} />
      <DropTarget targetKey="unit" onHit={onUnitHit}>
        <DropTarget targetKey="squad" onHit={onSquadMoveHit}>
          <Paper key={gridIndex} className={classes.placementBox}>
            <Box sx={{ position: 'relative', p: 1 }}>
              {squadCards}
              <Box component="span" sx={{ position: 'absolute', right: '2px', top: '-1px' }} className={classes.popCMBox}>
                {gridPop}
                {callinModifierContent}
              </Box>
            </Box>
          </Paper>
        </DropTarget>
      </DropTarget>
    </>
  )
}
