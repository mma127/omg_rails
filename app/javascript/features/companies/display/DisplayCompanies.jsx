import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { createCompany, selectAllCompanies } from "../companiesSlice";
import { Divider, Grid } from "@mui/material";
import { CompanySummary } from "./CompanySummary";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { ALLIED_SIDE, AXIS_SIDE } from "../../../constants/doctrines";
import { CompanyForm } from "../creation/CompanyForm";
import { selectAllDoctrines } from "../../doctrines/doctrinesSlice";
import { EmptyCompanySpot } from "./EmptyCompanySpot";
import { SnapshotCompanies } from "./SnapshotCompanies";
import { AlertSnackbar } from "../AlertSnackbar";
import { clearNotifySnackbar } from "../manage/units/squadsSlice";
import { clearNotifySnackbarSnapshot } from "../snapshotCompaniesSlice";

/**
 * Expect there will be up to 4 companies, 2 allied + 2 axis
 * For existing player companies, separate into allied and axis lists
 * Render as
 *  [ ALLIED ] [ AXIS ]
 *  [ ALLIED ] [ AXIS ]
 * If the player only has one Allied or one Axis company, preferentially display that at the top row
 * Display the company creation form for any company spots that are empty where the previous company spot of that side
 * is not null
 */
const buildCompanyElement = (company, side, previousCompanyExists, createCallback) => {
  if (company) {
    return <CompanySummary key={company.id} company={company} />
  } else if (previousCompanyExists) {
    return <CompanyForm side={side} company={{ name: "", doctrine: "" }} companyCallback={createCallback} single />
  } else {
    return <EmptyCompanySpot />
  }
}

const buildRow = (alliedCompany, axisCompany, previousAlliedExists, previousAxisExists, createCallback) => (
  <Grid item xs={12} container>
    <Grid item md={6} sx={{display: "flex"}}>
      {buildCompanyElement(alliedCompany, ALLIED_SIDE, previousAlliedExists, createCallback)}
    </Grid>
    <Grid item md={6} sx={{display: "flex"}}>
      {buildCompanyElement(axisCompany, AXIS_SIDE, previousAxisExists, createCallback)}
    </Grid>
  </Grid>
)

export const DisplayCompanies = () => {
  const dispatch = useDispatch()
  const companies = useSelector(selectAllCompanies)
  const doctrines = useSelector(selectAllDoctrines)

  const snapshotDeletingError = useSelector(state => state.companies.deletingError)

  const [openSnackbar, setOpenSnackbar] = useState(false)

  const notifySnackbarSnapshot = useSelector(state => state.snapshotCompanies.notifySnackbar)
  useEffect(() => {
    setOpenSnackbar(notifySnackbarSnapshot)
  }, [notifySnackbarSnapshot])

  const handleCloseSnackbar = () => {
    setOpenSnackbar(false)
    dispatch(clearNotifySnackbar())
    dispatch(clearNotifySnackbarSnapshot())
  }

  const alliedCompanies = companies.filter(c => c.side === ALLIED_SIDE)
  const axisCompanies = companies.filter(c => c.side === AXIS_SIDE)

  const createNewCompany = (company) => {
    const doctrine = doctrines.find(d => d.name === company.doctrine)
    const companyPayload = {
      name: company.name,
      doctrine: company.doctrine,
      doctrineId: doctrine.id
    }
    dispatch(createCompany(companyPayload))
  }

  let companyError
  let content
  if (alliedCompanies.length > 3) {
    companyError = "Invalid number of Allied companies"
  } else if (axisCompanies.length > 3) {
    companyError = "Invalid number of Axis companies"
  } else {
    const alliedCompany1 = alliedCompanies.length >= 1 ? alliedCompanies[0] : null
    const alliedCompany2 = alliedCompanies.length >= 2 ? alliedCompanies[1] : null
    const alliedCompany3 = alliedCompanies.length === 3 ? alliedCompanies[2] : null
    const axisCompany1 = axisCompanies.length >= 1 ? axisCompanies[0] : null
    const axisCompany2 = axisCompanies.length >= 2 ? axisCompanies[1] : null
    const axisCompany3 = axisCompanies.length === 3 ? axisCompanies[2] : null
    content = (
      <>
        {
          buildRow(
            alliedCompany1,
            axisCompany1,
            true,
            true,
            createNewCompany
          )
        }
        {
          buildRow(
            alliedCompany2,
            axisCompany2,
            alliedCompany1 !== null,
            axisCompany1 !== null,
            createNewCompany
          )
        }
        {
          buildRow(
            alliedCompany3,
            axisCompany3,
            alliedCompany2 !== null,
            axisCompany2 !== null,
            createNewCompany
          )
        }
      </>
    )
  }

  let snackbarSeverity = "success"
  let snackbarContent
  if (notifySnackbarSnapshot) {
    if (snapshotDeletingError?.length > 0) {
      snackbarSeverity = "error"
      snackbarContent = "Error deleting snapshot"
    } else {
      snackbarContent = "Snapshot deleted"
    }
  }

  return (
    <>
      <AlertSnackbar isOpen={openSnackbar}
                     setIsOpen={setOpenSnackbar}
                     handleClose={handleCloseSnackbar}
                     severity={snackbarSeverity}
                     content={snackbarContent}/>
      <ErrorTypography>{snapshotDeletingError}</ErrorTypography>
      <ErrorTypography>{companyError}</ErrorTypography>
      <Grid container spacing={2}>
        {content}
      </Grid>
      <Divider variant="middle" flexItem sx={{paddingTop: "1rem"}}/>
      <SnapshotCompanies />
    </>
  )
}