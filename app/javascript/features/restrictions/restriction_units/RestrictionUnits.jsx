import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Table, TableBody, TableContainer, TableHead } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { fetchRestrictionUnits, selectRestrictionUnits } from "./restrictionUnitsSlice";
import { RestrictionUnit } from "./RestrictionUnit";


const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
  }
}))

export const RestrictionUnits = () => {
  const classes = useStyles()
  const dispatch = useDispatch()

  useEffect(() => {
    fetchData()
  }, [])

  const fetchData = () => {
    dispatch(fetchRestrictionUnits({ rulesetId: 1, factionId: 2, doctrineId: 11 }))
  }

  const restrictionUnits = useSelector(selectRestrictionUnits)

  return (
    <Box className={classes.wrapper}>
      <TableContainer>
        <Table size="small">
          <TableHead>
          </TableHead>
          <TableBody>
            { restrictionUnits.map(ru => <RestrictionUnit entity={ ru } key={ru.activeRestrictionUnit.id} />) }
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  )
}
