import React, { useEffect, useState } from 'react'
import { CompanyForm } from "./CompanyForm";
import { fetchDoctrines, selectAllDoctrines, selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { useDispatch, useSelector } from "react-redux";
import { Box, Button, Grid, Typography } from "@mui/material";
import * as constants from '../../../constants/doctrines'

import { makeStyles } from "@mui/styles";
import { createCompany } from "../companiesSlice";
import { ErrorTypography } from "../../../components/ErrorTypography";


const reviewStep = "review"
const steps = [constants.ALLIED_SIDE, constants.AXIS_SIDE, reviewStep]

const useStyles = makeStyles(theme => ({
  optionImage: {
    height: '120px'
  }
}))

export const CreateCompaniesForm = () => {
  // Create companies
  const dispatch = useDispatch()
  const classes = useStyles()

  // Order is Allied -> Axis -> Review
  const [currentStep, setCurrentStep] = useState(steps[0])
  const [alliedCompany, setAlliedCompany] = useState({ name: "", doctrine: "" })
  const [axisCompany, setAxisCompany] = useState({ name: "", doctrine: "" })

  const doctrines = useSelector(selectAllDoctrines)
  const creationError = useSelector(state => state.companies.creatingError)


  const setCompany = ({ name, doctrine }) => {
    if (currentStep === constants.ALLIED_SIDE) {
      setAlliedCompany({ name, doctrine })
      setCurrentStep(constants.AXIS_SIDE)
    } else {
      setAxisCompany({ name, doctrine })
      setCurrentStep(reviewStep)
    }
  }

  const back = () => {
    if (currentStep === constants.AXIS_SIDE) {
      setCurrentStep(constants.ALLIED_SIDE)
    } else if (currentStep === reviewStep) {
      setCurrentStep(constants.AXIS_SIDE)
    }
  }

  const onSubmit = () => {
    // Get doctrine id for doctrine name
    const alliedDoctrine = doctrines.find(d => d.attributes.name === alliedCompany.doctrine)
    const axisDoctrine = doctrines.find(d => d.attributes.name === axisCompany.doctrine)
    dispatch(createCompany({
      name: alliedCompany.name,
      doctrine: alliedCompany.doctrine,
      doctrineId: alliedDoctrine.id
    }))
    dispatch(createCompany({
      name: axisCompany.name,
      doctrine: axisCompany.doctrine,
      doctrineId: axisDoctrine.id
    }))
  }

  let error
  if (creationError) {
    error = (
      <Box>
        <Typography>{creationError}</Typography>
      </Box>
    )
  }

  let content
  if (currentStep === constants.ALLIED_SIDE) {
    content = <CompanyForm side={currentStep} back={back} company={alliedCompany}
                           companyCallback={setCompany} />
  } else if (currentStep === constants.AXIS_SIDE) {
    content = <CompanyForm side={currentStep} back={back} company={axisCompany}
                           companyCallback={setCompany} />
  } else {
    content = (
      <>
        <ErrorTypography>{error}</ErrorTypography>
        <Typography variant={"h5"} gutterBottom>Review</Typography>
        <Grid container spacing={4}>
          <Grid item xs={6}>
            <Typography variant="h6">{alliedCompany.name}</Typography>
            <img src={constants.doctrineImgMapping[alliedCompany.doctrine]} alt={alliedCompany.doctrine}
                 className={classes.optionImage} />
          </Grid>
          <Grid item xs={6}>
            <Typography variant="h6">{axisCompany.name}</Typography>
            <img src={constants.doctrineImgMapping[axisCompany.doctrine]} alt={axisCompany.doctrine}
                 className={classes.optionImage} />
          </Grid>
        </Grid>
        <Grid container pt={4}>
          <Grid item xs={2}>
            <Button variant="outlined" color="secondary" size="small" sx={{ marginRight: "10px" }}
                    onClick={back}>Back</Button>
          </Grid>
          <Grid item xs={8} />
          <Grid item xs={2} container justifyContent="flex-end">
            <Button variant="contained" color="secondary" size="small" onClick={onSubmit}>Submit</Button>
          </Grid>
        </Grid>
      </>
    )
  }

  return (
    <Box>
      {content}
    </Box>
  )

}
