import React from 'react'
import { Box, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  statRow: {
    display: "flex",
    alignItems: "baseline",
    justifyContent: "flex-end",
    minWidth: "5rem",
    paddingLeft: "0.25rem",
    paddingRight: "0.25rem",
  }
}))

export const Stat = ({ value, label, isRate = false, variant = "h6" }) => {
  const classes = useStyles()

  if (isRate) {
    value = `${(value * 100).toFixed(2)}%`
  }
  return (
    <Box className={classes.statRow}>
      <Typography variant={variant} color="text.secondary">{value}</Typography>
      <Typography variant="caption" color="text.secondary" sx={{ paddingLeft: "0.25rem" }}>{label}</Typography>
    </Box>
  )
}
