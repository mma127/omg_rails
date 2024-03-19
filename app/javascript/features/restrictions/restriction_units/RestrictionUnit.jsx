import React from "react";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { Box, TableCell, TableRow, Tooltip, Typography } from "@mui/material";
import { selectFactionById } from "../../factions/factionsSlice";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { FactionIcon } from "../../factions/FactionIcon";
import { DoctrineIcon } from "../../doctrines/DoctrineIcon";
import { ResourceQuantity } from "../../resources/ResourceQuantity";
import { FUEL, MAN, MUN, POP } from "../../../constants/resources";
import { StaticUnitIcon } from "../../companies/manage/unlocks/StaticUnitIcon";
import { BorderlessCell } from "../../../components/BorderlessCell";
import { nanoid } from "@reduxjs/toolkit";
import { UnitVet } from "./UnitVet";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    justifyContent: "space-between",
    marginBottom: "1rem"
  },
  enabledUnit: {
    borderLeftColor: theme.palette.success.light,
    borderLeftWidth: '3px',
    borderLeftStyle: 'solid',
    borderBottom: "none"
  },
  disabledUnit: {
    borderLeftColor: `${theme.palette.error.light + 'CC'}`,
    borderLeftWidth: '3px',
    borderLeftStyle: 'solid',
    borderBottom: "none"

  },
  restrictionWrapper: {
    verticalAlign: "middle"
  },
  disabled: {
    opacity: "0.7"
  },
  notActive: {
    opacity: "0.5 !important",
    "& $enabledUnit": {
      borderLeftColor: `${theme.palette.success.light + '77'}`,
    },
    "& $disabledUnit": {
      borderLeftColor: `${theme.palette.error.light + '77'}`,
    },
  }
}))

const Restriction = ({ restrictionName, type, factionId, doctrineId }) => {
  const classes = useStyles()
  const faction = useSelector(state => selectFactionById(state, factionId))
  const doctrine = useSelector(state => selectDoctrineById(state, doctrineId))

  let tooltipText
  if (type === "EnabledUnit") {
    tooltipText = `Enabled by ${restrictionName}`
  } else if (type === "DisabledUnit") {
    tooltipText = `Disabled by ${restrictionName}`
  }

  let content
  if (!!faction) {
    content = <FactionIcon factionName={faction.name} alt={restrictionName} height={36}/>
  } else if (!!doctrine) {
    content = <DoctrineIcon doctrineName={doctrine.name} alt={restrictionName} height={36}/>
  } else {
    content = <Typography>{restrictionName}</Typography>
  }

  if (!!tooltipText) {
    return (
      <Tooltip title={tooltipText} placement="top" followCursor={true} arrow>
        <Box>
          {content}
        </Box>
      </Tooltip>
    )
  }
  return content
}

const EnabledUnit = ({ enabledUnit, isActive, currentFactionId }) => {
  const classes = useStyles()
  const unit = enabledUnit.unit
  const restriction = enabledUnit.restriction
  const faction = useSelector(state => selectFactionById(state, currentFactionId))

  return (
    <TableRow className={!isActive ? classes.notActive : null}>
      <TableCell className={classes.enabledUnit}>
        {isActive ? <StaticUnitIcon name={unit.name} height={36}/> : null}
      </TableCell>
      <BorderlessCell>
        {isActive ? <Typography>{unit.displayName}</Typography> : null}
      </BorderlessCell>
      <BorderlessCell>
        <Restriction restrictionName={restriction.name} type={enabledUnit.type}
                     factionId={restriction.factionId} doctrineId={restriction.doctrineId}/>
      </BorderlessCell>
      <BorderlessCell>
        {isActive ? <UnitVet vet={unit.vet} side={faction.side} /> : null}
      </BorderlessCell>
      <BorderlessCell>
        <ResourceQuantity resource={MAN} quantity={enabledUnit.man}/>
      </BorderlessCell>
      <BorderlessCell>
        <ResourceQuantity resource={MUN} quantity={enabledUnit.mun}/>
      </BorderlessCell>
      <BorderlessCell>
        <ResourceQuantity resource={FUEL} quantity={enabledUnit.fuel}/>
      </BorderlessCell>
      <BorderlessCell>
        <ResourceQuantity resource={POP} quantity={enabledUnit.pop}/>
      </BorderlessCell>
      <BorderlessCell>
        <Typography>{enabledUnit.resupply}</Typography>
      </BorderlessCell>
      <BorderlessCell>
        <Typography>{enabledUnit.resupplyMax}</Typography>
      </BorderlessCell>
      <BorderlessCell>
        <Typography>{enabledUnit.companyMax}</Typography>
      </BorderlessCell>
      <BorderlessCell>
        <Typography>{enabledUnit.upgradeSlots}</Typography>
      </BorderlessCell>
      <BorderlessCell>
        <Typography>{enabledUnit.unitwideUpgradeSlots}</Typography>
      </BorderlessCell>
      {/*<BorderlessCell>*/}
      {/*  <Typography>{unit.transportModelSlots}</Typography>*/}
      {/*</BorderlessCell>*/}
      {/*<BorderlessCell>*/}
      {/*  <Typography>{unit.transportSquadSlots}</Typography>*/}
      {/*</BorderlessCell>*/}
      {/*<BorderlessCell>*/}
      {/*  <Typography>{unit.transportableUnitIds}</Typography>*/}
      {/*</BorderlessCell>*/}
    </TableRow>
  )
}

const DisabledUnit = ({ disabledUnit, isActive }) => {
  const classes = useStyles()
  const unit = disabledUnit.unit
  const restriction = disabledUnit.restriction
  const tooltipText = `Disabled by ${restriction.name}`
  return (
    <TableRow className={`${!isActive ? classes.notActive : null} ${classes.disabled}`}>
      <TableCell className={classes.disabledUnit}>
        {isActive ? <Tooltip title={tooltipText} placement="top" followCursor={true} arrow>
          <Box><StaticUnitIcon name={unit.name} height={36}/></Box></Tooltip> : null}
      </TableCell>
      <BorderlessCell>
        <Tooltip title={tooltipText} placement="top" followCursor={true} arrow>
          <Typography>{unit.displayName}</Typography>
        </Tooltip>
      </BorderlessCell>
      <BorderlessCell>
        <Restriction restrictionName={restriction.name} type={disabledUnit.type}
                     factionId={restriction.factionId} doctrineId={restriction.doctrineId}/>
      </BorderlessCell>
    </TableRow>
  )
}

export const RestrictionUnit = ({ entity, showDisabled, currentFactionId }) => {
  const classes = useStyles()

  const unitId = entity.unitId
  const activeRU = entity.activeRestrictionUnit
  const overriddenRUs = entity.overriddenRestrictionUnits
  const unit = activeRU.unit

  let content = []
  if (activeRU.type === "EnabledUnit") {
    content.push(<EnabledUnit enabledUnit={activeRU} isActive={true} currentFactionId={currentFactionId} key={activeRU.id}/>)
  } else if (activeRU.type === "DisabledUnit") {
    if (showDisabled) {
      content.push(<DisabledUnit disabledUnit={activeRU} isActive={true} currentFactionId={currentFactionId} key={activeRU.id}/>)
    } else {
      return null
    }
  }

  if (overriddenRUs.length > 0) {
    overriddenRUs.forEach(oru => {
      content.push(<TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>)

      if (oru.type === "EnabledUnit") {
        content.push(<EnabledUnit enabledUnit={oru} isActive={false} currentFactionId={currentFactionId} key={oru.id}/>)
      } else if (oru.type === "DisabledUnit") {
        content.push(<DisabledUnit disabledUnit={oru} isActive={false} currentFactionId={currentFactionId} key={oru.id}/>)
      }
    })
  }

  return (
    <>
      <TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>
      {content}
      <TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>
      <TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>
      <TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>
      <TableRow key={nanoid()}><BorderlessCell></BorderlessCell></TableRow>
    </>
  )
}
