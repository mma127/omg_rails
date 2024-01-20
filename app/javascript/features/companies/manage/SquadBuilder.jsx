import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, CircularProgress, Grid, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";

import { CompanyGridDropTarget } from "./squads/CompanyGridDropTarget";
import { SquadsGridTabs } from "./squads/SquadsGridTabs";

import { CORE } from "../../../constants/company";
import { addCost, removeCost, selectCompanyActiveBattleId } from "../companiesSlice";
import {
  resetAvailableUnitState,
  selectAvailableUnitsStatus,
  setSelectedAvailableUnitId
} from "./available_units/availableUnitsSlice"
import { AvailableUnits } from "./available_units/AvailableUnits";
import { AvailableUnitDetails } from "./available_units/AvailableUnitDetails";
import {
  addNonTransportedSquad,
  addTransportedSquad,
  clearNotifySnackbar,
  fetchCompanySquads,
  moveSquad,
  removeSquad,
  removeTransportedSquad,
  resetSquadState,
  setSelectedSquadAccess,
  clearSelectedSquad,
  upsertSquads, copySquad
} from "./units/squadsSlice";
import { AlertSnackbar } from "../AlertSnackbar";
import { selectIsCompanyUnlocksChanged } from "./unlocks/companyUnlocksSlice";
import { createSquad } from "./units/squad";
import { AvailableOffmaps } from "./available_offmaps/AvailableOffmaps";
import { createCompanyOffmap } from "./company_offmaps/companyOffmap";
import {
  addNewCompanyOffmap,
  removeExistingCompanyOffmap,
  removeNewCompanyOffmap,
} from "./company_offmaps/companyOffmapsSlice";
import { PurchasedOffmaps } from "./company_offmaps/PurchasedOffmaps";
import { CompanyResources } from "./CompanyResources";
import { copySquadUpgrade, createSquadUpgrade } from "./squad_upgrades/squadUpgrade";
import { addNewSquadUpgrade, removeSquadUpgrade, } from "./squad_upgrades/squadUpgradesSlice";
import { SaveCompanyButton } from "./SaveCompanyButton";
import { AvailableCounts } from "./available_units/AvailableCounts";

const useStyles = makeStyles(theme => ({
  availableUnitsContainer: {
    minHeight: '250px'
  },
  detailTitle: {
    fontWeight: 'bold'
  },
  saveWrapper: {
    display: 'flex',
    // alignItems: 'center',
    marginTop: "8px"
  },
  saveButton: {
    height: 'fit-content'
  },
  gridTargetWrapper: {
    display: "flex"
  }
}))

const defaultTab = CORE
export const SquadBuilder = ({}) => {
  console.log("SquadBuilder render")
  const dispatch = useDispatch()
  const [currentTab, setCurrentTab] = useState(defaultTab)

  const notifySnackbar = useSelector(state => state.squads.notifySnackbar)
  const snackbarMessage = useSelector(state => state.squads.snackbarMessage)
  const [openSnackbar, setOpenSnackbar] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [notifySnackbar])

  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))

  const squadsStatus = useSelector(state => state.squads.squadsStatus)
  const squadsError = useSelector(state => state.squads.squadsError)
  const isSaving = squadsStatus === 'pending'
  const errorMessage = isSaving ? "" : squadsError

  const isCompanyUnlocksChange = useSelector(selectIsCompanyUnlocksChanged)

  useEffect(() => {
    console.log("dispatching squad and available_unit fetch from SquadBuilder")
    dispatch(fetchCompanySquads({ companyId }))

    return () => {
      console.log("dispatching resetSquadState resetAvailableUnitState")
      dispatch(resetSquadState())
      dispatch(resetAvailableUnitState())
    }
  }, [companyId, isCompanyUnlocksChange])

  // TODO use this to constrain the drag area
  const constraintsRef = useRef(null)

  const handleCloseSnackbar = () => {
    setOpenSnackbar(false)
    dispatch(clearNotifySnackbar())
  }

  const onTabChange = (newTab) => {
    setCurrentTab(newTab)
    dispatch(clearSelectedSquad())
    dispatch(setSelectedAvailableUnitId(null))
  }

  const onUnitSelect = (availableUnitId) => {
    /** Called when a unit is selected. Populates the unit stats box with relevant data
     */
    dispatch(clearSelectedSquad())
    dispatch(setSelectedAvailableUnitId(availableUnitId))
  }

  const onSquadSelect = (availableUnitId, tab, index, uuid, transportUuid) => {
    /** Called when a squad is selected. Populates the unit stats box with relevant data
     * TODO if a squad is clicked, should take upgrades into account
     */
    dispatch(setSelectedSquadAccess({ tab, index, uuid, transportUuid }))
    dispatch(setSelectedAvailableUnitId(availableUnitId))
  }

  /** For a new non-transported squad, use the availableUnit and unit to construct a new squad object
   * Update the company's resources with the new squad's base cost and add the squad to state */
  const onNonTransportSquadCreate = (availableUnit, unit, index, tab,) => {
    const newSquad = createSquad(availableUnit, unit, index, tab, companyId)
    dispatch(addCost({
      id: companyId,
      pop: newSquad.pop,
      man: newSquad.man,
      mun: newSquad.mun,
      fuel: newSquad.fuel
    }))
    dispatch(addNonTransportedSquad(newSquad))
    onSquadSelect(availableUnit.id, tab, index, newSquad.uuid, null)
  }

  /** For a new transported squad, use the availableUnit and unit to construct a new squad object.
   * Additionally include the transport's UUID to denote the transport relationship
   * Update the company's resources with the new squad's base cost and add the squad to state */
  const onTransportedSquadCreate = (availableUnit, unit, index, tab, transportUuid) => {
    const newSquad = createSquad(availableUnit, unit, index, tab, companyId, transportUuid)
    dispatch(addCost({
      id: companyId,
      pop: newSquad.pop,
      man: newSquad.man,
      mun: newSquad.mun,
      fuel: newSquad.fuel
    }))
    dispatch(addTransportedSquad({ newSquad, transportUuid }))
    onSquadSelect(availableUnit.id, tab, index, newSquad.uuid, transportUuid)
  }

  const onSquadCopy = ({ availableUnit, unit, squad, squadUpgrades, transportedUnitAvailableByAvailableUnitId }) => {
    const newSquad = createSquad(availableUnit, unit, squad.index, squad.tab, companyId, squad.transportUuid)

    let pop = newSquad.pop,
      man = newSquad.man,
      mun = newSquad.mun,
      fuel = newSquad.fuel

    const newSquadUpgrades = squadUpgrades.map(su => {
      const newSquadUpgrade = copySquadUpgrade(su, newSquad)
      pop += newSquadUpgrade.pop
      man += newSquadUpgrade.man
      mun += newSquadUpgrade.mun
      fuel += newSquadUpgrade.fuel
      return newSquadUpgrade
    })

    // Handle transported squads, if any
    if (squad.transportedSquads) {
      const newTransportedSquads = squad.transportedSquads.reduce((acc, current) => {
        if (transportedUnitAvailableByAvailableUnitId[current.availableUnitId] > 0) {
          // have availability
          const newTransportedSquad = copySquad(current)
          pop += newTransportedSquad.pop
          man += newTransportedSquad.man
          mun += newTransportedSquad.mun
          fuel += newTransportedSquad.fuel

          const newSquadUpgrades = squadUpgrades.map(su => {
            const newSquadUpgrade = copySquadUpgrade(su, newSquad)
            pop += newSquadUpgrade.pop
            man += newSquadUpgrade.man
            mun += newSquadUpgrade.mun
            fuel += newSquadUpgrade.fuel
            return newSquadUpgrade
          })

          acc.push(newTransportedSquad)
        }
        return acc
      }, [])
    }

    dispatch(copySquad({ squad: newSquad, squadUpgrades: newSquadUpgrades, transportUuid: squad.transportUuid }))

    dispatch(addCost({
      id: companyId,
      pop: pop,
      man: man,
      mun: mun,
      fuel: fuel
    }))

    onSquadSelect(availableUnit.id, newSquad.tab, newSquad.index, newSquad.uuid, newSquad.transportUuid)
  }

  const onSquadDestroy = (squad, squadUpgrades, transportUuid = null) => {
    // TODO remove squad id from company if not null

    // Calculate total cost to remove from sum of squad and upgrades
    let pop = squad.pop,
      man = squad.man,
      mun = squad.mun,
      fuel = squad.fuel;
    (squadUpgrades || []).forEach(su => {
      // Don't need to recalculate squad pop
      man += su.man
      mun += su.mun
      fuel += su.fuel
      dispatch(removeSquadUpgrade({ squadUpgrade: su }))
    })

    dispatch(removeCost({ id: companyId, pop: pop, man: man, mun: mun, fuel: fuel }))
    if (_.isNull(transportUuid)) {
      dispatch(removeSquad(squad))
    } else {
      dispatch(removeTransportedSquad({ squad, transportUuid }))
    }
  }

  const onSquadMove = (squad, unit, newIndex, newTab, targetTransportUuid = null) => {
    dispatch(moveSquad({ squad, unit, newIndex, newTab, targetTransportUuid }))
  }

  const saveSquads = () => {
    dispatch(upsertSquads({ companyId }))
  }

  const onOffmapSelect = (availableOffmap) => {
    const newCompanyOffmap = createCompanyOffmap(null, availableOffmap)
    dispatch(addCost({ id: companyId, pop: 0, man: 0, mun: newCompanyOffmap.mun, fuel: 0 }))
    dispatch(addNewCompanyOffmap({ newCompanyOffmap }))
  }

  const onOffmapDestroyClick = (companyOffmap) => {
    dispatch(removeCost({ id: companyId, pop: 0, man: 0, mun: companyOffmap.mun, fuel: 0 }))
    if (_.isNull(companyOffmap.id)) {
      dispatch(removeNewCompanyOffmap({ availableOffmapId: companyOffmap.availableOffmapId }))
    } else {
      dispatch(removeExistingCompanyOffmap({
        id: companyOffmap.id,
        availableOffmapId: companyOffmap.availableOffmapId
      }))
    }
  }

  const onAvailableUpgradeClick = (availableUpgrade, upgrade, squad) => {
    const newSquadUpgrade = createSquadUpgrade(availableUpgrade, upgrade, squad)
    dispatch(addCost({
      id: companyId,
      pop: newSquadUpgrade.pop,
      man: newSquadUpgrade.man,
      mun: newSquadUpgrade.mun,
      fuel: newSquadUpgrade.fuel
    }))
    dispatch(addNewSquadUpgrade({ newSquadUpgrade }))
  }

  const onSquadUpgradeDestroyClick = (squadUpgrade) => {
    dispatch(removeCost({
      id: companyId,
      pop: squadUpgrade.pop || 0,
      man: squadUpgrade.man,
      mun: squadUpgrade.mun,
      fuel: squadUpgrade.fuel
    }))
    dispatch(removeSquadUpgrade({ squadUpgrade }))
  }

  const editEnabled = !activeBattleId
  const availableUnitsStatus = useSelector(selectAvailableUnitsStatus)
  let availableUnitsContent,
    availableOffmapsContent
  if (availableUnitsStatus === "pending") {
    availableUnitsContent = <CircularProgress/>
    availableOffmapsContent = null
  } else {
    availableUnitsContent = <AvailableUnits onUnitSelect={onUnitSelect} enabled={editEnabled}/>
    availableOffmapsContent = <AvailableOffmaps onSelect={onOffmapSelect} enabled={editEnabled}/>
  }

  let snackbarSeverity = "success"
  let snackbarContent = "Saved successfully"
  if (notifySnackbar) {
    if (errorMessage?.length > 0) {
      snackbarSeverity = "error"
      snackbarContent = "Failed to save company"
    }
  }

  return (
    <>
      <Box sx={{ padding: 1 }}>
        <AlertSnackbar isOpen={openSnackbar}
                       setIsOpen={setOpenSnackbar}
                       handleClose={handleCloseSnackbar}
                       severity={snackbarSeverity}
                       content={snackbarContent}/>
        <Grid container spacing={2} ref={constraintsRef}>
          <Grid item container>
            <AvailableCounts/>
          </Grid>
          <Grid item container spacing={2}>
            <CompanyResources companyId={companyId}/>
            <Grid item md={2}></Grid>
            <SaveCompanyButton saveSquads={saveSquads}/>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item md={6}>
              {availableOffmapsContent}
            </Grid>
            <Grid item md={6}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Purchased Offmaps</Typography>
              <PurchasedOffmaps onDeleteClick={onOffmapDestroyClick} enabled={editEnabled}/>
            </Grid>
          </Grid>
          <Grid item container spacing={2} className={classes.availableUnitsContainer}>
            <Grid item container md={6} sx={{flexDirection: "column"}}>
                {availableUnitsContent}
            </Grid>
            <Grid item container md={6} xs={12}>
              <AvailableUnitDetails onAvailableUpgradeClick={onAvailableUpgradeClick}/>
            </Grid>
          </Grid>
          <Grid item container spacing={2} sx={{ alignItems: "baseline" }}>
            <SquadsGridTabs selectedTab={currentTab} changeCallback={onTabChange}/>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={0} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={1} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={2} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={3} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={4} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={5} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={6} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
            <Grid item xs={3} className={classes.gridTargetWrapper}>
              <CompanyGridDropTarget gridIndex={7} currentTab={currentTab}
                                     onNonTransportSquadCreate={onNonTransportSquadCreate}
                                     onTransportedSquadCreate={onTransportedSquadCreate}
                                     onSquadClick={onSquadSelect}
                                     onSquadDestroy={onSquadDestroy}
                                     onSquadMove={onSquadMove}
                                     onSquadCopy={onSquadCopy}
                                     onSquadUpgradeDestroyClick={onSquadUpgradeDestroyClick}
                                     enabled={editEnabled}/>
            </Grid>
          </Grid>
        </Grid>
      </Box>
    </>
  )
}
