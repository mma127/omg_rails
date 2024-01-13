import React from 'react'
import { Box, Switch, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  toggleContainer: {
    display: 'inline-flex',
    flexDirection: "row",
    alignItems: "center",
    [theme.breakpoints.down('md')]: {
      flexDirection: "column",
      top: "-135px",
      right: "-16px"
    }
  }
}))

export const CompactSelector = ({ isCompact, handleToggleCompact }) => {
  const classes = useStyles()

  return (
    <Box className={classes.toggleContainer}>
      <Switch checked={isCompact} onChange={handleToggleCompact} inputProps={{ 'aria-label': 'controlled' }} color="secondary"/>
      <Typography variant="subtitle2" color="secondary.main">COMPACT</Typography>
    </Box>
  )
}
