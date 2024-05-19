import { Typography } from "@mui/material";
import { withStyles } from "@mui/styles";

export const StatsLabelTypography = withStyles(theme => ({
  root: {
    color: theme.palette.text.label,
    maxWidth: "9rem"
  }
}))(Typography)