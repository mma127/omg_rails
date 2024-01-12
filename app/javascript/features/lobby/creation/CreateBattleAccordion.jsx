import React, { useEffect } from 'react'
import { Box, Container, Typography, Accordion, AccordionSummary, AccordionDetails, Button } from "@mui/material";
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';

import { ActionCableConsumer, ActionCableProvider } from '@thrash-industries/react-actioncable-provider';
import { CreateBattleForm } from "./CreateBattleForm";
import { fetchActiveBattles } from "../lobbySlice";
import { useDispatch, useSelector } from "react-redux";
import { fetchCompanies } from "../../companies/companiesSlice";
import { selectIsAuthed, selectPlayer, selectPlayerCurrentBattleId } from "../../player/playerSlice";

const rulesetId = 1

export const CreateBattleAccordion = ({rulesetId}) => {
  // Create battle accordion expansion control
  const [isExpanded, setIsExpanded] = React.useState(false);
  const isAuthed = useSelector(selectIsAuthed)
  const currentBattleId = useSelector(selectPlayerCurrentBattleId)

  const isDisabled = isAuthed && !!currentBattleId

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
      disabled={isDisabled}
      onChange={handleAccordionChange}
      TransitionProps={{ unmountOnExit: true }}
    >
      <AccordionSummary
        expandIcon={<ExpandMoreIcon />}
        id="create-battle-header"
      >
        <Button variant="contained" color="secondary" disabled={isExpanded || isDisabled}>Create New Battle</Button>
      </AccordionSummary>
      <AccordionDetails>
        <CreateBattleForm rulesetId={rulesetId} onCreateCallback={onCreateCallback} />
      </AccordionDetails>
    </Accordion>
  )
}