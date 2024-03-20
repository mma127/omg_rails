import React, { useEffect } from 'react'
import { useDispatch } from "react-redux";
import { Box } from "@mui/material";
import { makeStyles } from "@mui/styles";
import { BattlesHistory } from "../../leaderboards/war_log/BattlesHistory";
import { fetchCompanyBattlesHistory } from "../../leaderboards/war_log/warLogSlice";
import { useParams } from "react-router-dom";


const useStyles = makeStyles(() => ({
  wrapper: {
    paddingLeft: '1rem',
    flexGrow: "1"
  },
  cell: {
    border: "none"
  },
  narrowCell: {
    maxWidth: "87px"
  }
}))

export const CompanyWarLog = () => {
  const classes = useStyles()
  const dispatch = useDispatch()
  let params = useParams()
  const companyId = params.companyId

  useEffect(() => {
    dispatch(fetchCompanyBattlesHistory({ companyId }))
  }, []);

  return (
    <Box className={classes.wrapper}>
      <BattlesHistory/>
    </Box>
  )
}