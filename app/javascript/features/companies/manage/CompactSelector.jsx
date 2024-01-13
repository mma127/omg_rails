import React from 'react'
import { Box, Switch, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { selectIsCompanyManagerCompact, setIsCompanyManagerCompact } from "./units/squadsSlice";
import { useDispatch, useSelector } from "react-redux";

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

export const CompactSelector = ({ }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const isCompact = useSelector(selectIsCompanyManagerCompact)

  const handleToggleCompact = (event) => {
    dispatch(setIsCompanyManagerCompact(event.target.checked))
  }

  return (
    <Box className={classes.toggleContainer}>
      <Switch checked={isCompact} onChange={handleToggleCompact} inputProps={{ 'aria-label': 'controlled' }} color="secondary"/>
      <Typography variant="subtitle2" color="secondary.main">COMPACT</Typography>
    </Box>
  )
}
