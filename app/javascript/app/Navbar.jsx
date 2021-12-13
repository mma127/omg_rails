import React from 'react'
import { Link, useLocation, matchPath } from "react-router-dom";
import { PlayerAuthStatus } from "../features/player/PlayerAuthStatus";
import { AppBar, Box, Button, createTheme, Tab, Tabs, ThemeProvider, Toolbar, Typography } from "@mui/material";
import logo from "../../assets/images/omg-logo.png"

function useRouteMatch(patterns) {
  const { pathname } = useLocation();

  for (let i = 0; i < patterns.length; i += 1) {
    const pattern = patterns[i];
    const possibleMatch = matchPath(pattern, pathname);
    if (possibleMatch !== null) {
      return possibleMatch;
    }
  }

  return null;
}

export const Navbar = () => {
  const routeMatch = useRouteMatch(["/companies", "/"]);
  const currentTab = routeMatch?.pattern?.path;
  return (
    <AppBar position="static">
      <Toolbar>
        <Box>
          <img src={logo} alt="Operation Market Garden mod" />
        </Box>
        <Tabs value={currentTab} sx={{ marginTop: 'auto' }}>
          <Tab label="Lobby" value="/" component={Link} to="/" />
          <Tab label="Companies" value="/companies" component={Link} to="/companies" />
        </Tabs>
        <PlayerAuthStatus />
      </Toolbar>
    </AppBar>

  )
}
