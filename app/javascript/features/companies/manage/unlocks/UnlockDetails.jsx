import React from 'react'
import { makeStyles } from "@mui/styles";
import { Accordion, AccordionDetails, AccordionSummary, Box, Card, CardContent, Typography } from "@mui/material";
import { StaticUnitIcon } from "./StaticUnitIcon";
import EastIcon from "@mui/icons-material/East";
import { OffmapIcon } from "../offmaps/OffmapIcon";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { SUPPORT_TEAMS } from "../../../../constants/unlocks/americans";
import { UnlockOffmap } from "./UnlockOffmap";
import { UnlockCallinModifier } from "./UnlockCallinModifier";

const useStyles = makeStyles(() => ({
  background: {
    backgroundColor: '#232323'
  },
  cardContent: {
    paddingTop: "8px",
    paddingBottom: "8px",
    '&:last-child': {
      paddingBottom: "8px"
    }
  },
  wellContainer: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center"
  }
}))

const buildEnabledUnits = (enabledUnits) => {
  if (enabledUnits.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="success.dark">Available Units</Typography>
      {enabledUnits.map(eu => (<StaticUnitIcon name={eu.unit.name} key={eu.id} />))}
    </Box>
  )
}

const buildDisabledUnits = (disabledUnits) => {
  if (disabledUnits.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="error.main">Disabled Units</Typography>
      {disabledUnits.map(du => (<StaticUnitIcon name={du.unit.name} key={du.id} />))}
    </Box>
  )
}

const buildUnitSwaps = (unitSwaps) => {
  if (unitSwaps.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="info.dark">Squad Unit Swaps</Typography>
      {
        unitSwaps.map(us => (
          <Box sx={{ display: "flex", alignItems: "center" }} key={us.id}>
            <StaticUnitIcon name={us.oldUnit.name} />
            <Box sx={{ paddingLeft: '1rem', paddingRight: '1rem' }}>
              <EastIcon />
            </Box>
            <StaticUnitIcon name={us.newUnit.name} />
          </Box>
        ))}
    </Box>
  )
}

const buildEnabledOffmaps = enabledOffmaps => {
  if (enabledOffmaps.length === 0) {
    return null
  }

  return (
    <Box>
      <Typography variant="subtitle2" color="success.dark">Available Offmaps</Typography>
      {enabledOffmaps.map(eo => (<UnlockOffmap enabledOffmap={eo} key={eo.id} />))}
    </Box>
  )
}

const buildEnabledCallinModifiers = (enabledCallinModifiers, classes) => {
  if (enabledCallinModifiers.length === 0) {
    return null
  }

  return (
    <Box className={classes.wellContainer}>
      <Typography variant="subtitle2" color="success.dark">Callin Modifier</Typography>
      {enabledCallinModifiers.map(ecm => (<UnlockCallinModifier enabledCallinModifier={ecm} key={ecm.id} />))}
    </Box>
  )
}

export const UnlockDetails = ({ doctrineUnlock }) => {
  const classes = useStyles()
  const enabledUnits = doctrineUnlock.enabledUnits
  const disabledUnits = doctrineUnlock.disabledUnits
  const unitSwaps = doctrineUnlock.unitSwaps
  const enabledOffmaps = doctrineUnlock.enabledOffmaps
  const enabledCallinModifiers = doctrineUnlock.enabledCallinModifiers

  const detailsContent = (
    <>
      {buildEnabledUnits(enabledUnits)}
      {buildDisabledUnits(disabledUnits)}
      {buildUnitSwaps(unitSwaps)}
      {buildEnabledOffmaps(enabledOffmaps)}
      {buildEnabledCallinModifiers(enabledCallinModifiers, classes)}
    </>
  )

  if (detailsContent.props.children.some(e => !_.isNull(e))) {
    if (doctrineUnlock.unlock.name === SUPPORT_TEAMS) {
      // Special case for support teams as it has a very lengthy details section
      return (
        <Accordion sx={{ backgroundColor: '#232323' }}>
          <AccordionSummary
            expandIcon={<ExpandMoreIcon />}
          >
            <Typography>Details</Typography>
          </AccordionSummary>
          <AccordionDetails>
            {detailsContent}
          </AccordionDetails>
        </Accordion>
      )
    } else {
      return (
        <Card className={classes.background}>
          <CardContent className={classes.cardContent}>
            {detailsContent}
          </CardContent>
        </Card>
      )
    }
  } else {
    return null
  }
}
