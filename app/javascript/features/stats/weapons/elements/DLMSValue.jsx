import React from 'react'
import { Grid } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { precise } from "../../../../utils/numbers";

const useStyles = makeStyles(theme => ({
  values: {
    display: "flex",
    flexDirection: "column"
  }
}))

export const DLMSValue = ({ data, defaultValue, }) => {
  const classes = useStyles()

  const short = data?.short || defaultValue
  const medium = data?.medium || defaultValue
  const long = data?.long || defaultValue
  const distant = data?.distant || defaultValue

  return (
        <Grid container>
          {long === distant ?
            null :
            <Grid container item>
              <Grid item xs={4}>distant</Grid>
              <Grid item xs={8}>{precise(distant, 4)}</Grid>
            </Grid>}
          <Grid container item>
            <Grid item xs={4}>long</Grid>
            <Grid item xs={8}>{precise(long, 4)}</Grid>
          </Grid>
          <Grid container item>
            <Grid item xs={4}>med</Grid>
            <Grid item xs={8}>{precise(medium, 4)}</Grid>
          </Grid>
          <Grid container item>
            <Grid item xs={4}>short</Grid>
            <Grid item xs={8}>{precise(short, 4)}</Grid>
          </Grid>
        </Grid>
  )
}
