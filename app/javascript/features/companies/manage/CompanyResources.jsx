import React from 'react'
import { Grid, Typography } from "@mui/material";
import { useSelector } from "react-redux";
import {
  selectCompanyById,
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
export const CompanyResources = ({companyId}) => {
  const classes = useStyles()

  const pop = useSelector(state => selectCompanyPop(state, companyId))
  const man = useSelector(state => selectCompanyMan(state, companyId))
  const mun = useSelector(state => selectCompanyMun(state, companyId))
  const fuel = useSelector(state => selectCompanyFuel(state, companyId))

  return (
    <>
      <Grid item xs={2} md={1}>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                    pr={1}>Population</Typography>
        <Typography variant="body2" gutterBottom>{pop}</Typography>
      </Grid>
      <Grid item xs={2} md={1}>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                    pr={1}>Manpower</Typography>
        <Typography variant="body2" gutterBottom>{man}</Typography>
      </Grid>
      <Grid item xs={2} md={1}>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                    pr={1}>Munitions</Typography>
        <Typography variant="body2" gutterBottom>{mun}</Typography>
      </Grid>
      <Grid item xs={2} md={1}>
        <Typography variant="subtitle2" color="text.secondary" gutterBottom className={classes.detailTitle}
                    pr={1}>Fuel</Typography>
        <Typography variant="body2" gutterBottom>{fuel}</Typography>
      </Grid>
    </>
  )
}
