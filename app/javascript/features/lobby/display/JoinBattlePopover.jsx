import React, {useEffect, useState} from 'react'
import {useDispatch, useSelector} from "react-redux";
import {selectAllCompanies} from "../../companies/companiesSlice";
import {ALLIED_SIDE, doctrineImgMapping} from "../../../constants/doctrines";
import {Box, Tooltip, Typography} from "@mui/material";
import {makeStyles} from "@mui/styles";
import {joinBattle} from "../lobbySlice";

const useStyles = makeStyles(theme => ({
  wrapperRow: {
    display: 'flex',
    alignItems: 'center',
    height: '60px',
    paddingTop: '5px',
    paddingBottom: '5px'
  },
  optionImage: {
    height: '60px',
    width: '120px'
  }
}))

export const JoinBattlePopover = ({battleId, side, handleClose}) => {
  const classes = useStyles()
  const dispatch = useDispatch()

  const companies = useSelector(selectAllCompanies)
  const companiesForSide = companies.filter(c => c.side === side)

  const selectCompany = (companyId) => {
    dispatch(joinBattle({battleId, companyId}))
    handleClose()
  }

  let content
  if (companiesForSide.length > 0) {
    content = companiesForSide.map(c =>
      <Box
        key={c.id}
        sx={{display: "flex", justifyContent: 'center', cursor: 'pointer'}}
        onClick={() => selectCompany(c.id)}>
        <Tooltip title={c.name} placement="right" arrow>
          <img src={doctrineImgMapping[c.doctrineName]} alt={c.doctrineName}
               className={classes.optionImage}/>
        </Tooltip>
      </Box>
    )
  } else {
    content = <Typography>No {side} companies</Typography>
  }

  return (
    content
  )
}