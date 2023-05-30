import React from 'react'
import { Alert, Box, Button } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";

const useStyles = makeStyles(theme => ({
  saveWrapper: {
    display: 'flex',
    marginTop: "8px"
  },
  saveButton: {
    height: 'fit-content'
  }
}))
export const SaveCompanyButton = ({saveSquads}) => {
  const classes = useStyles()

  const squadsStatus = useSelector(state => state.squads.squadsStatus)
  const squadsIsChanged = useSelector(state => state.squads.isChanged)
  const companyOffmapsIsChanged = useSelector(state => state.companyOffmaps.isChanged)
  const squadUpgradesIsChanged = useSelector(state => state.squadUpgrades.isChanged)
  const squadsError = useSelector(state => state.squads.squadsError)
  const isSaving = squadsStatus === 'pending'
  const isChanged = squadsIsChanged || companyOffmapsIsChanged || squadUpgradesIsChanged
  const canSave = !isSaving && isChanged
  const errorMessage = isSaving ? "" : squadsError

  let errorAlert
  if (errorMessage?.length > 0) {
    errorAlert = <Alert severity="error">{errorMessage}</Alert>
  }

  return (
    <Box className={classes.saveWrapper}>
      <Button variant="contained" color="secondary" size="small" onClick={saveSquads}
              disabled={!canSave} className={classes.saveButton}>Save</Button>
      {errorAlert}
    </Box>
  )
}
