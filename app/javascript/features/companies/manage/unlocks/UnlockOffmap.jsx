import React from 'react'
import { OffmapIcon } from "../offmaps/OffmapIcon";
import { OffmapTooltip } from "../offmaps/OffmapTooltip";
import { UnlockOffmapTooltipContent } from "./UnlockOffmapTooltipContent";
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(() => ({
  wrapper: {
    display: "inline-flex"
  }
}))

export const UnlockOffmap = ({ enabledOffmap }) => {
  const classes = useStyles()
  const offmap = enabledOffmap.offmap

  return (
    <Box className={classes.wrapper}>
      <OffmapTooltip
        key={offmap.id}
        title={<UnlockOffmapTooltipContent enabledOffmap={enabledOffmap} key={enabledOffmap.id} />}
        followCursor={true}
        placement="bottom-start"
        arrow
      >
        <Box>
          <OffmapIcon offmap={offmap} key={enabledOffmap.id} />
        </Box>
      </OffmapTooltip>
    </Box>
  )
}
