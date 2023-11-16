import React from "react"
import { factionImgMapping } from "../../constants/doctrines";
import { makeStyles } from "@mui/styles";


const useStyles = makeStyles(theme => ({
  image: {
    height: '60px'
    // width: '84px'
  }
}))

export const FactionIcon = ({ factionName, alt, height }) => {
  const classes = useStyles()

  return (
    <img src={factionImgMapping[factionName]} alt={alt}
         className={!_.isNumber(height) ? classes.image : null} height={height}/>
  )
}