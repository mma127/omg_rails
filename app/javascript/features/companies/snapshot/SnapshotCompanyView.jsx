import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { loadSnapshotCompany, selectCurrentSnapshotCompany } from "../snapshotCompaniesSlice";
import { PageContainer } from "../../../components/PageContainer";
import { makeStyles, useTheme } from "@mui/styles";
import { useParams } from "react-router-dom";
import { Box, Grid, Typography } from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import useMediaQuery from "@mui/material/useMediaQuery";
import { AvailableCounts } from "../manage/available_units/AvailableCounts";
import { resetSquadState } from "../manage/units/squadsSlice";
import { resetAvailableUnitState } from "../manage/available_units/availableUnitsSlice";
import { CompanyUnlocksSnapshot } from "./CompanyUnlocksSnapshot";
import { CompanyResources } from "./CompanyResources";
import { CompanyOffmaps } from "./CompanyOffmaps";
import { CompanySquadCategory } from "./CompanySquadCategory";
import { ANTI_ARMOUR, ARMOUR, ASSAULT, CORE, INFANTRY, SUPPORT } from "../../../constants/company";

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
    display: 'flex',
    flexDirection: "column"
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

export const SnapshotCompanyView = () => {
  const classes = useStyles()
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.down('md'));

  let params = useParams()
  const uuid = params.uuid

  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(loadSnapshotCompany({ uuid }))

    return () => {
      dispatch(resetSquadState())
      dispatch(resetAvailableUnitState())
    }
  }, [])

  const snapshot = useSelector(selectCurrentSnapshotCompany)
  const companyId = snapshot?.id

  if (snapshot == null) {
    return null
  }

  const resourceOffmapsRow = (
    <Grid container p={2}>
      <Grid item sm={4}>
        <CompanyResources/>
      </Grid>
      <Grid item sm={1}></Grid>
      <Grid item sm={7}>
        <CompanyOffmaps/>
      </Grid>
    </Grid>
  )


  return (
    <PageContainer maxWidth="xl" sx={{ paddingTop: '1rem' }}>
      <Box className={classes.headerRow}>
        <Box sx={{ display: "flex" }}>
          <Box className={`${classes.titleItem} ${classes.companyDocImage}`}>
            <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
              <img src={doctrineImgMapping[snapshot.doctrineName]} alt={snapshot.doctrineDisplayName}
                   className={classes.doctrineImage}/>
            </Box>
          </Box>
          <Box className={`${classes.titleItem} ${classes.companyName}`}>
            <Typography variant="h5" gutterBottom>{snapshot.name}</Typography>
          </Box>
        </Box>
      </Box>
      <Box className={classes.contentContainer}>
        <AvailableCounts/>
        <CompanyUnlocksSnapshot/>
        {resourceOffmapsRow}

        <CompanySquadCategory tab={CORE}/>
        <CompanySquadCategory tab={ASSAULT}/>
        <CompanySquadCategory tab={INFANTRY}/>
        <CompanySquadCategory tab={ARMOUR}/>
        <CompanySquadCategory tab={ANTI_ARMOUR}/>
        <CompanySquadCategory tab={SUPPORT}/>
      </Box>
    </PageContainer>
  )
}
