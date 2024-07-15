import React, { useEffect, useState } from 'react'
import { Alert, Box, Grid, Typography } from "@mui/material";
import { AlertSnackbar } from "../../AlertSnackbar";
import { useDispatch, useSelector } from "react-redux";
import { fetchCompanyById, selectCompanyById, resetNeedsRefresh } from "../../companiesSlice";
import { useParams, useLocation } from "react-router-dom";
import { makeStyles } from "@mui/styles";
import { fetchCompanySquads, resetSquadState } from "../units/squadsSlice";
import { resetAvailableUnitState } from "../available_units/availableUnitsSlice";
import {
  fetchDoctrineUnlocksByDoctrineId,
  selectDoctrineUnlockRowsByDoctrineId,
} from "../../../doctrines/doctrinesSlice";
import { DoctrineUnlock } from "./DoctrineUnlock";
import { selectCompanyUnlockIds, selectCompanyUnlocksByDoctrineUnlockId, clearNotifySnackbar } from "./companyUnlocksSlice";
import { selectActiveRuleset } from "../../../rulesets/rulesetsSlice";

const buildUnlock = (doctrineUnlock, companyUnlocksByDoctrineUnlockId, companyId) => {
  const companyUnlock = _.get(companyUnlocksByDoctrineUnlockId, doctrineUnlock.id, null)

  return (
    <Grid item xs={2} key={`grid-${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}>
      <DoctrineUnlock doctrineUnlock={doctrineUnlock} companyUnlock={companyUnlock} companyId={companyId} />
    </Grid>
  )
}

const buildUnlockRow = (i, unlockRow, companyUnlocksByDoctrineUnlockId, companyId) => {
  return (
    <Grid item container spacing={2} key={`row-${i}`}>
      {
        unlockRow.map(u => buildUnlock(u, companyUnlocksByDoctrineUnlockId, companyId))
      }
    </Grid>
  )
}

const useStyles = makeStyles(theme => ({
  wrapper: {
    padding: 1,
    flexGrow: 1
  },
  availableUnitsContainer: {
    minHeight: '280px'
  },
  detailTitle: {
    fontWeight: 'bold'
  }
}))
export const CompanyUnlocks = () => {
  const dispatch = useDispatch()
  const classes = useStyles()
  let params = useParams()

  const companyId = params.companyId
  const company = useSelector(state => selectCompanyById(state, companyId))
  const editEnabled = !company.activeBattleId
  const needsRefresh = useSelector(state => state.companies.needsRefresh)
  const companyUnlocksByDoctrineUnlockId = useSelector(selectCompanyUnlocksByDoctrineUnlockId)
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    dispatch(fetchDoctrineUnlocksByDoctrineId({ doctrineId: company.doctrineId, rulesetId: activeRuleset.id }))
  }, [companyId])

  useEffect(() => {
    dispatch(fetchCompanyById({ companyId: company.id }))
  }, [needsRefresh])

  const doctrineUnlockRows = useSelector(state => selectDoctrineUnlockRowsByDoctrineId(state, company.doctrineId))

  const isSaving = useSelector(state => state.companyUnlocks.isSaving)
  const error = useSelector(state => state.companyUnlocks.errorMessage)
  const errorMessage = isSaving ? "" : error
  const notifySnackbar = useSelector(state => state.companyUnlocks.notifySnackbar)
  const [openSnackbar, setOpenSnackbar] = useState(false)
  let location = useLocation()

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [notifySnackbar])

  useEffect(() => {
    dispatch(clearNotifySnackbar())
  }, [location]);

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity = "success"
  let snackbarContent = "Saved successfully"
  let errorAlert
  if (errorMessage?.length > 0) {
    errorAlert = <Alert severity="error">{errorMessage}</Alert>
  }
  if (notifySnackbar) {
    if (errorMessage?.length > 0) {
      snackbarSeverity = "error"
      snackbarContent = "Failed to purchase unlock"
    }
  }

  let content
  if (!_.isEmpty(doctrineUnlockRows)) {
    const keys = Object.keys(doctrineUnlockRows).sort()
    content = keys.map(i => buildUnlockRow(i, doctrineUnlockRows[i], companyUnlocksByDoctrineUnlockId, companyId))
  } else {
    content = (
      <Box></Box>
    )
  }
  return (
    <Box className={classes.wrapper}>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent} />
      <Grid item container>
        <Grid item md={4} p={2}>
          <Typography variant="h5">
            Available VPs: {company.vpsCurrent}
          </Typography>
        </Grid>
        <Grid item md={4}>
          {errorAlert}
        </Grid>
      </Grid>
      <Grid container spacing={2}>
        {content}
      </Grid>
    </Box>
  )
}