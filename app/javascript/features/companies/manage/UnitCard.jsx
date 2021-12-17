import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";

const useStyles = makeStyles(() => ({
  unitCard: {
    width: '45px',
    height: '45px'
  }
}))

/**
 * Display component to show an unit image
 * @param label: image label
 * @param image
 */
export const UnitCard = ({ label, image }) => {
  const classes = useStyles()

  return (
    <Card className={classes.unitCard}>
      <CardMedia component="img" height="45" image={image} alt={label} />
    </Card>
  )
}