import React, { useEffect, useState } from 'react'
import { PageContainer } from "../../../components/PageContainer";
import { Box, Tab, Tabs, Typography } from "@mui/material";
import { makeStyles, useTheme } from "@mui/styles";
import { StaticUnitIcon } from "../../companies/manage/unlocks/StaticUnitIcon";
import { useDispatch, useSelector } from "react-redux";
import { fetchUnitById, selectUnitById } from "../../companies/manage/units/unitsSlice";
import { fetchStatsUnit, selectStatsUnitByConstName } from "./statsUnitsSlice";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";
import { Link, useParams } from "react-router-dom";
import PersonIcon from "@mui/icons-material/Person";
import { UnitStatsTables } from "./UnitStatsTables";
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
    width: '100%'
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
const DEFAULT_TAB = STATS

export const UnitStats = ({}) => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));
  let params = useParams()
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
    if (unit && !statsUnit) {
      dispatch(fetchStatsUnit({ rulesetId: ruleset.id, constName: unit.constName }))
    }
  }, [unit])

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
               label={matches ? null : "stats"}
               value={STATS}
               to={STATS}
               className={classes.tab}
               component={Link}/>
        </Tabs>
        <Box className={classes.contentContainer} hidden={currentTab !== STATS}>
          <UnitStatsTables constName={unit.constName}/>
        </Box>
      </Box>
    </PageContainer>
  )
}