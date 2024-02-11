import React, { useState } from 'react'
import { useSelector } from "react-redux";
import { selectAllSnapshotCompanies } from "../snapshotCompaniesSlice";
import { Grid, Typography } from "@mui/material";
import { SnapshotCompanySummary } from "./SnapshotCompanySummary";
import { AlertSnackbar } from "../AlertSnackbar";

export const SnapshotCompanies = () => {
  const snapshots = useSelector(selectAllSnapshotCompanies)

  const deletingError = useSelector(state => state.snapshotCompanies.deletingError)

  const [openSnackbar, setOpenSnackbar] = useState(false)
  const handleCloseSnackbar = () => setOpenSnackbar(false)

  let snackbarSeverity
  let snackbarContent
  if (deletingError?.length > 0) {
    snackbarSeverity = "error"
    snackbarContent = "Failed to purchase unlock"
  }

  if (snapshots.length === 0) {
    return (
      <Typography variant="h6" color="text.secondary" pt={2}>No Snapshot Companies</Typography>
    )
  }

  return (
    <>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent} />
      <Typography variant="h5" color="text.secondary" gutterBottom pt={2}>Snapshot Companies</Typography>
      <Grid container spacing={1} pt={1} pl={5} pr={5}>
        {snapshots.map(s => (
          <Grid item sm={3} key={s.id}>
            <SnapshotCompanySummary company={s} />
          </Grid>
        ))}
      </Grid>
    </>
  )
}
