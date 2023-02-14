import React from 'react'
import { styled } from '@mui/material/styles';
import { Box, Button, Paper, Tooltip, tooltipClasses, Typography } from "@mui/material";
import EastIcon from '@mui/icons-material/East';
import { makeStyles } from "@mui/styles";
import { unlockImageMapping } from "../../../../constants/unlocks/all_factions";
import { UnlockCard } from "./UnlockCard";
import { useDispatch, useSelector } from "react-redux";
import { purchaseUnlock, refundUnlock } from "./companyUnlocksSlice";
import { StaticUnitIcon } from "./StaticUnitIcon";

const useStyles = makeStyles(theme => ({
  unlockContainer: {
    display: 'flex',
    minHeight: '25rem',
    minWidth: '4rem',
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
    margin: 'auto'
  }
}))

const UnlockTooltip = styled(({className, ...props}) => (
  <Tooltip {...props} classes={{popper: className}} />
))({
  [`& .${tooltipClasses.tooltip}`]: {
    backgroundColor: 'rgba(97,97,97,1)'
  }
})

const buildEnabledUnits = (enabledUnits) => {
  if (enabledUnits.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="success.dark">Available for Purchase</Typography>
      {enabledUnits.map(eu => (<StaticUnitIcon name={eu.unit.name} key={eu.id} />))}
    </Box>
  )
}

const buildDisabledUnits = (disabledUnits) => {
  if (disabledUnits.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="error.main">No Longer Purchasable</Typography>
      {disabledUnits.map(du => (<StaticUnitIcon name={du.unit.name} key={du.id} />))}
    </Box>
  )
}

const buildUnitSwaps = (unitSwaps) => {
  if (unitSwaps.length === 0) {
    return null
  }
  return (
    <Box>
      <Typography variant="subtitle2" color="info.dark">Squad Unit Swaps</Typography>
      {
        unitSwaps.map(us => (
          <Box sx={{ display: "flex", alignItems: "center" }} key={us.id}>
            <StaticUnitIcon name={us.oldUnit.name} />
            <Box sx={{ paddingLeft: '1rem', paddingRight: '1rem' }}>
              <EastIcon />
            </Box>
            <StaticUnitIcon name={us.newUnit.name} />
          </Box>
        ))}
    </Box>
  )
}

export const DoctrineUnlock = ({ doctrineUnlock, companyUnlock }) => {
  const classes = useStyles()
  const dispatch = useDispatch()
  const isSaving = useSelector(state => state.companyUnlocks.isSaving)

  const unlock = doctrineUnlock.unlock
  const isOwned = !_.isNil(companyUnlock)

  const enabledUnits = doctrineUnlock.enabledUnits
  const disabledUnits = doctrineUnlock.disabledUnits
  const unitSwaps = doctrineUnlock.unitSwaps

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
              disabled={isSaving}>
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
        <Box sx={{ marginTop: 'auto' }}>
          {buttonContent}
        </Box>
      </Box>
    )
  }

  return (
    <UnlockTooltip
      key={doctrineUnlock.id}
      title={
        <>
          {buildEnabledUnits(enabledUnits)}
          {buildDisabledUnits(disabledUnits)}
          {buildUnitSwaps(unitSwaps)}
        </>
      }
      followCursor={true}
      placement="bottom-start"
      arrow
    >
      <Paper key={`${doctrineUnlock.tree}-${doctrineUnlock.branch}-${doctrineUnlock.row}`}
             className={`${classes.unlockContainer} ${isOwned ? 'owned' : ''}`}>
        {innerContent}
      </Paper>
    </UnlockTooltip>
  )
}
