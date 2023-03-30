import React from "react";
import { styled } from "@mui/material/styles";
import { Tooltip, tooltipClasses } from "@mui/material";

export const OffmapTooltip = styled(({ className, ...props }) => (
  <Tooltip {...props} classes={{ popper: className }} />
))({
  [`& .${tooltipClasses.tooltip}`]: {
    backgroundColor: 'rgba(97,97,97,1)'
  }
})