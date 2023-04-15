import React from 'react'
import { styled } from '@mui/material/styles';
import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Button,
  Paper,
  Tooltip,
  tooltipClasses,
  Typography
} from "@mui/material";
import EastIcon from '@mui/icons-material/East';
import { makeStyles } from "@mui/styles";
import { unlockImageMapping } from "../../../../constants/unlocks/all_factions";
import { UnlockCard } from "./UnlockCard";
import { useDispatch, useSelector } from "react-redux";
import { purchaseUnlock, refundUnlock } from "./companyUnlocksSlice";
import { StaticUnitIcon } from "./StaticUnitIcon";
import { OffmapIcon } from "../offmaps/OffmapIcon";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import { UnlockDetails } from "./UnlockDetails";
import { selectCompanyById } from "../../companiesSlice";

const useStyles = makeStyles(theme => ({
  unlockContainer: {
    display: 'flex',
    minHeight: '25rem',
    minWidth: '4rem',
    height: '100%',
    '&.owned': {
      borderColor: theme.palette.secondary.light,
      borderWidth: '2px',
      borderStyle: 'solid'
    }
  },
  unlockInnerContainer: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    flex: 1
  },
  unlockCardBox: {
    display: 'flex',
    justifyContent: 'center',
    marginBottom: '0.35em'
  },
  titleText: {
    minHeight: '4rem'
  },
  ownedText: {
    color: theme.palette.secondary.light
  },
  button: {
    margin: 'auto',
    marginTop: "8px"
  }
}))

export const DoctrineUnlock = ({ doctrineUnlock, companyUnlock, companyId }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const isSaving = useSelector(state => state.companyUnlocks.isSaving)
  const company = useSelector(state => selectCompanyById(state, companyId))

  const unlock = doctrineUnlock.unlock
  const isOwned = !_.isNil(companyUnlock)
  const canPurchase = company.vpsCurrent >= doctrineUnlock.vpCost

  const disablePurchase = isSaving || !canPurchase

  const purchase = () => {
    dispatch(purchaseUnlock({ doctrineUnlockId: doctrineUnlock.id }))
  }

  const refund = () => {
    dispatch(refundUnlock({ companyUnlockId: companyUnlock.id }))
  }

  let buttonContent
  if (isOwned) {
    buttonContent = (
      <Button variant="contained" color="error" size="small" onClick={refund} className={classes.button}
              disabled={isSaving}>
        <Typography variant="button" display="block">
          Refund {doctrineUnlock.vpCost} VP
        </Typography>
      </Button>
    )
  } else {
    buttonContent = (
      <Button variant="contained" color="secondary" size="small" onClick={purchase} className={classes.button}
              disabled={disablePurchase}>
        <Typography variant="button" display="block">
          {doctrineUnlock.vpCost} VP
        </Typography>
      </Button>
    )
  }

  let innerContent
  if (!doctrineUnlock.disabled) {
    innerContent = (
      <Box p={2} className={classes.unlockInnerContainer}>
        <Typography variant="h5" gutterBottom align="center"
                    className={`${classes.titleText} ${isOwned ? classes.ownedText : null}`}>
          {unlock.displayName}
        </Typography>
        <Box className={classes.unlockCardBox}>
          <UnlockCard image={unlockImageMapping[unlock.name]} label={unlock.name} />
        </Box>
        <Typography variant="body2" gutterBottom align="center" className={isOwned ? classes.ownedText : null}>
          {unlock.description}
        </Typography>
        <Box sx={{ marginTop: 'auto', display: 'flex', flexDirection: "column" }}>
          <UnlockDetails doctrineUnlock={doctrineUnlock} />
          {buttonContent}
        </Box>
      </Box>
    )
  }

  return (
    <Paper key={`${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}
           className={`${classes.unlockContainer} ${isOwned ? 'owned' : ''}`}>
      {innerContent}
    </Paper>
  )
}
