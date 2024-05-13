import { withStyles } from "@mui/styles";
import { Container } from "@mui/material";

/* This component displays text in a similar style to error helperText for inputs */
export const PageContainer = withStyles(() => ({
  root: {
    paddingBottom: "4rem",
  }
}))(Container)