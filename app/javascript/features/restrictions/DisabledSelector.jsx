import React from 'react'
import { useSelector } from "react-redux";
import { Box, Grid, Switch, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { selectDoctrinesByFactionId } from "../doctrines/doctrinesSlice";
import { DoctrineIcon } from "../doctrines/DoctrineIcon";

const useStyles = makeStyles(theme => ({
  toggleContainer: {
  display: 'inline-flex',
  flexDirection: "row",
  alignItems: "center",
  position: 'relative',
  right: '0',
  marginLeft: 'auto',
  top:'-120px',
  [theme.breakpoints.down('md')]: {
    flexDirection: "column",
    top: "-135px",
    right: "-16px"
  }
}
}))

export const DisabledSelector = ({ showDisabled, handleShowDisabledToggle }) => {
  const classes = useStyles()

  return (
    <Box className={classes.toggleContainer}>
      <Switch checked={showDisabled} onChange={handleShowDisabledToggle} inputProps={{ 'aria-label': 'controlled' }}/>
      Show Disabled
    </Box>
  )
}
