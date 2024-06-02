import React from 'react'
import { BrowserRouter as Router, Route, Routes, } from 'react-router-dom'

import { Navbar } from "./Navbar";
import { createTheme, CssBaseline, ThemeProvider } from "@mui/material";
import { Lobby } from "../features/lobby/Lobby";
import { Companies } from "../features/companies/Companies";
import { CompanyManager } from "../features/companies/manage/CompanyManager";
import { ActionCableProvider } from "@thrash-industries/react-actioncable-provider";
import { Restrictions } from "../features/restrictions/Restrictions";
import { Leaderboards } from "../features/leaderboards/Leaderboards";
import { SnapshotCompanyView } from "../features/companies/snapshot/SnapshotCompanyView";
import { UnitStatsContainer } from "../features/stats/units/UnitStatsContainer";
import { WeaponStats } from "../features/stats/weapons/WeaponStats";
import { WeaponStatsContainer } from "../features/stats/weapons/WeaponStatsContainer";

const theme = createTheme({
  palette: {
    mode: "dark",
    secondary: {
      main: "#FFAC33",
      light: "#EFAD4DFF",
      dark: "#EE930FEC",
      contrastText: "#222222C8"
    },
    text: {
      primary: "#CCC",
      label: "#777"
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
                <Route path="companies/:companyId/*" element={<CompanyManager />} />
                <Route path="companies/snapshots/:uuid/*" element={<SnapshotCompanyView />} />
                <Route path="restrictions/*" element={<Restrictions />} />
                <Route path="restrictions/unit/:unitId/*" element={<UnitStatsContainer />} />
                <Route path="restrictions/weapon/:weaponId/:weaponRef/*" element={<WeaponStatsContainer />} />
                <Route path="leaderboards/*" element={<Leaderboards />} />
              </Route>
            </Routes>
          </Router>
        </CssBaseline>
      </ThemeProvider>
    </ActionCableProvider>
  </>
)
