import React from 'react'
import { Grid, Typography } from "@mui/material";
import { useSelector } from "react-redux";
import {
  selectCompanyFuel,
  selectCompanyMan,
  selectCompanyMun,
  selectCompanyPop
} from "../companiesSlice";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  detailTitle: {
    fontWeight: 'bold'
  }
}))

const ResourceDisplay = ({resource, quantity}) => {
  const classes = useStyles()
  let color
  if (quantity < 0) {
    color = "error"
  }
  return (
    <>
      <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                  pr={1}>{resource}</Typography>
      <Typography variant="body2" gutterBottom color={color}>{quantity}</Typography>
    </>
  )
}

export const CompanyResources = ({companyId}) => {
  const pop = useSelector(state => selectCompanyPop(state, companyId))
  const man = useSelector(state => selectCompanyMan(state, companyId))
  const mun = useSelector(state => selectCompanyMun(state, companyId))
  const fuel = useSelector(state => selectCompanyFuel(state, companyId))

  return (
    <>
      <Grid item xs={2} md={1}>
        <ResourceDisplay resource="Population" quantity={pop} />
      </Grid>
      <Grid item xs={2} md={1}>
        <ResourceDisplay resource="Manpower" quantity={man} />
      </Grid>
      <Grid item xs={2} md={1}>
        <ResourceDisplay resource="Munitions" quantity={mun} />
      </Grid>
      <Grid item xs={2} md={1}>
        <ResourceDisplay resource="Fuel" quantity={fuel} />
      </Grid>
    </>
  )
}
