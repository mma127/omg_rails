import { Typography } from "@mui/material";
import { withStyles } from "@mui/styles";

export const LabelTypography = withStyles(theme => ({
  root: {
    color: theme.palette.text.label
  }
}))(Typography)