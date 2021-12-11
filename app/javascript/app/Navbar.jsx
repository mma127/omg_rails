import React from 'react'
import { Link, useLocation, matchPath } from "react-router-dom";
import { PlayerAuthStatus } from "../features/player/PlayerAuthStatus";
import { AppBar, Box, Button, createTheme, Tab, Tabs, ThemeProvider, Toolbar, Typography } from "@mui/material";
import logo from "../../assets/images/omg-logo.png"

const customTheme = createTheme({
  palette: {
    secondary: {
      main: "#333333",
      contrastText: "#EEEEEE"
    }
  }
})
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
    <ThemeProvider theme={customTheme}>
      <AppBar position="static" color={"secondary"}>
        <Toolbar>
          <Box>
            <img src={logo} alt="Operation Market Garden mod" />
          </Box>
          <Tabs value={currentTab}>
            <Tab label="Lobby" value="/" component={Link} to="/" />
            <Tab label="Companies" value="/companies" component={Link} to="/companies" />
          </Tabs>
          <PlayerAuthStatus />
        </Toolbar>
      </AppBar>
    </ThemeProvider>

  )
}
