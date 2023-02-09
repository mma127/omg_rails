import React from 'react'
import { makeStyles } from "@mui/styles";
import { Card, CardMedia } from "@mui/material";

const useStyles = makeStyles(() => ({
  unlockCard: {
    width: '45px',
    height: '45px',
    display: 'inline-flex',
    '&.disabled': {
      cursor: 'initial',
      filter: 'grayscale(1)'
    }
  }
}))

/**
 * Display component to show an unlock image
 * @param label: image label
 * @param image
 */
export const UnlockCard = ({ label, image, }) => {
  const classes = useStyles()

  return (
    <Card className={classes.unlockCard} >
      <CardMedia component="img" height="45" image={image} alt={label} />
    </Card>
  )
}