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
import { CompanyManager } from "../features/companies/manage/CompanyManager";
import { ActionCableConsumer, ActionCableProvider } from "@thrash-industries/react-actioncable-provider";

const theme = createTheme({
  palette: {
    mode: "dark",
    secondary: {
      main: "#FFAC33",
      light: "#EFAD4DFF",
      dark: "#EE930FEC",
      contrastText: "#222222C8"
    }
  },
  components: {
    MuiTabs: {
      styleOverrides: {
        indicator: {
          backgroundColor: "#FFAC33"
        }

      }
    },
    MuiTab: {
      styleOverrides: {
        root: {
          opacity: 0.7,
          "&.Mui-selected": {
            "opacity": 1,
            "color": "#FFAC33"
          }
        }
      }
    }
  }
});

// const cableUrl = "ws://localhost:5000/cable"
const cableUrl = "/cable"

export const App = () => (
  <>
    <ActionCableProvider url={cableUrl}>
      <ThemeProvider theme={theme}>
        <CssBaseline enableColorScheme>
          <Router>
            <Navbar />
            <Routes>
              <Route path="/">
                <Route index element={<Lobby />} />
                <Route path="companies" element={<Companies />} />
                <Route path="companies/:companyId" element={<CompanyManager />} />
              </Route>
            </Routes>
          </Router>
        </CssBaseline>
      </ThemeProvider>
    </ActionCableProvider>
  </>
)
