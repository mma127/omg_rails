import React from 'react'
import { useSelector } from "react-redux";
import { selectAvailableOffmapById } from "./availableOffmapsSlice";
import { OffmapIcon } from "../offmaps/OffmapIcon";
import { Box, Tooltip } from "@mui/material";
import { AvailableOffmapTooltipContent } from "./AvailableOffmapTooltipContent";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  container: {
    display: "inline-block",
    padding: "2px"
  },
  wrapperEnabled: {
    cursor: 'pointer'
  }
}))
export const AvailableOffmapClickable = ({ availableOffmapId, onOffmapClick, enabled }) => {
  const classes = useStyles()
  const availableOffmap = useSelector(state => selectAvailableOffmapById(state, availableOffmapId))
  const offmap = availableOffmap.offmap
  const notAvailable = availableOffmap.available <= 0

  const disabled = notAvailable || !enabled

  const onOffmapBoxClick = () => {
    if (!disabled) {
      onOffmapClick(availableOffmap)
    }
  }

  return (
    <Tooltip
      key={offmap.id}
      title={<AvailableOffmapTooltipContent availableOffmap={availableOffmap} key={availableOffmap.id} />}
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Box onClick={onOffmapBoxClick} className={`${classes.container} ${disabled ? null : classes.wrapperEnabled}`}>
        <OffmapIcon offmap={offmap} key={availableOffmapId} disabled={disabled} />
      </Box>
    </Tooltip>
  )
}
