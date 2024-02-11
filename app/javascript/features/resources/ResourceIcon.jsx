import React from "react";
import { makeStyles } from "@mui/styles";
import { RESOURCE_TO_ICON, RESOURCE_TO_NAME } from "../../constants/resources";

export const LARGE = "large"
export const MED = "med"
export const SMALL="small"

const useStyles = makeStyles(() => ({
  resourceIcon: {
    height: "24px",
    width: "24px"
  },
  resourceIconMed: {
    height: "20px",
    width: "20px"
  },
  resourceIconSmall: {
    height: "16px",
    width: "16px"
  }
}))

export const ResourceIcon = ({ resource, size = LARGE }) => {
  const classes = useStyles()
  let style
  switch (size) {
    case LARGE:
      style = classes.resourceIcon
      break
    case MED:
      style = classes.resourceIconMed
      break
    case SMALL:
      style = classes.resourceIconSmall
      break
    default:
      style = classes.resourceIcon
  }
  return (
    <img src={ RESOURCE_TO_ICON[resource] } className={ style } alt={ RESOURCE_TO_NAME[resource] }/>
  )
}
