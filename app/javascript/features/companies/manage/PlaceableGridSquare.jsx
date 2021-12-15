import React, { useState } from 'react'
import { Card, CardMedia, Paper } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { DropTarget } from 'react-drag-drop-container';
import riflemen from "../../../../assets/images/doctrines/americans/riflemen.png";

const useStyles = makeStyles(theme => ({
  placementBox: {
    minHeight: '10rem',
    minWidth: '4rem'
  }
}))

export const PlaceableGridSquare = ({ index }) => {
  const classes = useStyles()

  const [content, setContent] = useState([])

  const onHit = (e) => {
    console.log(`Something dropped into target ${index}`)
    const existing = content.slice()
    existing.push((<Card sx={{ width: 64 }}>
      <CardMedia component="img" height="64" image={riflemen} alt="Riflemen" />
    </Card>))
    setContent(existing)
  }

  return (
    <DropTarget targetKey="unit" onHit={onHit}>
      <Paper key={index} className={classes.placementBox}>
        {index}
        {content}
      </Paper>
    </DropTarget>
  )
}