import React, { useEffect, useState } from 'react'
import { Link, Route, Routes, useParams } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";
import { fetchStatsWeapon, selectStatsWeaponByReference } from "./statsWeaponsSlice";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";
import { Box, Tab, Tabs, Typography } from "@mui/material";
import { PageContainer } from "../../../components/PageContainer";
import { makeStyles, useTheme } from "@mui/styles";
import PersonIcon from "@mui/icons-material/Person";
import { WeaponStats } from "./WeaponStats";
import useMediaQuery from "@mui/material/useMediaQuery";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    alignItems: "center",
    alignContent: "center",
    paddingLeft: "6rem",
    [theme.breakpoints.down('md')]: {
      paddingLeft: '0'
    }
  },
  titleItem: {
    display: 'flex',
    flexDirection: "column"
  },
  subtitle: {
    fontStyle: "italic"
  },
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
    display: 'flex',
    flexDirection: "column",
    rowGap: "1rem",
    width: '100%',
    marginLeft: '0.5rem',
    marginRight: '0.5rem'
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


const STATS = "stats"
const COVER = "cover"
const TARGETS = "targets"
const CRITICALS = "criticals"
const DEFAULT_TAB = STATS

export const WeaponStatsContainer = ({}) => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));
  const params = useParams()
  const weaponRef = params.weaponRef

  const reference = decodeURIComponent(weaponRef)

  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))
  const ruleset = useSelector(selectActiveRuleset)

  const [currentTab, setCurrentTab] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  const dispatch = useDispatch()
  useEffect(() => {
    // Dispatch a fetch if the unit id is valid and the selector failed to find a matching unit
    if (ruleset && !weapon)
      dispatch(fetchStatsWeapon({ rulesetId: ruleset.id, reference: reference }))
  }, [ruleset])

  if (!weapon) {
    return null
  }

  return (
    <PageContainer maxWidth="lg" sx={{ paddingTop: '1rem' }}>
      <Box className={classes.headerRow} pb={4}>
        <Box sx={{ display: "flex" }}>
          {/*TODO WEAPON ICON*/}
          {/*<Box className={`${classes.titleItem} ${classes.companyDocImage}`}>*/}
          {/*  <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1} pr={1}>*/}
          {/*    <StaticUnitIcon name={unit.name} height={64}/>*/}
          {/*  </Box>*/}
          {/*</Box>*/}
          <Box className={classes.titleItem}>
            <Typography variant="h3">{weapon.displayName}</Typography>
            <Typography variant="subtitle1" className={classes.subtitle} gutterBottom>{reference}</Typography>
          </Box>
        </Box>
      </Box>

      <Box className={classes.wrapper}>
        <Tabs value={currentTab} onChange={onTabChange} orientation="vertical" className={classes.tabs}>
          <Tab key={`stats-tab-${STATS}`}
               icon={matches ? <PersonIcon/> : null}
               label={matches ? null : STATS}
               value={STATS}
               to={STATS}
               className={classes.tab}
               component={Link}/>
          <Tab key={`stats-tab-${COVER}`}
               icon={matches ? <PersonIcon/> : null}
               label={matches ? null : COVER}
               value={COVER}
               to={COVER}
               className={classes.tab}
               component={Link}/>
          <Tab key={`stats-tab-${TARGETS}`}
               icon={matches ? <PersonIcon/> : null}
               label={matches ? null : TARGETS}
               value={TARGETS}
               to={TARGETS}
               className={classes.tab}
               component={Link}/>
          <Tab key={`stats-tab-${CRITICALS}`}
               icon={matches ? <PersonIcon/> : null}
               label={matches ? null : CRITICALS}
               value={CRITICALS}
               to={CRITICALS}
               className={classes.tab}
               component={Link}/>
        </Tabs>
        <Routes>
          <Route path={STATS} element={<WeaponStats reference={reference}/>}/>
          {/*TODO*/}
          {/*<Route path={COVER} element={<WeaponStats constName={unit.constName}/>}/> */}
          {/*<Route path={TARGETS} element={<WeaponStats constName={unit.constName}/>}/>*/}
          {/*<Route path={CRITICALS} element={<WeaponStats constName={unit.constName}/>}/>*/}
          <Route index element={<WeaponStats reference={reference}/>}/>
        </Routes>
      </Box>
    </PageContainer>
  )
}
