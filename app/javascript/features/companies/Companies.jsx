import React, { useState } from 'react'
import { Box, Container, Typography } from "@mui/material";
import { CreateCompaniesForm } from "./creation/CreateCompaniesForm";
import { useSelector } from "react-redux";
import { selectIsAuthed } from "../player/playerSlice";
import { selectAllCompanies } from "./companiesSlice";
import { DisplayCompanies } from "./display/DisplayCompanies";

export const Companies = () => {
  // Companies page container
  // TODO
  //    Create new companies
  //    Display current companies
  //    Enter company builder
  const isAuthed = useSelector(selectIsAuthed)
  const companies = useSelector(selectAllCompanies)

  let content
  // If not authenticated, display message telling player to log in first
  if (!isAuthed) {
    content = (
      <Box>
        <Typography>Log in to manage companies</Typography>
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
    <Box>
      <Box display="flex" justifyContent="center" alignItems="center" >
        {content}
      </Box>
    </Box>
  )
}