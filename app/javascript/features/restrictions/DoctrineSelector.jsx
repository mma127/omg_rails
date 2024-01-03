import React from 'react'
import { useSelector } from "react-redux";
import { Grid, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { selectDoctrinesByFactionId } from "../doctrines/doctrinesSlice";
import { DoctrineIcon } from "../doctrines/DoctrineIcon";

const useStyles = makeStyles(theme => ({
  wrapper: {
    display: "flex",
    justifyContent: "center",
    minHeight: "76px" // hardcode for spacing
  }
}))

export const DoctrineSelector = ({ currentFactionId, currentDoctrineName, handleDoctrineSelect }) => {
  const classes = useStyles()

  const doctrines = useSelector(state => selectDoctrinesByFactionId(state, currentFactionId))

  return (
    <Grid container className={classes.wrapper}>
      {doctrines.map(doctrine => (
        <Tooltip title={doctrine.displayName} placement="top" arrow key={doctrine.id}>
          <Grid item sx={{ cursor: "pointer" }} p={1}>
            <DoctrineIcon doctrineName={doctrine.name} alt={doctrine.name} height={60}
                          doctrineId={doctrine.id}
                          onDoctrineClick={handleDoctrineSelect}
                          isActive={currentDoctrineName === doctrine.name || currentDoctrineName === null}/>
          </Grid>
        </Tooltip>
      ))}
    </Grid>
  )
}
