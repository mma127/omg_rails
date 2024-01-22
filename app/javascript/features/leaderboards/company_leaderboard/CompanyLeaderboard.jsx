import React, { useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Grid, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { TopCompaniesList } from "./TopCompaniesList";
import {
  TOP_EXP_COMPANIES,
  TOP_INF_KILLERS, TOP_INF_LOSERS,
  TOP_UNIT_KILLERS, TOP_UNIT_LOSERS, TOP_VEH_KILLERS, TOP_VEH_LOSERS,
  TOP_WIN_STREAK,
  TOP_WINS
} from "../../../constants/leaderboard";
import { fetchCompanyLeaderboard } from "../companyLeaderboardSlice";
import { selectPlayer } from "../../player/playerSlice";


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

const DEFAULT_LIMIT = 10

export const CompanyLeaderboard = ({}) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const player = useSelector(selectPlayer)

  useEffect(() => {
    dispatch(fetchCompanyLeaderboard(DEFAULT_LIMIT))
  }, []);

  return (
    <Box className={classes.wrapper}>
      <Grid container spacing={2}>
        <Grid item container spacing={2}>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_EXP_COMPANIES} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_WINS} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_WIN_STREAK} player={player}/>
          </Grid>
        </Grid>
        <Grid item container spacing={2}>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_UNIT_KILLERS} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_INF_KILLERS} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_VEH_KILLERS} player={player}/>
          </Grid>
        </Grid>
        <Grid item container spacing={2}>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_UNIT_LOSERS} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_INF_LOSERS} player={player}/>
          </Grid>
          <Grid item container sm={4}>
            <TopCompaniesList statType={TOP_VEH_LOSERS} player={player}/>
          </Grid>
        </Grid>
      </Grid>
    </Box>
  )
}