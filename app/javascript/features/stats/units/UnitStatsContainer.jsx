import React, { useEffect, useState } from 'react'
import { PageContainer } from "../../../components/PageContainer";
import { Box, Tab, Tabs, Typography } from "@mui/material";
import { makeStyles, useTheme } from "@mui/styles";
import { StaticUnitIcon } from "../../companies/manage/unlocks/StaticUnitIcon";
import { useDispatch, useSelector } from "react-redux";
import { fetchUnitById, selectUnitById } from "../../companies/manage/units/unitsSlice";
import { fetchStatsUnit, selectStatsUnitByConstName } from "./statsUnitsSlice";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";
import { Link, Route, Routes, useParams } from "react-router-dom";
import PersonIcon from "@mui/icons-material/Person";
import useMediaQuery from "@mui/material/useMediaQuery";
import { UnitStats } from "./UnitStats";
import { UnitWeaponsList } from "../weapons/UnitWeaponsList";

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
    display: 'flex'
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
const WEAPONS = "weapons"
const DEFAULT_TAB = STATS

export const UnitStatsContainer = ({}) => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));
  const params = useParams()
  const unitId = params.unitId

  const unit = useSelector(state => selectUnitById(state, unitId))
  const statsUnit = useSelector(state => selectStatsUnitByConstName(state, unit?.constName))
  const ruleset = useSelector(selectActiveRuleset)

  const [currentTab, setCurrentTab] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  const dispatch = useDispatch()
  useEffect(() => {
    // Dispatch a fetch if the unit id is valid and the selector failed to find a matching unit
    if (unitId && !unit)
      dispatch(fetchUnitById({ unitId }))
  }, [unitId])

  useEffect(() => {
    if (unit && ruleset && !statsUnit) {
      dispatch(fetchStatsUnit({ rulesetId: ruleset.id, name: unit.name, constName: unit.constName }))
    }
  }, [unit, ruleset])

  if (!unit || !statsUnit) {
    return null
  }

  return (
    <PageContainer maxWidth="lg" sx={{ paddingTop: '1rem' }}>
      <Box className={classes.headerRow} pb={4}>
        <Box sx={{ display: "flex" }}>
          <Box className={`${classes.titleItem} ${classes.companyDocImage}`}>
            <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1} pr={1}>
              <StaticUnitIcon name={unit.name} height={64}/>
            </Box>
          </Box>
          <Box className={`${classes.titleItem} ${classes.companyName}`}>
            <Typography variant="h3" gutterBottom>{unit.displayName}</Typography>
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
          <Tab key={`stats-tab-${WEAPONS}`}
               icon={matches ? <PersonIcon/> : null}
               label={matches ? null : WEAPONS}
               value={WEAPONS}
               to={WEAPONS}
               className={classes.tab}
               component={Link}/>
        </Tabs>
        <Routes>
          <Route path={STATS} element={<UnitStats constName={unit.constName}/>}/>
          <Route path={WEAPONS} element={<UnitWeaponsList constName={unit.constName}/>}/>
          <Route index element={<UnitStats constName={unit.constName}/>}/>
        </Routes>
      </Box>
    </PageContainer>
  )
}
