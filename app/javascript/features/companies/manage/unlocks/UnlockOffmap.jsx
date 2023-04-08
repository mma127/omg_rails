import React from 'react'
import { OffmapIcon } from "../offmaps/OffmapIcon";
import { OffmapTooltip } from "../offmaps/OffmapTooltip";
import { UnlockOffmapTooltipContent } from "./UnlockOffmapTooltipContent";
import { Box } from "@mui/material";

export const UnlockOffmap = ({ enabledOffmap }) => {
  const offmap = enabledOffmap.offmap

  return (
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
  )
}
