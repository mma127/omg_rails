import { makeStyles } from "@mui/styles";
import { TableCell } from "@mui/material";
import React from "react";

const useStyles = makeStyles(theme => ({
  noBorder: {
    border: "none",
    padding: "3px 8px",
    verticalAlign: "middle"
  }
}))

export const BorderlessCell = (props) => {
  const { visible, cancel, children } = props;

  const classes = useStyles()
  return (
    <TableCell className={classes.noBorder}>
      {children}
    </TableCell>
  )
}
