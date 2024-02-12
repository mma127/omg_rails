import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { Box, Tooltip } from "@mui/material";
import { makeStyles } from "@mui/styles";


import { UpgradeIcon } from "../upgrades/UpgradeIcon";
import { selectUpgradeById } from "../upgrades/upgradesSlice";
import { SquadUpgradeTooltipContent } from "./SquadUpgradeTooltipContent";
import { clearHighlightedUuid, selectHighlightedUuid, setHighlightedUuid } from "../units/squadsSlice";


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
export const SquadUpgradeClickable = ({ squadUpgrade, onUpgradeClick, enabled, isSnapshot }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const elementRef = useRef()
  const upgrade = useSelector(state => selectUpgradeById(state, squadUpgrade.upgradeId))

  const [isTooltipOpen, setIsTooltipOpen] = useState(false)

  const disabled = !enabled

  const highlightedUuid = useSelector(selectHighlightedUuid)
  const isHighlighted = squadUpgrade.uuid === highlightedUuid
  useEffect(() => {
    const hasGhost = !!elementRef.current.closest(".ddcontainerghost")
    if (isHighlighted && !hasGhost) {
      setIsTooltipOpen(true)
    } else if (isTooltipOpen) {
      setIsTooltipOpen(false)
    }
  }, [isHighlighted]);

  const onUpgradeBoxClick = () => {
    if (!disabled) {
      onUpgradeClick(squadUpgrade)
    }
  }

  const handleTooltipOpen = () => {
    dispatch(setHighlightedUuid({ uuid: squadUpgrade.uuid }))
  }
  const handleTooltipClose = () => {
    dispatch(clearHighlightedUuid())
  }

  return (
    <Tooltip
      key={upgrade.id}
      open={isTooltipOpen}
      onMouseLeave={handleTooltipClose}
      onMouseEnter={handleTooltipOpen}
      title={<SquadUpgradeTooltipContent squadUpgrade={squadUpgrade} key={squadUpgrade.uuid}/>}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box onClick={onUpgradeBoxClick} className={`${classes.container} ${(disabled || isSnapshot) ? null : classes.wrapperEnabled}`}
           ref={elementRef}>
        <UpgradeIcon upgrade={upgrade} disabled={disabled}/>
      </Box>
    </Tooltip>
  )
}
