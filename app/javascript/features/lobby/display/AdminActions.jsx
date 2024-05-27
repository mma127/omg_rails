import React from 'react'
import { useSelector } from "react-redux";
import { selectPlayer } from "../../player/playerSlice";
import { Accordion, AccordionDetails, AccordionSummary } from "@mui/material";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { ChangeBattleSize } from "./ChangeBattleSize";
import { makeStyles } from "@mui/styles";

const useStyles = makeStyles(theme => ({
  summary: {
    minHeight: "1rem",
    "& .MuiAccordionSummary-content": {
      margin: "2px 0"
    }
  }
}))

export const AdminActions = ({ battleId }) => {
  const classes = useStyles()
  const player = useSelector(selectPlayer)
  const isAdmin = player ? player.role === "admin" : false

  if (!isAdmin) {
    return null
  }

  return (
    <Accordion disableGutters={true}>
      <AccordionSummary
        className={classes.summary}
        expandIcon={<ExpandMoreIcon/>}>
        Admin
      </AccordionSummary>
      <AccordionDetails>
        <ChangeBattleSize battleId={battleId}/>
      </AccordionDetails>
    </Accordion>
  )
}
