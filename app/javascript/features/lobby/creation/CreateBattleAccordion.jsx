import React, { useEffect } from 'react'
import { Box, Container, Typography, Accordion, AccordionSummary, AccordionDetails } from "@mui/material";
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';

import { ActionCableConsumer, ActionCableProvider } from 'react-actioncable-provider';
import { CreateBattleForm } from "./CreateBattleForm";
import { fetchActiveBattles } from "../lobbySlice";
import { useDispatch } from "react-redux";
import { fetchCompanies } from "../../companies/companiesSlice";

const rulesetId = 1

export const CreateBattleAccordion = ({rulesetId}) => {
  // Lobby page container
  // TODO:
  //    Chat
  //    List of active players
  //    List of games
  //    Joined game

  // Create battle accordion expansion control
  const [isExpanded, setIsExpanded] = React.useState(false);

  const handleAccordionChange = (event, isExpanded) => {
    setIsExpanded(isExpanded)
    console.log(`Toggled accordion ${isExpanded ? 'open' : 'closed'}`)
  }

  const onCreateCallback = () => {
    setIsExpanded(false)
  }

  return (
    <Accordion
      expanded={isExpanded}
      onChange={handleAccordionChange}
      TransitionProps={{ unmountOnExit: true }}
    >
      <AccordionSummary
        expandIcon={<ExpandMoreIcon />}
        id="create-battle-header"
      >
        <Typography>Create new battle</Typography>
      </AccordionSummary>
      <AccordionDetails>
        <CreateBattleForm rulesetId={rulesetId} onCreateCallback={onCreateCallback} />
      </AccordionDetails>
    </Accordion>
  )
}