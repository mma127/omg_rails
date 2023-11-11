import { useDispatch, useSelector } from "react-redux";
import React, { useEffect, useState } from "react";
import { fetchCompanyBonuses } from "./companyBonusesSlice";
import { Alert, Box } from "@mui/material";
import { AlertSnackbar } from "../../AlertSnackbar";
import { ResourceBonuses } from "./ResourceBonuses";

export const CompanyBonuses = () => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(fetchCompanyBonuses())
  }, []);

  const isSaving = useSelector(state => state.companyBonuses.isSaving)
  const error = useSelector(state => state.companyBonuses.errorMessage)
  const errorMessage = isSaving ? "" : error
  const notifySnackbar = useSelector(state => state.companyBonuses.notifySnackbar)
  const [ openSnackbar, setOpenSnackbar ] = useState(false)

  useEffect(() => {
    setOpenSnackbar(notifySnackbar)
  }, [ notifySnackbar ])

  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity = null
  let snackbarContent = null
  let errorAlert
  if (errorMessage?.length > 0) {
    errorAlert = <Alert severity="error">{ errorMessage }</Alert>
  }
  if (notifySnackbar) {
    if (errorMessage?.length > 0) {
      snackbarSeverity = "error"
      snackbarContent = "Failed to purchase resource bonus"
    }
  }

  return (
    <Box sx={ { padding: 1 } }>
      <AlertSnackbar isOpen={ openSnackbar }
                     setIsOpen={ setOpenSnackbar }
                     handleClose={ handleCloseSnackbar }
                     severity={ snackbarSeverity }
                     content={ snackbarContent }/>
      { errorAlert }
      <ResourceBonuses/>
    </Box>
  )
}
