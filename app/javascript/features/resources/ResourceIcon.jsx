import React from "react";
import { makeStyles } from "@mui/styles";
import { RESOURCE_TO_ICON, RESOURCE_TO_NAME } from "../../constants/resources";

const useStyles = makeStyles(() => ({
  resourceIcon: {
    height: "24px",
    width: "24px"
  },
  resourceIconSmall: {
    height: "16px",
    width: "16px"
  }
}))

export const ResourceIcon = ({ resource, small = false }) => {
  const classes = useStyles()
  const style = small ? classes.resourceIconSmall : classes.resourceIcon
  return (
    <img src={ RESOURCE_TO_ICON[resource] } className={ style } alt={ RESOURCE_TO_NAME[resource] }/>
  )
}
