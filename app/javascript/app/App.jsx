import React from 'react'
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Redirect,
} from 'react-router-dom'

import { Navbar } from "./Navbar";
import { Container, CssBaseline } from "@mui/material";
import { Lobby } from "../features/lobby/Lobby";
import { Companies } from "../features/companies/Companies";

export const App = () => (
  <>
    <CssBaseline enableColorScheme>
      <Container maxWidth="xl" disableGutters sx={{ backgroundColor: "#555555", height: '100vh' }}>
        <Router>
          <Navbar />
          <Routes>
            <Route path="/" element={<Lobby />} />
            <Route path="companies" element={<Companies />} />
          </Routes>
        </Router>
      </Container>
    </CssBaseline>
  </>
)