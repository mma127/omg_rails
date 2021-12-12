import React from 'react'
import { useDispatch, useSelector } from "react-redux";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { Box, Typography, Icon } from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { makeStyles } from "@mui/styles";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { deleteCompanyById } from "../companiesSlice";

const useStyles = makeStyles(theme => ({
  optionImage: {
    height: '120px',
    width: '240px'
  }
}))

export const CompanySummary = ({ company }) => {
  const dispatch = useDispatch()
  const classes = useStyles()
  const doctrine = useSelector(state => selectDoctrineById(state, company.attributes.doctrineId))

  const deleteCompany = () => {
    dispatch(deleteCompanyById({ companyId: company.id }))
  }

  return (
    <Box>
      <Box>
        <Typography>{company.attributes.name}</Typography>
        <DeleteOutlineIcon onClick={deleteCompany} />
      </Box>
      <img src={doctrineImgMapping[doctrine.attributes.name]} alt={doctrine.attributes.displayName}
           className={classes.optionImage} />
    </Box>
  )
}