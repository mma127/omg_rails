import React from 'react'
import { Box, Grid, Typography } from "@mui/material";
import { CompanyPlatoonBox } from "./CompanyPlatoonBox";
import { DISPLAY_CATEGORIES } from "../../../constants/company";
import { useSelector } from "react-redux";
import { selectSquadsInTab } from "../manage/units/squadsSlice";

export const CompanySquadCategory = ({ tab }) => {
  const squads = useSelector(state => selectSquadsInTab(state, tab))
  if (squads.length === 0) {
    return null
  }

  return (
    <Box p={2}>
      <Typography variant="subtitle2" color="text.secondary" gutterBottom
                  pl={"0.25rem"}>{DISPLAY_CATEGORIES[tab]}</Typography>
      <Grid container spacing={1}>
        <Grid item container spacing={1}>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={0} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={1} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={2} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={3} tab={tab}/>
          </Grid>
        </Grid>
        <Grid item container spacing={1}>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={4} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={5} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={6} tab={tab}/>
          </Grid>
          <Grid item lg={3} sm={6} xs={12}>
            <CompanyPlatoonBox index={7} tab={tab}/>
          </Grid>
        </Grid>
      </Grid>
    </Box>

  )
}
