import React, { useState } from 'react'
import { makeStyles, useTheme } from "@mui/styles";
import { Box, Container, Tab, Tabs } from "@mui/material";
import { Link, Route, Routes } from "react-router-dom";
import { WarStats } from "./WarStats";
import { Leaderboard } from "./Leaderboard";
import LeaderboardIcon from '@mui/icons-material/Leaderboard';
import TimelineIcon from '@mui/icons-material/Timeline';
import useMediaQuery from "@mui/material/useMediaQuery";

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
const DEFAULT_TAB = LEADERBOARD

export const Leaderboards = () => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  const [currentTab, setCurrentTab] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  return (
    <Container maxWidth="xl" disableGutters>
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
                 icon={matches ? <TimelineIcon /> : null}
                 label={matches ? null : "War Stats"}
                 value={WAR_STATS}
                 to={WAR_STATS}
                 className={classes.tab}
                 component={Link}/>
          </Tabs>
          <Routes>
            <Route path={LEADERBOARD} element={<Leaderboard />}/>
            <Route path={WAR_STATS} element={<WarStats />}/>
            <Route index element={<Leaderboard />}/>
          </Routes>
        </Box>
      </Box>
    </Container>
  )
}
