import React from "react";
import { makeStyles } from "@mui/styles";
import SquareIcon from '@mui/icons-material/Square';

const useStyles = makeStyles(() => ({
  team1BalanceIcon: {
    height: "20px",
    width: "20px",
    color: "yellow",
    marginRight: "5px"
  },
  team2BalanceIcon: {
    height: "20px",
    width: "20px",
    color: "purple",
    marginRight: "5px"
  },
}))

export const TeamBalanceIcon = ({ team }) => {
  const classes = useStyles()
  const style = team == 1 ? classes.team1BalanceIcon : classes.team2BalanceIcon
  return (
    <SquareIcon className={ style } alt={ team }/>
  )
}
