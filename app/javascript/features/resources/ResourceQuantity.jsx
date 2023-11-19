import { Box, Typography } from "@mui/material";
import React from "react";
import { ResourceIcon } from "./ResourceIcon";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  wrapper: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: "center",
    verticalAlign: "middle"
  }
}))

export const ResourceQuantity = ({ resource, quantity, showZero=false }) => {
  const classes = useStyles()

  if (!showZero && quantity === 0) {
    return <Typography></Typography>
  }

  return (
    <Box className={classes.wrapper}>
      <Typography pr={0.5}>{quantity}</Typography>
      <ResourceIcon resource={resource} small={true}/>
    </Box>
  )
}
