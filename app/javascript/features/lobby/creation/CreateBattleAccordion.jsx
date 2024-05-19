import React from 'react'
import { Accordion, AccordionDetails, AccordionSummary, Button } from "@mui/material";
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import { CreateBattleForm } from "./CreateBattleForm";
import { useSelector } from "react-redux";
import { selectIsAuthed, selectPlayerCurrentBattleId } from "../../player/playerSlice";

export const CreateBattleAccordion = ({}) => {
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
        <CreateBattleForm onCreateCallback={onCreateCallback} />
      </AccordionDetails>
    </Accordion>
  )
}