import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Alert, AlertTitle, Box, Container, Tab, Tabs, Typography } from "@mui/material";
import { Link, Route, Routes, useParams } from "react-router-dom";
import { makeStyles, useTheme } from "@mui/styles";
import useMediaQuery from '@mui/material/useMediaQuery';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import AccountTreeIcon from '@mui/icons-material/AccountTree';

import { fetchCompanyById, selectCompanyById } from "../companiesSlice";

import { SquadBuilder } from "./SquadBuilder";
import { CompanyUnlocks } from "./unlocks/CompanyUnlocks";

const useStyles = makeStyles(theme => ({
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

const SQUADS = "squads"
const UNLOCKS = "unlocks"
const DEFAULT_TAB = SQUADS

export const CompanyManager = () => {
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  const dispatch = useDispatch()
  const [currentTab, setCurrentTab] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    console.log(`Manager changed to new tab ${newTab}`)
    setCurrentTab(newTab)
  }

  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  const company = useSelector(state => selectCompanyById(state, companyId))

  useEffect(() => {
    console.log("dispatching company fetch from CompanyManager")
    dispatch(fetchCompanyById({ companyId }))
  }, [companyId])


  const editEnabled = !company.activeBattleId
  let companyLockedContent = ""
  if (!editEnabled) {
    companyLockedContent = <Alert severity={"warning"}>
      <AlertTitle>In Battle - Company Locked</AlertTitle>
    </Alert>
  }

  return (
    <Container maxWidth="xl" sx={{ paddingTop: '1rem', paddingBottom: '1rem' }}>
      {companyLockedContent}
      <Typography variant="h5" gutterBottom>{company.name}</Typography>
      <Box className={classes.contentContainer}>
        <Tabs value={currentTab} onChange={onTabChange} orientation="vertical" className={classes.tabs}>
          <Tab key={`company-manager-tab-${SQUADS}`}
               icon={matches ? <PersonAddIcon /> : null}
               label={matches ? null : "Squads"}
               value="squads"
               to="squads"
               className={classes.tab}
               component={Link} />
          <Tab key={`company-manager-tab-${UNLOCKS}`}
               icon={matches ? <AccountTreeIcon /> : null}
               label={matches ? null : "Unlocks"}
               value="unlocks"
               to="unlocks"
               className={classes.tab}
               component={Link} />
        </Tabs>
        <Routes>
          <Route path="squads" element={<SquadBuilder />} />
          <Route path="unlocks" element={<CompanyUnlocks />} />
          <Route index element={<SquadBuilder />} />
        </Routes>
      </Box>
    </Container>
  )
}