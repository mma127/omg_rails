import React from "react";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { TableCell, TableRow, Typography } from "@mui/material";

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
    border: "none"
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

const EnabledUnit = ({ enabledUnit, isActive }) => {
  const classes = useStyles()
  const unit = enabledUnit.unit
  const restriction = enabledUnit.restriction

  return (
    <TableRow>
      <TableCell className={classes.enabledUnit}>
        <Typography>{unit.name}</Typography>
      </TableCell>
      <Cell>
        <Typography>{restriction.name}</Typography>
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
      <TableCell className={classes.disabledUnit}>
        <Typography>{unit.name}</Typography>
      </TableCell>
      <Cell>
        <Typography>{restriction.name}</Typography>
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
    </>
  )
}
