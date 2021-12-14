import React from 'react'
import { Container, Grid, Paper, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  placementBox: {
    minHeight: '10rem',
    minWidth: '4rem'
  }
}))

export const CompanyManager = () => {
  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  console.log(companyId)

  return (
    <Container maxWidth="xl" >
      <Typography variant="h5">Company {companyId}</Typography>
      <Grid container spacing={2}>
        <Grid item container spacing={2} >
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
        </Grid>
        <Grid item container spacing={2} >
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
          <Grid item xs={3}>
            <Paper className={classes.placementBox}/>
          </Grid>
        </Grid>
      </Grid>
    </Container>
  )
}