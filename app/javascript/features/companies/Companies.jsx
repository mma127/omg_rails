import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Typography } from "@mui/material";

import { CreateCompaniesForm } from "./creation/CreateCompaniesForm";
import { selectIsAuthed } from "../player/playerSlice";
import { selectAllCompanies } from "./companiesSlice";
import { DisplayCompanies } from "./display/DisplayCompanies";
import { Fingerprint } from "@mui/icons-material";
import { PageContainer } from "../../components/PageContainer";
import { fetchPlayerSnapshotCompanies, resetSnapshotState } from "./snapshotCompaniesSlice";

export const Companies = () => {
  // Companies page container
  //    Create new companies
  //    Display current companies
  //    Enter company builder
  const dispatch = useDispatch()
  useEffect( () => {
    dispatch(fetchPlayerSnapshotCompanies())

    return () => {
      dispatch(resetSnapshotState())
    }
  },[])

  const isAuthed = useSelector(selectIsAuthed)
  const companies = useSelector(selectAllCompanies)

  let content
  // If not authenticated, display message telling player to log in first
  if (!isAuthed) {
    content = (
      <Box pt={5} sx={{ "display": "flex" }}>
        <Fingerprint fontSize={"large"} color="warning" />
        <Typography variant={"h5"} pl={"5px"} sx={{ alignSelf: 'end' }}>Sign in to manage companies</Typography>
      </Box>
    )
  } else if (companies.length === 0) {
    // No companies for the player, show creation form
    content = <CreateCompaniesForm />
  } else {
    // Show companies
    content = <DisplayCompanies />
  }

  return (
    <PageContainer maxWidth="xl" disableGutters>
      <Box p={3} pt={5} display="flex" flexDirection="column" justifyContent="center" alignItems="center">
        {content}
      </Box>
    </PageContainer>
  )
}