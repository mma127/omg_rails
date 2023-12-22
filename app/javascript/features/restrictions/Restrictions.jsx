import React, { useEffect, useState } from 'react'
import { useDispatch } from "react-redux";
import { Box, Container, Tab, Tabs } from "@mui/material";
import { makeStyles, useTheme } from "@mui/styles";
import PersonIcon from '@mui/icons-material/Person';
import { Link, Route, Routes } from "react-router-dom";
import { RestrictionUnits } from "./restriction_units/RestrictionUnits";
import useMediaQuery from "@mui/material/useMediaQuery";
import { fetchFactions } from "../factions/factionsSlice";
import { fetchDoctrines } from "../doctrines/doctrinesSlice";
import { FactionSelector } from "./FactionSelector";
import { DoctrineSelector } from "./DoctrineSelector";
import { clearRestrictionUnits } from "./restriction_units/restrictionUnitsSlice";


const useStyles = makeStyles(theme => ({
  topWrapper: {
    display: 'flex',
    flexDirection: "column"
  },
  selectors: {
    display: 'flex',
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
  },
}))

const UNITS = "units"
const DEFAULT_TAB = UNITS

export const Restrictions = () => {
  // Restrictions guides container
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));
  const dispatch = useDispatch()

  const [currentTab, setCurrentTab] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  const [currentFactionName, setCurrentFactionName] = useState(null)
  const [currentFactionId, setCurrentFactionId] = useState(null)
  const [currentDoctrineName, setCurrentDoctrineName] = useState(null)
  const [currentDoctrineId, setCurrentDoctrineId] = useState(null)

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

  const handleDoctrineSelect= ({doctrineName, doctrineId}) => {
    if (doctrineId !== currentDoctrineId) {
      setCurrentDoctrineName(doctrineName)
      setCurrentDoctrineId(doctrineId)
    }
  }

  return (
    <Container maxWidth="xl" disableGutters>
      <Box p={3} pt={5} className={classes.topWrapper}>
        <Box className={classes.selectors} pb={2}>
          <FactionSelector currentFactionName={currentFactionName} handleFactionSelect={handleFactionSelect}/>
          <DoctrineSelector currentFactionId={currentFactionId} currentDoctrineName={currentDoctrineName}
                            handleDoctrineSelect={handleDoctrineSelect}/>
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
          </Tabs>
          <Routes>
            <Route path={UNITS} element={<RestrictionUnits currentFactionId={currentFactionId} currentDoctrineId={currentDoctrineId}/>}/>
            <Route index element={<RestrictionUnits currentFactionId={currentFactionId} currentDoctrineId={currentDoctrineId}/>}/>
          </Routes>
        </Box>
      </Box>
    </Container>
  )
}
