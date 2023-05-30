import React from 'react'
import { useSelector } from "react-redux";
import { Box, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";


import { UpgradeIcon } from "../upgrades/UpgradeIcon";
import { selectUpgradeById } from "../upgrades/upgradesSlice";
import { SquadUpgradeTooltipContent } from "./SquadUpgradeTooltipContent";


const useStyles = makeStyles(() => ({
  container: {
    display: "inline-flex",
    paddingRight: "1px",
    paddingLeft: "1px"
  },
  wrapperEnabled: {
    cursor: 'pointer'
  }
}))
export const SquadUpgradeClickable = ({ squadUpgrade, onUpgradeClick, enabled }) => {
  const classes = useStyles()
  const upgrade = useSelector(state => selectUpgradeById(state, squadUpgrade.upgradeId))

  const disabled = !enabled

  const onUpgradeBoxClick = () => {
    if (!disabled) {
      onUpgradeClick(squadUpgrade)
    }
  }

  return (
    <Tooltip
      key={upgrade.id}
      title={<SquadUpgradeTooltipContent squadUpgrade={squadUpgrade} key={squadUpgrade.uuid} />}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box onClick={onUpgradeBoxClick} className={`${classes.container} ${disabled ? null : classes.wrapperEnabled}`}>
        <UpgradeIcon upgrade={upgrade} disabled={disabled} />
      </Box>
    </Tooltip>
  )
}
