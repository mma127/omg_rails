import React from 'react'
import { useSelector } from "react-redux";
import { selectAvailableOffmapById } from "../available_offmaps/availableOffmapsSlice";
import { Box, Tooltip } from "@mui/material";
import { DEFAULT_HEIGHT, OffmapIcon } from "../offmaps/OffmapIcon";
import { nanoid } from "@reduxjs/toolkit";
import { makeStyles } from "@mui/styles";
import { AvailableOffmapTooltipContent } from "../available_offmaps/AvailableOffmapTooltipContent";

const useStyles = makeStyles(() => ({
  wrapper: {
    height: DEFAULT_HEIGHT
  }
}))
export const PurchasedOffmapClickable = ({ companyOffmap, onOffmapClick, enabled }) => {
  const classes = useStyles()
  const availableOffmap = useSelector(state => selectAvailableOffmapById(state, companyOffmap.availableOffmapId))
  const offmap = availableOffmap.offmap

  const onOffmapBoxClick = () => {
    if (enabled) {
      onOffmapClick(companyOffmap)
    }
  }

  return (
    <Box onClick={onOffmapBoxClick} margin={0.5} className={classes.wrapper}>
      <Tooltip
        key={offmap.id}
        title={<AvailableOffmapTooltipContent availableOffmap={availableOffmap} key={availableOffmap.id} skipBuffs={true} />}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box>
          <OffmapIcon offmap={offmap} key={nanoid()} disabled={!enabled} />
        </Box>
      </Tooltip>
    </Box>
  )
}
