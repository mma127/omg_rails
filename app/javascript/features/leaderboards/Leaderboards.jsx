import React, { useState } from 'react'
import { makeStyles, useTheme } from "@mui/styles";
import { Box, Tab, Tabs } from "@mui/material";
import { Link, Route, Routes, useLocation } from "react-router-dom";
import { WarStats } from "./WarStats";
import { CompanyLeaderboard } from "./company_leaderboard/CompanyLeaderboard";
import LeaderboardIcon from '@mui/icons-material/Leaderboard';
import TimelineIcon from '@mui/icons-material/Timeline';
import useMediaQuery from "@mui/material/useMediaQuery";
import { PageContainer } from "../../components/PageContainer";
import HistoryIcon from '@mui/icons-material/History';
import { WarLog } from "./WarLog";

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

const LEADERBOARD = "leaderboard"
const WAR_STATS = "war_stats"
const WAR_LOG = "war_log"

const getCurrentUrlTab = (pathname) => {
  const lastPathElement = pathname.split("/").pop()
  switch (lastPathElement) {
    case WAR_STATS:
      return WAR_STATS
    case WAR_LOG:
      return WAR_LOG
    default:
      return LEADERBOARD
  }
}

export const Leaderboards = () => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  const location = useLocation()
  const { pathname } = location

  const tab = getCurrentUrlTab(pathname)

  const [currentTab, setCurrentTab] = useState(tab)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  return (
    <PageContainer maxWidth="xl" disableGutters>
      <Box p={3} pt={5} className={classes.topWrapper}>
        <Box className={classes.wrapper}>
          <Tabs value={currentTab} onChange={onTabChange} orientation="vertical" className={classes.tabs}>
            <Tab key={`leaderboards-tab-${LEADERBOARD}`}
                 icon={matches ? <LeaderboardIcon/> : null}
                 label={matches ? null : "Leaderboard"}
                 value={LEADERBOARD}
                 to={LEADERBOARD}
                 className={classes.tab}
                 component={Link}/>
            <Tab key={`leaderboards-tab-${WAR_STATS}`}
                 icon={matches ? <TimelineIcon/> : null}
                 label={matches ? null : "War Stats"}
                 value={WAR_STATS}
                 to={WAR_STATS}
                 className={classes.tab}
                 component={Link}/>
            <Tab key={`leaderboards-tab-${WAR_LOG}`}
                 icon={matches ? <HistoryIcon/> : null}
                 label={matches ? null : "War Log"}
                 value={WAR_LOG}
                 to={WAR_LOG}
                 className={classes.tab}
                 component={Link}/>
          </Tabs>
          <Routes>
            <Route path={LEADERBOARD} element={<CompanyLeaderboard/>}/>
            <Route path={WAR_STATS} element={<WarStats/>}/>
            <Route path={WAR_LOG} element={<WarLog/>}/>
            <Route index element={<CompanyLeaderboard/>}/>
          </Routes>
        </Box>
      </Box>
    </PageContainer>
  )
}
