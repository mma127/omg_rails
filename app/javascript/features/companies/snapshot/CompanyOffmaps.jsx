import React from 'react'
import { useSelector } from "react-redux";
import { selectAllCompanyOffmaps } from "../manage/company_offmaps/companyOffmapsSlice";
import { Typography } from "@mui/material";
import { PurchasedOffmaps } from "../manage/company_offmaps/PurchasedOffmaps";
import { noop } from "lodash";

export const CompanyOffmaps = ({}) => {
  const existingCompanyOffmaps = useSelector(selectAllCompanyOffmaps)
  if (existingCompanyOffmaps.length === 0) {
    return null
  }

  return (
    <>
      <Typography variant="subtitle2" color="text.secondary" gutterBottom>Purchased Offmaps</Typography>
      <PurchasedOffmaps onDeleteClick={noop} enabled={true} />
    </>
  )
}
