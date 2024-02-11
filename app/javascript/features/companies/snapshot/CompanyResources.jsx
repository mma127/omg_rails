import React from 'react'
import { Box, Grid, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectCurrentSnapshotCompany } from "../snapshotCompaniesSlice";
import { MED, ResourceIcon, SMALL } from "../../resources/ResourceIcon";
import { FUEL, MAN, MUN, POP, RESOURCE_TO_NAME } from "../../../constants/resources";
import { selectCompanyBonuses } from "../manage/bonuses/companyBonusesSlice";

const useStyles = makeStyles(() => ({
  resourceValueRow: {
    display: "flex",
    alignItems: "center"
  }
}))

const ResourceBonuses = ({ resource, count }) => {
  const classes = useStyles()
  if (count <= 0) {
    return null
  }

  const content = []
  for (let i = 0; i < count; i++) {
    content.push(<ResourceIcon resource={resource} size={SMALL} key={i}/>)
  }

  return (
    <Box className={classes.resourceValueRow}>
      <Typography variant="caption" color="text.secondary" pr={"0.125rem"}>+</Typography>
      {content}
    </Box>
  )
}

const ResourceDisplay = ({ resource, quantity }) => {
  const classes = useStyles()
  let color
  if (quantity < 0) {
    color = "error"
  }

  let count
  if (resource !== POP) {
    const countKey = `${resource}BonusCount`
    const companyBonuses = useSelector(selectCompanyBonuses);
    count = companyBonuses[countKey]
  }

  const label = RESOURCE_TO_NAME[resource]

  return (
    <>
      <Box className={classes.resourceValueRow} pb={1}>
        <ResourceIcon resource={resource} size={MED}/>
        <Typography variant="subtitle2" color="text.secondary" pl={"0.25rem"}>{label}</Typography>
      </Box>
      <Typography variant="body2" color={color} sx={{ paddingRight: "0.25rem" }}> {quantity}</Typography>
      {count ? <ResourceBonuses resource={resource} count={count}/> : null}
    </>
  )
}

export const CompanyResources = ({}) => {
  const snapshot = useSelector(selectCurrentSnapshotCompany)

  return (
    <Grid container>
      <Grid item xs={3}>
        <ResourceDisplay resource={POP} quantity={snapshot.pop}/>
      </Grid>
      <Grid item xs={3}>
        <ResourceDisplay resource={MAN} quantity={snapshot.man}/>
      </Grid>
      <Grid item xs={3}>
        <ResourceDisplay resource={MUN} quantity={snapshot.mun}/>
      </Grid>
      <Grid item xs={3}>
        <ResourceDisplay resource={FUEL} quantity={snapshot.fuel}/>
      </Grid>
    </Grid>
  )
}
