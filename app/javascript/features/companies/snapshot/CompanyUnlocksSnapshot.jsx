import React, { useEffect } from 'react'
import { Accordion, AccordionDetails, AccordionSummary, Box, Grid, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useDispatch, useSelector } from "react-redux";
import { selectCurrentSnapshotCompany } from "../snapshotCompaniesSlice";
import { fetchDoctrineUnlocksByDoctrineId, selectDoctrineUnlockRowsByDoctrineId } from "../../doctrines/doctrinesSlice";
import { DoctrineUnlock } from "../manage/unlocks/DoctrineUnlock";
import { selectCompanyUnlocksByDoctrineUnlockId } from "../manage/unlocks/companyUnlocksSlice";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import _ from "lodash";
import { selectActiveRuleset } from "../../rulesets/rulesetsSlice";

const useStyles = makeStyles(theme => ({
  container: {
    display: "flex",
    flexGrow: 1
  },
  unitCountWrapper: {
    display: "flex",
    alignItems: "center",
    padding: "0.5rem"
  },
  unitIconWrapper: {
    marginRight: '0.5rem'
  },
  unitCountText: {
    width: "30px"
  },
  detailsContainer: {
    display: 'flex',
    flexWrap: "wrap"
  }
}))

const buildUnlock = (doctrineUnlock, companyUnlocksByDoctrineUnlockId, companyId) => {
  const companyUnlock = _.get(companyUnlocksByDoctrineUnlockId, doctrineUnlock.id, null)

  return (
    <Grid item xs={2} key={`grid-${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}>
      <DoctrineUnlock doctrineUnlock={doctrineUnlock} companyUnlock={companyUnlock} companyId={companyId} isSnapshot={true}/>
    </Grid>
  )
}

const buildUnlockRow = (i, unlockRow, companyUnlocksByDoctrineUnlockId, companyId) => {
  return (
    <Grid item container spacing={2} key={`row-${i}`}>
      {
        unlockRow.map(u => buildUnlock(u, companyUnlocksByDoctrineUnlockId, companyId))
      }
    </Grid>
  )
}

export const CompanyUnlocksSnapshot = ({ }) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const snapshot = useSelector(selectCurrentSnapshotCompany)
  const doctrineUnlockRows = useSelector(state => selectDoctrineUnlockRowsByDoctrineId(state, snapshot.doctrineId))
  const companyUnlocksByDoctrineUnlockId = useSelector(selectCompanyUnlocksByDoctrineUnlockId)
  const activeRuleset = useSelector(selectActiveRuleset)

  useEffect(() => {
    dispatch(fetchDoctrineUnlocksByDoctrineId({ doctrineId: snapshot.doctrineId, rulesetId: activeRuleset.id }))
  }, [snapshot.id])

  let content
  if (!_.isEmpty(doctrineUnlockRows)) {
    const keys = Object.keys(doctrineUnlockRows).sort()
    content = keys.map(i => buildUnlockRow(i, doctrineUnlockRows[i], companyUnlocksByDoctrineUnlockId, snapshot.id))
  } else {
    content = (
      <Box></Box>
    )
  }
  return (
    <Box p={2} className={classes.container}>
      <Accordion sx={{ flexGrow: 1 }}>
        <AccordionSummary
          expandIcon={<ExpandMoreIcon/>}
          sx={{ margin: "0" }}
        >
          <Typography variant="h6" color="text.secondary">Doctrine Unlocks</Typography>
        </AccordionSummary>
        <AccordionDetails sx={{ paddingTop: 0, paddingBottom: "0.5rem" }}>
          <Grid item container>
            <Grid item md={4} p={2}>
              <Typography variant="h5">
                Available VPs: {snapshot.vpsCurrent}
              </Typography>
            </Grid>
          </Grid>
          <Grid container spacing={2}>
            {content}
          </Grid>
        </AccordionDetails>
      </Accordion>
    </Box>
  )
}
