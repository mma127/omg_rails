import React from 'react'
import { Box, Typography } from "@mui/material";
import { ResourceQuantity } from "./ResourceQuantity";
import { FUEL, MAN, MUN } from "../../constants/resources";
import { makeStyles } from "@mui/styles";


const useStyles = makeStyles(theme => ({
  wrapper: {
    display: "flex"
  },
  resource: {
    marginRight: "0.25rem",
    "&:last-child": {
      marginRight: 0
    }
  }
}))


export const ResourcesCost = ({ man, mun, fuel }) => {
  const classes = useStyles()

  let manContent, munContent, fuelContent, freeContent

  if (man > 0) {
    manContent = <Box className={classes.resource}><ResourceQuantity resource={MAN} quantity={man}/></Box>
  }

  if (mun > 0) {
    munContent = <Box className={classes.resource}><ResourceQuantity resource={MUN} quantity={mun}/></Box>
  }

  if (fuel > 0) {
    fuelContent = <Box className={classes.resource}><ResourceQuantity resource={FUEL} quantity={fuel}/></Box>
  }

  if (!manContent && !munContent && !fuelContent) {
    freeContent = <Typography variant="subtitle2" color="secondary">Free</Typography>
  }

  return (
    <Box className={classes.wrapper}>
      {manContent}
      {munContent}
      {fuelContent}
      {freeContent}
    </Box>
  )
}
