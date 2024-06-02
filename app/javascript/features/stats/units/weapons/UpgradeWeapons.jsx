import React from 'react'
import { makeStyles } from "@mui/styles";
import { Box, Card, Paper, Typography } from "@mui/material";
import { StaticUnitIcon } from "../../../companies/manage/unlocks/StaticUnitIcon";
import { selectUpgradeById } from "../../../companies/manage/upgrades/upgradesSlice";
import { useSelector } from "react-redux";
import { UpgradeIcon } from "../../../companies/manage/upgrades/UpgradeIcon";
import { WeaponStatsSummary } from "../../weapons/WeaponStatsSummary";

const useStyles = makeStyles(theme => ({
  headerRow: {
    display: "flex",
    alignItems: "center",
    [theme.breakpoints.down('md')]: {
      paddingLeft: '0'
    }
  },
  titleItem: {
    display: 'flex'
  },
}))

export const UpgradeWeapons = ({ upgradeId, weaponCount, slotItemCount }) => {
  const classes = useStyles()
  const upgrade = useSelector(state => selectUpgradeById(state, upgradeId))


  return (
    <Paper sx={{ width: '50%', padding: '1rem' }}>
      <Box className={classes.headerRow} pb={1}>
        <Box sx={{ display: "flex" }}>
          <Box className={classes.titleItem}>
            <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1} pr={1}>
              <UpgradeIcon upgrade={upgrade}/>
            </Box>
          </Box>
          <Box className={classes.titleItem}>
            <Typography variant="h5" gutterBottom>{upgrade.displayName}</Typography>
          </Box>
        </Box>
      </Box>
      <Box>
        {weaponCount.map(wc => <WeaponStatsSummary reference={wc.reference} count={wc.count} key={wc.reference}/>)}
      </Box>
    </Paper>
  )
}
