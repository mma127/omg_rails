import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Alert, AlertTitle, Box, Container, Grid, Tab, Tabs, Typography } from "@mui/material";
import { Link, Route, Routes, useLocation, useParams } from "react-router-dom";
import { makeStyles, useTheme } from "@mui/styles";
import useMediaQuery from '@mui/material/useMediaQuery';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import AccountTreeIcon from '@mui/icons-material/AccountTree';
import AddBoxIcon from '@mui/icons-material/AddBox';

import {
  fetchCompanyById,
  selectCompanyActiveBattleId, selectCompanyById,
  selectCompanyDoctrineId, selectCompanyName
} from "../companiesSlice";

import { SquadBuilder } from "./SquadBuilder";
import { CompanyUnlocks } from "./unlocks/CompanyUnlocks";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { CompanyBonuses } from "./bonuses/CompanyBonuses";
import { selectIsCompanyBonusesChanged } from "./bonuses/companyBonusesSlice";
import { CompactSelector } from "./CompactSelector";
import { PageContainer } from "../../../components/PageContainer";
import { SnapshotCreator } from "./SnapshotCreator";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    alignContent: "center"
  },
  titleItem: {
    display: 'flex'
  },
  companyDocImage: {
    flex: 1,
    display: "flex",
    alignItems: "center",
    justifyContent: "flex-end"
  },
  companyName: {
    justifyContent: 'flex-start',
    alignItems: 'center'
  },
  compactWrapper: {
    flex: 1,
    display: "flex",
    flexDirection: "column",
    alignItems: "flex-end",
    justifyContent: "flex-end"
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
const getCurrentUrlTab = (pathname) => {
  const lastPathElement = pathname.split("/").pop()
  switch (lastPathElement) {
    case UNLOCKS:
      return UNLOCKS
    case BONUSES:
      return BONUSES
    default:
      return SQUADS
  }
}


export const CompanyManager = () => {
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  const dispatch = useDispatch()

  const location = useLocation()
  const { pathname } = location
  const tab = getCurrentUrlTab(pathname)

  const [currentTab, setCurrentTab] = useState(tab)
  const onTabChange = (event, newTab) => {
    console.log(`Manager changed to new tab ${newTab}`)
    setCurrentTab(newTab)
  }

  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  const company = useSelector(state => selectCompanyById(state, companyId))
  useEffect(() => {
    if (!company) {
      console.log("dispatching company fetch from CompanyManager for null company")
      dispatch(fetchCompanyById({ companyId, current: true }))
    }
  },[])

  const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))
  const doctrineId = useSelector(state => selectCompanyDoctrineId(state, companyId))
  const companyName = useSelector(state => selectCompanyName(state, companyId))
  const doctrine = useSelector(state => selectDoctrineById(state, doctrineId))
  const isCompanyBonusesChanged = useSelector(selectIsCompanyBonusesChanged)

  useEffect(() => {
    console.log("dispatching company fetch from CompanyManager")
    dispatch(fetchCompanyById({ companyId, current: true }))
  }, [companyId, isCompanyBonusesChanged])

  if (!company || !doctrine) {
    return null
  }

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
    <PageContainer maxWidth="xl" sx={{ paddingTop: '1rem' }}>
      {companyLockedContent}
      <Box className={classes.headerRow}>
        <Box className={`${classes.titleItem} ${classes.companyDocImage}`}>
          <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
            <img src={doctrineImgMapping[doctrine.name]} alt={doctrine.displayName}
                 className={classes.doctrineImage}/>
          </Box>
        </Box>
        <Box className={`${classes.titleItem} ${classes.companyName}`}>
          <Typography variant="h5" gutterBottom>{companyName}</Typography>
        </Box>
        <Box className={classes.compactWrapper}>
          <CompactSelector />
          <SnapshotCreator companyId={companyId} companyName={companyName} />
        </Box>
      </Box>
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
    </PageContainer>
  )
}