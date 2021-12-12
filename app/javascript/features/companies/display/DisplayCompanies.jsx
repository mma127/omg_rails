import React from 'react'
import { useSelector } from "react-redux";
import { selectAllCompanies } from "../companiesSlice";
import { Box, Typography } from "@mui/material";
import { CompanySummary } from "./CompanySummary";


export const DisplayCompanies = () => {
  const companies = useSelector(selectAllCompanies)
  const deletingError = useSelector(state => state.companies.deletingError)

  let content = companies.map(c => (
    <CompanySummary key={c.id} company={c} />
  ))

  return (
    <Box>
      <Typography>{deletingError}</Typography>
      {content}
    </Box>
  )
}