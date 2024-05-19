import React from 'react'
import { Box } from "@mui/material";
import { UnitStatsCard } from "./UnitStatsCard";
import { EntityStatsList } from "../entities/EntityStatsList";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  contentContainer: {
    display: 'flex',
    flexDirection: "column",
    rowGap: "1rem",
    width: '100%',
    marginLeft: '1rem',
    marginRight: '1rem'
  }
}))

export const UnitStats = ({ constName }) => {
  const classes = useStyles()

  return (
    <Box className={classes.contentContainer}>
      <UnitStatsCard constName={constName}/>
      <EntityStatsList constName={constName}/>
    </Box>
  )
}
