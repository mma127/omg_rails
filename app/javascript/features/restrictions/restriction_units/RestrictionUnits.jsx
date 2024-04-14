import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Table, TableBody, TableContainer, TableHead, TableRow, Tooltip, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { fetchRestrictionUnits, selectRestrictionUnits } from "./restrictionUnitsSlice";
import { RestrictionUnit } from "./RestrictionUnit";
import { BorderlessCell } from "../../../components/BorderlessCell";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";


const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  cell: {
    border: "none"
  },
  narrowCell: {
    maxWidth: "87px"
  }
}))

export const RestrictionUnits = ({currentFactionId, currentDoctrineId, showDisabled}) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    fetchData()
  }, [currentFactionId, currentDoctrineId])

  const fetchData = () => {
    if (currentFactionId !== null) {
      dispatch(fetchRestrictionUnits({ rulesetId: activeRuleset.id, factionId: currentFactionId, doctrineId: currentDoctrineId }))
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
              <BorderlessCell><Typography variant="subtitle1">Vet</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Man</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Mun</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Fuel</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1">Pop</Typography></BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Unit availability gained per battle" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Avail/B</Typography>
                </Tooltip>
              </BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Maximum number of this unit available to purchase at a time" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Avail Max</Typography>
                </Tooltip>
              </BorderlessCell>
              <BorderlessCell>
                <Tooltip title="Maximum number of this unit allowed in a company" placement="top" followCursor={true} arrow>
                  <Typography variant="subtitle1">Co Max</Typography>
                </Tooltip>
              </BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1" className={classes.narrowCell}>Upgrade Slots</Typography></BorderlessCell>
              <BorderlessCell><Typography variant="subtitle1" className={classes.narrowCell}>Unitwide Slots</Typography></BorderlessCell>
              {/* Commenting these out as there are relatively few transports per doctrine/faction and the columns would be too much whitespace */}
              {/*<BorderlessCell><Typography variant="subtitle1" className={classes.narrowCell}>TP Model Slots</Typography></BorderlessCell>*/}
              {/*<BorderlessCell><Typography variant="subtitle1" className={classes.narrowCell}>TP Squad Slots</Typography></BorderlessCell>*/}
              {/*<BorderlessCell><Typography variant="subtitle1">TP Units</Typography></BorderlessCell>*/}
            </TableRow>
          </TableHead>
          <TableBody>
            {restrictionUnits.map(ru => <RestrictionUnit entity={ru} key={ru.activeRestrictionUnit.id} showDisabled={showDisabled} currentFactionId={currentFactionId}/>)}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  )
}
