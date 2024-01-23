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
  TableRow, Tooltip,
  Typography
} from "@mui/material";
import {
  TOP_AVG_KILLS,
  TOP_AVG_LOSSES,
  TOP_EXP_COMPANIES, TOP_EXP_SQUADS,
  TOP_INF_KILLERS,
  TOP_INF_LOSERS,
  TOP_UNIT_KILLERS,
  TOP_UNIT_LOSERS,
  TOP_VEH_KILLERS, TOP_VEH_LOSERS,
  TOP_WIN_STREAK,
  TOP_WINS, TYPE_TO_ENTITY_TITLE,
  TYPE_TO_STAT,
  TYPE_TO_STAT_TITLE,
  TYPE_TO_TITLE
} from "../../../constants/leaderboard";
import { getVetLevel } from "../../companies/manage/units/unit_vet";

const useStyles = makeStyles((theme) => ({
  headerRow: {
    display: "flex",
    justifyContent: "space-between",
    marginBottom: "1rem"
  },
  card: {
    flexGrow: "1"
  },
  cardContent: {
    padding: '1rem'
  },
  playerOwned: {
    backgroundColor: "#536e54"
  },
  rowText: {
    lineHeight: 1.2
  },
  companyName: {
    overflowWrap: "anywhere"
  }
}))

const gameSizeBreakdownContent = (_1v1, _2v2, _3v3, _4v4) => {
  return (
    <>
      <Box><Typography variant="body"><b>1v1: </b>{_1v1}</Typography></Box>
      <Box><Typography variant="body"><b>2v2: </b>{_2v2}</Typography></Box>
      <Box><Typography variant="body"><b>3v3: </b>{_3v3}</Typography></Box>
      <Box><Typography variant="body"><b>4v4: </b>{_4v4}</Typography></Box>
    </>
  )
}

const gameSizeBreakdown = (companyStats, statType) => {
  switch (statType) {
    case TOP_EXP_COMPANIES:
      return null
    case TOP_WINS:
      return gameSizeBreakdownContent(companyStats.wins1v1, companyStats.wins2v2, companyStats.wins3v3, companyStats.wins4v4)
    case TOP_WIN_STREAK:
      return gameSizeBreakdownContent(companyStats.streak1v1, companyStats.streak2v2, companyStats.streak3v3, companyStats.streak4v4)
    case TOP_UNIT_KILLERS:
      return gameSizeBreakdownContent(companyStats.unitKills1v1, companyStats.unitKills2v2, companyStats.unitKills3v3, companyStats.unitKills4v4)
    case TOP_INF_KILLERS:
      return gameSizeBreakdownContent(companyStats.infantryKills1v1, companyStats.infantryKills2v2, companyStats.infantryKills3v3, companyStats.infantryKills4v4)
    case TOP_VEH_KILLERS:
      return gameSizeBreakdownContent(companyStats.vehicleKills1v1, companyStats.vehicleKills2v2, companyStats.vehicleKills3v3, companyStats.vehicleKills4v4)
    case TOP_UNIT_LOSERS:
      return gameSizeBreakdownContent(companyStats.unitLosses1v1, companyStats.unitLosses2v2, companyStats.unitLosses3v3, companyStats.unitLosses4v4)
    case TOP_INF_LOSERS:
      return gameSizeBreakdownContent(companyStats.infantryLosses1v1, companyStats.infantryLosses2v2, companyStats.infantryLosses3v3, companyStats.infantryLosses4v4)
    case TOP_VEH_LOSERS:
      return gameSizeBreakdownContent(companyStats.vehicleLosses1v1, companyStats.vehicleLosses2v2, companyStats.vehicleLosses3v3, companyStats.vehicleLosses4v4)

    case TOP_AVG_KILLS:
      return gameSizeBreakdownContent(companyStats.avgKills1v1, companyStats.avgKills2v2, companyStats.avgKills3v3, companyStats.avgKills4v4)
    case TOP_AVG_LOSSES:
      return gameSizeBreakdownContent(companyStats.avgLosses1v1, companyStats.avgLosses2v2, companyStats.avgLosses3v3, companyStats.avgLosses4v4)
    case TOP_EXP_SQUADS:
      return <>
        <Box><Typography variant="body"><b>Unit: </b>{companyStats.unitDisplayName}</Typography></Box>
        <Box><Typography variant="body"><b>Vet: </b>{getVetLevel(parseFloat(companyStats.vet), companyStats.vet)[0]}</Typography></Box>
      </>

    default:
      console.log(`Unknown statType ${statType}`)
      break
  }
}

const statTooltip = (companyStats, statType) => {
  return (
    <>
      <Box><Typography variant="body"><b>Player: </b>{companyStats.playerName}</Typography></Box>
      <Box><Typography variant="body"><b>Faction: </b>{companyStats.factionDisplayName}</Typography></Box>
      <Box><Typography variant="body"><b>Doctrine: </b>{companyStats.doctrineDisplayName}</Typography></Box>
      {gameSizeBreakdown(companyStats, statType)}
    </>
  )
}

const CompanyRow = ({ index, companyStats, statType, isPlayerCompany }) => {
  const classes = useStyles()
  const color = index === 1 ? "secondary.main" : "text.secondary"
  const statName = TYPE_TO_STAT[statType]

  let entity
  if (statType === TOP_EXP_SQUADS) {
    entity = companyStats.unitDisplayName
  } else {
    entity = companyStats.companyName
  }

  return (
    <Tooltip
      title={statTooltip(companyStats, statType)}>
      <TableRow className={isPlayerCompany ? classes.playerOwned : null}>
        <TableCell><Typography color={color} className={classes.rowText}>{index}</Typography></TableCell>
        <TableCell><Typography color={color} sx={{lineHeight: 1.2}}
                               className={`${classes.companyName} ${classes.rowText}`}>{entity}</Typography></TableCell>
        <TableCell><Typography color={color} className={classes.rowText}>{companyStats[statName]}</Typography></TableCell>
      </TableRow>
    </Tooltip>
  )
}

export const TopCompaniesList = ({ statType, player }) => {
  const classes = useStyles()

  const companies = useSelector(state => selectCompanyLeaderboardStat(state, statType))

  return (
    <Card className={classes.card}>
      <Box className={classes.cardContent}>
        <Box className={classes.headerRow}>
          <Typography variant="h5">{TYPE_TO_TITLE[statType]}</Typography>
        </Box>
        <TableContainer>
          <Table size="small">
            <TableHead>
              <TableRow>
                <TableCell><Typography color="text.secondary">#</Typography></TableCell>
                <TableCell><Typography color="text.secondary">{TYPE_TO_ENTITY_TITLE[statType]}</Typography></TableCell>
                <TableCell><Typography color="text.secondary">{TYPE_TO_STAT_TITLE[statType]}</Typography></TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {companies.map((c, idx) => <CompanyRow index={idx + 1} companyStats={c} statType={statType}
                                                     isPlayerCompany={c.playerId === player.id} key={idx}/>)}
            </TableBody>
          </Table>
        </TableContainer>
      </Box>
    </Card>
  )
}
