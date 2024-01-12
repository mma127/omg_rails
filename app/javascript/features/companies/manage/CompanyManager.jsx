import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Alert, AlertTitle, Box, Container, Grid, Tab, Tabs, Typography } from "@mui/material";
import { Link, Route, Routes, useParams } from "react-router-dom";
import { makeStyles, useTheme } from "@mui/styles";
import useMediaQuery from '@mui/material/useMediaQuery';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import AccountTreeIcon from '@mui/icons-material/AccountTree';
import AddBoxIcon from '@mui/icons-material/AddBox';

import {
  fetchCompanyById,
  selectCompanyActiveBattleId,
  selectCompanyDoctrineId, selectCompanyName
} from "../companiesSlice";

import { SquadBuilder } from "./SquadBuilder";
import { CompanyUnlocks } from "./unlocks/CompanyUnlocks";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { CompanyBonuses } from "./bonuses/CompanyBonuses";
import { selectIsCompanyBonusesChanged } from "./bonuses/companyBonusesSlice";

const useStyles = makeStyles(theme => ({
  titleItem: {
    display: 'flex'
  },
  companyDocImage: {
    justifyContent: 'flex-end'
  },
  companyName: {
    justifyContent: 'flex-start',
    alignItems: 'center'
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
  },
  doctrineImage: {
    height: '90px',
    width: '180px'
  },
  lockedContainer: {
    display: "flex",
    alignItems: "center"
  },
  lockedAlert: {
    width: "100%",
    justifyContent: "center",
    alignItems: "center"
  },
  lockedAlertTitle: {
    margin: 0,
    fontWeight: "bold",
    fontSize: "20px"
  }
}))

const SQUADS = "squads"
const UNLOCKS = "unlocks"
const BONUSES = "bonuses"
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
  const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))
  const doctrineId = useSelector(state => selectCompanyDoctrineId(state, companyId))
  const companyName = useSelector(state => selectCompanyName(state, companyId))
  const doctrine = useSelector(state => selectDoctrineById(state, doctrineId))
  const isCompanyBonusesChanged = useSelector(selectIsCompanyBonusesChanged)

  useEffect(() => {
    console.log("dispatching company fetch from CompanyManager")
    dispatch(fetchCompanyById({ companyId }))
  }, [companyId, isCompanyBonusesChanged])


  const editEnabled = !activeBattleId
  let companyLockedContent = ""
  if (!editEnabled) {
    companyLockedContent = (
      <Box className={classes.lockedContainer}>
        <Alert severity="warning" variant="filled" className={classes.lockedAlert}>
          <AlertTitle className={classes.lockedAlertTitle}>In Battle - Company Locked</AlertTitle>
        </Alert>
      </Box>
    )
  }

  return (
    <Container maxWidth="xl" sx={{ paddingTop: '1rem', paddingBottom: '1rem' }}>
      {companyLockedContent}
      <Grid container spacing={2}>
        <Grid item md={6} xs={12} className={`${classes.titleItem} ${classes.companyDocImage}`}>
          <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
            <img src={doctrineImgMapping[doctrine.name]} alt={doctrine.displayName}
                 className={classes.doctrineImage}/>
          </Box>
        </Grid>
        <Grid item md={6} xs={12} className={`${classes.titleItem} ${classes.companyName}`}>
          <Typography variant="h5" gutterBottom>{companyName}</Typography>
        </Grid>
      </Grid>
      <Box className={classes.contentContainer}>
        <Tabs value={currentTab} onChange={onTabChange} orientation="vertical" className={classes.tabs}>
          <Tab key={`company-manager-tab-${SQUADS}`}
               icon={matches ? <PersonAddIcon/> : null}
               label={matches ? null : "Squads"}
               value="squads"
               to="squads"
               className={classes.tab}
               component={Link}/>
          <Tab key={`company-manager-tab-${UNLOCKS}`}
               icon={matches ? <AccountTreeIcon/> : null}
               label={matches ? null : "Unlocks"}
               value="unlocks"
               to="unlocks"
               className={classes.tab}
               component={Link}/>
          <Tab key={`company-manager-tab-${BONUSES}`}
               icon={matches ? <AddBoxIcon/> : null}
               label={matches ? null : "Bonuses"}
               value="bonuses"
               to="bonuses"
               className={classes.tab}
               component={Link}/>
        </Tabs>
        <Routes>
          <Route path="squads" element={<SquadBuilder/>}/>
          <Route path="unlocks" element={<CompanyUnlocks/>}/>
          <Route path="bonuses" element={<CompanyBonuses/>}/>
          <Route index element={<SquadBuilder/>}/>
        </Routes>
      </Box>
    </Container>
  )
}