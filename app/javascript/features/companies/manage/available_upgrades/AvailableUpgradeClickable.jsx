import React from 'react'
import { useSelector } from "react-redux";
import { Box, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";

import { selectAvailableUpgradeById } from "./availableUpgradesSlice";
import { AvailableUpgradeTooltipContent } from "./AvailableUpgradeTooltipContent";
import { UpgradeIcon } from "../upgrades/UpgradeIcon";
import { selectUpgradeById } from "../upgrades/upgradesSlice";

const useStyles = makeStyles(() => ({
  container: {
    display: "inline-block",
    padding: "2px"
  },
  wrapperEnabled: {
    cursor: 'pointer'
  }
}))
export const AvailableUpgradeClickable = ({ availableUpgradeId, onUpgradeClick, enabled }) => {
  const classes = useStyles()
  const availableUpgrade = useSelector(state => selectAvailableUpgradeById(state, availableUpgradeId))
  const upgrade = useSelector(state => selectUpgradeById(state, availableUpgrade?.upgradeId))
  const notAvailable = availableUpgrade.available <= 0

  const disabled = notAvailable || !enabled

  const onUpgradeBoxClick = () => {
    if (!disabled) {
      onUpgradeClick(availableUpgrade)
    }
  }

  return (
    <Tooltip
      key={upgrade.id}
      title={<AvailableUpgradeTooltipContent availableUpgrade={availableUpgrade} key={availableUpgrade.id} />}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box onClick={onUpgradeBoxClick} className={`${classes.container} ${disabled ? null : classes.wrapperEnabled}`}>
        <UpgradeIcon upgrade={upgrade} key={availableUpgradeId} disabled={disabled} />
      </Box>
    </Tooltip>
  )
}
