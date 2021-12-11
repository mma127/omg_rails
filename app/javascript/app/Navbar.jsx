import React from 'react'
import { Link } from "react-router-dom";
import { PlayerAuthStatus } from "../features/player/PlayerAuthStatus";
import { AppBar, Box, Button, createTheme, ThemeProvider, Toolbar, Typography } from "@mui/material";
import logo from "../../assets/images/omg-logo.png"

const customTheme = createTheme({
  palette: {
    secondary: {
      main: "#333333",
      contrastText: "#EEEEEE"
    }
  }
})

export const Navbar = () => {
  return (
    <ThemeProvider theme={customTheme}>
      <AppBar position="static" color={"secondary"}>
        <Toolbar>
          <Box>
            <img src={logo} alt="Operation Market Garden mod" />
          </Box>
          <Link to="/">
            <Button variant="contained">
              Lobby
            </Button>
          </Link>
          <Link to="/companies">
            <Button variant="contained">
              Companies
            </Button>
          </Link>
          <PlayerAuthStatus />
        </Toolbar>
      </AppBar>
    </ThemeProvider>

  )
}
