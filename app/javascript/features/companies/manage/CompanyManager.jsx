import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { CircularProgress, Container, Grid, Paper, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";

import { CompanyGridDropTarget } from "./CompanyGridDropTarget";
import { CompanyGridTabs } from "./CompanyGridTabs";
import { UnitCardDroppable } from "./UnitCardDroppable";

import { ANTI_ARMOUR, ARMOUR, ASSAULT, CORE, INFANTRY, SUPPORT } from "../../../constants/company";
import { RIFLEMEN, SHERMAN } from "../../../constants/units/americans";

import riflemen from '../../../../assets/images/doctrines/americans/units/riflemen.png'
import sherman from '../../../../assets/images/doctrines/americans/units/sherman.png'
import { fetchCompanyById, selectCompanyById } from "../companiesSlice";
import {
  fetchCompanyAvailableUnits,
  selectAllAvailableUnits,
  selectAvailableUnitsStatus
} from "../../units/availableUnitsSlice"
import { AvailableUnits } from "./available_units/AvailableUnits";
import { selectUnitById } from "../../units/unitsSlice";
import { UnitDetails } from "./UnitDetails";
import {
  addSquad, removeSquad,
  selectAntiArmourSquads,
  selectArmourSquads,
  selectAssaultSquads,
  selectCoreSquads,
  selectInfantrySquads, selectSupportSquads
} from "../../units/squadsSlice";

const useStyles = makeStyles(theme => ({
  placementBox: {
    minHeight: '10rem',
    minWidth: '4rem'
  },
  detailTitle: {
    fontWeight: 'bold'
  }
}))

const defaultTab = CORE
export const CompanyManager = () => {
  const [currentTab, setCurrentTab] = useState(defaultTab)
  const [selectedUnitId, setSelectedUnitId] = useState(null)
  const [selectedUnitImage, setSelectedUnitImage] = useState(null)
  const [selectedUnitName, setSelectedUnitName] = useState(null)

  const core = useSelector(selectCoreSquads)
  const assault = useSelector(selectAssaultSquads)
  const infantry = useSelector(selectInfantrySquads)
  const armour = useSelector(selectArmourSquads)
  const antiArmour = useSelector(selectAntiArmourSquads)
  const support = useSelector(selectSupportSquads)

  let currentTabPlatoons
  switch(currentTab) {
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
  const [companyPop, setCompanyPop] = useState(parseFloat(company.pop))
  const [availableMan, setAvailableMan] = useState(company.man)
  const [availableMun, setAvailableMun] = useState(company.mun)
  const [availableFuel, setAvailableFuel] = useState(company.fuel)

  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(fetchCompanyById({ companyId }))
  }, [companyId])

  // TODO use this to constrain the drag area
  const constraintsRef = useRef(null)

  const onTabChange = (newTab) => {
    console.log(`Manager changed to new tab ${newTab}`)
    setCurrentTab(newTab)
  }

  const onUnitSelect = (unitId, unitImage, unitName) => {
    /** Called when a unit is selected. Populates the unit stats box with relevant data
     * TODO if a squad is clicked, should take upgrades into account
     */
    setSelectedUnitId(unitId)
    setSelectedUnitImage(unitImage)
    setSelectedUnitName(unitName)
  }

  const onDropTargetHit = (unit, unitPop, manCost, munCost, fuelCost, index, newSquad) => {
    console.log(`Added ${unit}, pop ${unitPop}, costs ${manCost}MP ${munCost}MU ${fuelCost}FU to category ${currentTab} position ${index}`)
    setCompanyPop(companyPop + parseFloat(unitPop))
    setAvailableMan(availableMan - manCost)
    setAvailableMun(availableMun - munCost)
    setAvailableFuel(availableFuel - fuelCost)

    dispatch(addSquad({index: index, tab: currentTab, squad: newSquad}))
  }

  const onSquadDestroy = (squadId, squadPop, squadMan, squadMun, squadFuel, index, squadUuid) => {
    // TODO Remove squad from company
    setCompanyPop(companyPop - parseFloat(squadPop))
    setAvailableMan(availableMan + squadMan)
    setAvailableMun(availableMun + squadMun)
    setAvailableFuel(availableFuel + squadFuel)

    dispatch(removeSquad({index: index, tab: currentTab, squadUuid: squadUuid}))
  }

  const availableUnitsStatus = useSelector(selectAvailableUnitsStatus)
  const availableUnits = useSelector(selectAllAvailableUnits)
  let availableUnitsContent
  if (availableUnitsStatus === "pending") {
    console.log("Loading available units")
    availableUnitsContent = <CircularProgress />
  } else {
    console.log("Selected available units")
    console.log(availableUnits)
    availableUnitsContent = <AvailableUnits companyId={companyId} onUnitSelect={onUnitSelect} />
  }

  return (
    <Container maxWidth="xl" ref={constraintsRef} sx={{ paddingTop: '1rem' }}>
      <Typography variant="h5" gutterBottom>{company.name}</Typography>

      <Grid container spacing={2}>
        <Grid item container spacing={2}>
          <Grid item md={6}>
            {availableUnitsContent}
            {/*TODO read available units for this company from backend */}
            {/*TODO maybe populate by type, alphabetically or cost ASC */}
          </Grid>
          <Grid item md={6} xs={12}>
            <UnitDetails unitId={selectedUnitId} unitImage={selectedUnitImage} />
          </Grid>
        </Grid>
        <Grid item container spacing={2}>
          <Grid item xs={2} md={1}>
            <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                        pr={1}>Population</Typography>
            <Typography variant="body2" gutterBottom>{companyPop}</Typography>
          </Grid>
          <Grid item xs={2} md={1}>
            <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                        pr={1}>Manpower</Typography>
            <Typography variant="body2" gutterBottom>{availableMan}</Typography>
          </Grid>
          <Grid item xs={2} md={1}>
            <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                        pr={1}>Munitions</Typography>
            <Typography variant="body2" gutterBottom>{availableMun}</Typography>
          </Grid>
          <Grid item xs={2} md={1}>
            <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                        pr={1}>Fuel</Typography>
            <Typography variant="body2" gutterBottom>{availableFuel}</Typography>
          </Grid>
        </Grid>
        <Grid item>
          <CompanyGridTabs selectedTab={currentTab} changeCallback={onTabChange} />
        </Grid>
        <Grid item container spacing={2}>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={0} squads={currentTabPlatoons[0]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={1} squads={currentTabPlatoons[1]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={2} squads={currentTabPlatoons[2]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={3} squads={currentTabPlatoons[3]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
        </Grid>
        <Grid item container spacing={2}>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={4} squads={currentTabPlatoons[4]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={5} squads={currentTabPlatoons[5]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={6} squads={currentTabPlatoons[6]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget index={7} squads={currentTabPlatoons[7]}  onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
        </Grid>
      </Grid>
    </Container>
  )
}