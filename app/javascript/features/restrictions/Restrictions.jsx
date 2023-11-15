import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Container, Tab, Tabs } from "@mui/material";
import { makeStyles, useTheme } from "@mui/styles";
import PersonIcon from '@mui/icons-material/Person';
import { Link, Route, Routes } from "react-router-dom";
import { RestrictionUnits } from "./restriction_units/RestrictionUnits";
import useMediaQuery from "@mui/material/useMediaQuery";


const useStyles = makeStyles(theme => ({
  wrapper: {
    display: 'flex'
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
}))

const UNITS = "units"
const DEFAULT_TAB = UNITS

export const Restrictions = () => {
  // Restrictions guides container
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  const [ currentTab, setCurrentTab ] = useState(DEFAULT_TAB)
  const onTabChange = (event, newTab) => {
    setCurrentTab(newTab)
  }

  return (
    <Container maxWidth="xl" disableGutters>
      <Box p={ 3 } pt={ 5 } className={ classes.wrapper }>
        <Tabs value={ currentTab } onChange={ onTabChange } orientation="vertical" className={ classes.tabs }>
          <Tab key={ `restrictions-tab-${ UNITS }` }
               icon={ matches ? <PersonIcon/> : null }
               label={ matches ? null : "Units" }
               value={ UNITS }
               to={ UNITS }
               className={ classes.tab }
               component={ Link }/>
        </Tabs>
        <Routes>
          <Route path={ UNITS } element={ <RestrictionUnits/> }/>
          <Route index element={ <RestrictionUnits/> }/>
        </Routes>
      </Box>
    </Container>
  )
}
