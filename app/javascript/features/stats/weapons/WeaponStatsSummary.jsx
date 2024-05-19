import React from 'react'
import { Box, Link, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { useSelector } from "react-redux";
import { selectStatsWeaponByReference } from "./statsWeaponsSlice";
import { Link as RouterLink } from "react-router-dom";

const useStyles = makeStyles(theme => ({
}))

export const WeaponStatsSummary = ({ reference }) => {
  const classes = useStyles()
  const weapon = useSelector(state => selectStatsWeaponByReference(state, reference))

  const displayName = weapon?.displayName || reference
  const encodedReference = encodeURIComponent(reference)
  return (
    <Box>
      <Link component={RouterLink} to={`/restrictions/weapon/${weapon.id}/${encodedReference}`}
            underline="none" color="inherit" target="_blank">
        <Typography color="secondary">{displayName}</Typography>
      </Link>
    </Box>
  )
}
