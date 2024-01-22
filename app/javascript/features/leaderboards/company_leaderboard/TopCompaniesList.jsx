import React from 'react'
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectCompanyLeaderboardStat } from "../companyLeaderboardSlice";
import {
  Box,
  Card,
  CardContent,
  Table, TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from "@mui/material";
import { TYPE_TO_STAT, TYPE_TO_STAT_TITLE, TYPE_TO_TITLE } from "../../../constants/leaderboard";

const useStyles = makeStyles(() => ({
  headerRow: {
    display: "flex",
    justifyContent: "space-between",
    marginBottom: "1rem"
  },
  card: {
    flexGrow: "1"
  },
  playerOwned: {
    backgroundColor: "success.light"
  },
  companyName: {
    overflowWrap: "anywhere"
  }
}))

const CompanyRow = ({ index, companyName, value, isPlayerCompany }) => {
  const classes = useStyles()
  const color = index === 1 ? "secondary.main" : "text.secondary"

  return (
    <TableRow className={isPlayerCompany ? classes.playerOwned : null}>
      <TableCell><Typography color={color}>{index}</Typography></TableCell>
      <TableCell><Typography color={color} className={classes.companyName}>{companyName}</Typography></TableCell>
      <TableCell><Typography color={color}>{value}</Typography></TableCell>
    </TableRow>
  )
}

export const TopCompaniesList = ({ statType, player }) => {
  const classes = useStyles()

  const companies = useSelector(state => selectCompanyLeaderboardStat(state, statType))
  const statName = TYPE_TO_STAT[statType]

  return (
    <Card className={classes.card}>
      <CardContent>
        <Box className={classes.headerRow}>
          <Typography variant="h5">{TYPE_TO_TITLE[statType]}</Typography>
        </Box>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell><Typography color="text.secondary">#</Typography></TableCell>
                <TableCell><Typography color="text.secondary">Company</Typography></TableCell>
                <TableCell><Typography color="text.secondary">{TYPE_TO_STAT_TITLE[statType]}</Typography></TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {companies.map((c, idx) => <CompanyRow index={idx + 1} companyName={c.companyName} value={c[statName]}
                                                     isPlayerCompany={c.playerId === player.id}  key={idx}/>)}
            </TableBody>
          </Table>
        </TableContainer>
      </CardContent>
    </Card>
  )
}
