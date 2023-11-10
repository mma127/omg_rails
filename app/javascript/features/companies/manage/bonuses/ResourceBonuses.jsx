import React from "react";
import { useSelector } from "react-redux";
import { selectAvailableRBs, selectCompanyBonuses } from "./companyBonusesSlice";
import { Box, Grid, Typography } from "@mui/material";
import { ResourceCard } from "./ResourceCard";
import { FUEL, MAN, MUN } from "../../../../constants/resources";

export const ResourceBonuses = () => {
  const companyBonuses = useSelector(selectCompanyBonuses);
  const availableRBs = useSelector(selectAvailableRBs);

  if (_.isEmpty(companyBonuses.manResourceBonus)) {
    return <Box></Box>
  }

  return (
    <Grid container>
      <Grid item container md={ 12 } p={ 2 }>
        <Typography variant="h5">
          Available Resource Bonuses: { availableRBs }
        </Typography>
      </Grid>
      <Grid item container>
        <Grid item md={ 4 } p={ 2 }>
          <ResourceCard resource={ MAN } availableRB={ availableRBs }/>
        </Grid>
        <Grid item md={ 4 } p={ 2 }>
          <ResourceCard resource={ MUN } availableRB={ availableRBs }/>
        </Grid>
        <Grid item md={ 4 } p={ 2 }>
          <ResourceCard resource={ FUEL } availableRB={ availableRBs }/>
        </Grid>
      </Grid>
    </Grid>
  )
}
