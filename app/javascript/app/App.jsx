import React from 'react'
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Redirect,
} from 'react-router-dom'

import { Navbar } from "./Navbar";
import { Container, createTheme, CssBaseline, ThemeProvider } from "@mui/material";
import { Lobby } from "../features/lobby/Lobby";
import { Companies } from "../features/companies/Companies";

const theme = createTheme({
  palette: {
    type: "dark"
  }
});


export const App = () => (
  <>
    {/*<ThemeProvider theme={theme}>*/}
      <CssBaseline enableColorScheme>
        <Container maxWidth="xl" disableGutters sx={{ backgroundColor: "#888888"}}>
          <Router>
            <Navbar />
            <Routes>
              <Route path="/">
                <Route index element={<Lobby />} />
                <Route path="companies" element={<Companies />} />
              </Route>
            </Routes>
          </Router>
        </Container>
      </CssBaseline>
    {/*</ThemeProvider>*/}
  </>
)