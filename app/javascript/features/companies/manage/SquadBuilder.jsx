import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Alert, AlertTitle, Box, Button, CircularProgress, Container, Grid, Snackbar, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";

import { CompanyGridDropTarget } from "./CompanyGridDropTarget";
import { SquadsGridTabs } from "./SquadsGridTabs";

import { ANTI_ARMOUR, ARMOUR, ASSAULT, CORE, INFANTRY, SUPPORT } from "../../../constants/company";
import { addUnitCost, fetchCompanyById, removeUnitCost, selectCompanyById } from "../companiesSlice";
import {
  resetAvailableUnitState,
  fetchCompanyAvailableUnits,
  selectAllAvailableUnits,
  selectAvailableUnitsStatus
} from "../../units/availableUnitsSlice"
import { AvailableUnits } from "./available_units/AvailableUnits";
import { AvailableUnitDetails } from "./AvailableUnitDetails";
import {
  addSquad, resetSquadState, clearNotifySnackbar,
  removeSquad,
  selectAntiArmourSquads,
  selectArmourSquads,
  selectAssaultSquads,
  selectCoreSquads,
  selectInfantrySquads,
  selectSupportSquads, upsertSquads, fetchCompanySquads
} from "../../units/squadsSlice";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { AlertSnackbar } from "../AlertSnackbar";

const useStyles = makeStyles(theme => ({
  availableUnitsContainer: {
    minHeight: '280px'
  },
  detailTitle: {
    fontWeight: 'bold'
  }
}))

const defaultTab = CORE
export const SquadBuilder = ({}) => {
  const dispatch = useDispatch()
  const [currentTab, setCurrentTab] = useState(defaultTab)
  const [selectedUnitId, setSelectedUnitId] = useState(null)
  const [selectedAvailableUnitId, setSelectedAvailableUnitId] = useState(null)
  const [selectedUnitImage, setSelectedUnitImage] = useState(null)
  const [selectedUnitName, setSelectedUnitName] = useState(null)

  const notifySnackbar = useSelector(state => state.squads.notifySnackbar)
  const [openSnackbar, setOpenSnackbar] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [notifySnackbar])

  const core = useSelector(selectCoreSquads)
  const assault = useSelector(selectAssaultSquads)
  const infantry = useSelector(selectInfantrySquads)
  const armour = useSelector(selectArmourSquads)
  const antiArmour = useSelector(selectAntiArmourSquads)
  const support = useSelector(selectSupportSquads)

  let currentTabPlatoons
  switch (currentTab) {
    case CORE: {
      currentTabPlatoons = core
      break
    }
    case ASSAULT: {
      currentTabPlatoons = assault
      break
    }
    case INFANTRY: {
      currentTabPlatoons = infantry
      break
    }
    case ARMOUR: {
      currentTabPlatoons = armour
      break
    }
    case ANTI_ARMOUR: {
      currentTabPlatoons = antiArmour
      break
    }
    case SUPPORT: {
      currentTabPlatoons = support
      break
    }
    default: {
      console.log(`Unsupported tab ${currentTab}`)
      break
    }
  }

  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  const company = useSelector(state => selectCompanyById(state, companyId))

  const squadsStatus = useSelector(state => state.squads.squadsStatus)
  const isChanged = useSelector(state => state.squads.isChanged)
  const squadsError = useSelector(state => state.squads.squadsError)
  const isSaving = squadsStatus === 'pending'
  const canSave = !isSaving && isChanged
  const errorMessage = isSaving ? "" : squadsError

  useEffect(() => {
    console.log("dispatching squad and available_unit fetch from SquadBuilder")
    dispatch(fetchCompanySquads({ companyId }))
    dispatch(fetchCompanyAvailableUnits({ companyId }))

    return () => {
      console.log("dispatching resetSquadState resetAvailableUnitState")
      dispatch(resetSquadState())
      dispatch(resetAvailableUnitState())
    }
  }, [companyId])

  // TODO use this to constrain the drag area
  const constraintsRef = useRef(null)

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  const onTabChange = (newTab) => {
    console.log(`SquadBuilder changed to new tab ${newTab}`)
    setCurrentTab(newTab)
  }

  const onUnitSelect = (unitId, availableUnitId, unitImage, unitName) => {
    /** Called when a unit is selected. Populates the unit stats box with relevant data
     * TODO if a squad is clicked, should take upgrades into account
     */
    setSelectedUnitId(unitId)
    setSelectedAvailableUnitId(availableUnitId)
    setSelectedUnitImage(unitImage)
    setSelectedUnitName(unitName)
  }

  const onDropTargetHit = ({
                             uuid,
                             id,
                             unitId,
                             availableUnitId,
                             unitName,
                             pop,
                             man,
                             mun,
                             fuel,
                             image,
                             index,
                             tab,
                             vet
                           }) => {
    console.log(`Added ${unitName}, pop ${pop}, costs ${man}MP ${mun}MU ${fuel}FU to category ${tab} position ${index}`)
    dispatch(addUnitCost({ id: company.id, pop, man, mun, fuel }))
    dispatch(addSquad({ uuid, id, unitId, availableUnitId, unitName, pop, man, mun, fuel, image, index, tab, vet }))
  }

  const onSquadDestroy = (uuid, id, availableUnitId, pop, man, mun, fuel, index, tab) => {
    // TODO remove squad id from company if not null
    dispatch(removeUnitCost({ id: company.id, pop, man, mun, fuel }))
    dispatch(removeSquad({ uuid, availableUnitId, index, tab }))
  }

  const saveSquads = () => {
    dispatch(upsertSquads({ companyId }))
  }

  const editEnabled = !company.activeBattleId
  const availableUnitsStatus = useSelector(selectAvailableUnitsStatus)
  const availableUnits = useSelector(selectAllAvailableUnits)
  let availableUnitsContent
  if (availableUnitsStatus === "pending") {
    console.log("Loading available units")
    availableUnitsContent = <CircularProgress />
  } else {
    console.log("Selected available units")
    console.log(availableUnits)
    availableUnitsContent = <AvailableUnits companyId={companyId} onUnitSelect={onUnitSelect} enabled={editEnabled} />
  }

  let snackbarSeverity = "success"
  let snackbarContent = "Saved successfully"
  let errorAlert
  if (errorMessage?.length > 0) {
    errorAlert = <Alert severity="error">{errorMessage}</Alert>
  }
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
                       content={snackbarContent} />
        <Grid container spacing={2} ref={constraintsRef}>
          <Grid item container spacing={2} className={classes.availableUnitsContainer}>
            <Grid item md={6}>
              {availableUnitsContent}
              {/*TODO maybe populate by type, alphabetically or cost ASC */}
            </Grid>
            <Grid item md={6} xs={12}>
              <AvailableUnitDetails unitId={selectedUnitId} availableUnitId={selectedAvailableUnitId}
                                    unitImage={selectedUnitImage} />
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={2} md={1}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Population</Typography>
              <Typography variant="body2" gutterBottom>{company.pop}</Typography>
            </Grid>
            <Grid item xs={2} md={1}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Manpower</Typography>
              <Typography variant="body2" gutterBottom>{company.man}</Typography>
            </Grid>
            <Grid item xs={2} md={1}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Munitions</Typography>
              <Typography variant="body2" gutterBottom>{company.mun}</Typography>
            </Grid>
            <Grid item xs={2} md={1}>
              <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                          pr={1}>Fuel</Typography>
              <Typography variant="body2" gutterBottom>{company.fuel}</Typography>
            </Grid>
            <Grid item md={2} />
            <Grid item container md={6}>
              <Grid item md={2}>
                <Button variant="contained" color="secondary" size="small" onClick={saveSquads}
                        disabled={!canSave}>Save</Button>
              </Grid>
              <Grid item md={10}>
                {errorAlert}
                {/*<ErrorTypography>{errorMessage}</ErrorTypography>*/}
              </Grid>
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <SquadsGridTabs selectedTab={currentTab} changeCallback={onTabChange} />
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={0} currentTab={currentTab} squads={currentTabPlatoons[0]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={1} currentTab={currentTab} squads={currentTabPlatoons[1]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={2} currentTab={currentTab} squads={currentTabPlatoons[2]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={3} currentTab={currentTab} squads={currentTabPlatoons[3]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
          </Grid>
          <Grid item container spacing={2}>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={4} currentTab={currentTab} squads={currentTabPlatoons[4]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={5} currentTab={currentTab} squads={currentTabPlatoons[5]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={6} currentTab={currentTab} squads={currentTabPlatoons[6]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
            <Grid item xs={3}>
              <CompanyGridDropTarget gridIndex={7} currentTab={currentTab} squads={currentTabPlatoons[7]}
                                     onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                     onSquadDestroy={onSquadDestroy} enabled={editEnabled} />
            </Grid>
          </Grid>
        </Grid>
      </Box>
    </>
  )
}