import React from 'react'
import { Box, Button, Paper, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { unlockImageMapping } from "../../../../constants/unlocks/all_factions";
import { UnlockCard } from "./UnlockCard";
import { useDispatch, useSelector } from "react-redux";
import { purchaseUnlock, refundUnlock } from "./companyUnlocksSlice";
import { UnlockDetails } from "./UnlockDetails";
import { selectCompanyActiveBattleId, selectCompanyById } from "../../companiesSlice";
import { selectPlayer } from "../../../player/playerSlice";
import { selectCurrentSnapshotCompany } from "../../snapshotCompaniesSlice";

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
  constText: {
    fontSize: "0.65rem"
  },
  devOnlyText: {
    fontSize: "0.85rem",
    color: theme.palette.error.light
  },
  ownedText: {
    color: theme.palette.secondary.light
  },
  button: {
    margin: 'auto',
    marginTop: "8px"
  }
}))

export const DoctrineUnlock = ({ doctrineUnlock, companyUnlock, companyId, isSnapshot = false }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const isSaving = useSelector(state => state.companyUnlocks.isSaving)

  const player = useSelector(selectPlayer)

  let company
  let battleLocked
  if (isSnapshot) {
    company = useSelector(selectCurrentSnapshotCompany)
    battleLocked = false
  } else {
    company = useSelector(state => selectCompanyById(state, companyId))
    const activeBattleId = useSelector(state => selectCompanyActiveBattleId(state, companyId))
    battleLocked = !!activeBattleId
  }

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
              disabled={isSaving || battleLocked || isSnapshot}>
        <Typography variant="button" display="block">
          Refund {doctrineUnlock.vpCost} VP
        </Typography>
      </Button>
    )
  } else {
    buttonContent = (
      <Button variant="contained" color="secondary" size="small" onClick={purchase} className={classes.button}
              disabled={disablePurchase || battleLocked || isSnapshot}>
        <Typography variant="button" display="block">
          {doctrineUnlock.vpCost} VP
        </Typography>
      </Button>
    )
  }

  const isAdmin = player ? player.role === "admin" : false
  const isDisabled = doctrineUnlock.disabled
  const showDisabledForAdmin = isDisabled && (isAdmin || isSnapshot)

  let innerContent
  if (!isDisabled || isAdmin || (isSnapshot && isOwned)) {
    innerContent = (
      <Box p={2} className={classes.unlockInnerContainer}>
        <Typography variant="h5" gutterBottom align="center"
                    className={`${classes.titleText} ${isOwned ? classes.ownedText : null}`}>
          {unlock.displayName}
        </Typography>
        {/*<Typography className={classes.constText}>{unlock.constName}</Typography>*/}
        <Box className={classes.unlockCardBox}>
          <UnlockCard image={unlockImageMapping[unlock.name]} label={unlock.name}/>
        </Box>
        <Typography variant="body2" gutterBottom align="center" className={isOwned ? classes.ownedText : null}>
          {unlock.description}
        </Typography>
        <Box sx={{ marginTop: 'auto', display: 'flex', flexDirection: "column" }}>
          <UnlockDetails doctrineUnlock={doctrineUnlock}/>
          {showDisabledForAdmin ? <Typography className={classes.devOnlyText}>DEV ONLY</Typography> : null}
          {buttonContent}
        </Box>
      </Box>
    )
  }

  return (
    <Paper key={`${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}
           className={`${classes.unlockContainer} ${isOwned ? 'owned' : ''}`}
           elevation={isSnapshot ? 3 : 1}>
      {innerContent}
    </Paper>
  )
}
