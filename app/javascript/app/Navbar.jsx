import React from 'react'
import { Link, useLocation } from "react-router-dom";
import { PlayerAuthStatus } from "../features/player/PlayerAuthStatus";
import { AppBar, Box, Tab, Tabs, Toolbar } from "@mui/material";
import logo from "../../assets/images/omg-logo.png"
import { useSelector } from "react-redux";
import { selectPlayer } from "../features/player/playerSlice";

export const Navbar = () => {
  // https://stackoverflow.com/questions/70121657/react-material-ui-handle-nav-tabs-when-no-children-match-the-provided-value/70149889
  const location = useLocation();
  const [[, currentRoot]] = location.pathname.matchAll(/^(\/[^/]*)/g);

  const player = useSelector(selectPlayer)
  const isAdmin = player ? player.role === "admin" : false

  return (
    <AppBar position="static">
      <Toolbar>
        <Box>
          <img src={logo} alt="Operation Market Garden mod"/>
        </Box>
        <Tabs value={currentRoot} sx={{ marginTop: 'auto' }}>
          <Tab label="Lobby" value="/" component={Link} to="/"/>
          <Tab label="Companies" value="/companies" component={Link} to="/companies"/>
          <Tab label="Restrictions" value="/restrictions" component={Link} to="/restrictions"/>
          <Tab label="Leaderboards" value="/leaderboards" component={Link} to="/leaderboards"/>
          <Tab label="Download" href="https://data.omgmod.net/OMG_Updater_v2.1.0.0.zip" download/>
          {isAdmin ? <Tab label="Admin" to="/admin" target="_blank" rel="noopener noreferrer" component={Link}/> : null}
        </Tabs>
        <PlayerAuthStatus/>
      </Toolbar>
    </AppBar>

  )
}
