import React, { useEffect, useState } from 'react'
import { useDispatch } from "react-redux";
import { Box, Container, Switch, Tab, Tabs } from "@mui/material";
import { makeStyles, useTheme } from "@mui/styles";
import PersonIcon from '@mui/icons-material/Person';
import { Link, Route, Routes, useLocation } from "react-router-dom";
import { RestrictionUnits } from "./restriction_units/RestrictionUnits";
import useMediaQuery from "@mui/material/useMediaQuery";
import { fetchFactions } from "../factions/factionsSlice";
import { fetchDoctrines } from "../doctrines/doctrinesSlice";
import { FactionSelector } from "./FactionSelector";
import { DoctrineSelector } from "./DoctrineSelector";
import { clearRestrictionUnits } from "./restriction_units/restrictionUnitsSlice";
import { DisabledSelector } from "./DisabledSelector";
import { PageContainer } from "../../components/PageContainer";
import { RestrictionUnlocks } from "./unlocks/RestrictionUnlocks";
import AccountTreeIcon from "@mui/icons-material/AccountTree";


const useStyles = makeStyles(theme => ({
  topWrapper: {
    display: 'flex',
    flexDirection: "column"
  },
  selectors: {
    display: 'inline-flex',
    flexDirection: "column"
  },
  wrapper: {
    display: "flex"
  },
  contentContainer: {
    display: 'flex'
  },
  tabs: {
    minWidth: 'fit-content'
  },
  tab: {
    [theme.breakpoints.down('md')]: {
      minWidth: '50px'
    }
  },
  detailTitle: {
    fontWeight: 'bold'
  }
}))

const UNITS = "units"
const UNLOCKS = "unlocks"

export const Restrictions = () => {
  // Restrictions guides container
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));
  const dispatch = useDispatch()

  const location = useLocation()
  const pathEnd = location.pathname.slice(location.pathname.lastIndexOf("/") + 1, location.pathname.length) // +1 to skip "/"
  let tab
  if (pathEnd === UNLOCKS) {
    tab = UNLOCKS
  } else {
    tab = UNITS
  }

  const [currentTab, setCurrentTab] = useState(tab)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  const [currentFactionName, setCurrentFactionName] = useState(null)
  const [currentFactionId, setCurrentFactionId] = useState(null)
  const [currentDoctrineName, setCurrentDoctrineName] = useState(null)
  const [currentDoctrineId, setCurrentDoctrineId] = useState(null)

  // By default, don't show restriction chains that end in a disabled entity
  const [showDisabled, setShowDisabled] = useState(false)

  useEffect(() => {
    dispatch(fetchFactions())
    dispatch(fetchDoctrines())
    return () => {
      setCurrentFactionName(null)
      setCurrentFactionId(null)
      setCurrentDoctrineName(null)
      setCurrentDoctrineId(null)
      dispatch(clearRestrictionUnits())
    }
  }, [])

  const handleFactionSelect = ({ factionName, factionId }) => {
    if (factionName !== currentFactionName) {
      setCurrentFactionName(factionName)
      setCurrentFactionId(factionId)
    }
    setCurrentDoctrineId(null)
    setCurrentDoctrineName(null)
  }

  const handleDoctrineSelect = ({ doctrineName, doctrineId }) => {
    if (doctrineId !== currentDoctrineId) {
      setCurrentDoctrineName(doctrineName)
      setCurrentDoctrineId(doctrineId)
    }
  }

  const handleShowDisabledToggle = (event) => {
    setShowDisabled(event.target.checked)
  }

  return (
    <PageContainer maxWidth="xl" disableGutters>
      <Box p={3} pt={5} className={classes.topWrapper}>
        <Box className={classes.selectors} pb={2}>
          <FactionSelector currentFactionName={currentFactionName} handleFactionSelect={handleFactionSelect}/>
          <DoctrineSelector currentFactionId={currentFactionId} currentDoctrineName={currentDoctrineName}
                            handleDoctrineSelect={handleDoctrineSelect}/>
          <DisabledSelector showDisabled={showDisabled} handleShowDisabledToggle={handleShowDisabledToggle}/>
        </Box>
        <Box className={classes.wrapper}>
          <Tabs value={currentTab} onChange={onTabChange} orientation="vertical" className={classes.tabs}>
            <Tab key={`restrictions-tab-${UNITS}`}
                 icon={matches ? <PersonIcon/> : null}
                 label={matches ? null : "Units"}
                 value={UNITS}
                 to={UNITS}
                 className={classes.tab}
                 component={Link}/>
            <Tab key={`restrictions-tab-${UNLOCKS}`}
                 icon={matches ? <AccountTreeIcon/> : null}
                 label={matches ? null : "Unlocks"}
                 value={UNLOCKS}
                 to={UNLOCKS}
                 className={classes.tab}
                 component={Link}/>
          </Tabs>
          <Routes>
            <Route path={UNITS} element={<RestrictionUnits currentFactionId={currentFactionId}
                                                           currentDoctrineId={currentDoctrineId}
                                                           showDisabled={showDisabled}/>}/>
            <Route path={UNLOCKS} element={<RestrictionUnlocks currentFactionId={currentFactionId}
                                                               currentDoctrineId={currentDoctrineId}
                                                               showDisabled={showDisabled}/>}/>
            <Route index element={<RestrictionUnits currentFactionId={currentFactionId}
                                                    currentDoctrineId={currentDoctrineId}
                                                    showDisabled={showDisabled}/>}/>
          </Routes>
        </Box>
      </Box>
    </PageContainer>
  )
}
