import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Grid, Typography } from "@mui/material";

export const StatsDisplay = ({ stats }) => {

  const wins = stats.wins1v1 + stats.wins2v2 + stats.wins3v3 + stats.wins4v4
  const losses = stats.losses1v1 + stats.losses2v2 + stats.losses3v3 + stats.losses4v4
  const gamesPlayed = wins + losses
  const winRatio = gamesPlayed > 0 ? ((wins / (wins + losses)) * 100).toFixed(0) : "-"

  const totalInfKills = stats.infantryKills1v1 + stats.infantryKills2v2 + stats.infantryKills3v3 + stats.infantryKills4v4
  const totalVehKills = stats.vehicleKills1v1 + stats.vehicleKills2v2 + stats.vehicleKills3v3 + stats.vehicleKills4v4
  const totalKills = totalInfKills + totalVehKills

  const totalInfLosses = stats.infantryLosses1v1 + stats.infantryLosses2v2 + stats.infantryLosses3v3 + stats.infantryLosses4v4
  const totalVehLosses = stats.vehicleLosses1v1 + stats.vehicleLosses2v2 + stats.vehicleLosses3v3 + stats.vehicleLosses4v4
  const totalLosses = totalInfLosses + totalVehLosses

  const totalKD = totalLosses > 0 ? (totalKills / totalLosses).toFixed(2) : "-"

  return (
    <Grid container mt={1}>
      <Grid item container key="win-loss" mt={1}>
        <Grid item xs={6}><Box><Typography variant="body"><b>Wins/Losses:</b> {wins}/{losses}</Typography></Box></Grid>
        <Grid item xs={6}><Box><Typography variant="body"><b>Win Ratio:</b> {winRatio}%</Typography></Box></Grid>
      </Grid>
      <Grid item container key="kills" mt={1}>
        <Grid item sm={4} xs={12}><Box><Typography variant="body"><b>Total Kills:</b> {totalKills}</Typography></Box></Grid>
        <Grid item sm={4} xs={6}><Box><Typography variant="body"><b>Inf Kills:</b> {totalInfKills}</Typography></Box></Grid>
        <Grid item sm={4} xs={6}><Box><Typography variant="body"><b>Veh Kills:</b> {totalVehKills}</Typography></Box></Grid>
      </Grid>
      <Grid item container key="losses" mt={1}>
        <Grid item sm={4} xs={12}><Box><Typography variant="body"><b>Total Losses:</b> {totalLosses}</Typography></Box></Grid>
        <Grid item sm={4} xs={6}><Box><Typography variant="body"><b>Inf Losses:</b> {totalInfLosses}</Typography></Box></Grid>
        <Grid item sm={4} xs={6}><Box><Typography variant="body"><b>Veh Losses:</b> {totalVehLosses}</Typography></Box></Grid>
      </Grid>
      <Grid item container key="kd" mt={1}>
        <Grid item xs={6}><Box><Typography variant="body"><b>Total K/D:</b> {totalKD}</Typography></Box></Grid>
      </Grid>
    </Grid>
  )
}
