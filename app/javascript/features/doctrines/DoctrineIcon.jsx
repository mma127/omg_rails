import React from "react"
import { doctrineImgMapping } from "../../constants/doctrines";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  image: {
    height: '60px',
    width: '120px'
  },
  inactive: {
    opacity: "0.5"
  }
}))

export const DoctrineIcon = ({ doctrineName, alt, height, doctrineId, onDoctrineClick, isActive = true }) => {
  const classes = useStyles()

  const handleClick = () => {
    if (onDoctrineClick) {
      onDoctrineClick({ doctrineName, doctrineId })
    }
  }

  return (
    <img src={doctrineImgMapping[doctrineName]} alt={alt}
         className={`${!_.isNumber(height) ? classes.image : null} ${!isActive ? classes.inactive : null}`}
         style={{ verticalAlign: "middle" }} height={height} onClick={handleClick}/>
  )
}
