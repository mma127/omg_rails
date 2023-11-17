import React from "react"
import { doctrineImgMapping } from "../../constants/doctrines";
import { makeStyles } from "@mui/styles";


const useStyles = makeStyles(theme => ({
  image: {
    height: '60px',
    width: '120px'
  }
}))

export const DoctrineIcon = ({ doctrineName, alt, height }) => {
  const classes = useStyles()

  return (
    <img src={doctrineImgMapping[doctrineName]} alt={alt}
         className={!_.isNumber(height) ? classes.image : null} style={{verticalAlign: "middle"}} height={height}/>
  )
}