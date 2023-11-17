import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Table, TableBody, TableContainer, TableHead, TableRow, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { fetchRestrictionUnits, selectRestrictionUnits } from "./restrictionUnitsSlice";
import { RestrictionUnit } from "./RestrictionUnit";
import { BorderlessCell } from "../../../components/BorderlessCell";


const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
  },
  cell: {
    border: "none"
  }
}))

export const RestrictionUnits = ({currentFactionId, currentDoctrineId}) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  useEffect(() => {
    fetchData()
  }, [currentFactionId, currentDoctrineId])

  // TODO RULESET
  const fetchData = () => {
    if (currentFactionId !== null) {
      dispatch(fetchRestrictionUnits({ rulesetId: 1, factionId: currentFactionId, doctrineId: currentDoctrineId }))
    }
  }

  const restrictionUnits = useSelector(selectRestrictionUnits)

  return (
    <Box className={classes.wrapper}>
      <TableContainer>
        <Table size="small">
          <TableHead>
            <TableRow>
              <BorderlessCell></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Unit</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Restriction</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Man</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Mun</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Fuel</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Pop</Typography></BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Unit availability gained per battle" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Resupply</Typography>
                </Tooltip>
              </BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Maximum number of this unit available to purchase at a time" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Resupply Max</Typography>
                </Tooltip>
              </BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Maximum number of this unit allowed in a company" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Company Max</Typography>
                </Tooltip>
              </BorderlessCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {restrictionUnits.map(ru => <RestrictionUnit entity={ru} key={ru.activeRestrictionUnit.id}/>)}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  )
}
