import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { CircularProgress, Container, Grid, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";

import { CompanyGridDropTarget } from "./CompanyGridDropTarget";
import { CompanyGridTabs } from "./CompanyGridTabs";

import { ANTI_ARMOUR, ARMOUR, ASSAULT, CORE, INFANTRY, SUPPORT } from "../../../constants/company";
import { addUnitCost, fetchCompanyById, removeUnitCost, selectCompanyById } from "../companiesSlice";
import { selectAllAvailableUnits, selectAvailableUnitsStatus } from "../../units/availableUnitsSlice"
import { AvailableUnits } from "./available_units/AvailableUnits";
import { UnitDetails } from "./UnitDetails";
import {
  addSquad,
  removeSquad,
  selectAntiArmourSquads,
  selectArmourSquads,
  selectAssaultSquads,
  selectCoreSquads,
  selectInfantrySquads,
  selectSupportSquads
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
  const dispatch = useDispatch()
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

  const onDropTargetHit = ({ uuid, id, unitId, unitName, pop, man, mun, fuel, image, index, tab }) => {
    console.log(`Added ${unitName}, pop ${pop}, costs ${man}MP ${mun}MU ${fuel}FU to category ${tab} position ${index}`)
    dispatch(addUnitCost({ id: company.id, pop, man, mun, fuel }))
    dispatch(addSquad({ uuid, id, unitId, unitName, pop, man, mun, fuel, image, index, tab }))
  }

  const onSquadDestroy = (uuid, id, pop, man, mun, fuel, index, tab) => {
    // TODO remove squad id from company if not null
    dispatch(removeUnitCost({ id: company.id, pop, man, mun, fuel }))
    dispatch(removeSquad({ uuid, index, tab }))
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
        </Grid>
        <Grid item>
          <CompanyGridTabs selectedTab={currentTab} changeCallback={onTabChange} />
        </Grid>
        <Grid item container spacing={2}>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={0} currentTab={currentTab} squads={currentTabPlatoons[0]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={1} currentTab={currentTab} squads={currentTabPlatoons[1]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={2} currentTab={currentTab} squads={currentTabPlatoons[2]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={3} currentTab={currentTab} squads={currentTabPlatoons[3]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
        </Grid>
        <Grid item container spacing={2}>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={4} currentTab={currentTab} squads={currentTabPlatoons[4]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={5} currentTab={currentTab} squads={currentTabPlatoons[5]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={6} currentTab={currentTab} squads={currentTabPlatoons[6]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
          <Grid item xs={3}>
            <CompanyGridDropTarget gridIndex={7} currentTab={currentTab} squads={currentTabPlatoons[7]}
                                   onHitCallback={onDropTargetHit} onUnitClick={onUnitSelect}
                                   onSquadDestroy={onSquadDestroy} />
          </Grid>
        </Grid>
      </Grid>
    </Container>
  )
}