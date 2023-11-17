import React from "react"
import { factionImgMapping } from "../../constants/doctrines";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  image: {
    height: '60px'
    // width: '84px'
  },
  inactive: {
    opacity: "0.5"
  }
}))

export const FactionIcon = ({ factionName, alt, height, factionId, onFactionClick, isActive = true }) => {
  const classes = useStyles()

  const handleClick = () => {
    if (onFactionClick) {
      onFactionClick({factionName, factionId})
    }
  }

  return (
    <img src={factionImgMapping[factionName]} alt={alt}
         className={`${!_.isNumber(height) ? classes.image : null} ${!isActive ? classes.inactive : null}`}
         style={{ verticalAlign: "middle" }} height={height} onClick={handleClick}
    />
  )
}
