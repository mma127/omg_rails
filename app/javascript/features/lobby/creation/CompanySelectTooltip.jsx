import { Alert, AlertTitle, Typography } from "@mui/material";
import React from "react";

export const CompanySelectTooltip = ({ company }) => {
  let warnContent
  const floatingResources = []
  if (company?.man > 100) {
    floatingResources.push(`${company.man} man`)
  }
  if (company?.mun > 100) {
    floatingResources.push(`${company.mun} mun`)
  }
  if (company?.fuel > 100) {
    floatingResources.push(`${company.fuel} fuel`)
  }

  if (floatingResources.length > 0) {
    warnContent = (
      <Alert severity="warning">
        <AlertTitle>Unused Resources</AlertTitle>
        {floatingResources.join(', ')}</Alert>
    )
  }

  return (
    <>
      <Typography variant="subtitle2">{company.name}</Typography>
      {warnContent}
    </>
  )
}