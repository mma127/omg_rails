import React from "react";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { TableCell, TableRow, Typography } from "@mui/material";
import { selectFactionById } from "../../factions/factionsSlice";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { FactionIcon } from "../../factions/FactionIcon";
import { DoctrineIcon } from "../../doctrines/DoctrineIcon";
import { ResourceQuantity } from "../../resources/ResourceQuantity";
import { FUEL, MAN, MUN, POP } from "../../../constants/resources";
import { StaticUnitIcon } from "../../companies/manage/unlocks/StaticUnitIcon";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    justifyContent: "space-between",
    marginBottom: "1rem"
  },
  enabledUnit: {
    borderColor: theme.palette.success.light,
    borderWidth: '1px',
    borderStyle: 'solid'
  },
  disabledUnit: {
    borderColor: theme.palette.error.light,
    borderWidth: '1px',
    borderStyle: 'solid'
  },
  noBorder: {
    border: "none",
    padding: "3px 8px",
    verticalAlign: "middle"
  }
}))

const Cell = (props) => {
  const { visible, cancel, children } = props;

  const classes = useStyles()
  return (
    <TableCell className={classes.noBorder}>
      {children}
    </TableCell>
  )
}

const Restriction = ({ restrictionName, factionId, doctrineId }) => {
  const faction = useSelector(state => selectFactionById(state, factionId))
  const doctrine = useSelector(state => selectDoctrineById(state, doctrineId))

  let content
  if (!!faction) {
    return (
      <FactionIcon factionName={faction.name} alt={restrictionName} height={40}/>
    )
  } else if (!!doctrine) {
    return (
      <DoctrineIcon doctrineName={doctrine.name} alt={restrictionName} height={36}/>
    )
  } else {
    return (
      <Typography>{restrictionName}</Typography>
    )
  }
}

const EnabledUnit = ({ enabledUnit, isActive }) => {
  const classes = useStyles()
  const unit = enabledUnit.unit
  const restriction = enabledUnit.restriction

  return (
    <TableRow>
      <Cell>
        <StaticUnitIcon name={unit.name} height={36}/>
      </Cell>
      <TableCell className={classes.enabledUnit}>
        <Typography>{unit.displayName}</Typography>
      </TableCell>
      <Cell>
        <Restriction restrictionName={restriction.name} factionId={restriction.factionId} doctrineId={restriction.doctrineId}/>
      </Cell>
      <Cell>
        <ResourceQuantity resource={MAN} quantity={enabledUnit.man} />
      </Cell>
      <Cell>
        <ResourceQuantity resource={MUN} quantity={enabledUnit.mun} />
      </Cell>
      <Cell>
        <ResourceQuantity resource={FUEL} quantity={enabledUnit.fuel} />
      </Cell>
      <Cell>
        <ResourceQuantity resource={POP} quantity={enabledUnit.pop} />
      </Cell>
      <Cell>
        <Typography>{enabledUnit.resupply}</Typography>
      </Cell>
      <Cell>
        <Typography>{enabledUnit.resupplyMax}</Typography>
      </Cell>
      <Cell>
        <Typography>{enabledUnit.companyMax}</Typography>
      </Cell>
    </TableRow>
  )
}

const DisabledUnit = ({ disabledUnit, isActive }) => {
  const classes = useStyles()
  const unit = disabledUnit.unit
  const restriction = disabledUnit.restriction

  return (
    <TableRow>
      <Cell>
        <StaticUnitIcon name={unit.name} height={36}/>
      </Cell>
      <TableCell className={classes.disabledUnit}>
        <Typography>{unit.displayName}</Typography>
      </TableCell>
      <Cell>
        <Restriction restrictionName={restriction.name} factionId={restriction.factionId} doctrineId={restriction.doctrineId}/>
      </Cell>
    </TableRow>
  )
}

export const RestrictionUnit = ({ entity }) => {
  const classes = useStyles()

  const unitId = entity.unitId
  const activeRU = entity.activeRestrictionUnit
  const overriddenRUs = entity.overriddenRestrictionUnits
  const unit = activeRU.unit

  let content
  if (activeRU.type === "EnabledUnit") {
    content = <EnabledUnit enabledUnit={activeRU} isActive={true}/>
  } else if (activeRU.type === "DisabledUnit") {
    content = <DisabledUnit disabledUnit={activeRU} isActive={true}/>
  }

  return (
    <>
      {content}
      <TableRow><Cell></Cell></TableRow>
      <TableRow><Cell></Cell></TableRow>
      <TableRow><Cell></Cell></TableRow>
      <TableRow><Cell></Cell></TableRow>
    </>
  )
}
