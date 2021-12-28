import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { createCompany, fetchCompanies, selectAllCompanies } from "../companiesSlice";
import { Grid } from "@mui/material";
import { CompanySummary } from "./CompanySummary";
import { ErrorTypography } from "../../../components/ErrorTypography";
import { ALLIED_SIDE, AXIS_SIDE } from "../../../constants/doctrines";
import { CompanyForm } from "../creation/CompanyForm";
import { selectAllDoctrines } from "../../doctrines/doctrinesSlice";

/**
 * Expect there will be up to 4 companies, 2 allied + 2 axis
 * For existing player companies, separate into allied and axis lists
 * Render as
 *  [ ALLIED ] [ AXIS ]
 *  [ ALLIED ] [ AXIS ]
 * If the player only has one Allied or one Axis company, preferentially display that at the top row
 * Display the company creation form for any company spots that are empty
 */
const buildCompanyElement = (company, side, createCallback) => {
  if (company) {
    return <CompanySummary key={company.id} company={company} />
  } else {
    return <CompanyForm side={side} company={{ name: "", doctrine: "" }} companyCallback={createCallback} single />
  }
}

const buildRow = (alliedCompany, axisCompany, createCallback) => (
  <Grid item xs={12} container>
    <Grid item md={6}>
      {buildCompanyElement(alliedCompany, ALLIED_SIDE, createCallback)}
    </Grid>
    <Grid item md={6}>
      {buildCompanyElement(axisCompany, AXIS_SIDE, createCallback)}
    </Grid>
  </Grid>
)

export const DisplayCompanies = () => {
  const dispatch = useDispatch()
  const companies = useSelector(selectAllCompanies)
  const doctrines = useSelector(selectAllDoctrines)

  const deletingError = useSelector(state => state.companies.deletingError)

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
  if (alliedCompanies.length > 2) {
    companyError = "Invalid number of Allied companies"
  } else if (axisCompanies.length > 2) {
    companyError = "Invalid number of Axis companies"
  } else {
    content = (
      <>
        {
          buildRow(
            alliedCompanies.length >= 1 ? alliedCompanies[0] : null,
            axisCompanies.length >= 1 ? axisCompanies[0] : null,
            createNewCompany
          )
        }
        {
          buildRow(
            alliedCompanies.length === 2 ? alliedCompanies[1] : null,
            axisCompanies.length === 2 ? axisCompanies[1] : null,
            createNewCompany
          )
        }
      </>
    )
  }

  return (
    <>
      <ErrorTypography>{deletingError}</ErrorTypography>
      <ErrorTypography>{companyError}</ErrorTypography>
      <Grid container spacing={2}>
        {content}
      </Grid>
    </>
  )
}