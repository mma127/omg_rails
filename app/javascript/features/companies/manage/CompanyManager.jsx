import React, { useRef } from 'react'
import { Card, CardMedia, Container, Grid, Paper, Typography } from "@mui/material";
import { useParams } from "react-router-dom";
import { makeStyles } from "@mui/styles";
import { DragDropContainer } from 'react-drag-drop-container';

import riflemen from '../../../../assets/images/doctrines/americans/riflemen.png'
import { PlaceableGridSquare } from "./PlaceableGridSquare";

const useStyles = makeStyles(theme => ({
  placementBox: {
    minHeight: '10rem',
    minWidth: '4rem'
  }
}))

export const CompanyManager = () => {
  const classes = useStyles()

  let params = useParams()
  const companyId = params.companyId
  console.log(companyId)

  // TODO use this to constrain the drag area
  const constraintsRef = useRef(null)

  const onDrop = () => {
    console.log("dropped the unit card")
  }

  return (
    <Container maxWidth="xl" ref={constraintsRef}>
      <Typography variant="h5">Company {companyId}</Typography>

      <Grid container spacing={2}>
        <Grid item container spacing={2}>
          <Grid item xs={1}>
            <DragDropContainer targetKey="unit" onDrop={onDrop}>
              <Card sx={{ width: 64 }}>
                <CardMedia component="img" height="64" image={riflemen} alt="Riflemen" />
              </Card>
            </DragDropContainer>
          </Grid>
        </Grid>
        <Grid item container spacing={2} >
          <Grid item xs={3}>
            <PlaceableGridSquare index={1} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={2} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={3} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={4} />
          </Grid>
        </Grid>
        <Grid item container spacing={2} >
          <Grid item xs={3}>
            <PlaceableGridSquare index={5} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={6} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={7} />
          </Grid>
          <Grid item xs={3}>
            <PlaceableGridSquare index={8} />
          </Grid>
        </Grid>
      </Grid>
    </Container>
  )
}