import {makeStyles} from "@mui/styles";
import {useParams} from "react-router-dom";
import {useDispatch, useSelector} from "react-redux";
import {selectCompanyById} from "../../companiesSlice";
import React, {useEffect, useState} from "react";
import {fetchCompanyBonuses, selectCompanyBonuses} from "./companyBonusesSlice";
import {Alert, Box, Grid, Typography} from "@mui/material";
import {AlertSnackbar} from "../../AlertSnackbar";

const useStyles = makeStyles(theme => ({}))
export const CompanyBonuses = () => {
  const dispatch = useDispatch()
  const classes = useStyles()
  let params = useParams()

  useEffect(() => {
    dispatch(fetchCompanyBonuses())
  }, []);

  const companyBonuses = useSelector(selectCompanyBonuses);

  const isSaving = useSelector(state => state.companyBonuses.isSaving)
  const error = useSelector(state => state.companyBonuses.errorMessage)
  const errorMessage = isSaving ? "" : error
  const notifySnackbar = useSelector(state => state.companyBonuses.notifySnackbar)
  const [openSnackbar, setOpenSnackbar] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [notifySnackbar])

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity = null
  let snackbarContent = null
  let errorAlert
  if (errorMessage?.length > 0) {
    errorAlert = <Alert severity="error">{errorMessage}</Alert>
  }
  if (notifySnackbar) {
    if (errorMessage?.length > 0) {
      snackbarSeverity = "error"
      snackbarContent = "Failed to purchase resource bonus"
    }
  }

  if (_.isEmpty(companyBonuses.manResourceBonus)) {
    return <Box></Box>
  }

  return (
    <Box sx={{ padding: 1 }}>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent} />
      <Grid container>
        <Grid item md={4} p={2}>
          <Typography variant="h5">{companyBonuses.manResourceBonus.resource}</Typography>
        </Grid>
      </Grid>
    </Box>
  )
}
