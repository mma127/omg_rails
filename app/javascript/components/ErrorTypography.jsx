import React from 'react'
import { withStyles } from "@mui/styles";
import { Typography } from "@mui/material";

/* This component displays text in a similar style to error helperText for inputs */
export const ErrorTypography = withStyles(theme => ({
  root: {
    fontSize: "0.75rem",
    color: theme.palette.error.main
  }
}))(Typography)