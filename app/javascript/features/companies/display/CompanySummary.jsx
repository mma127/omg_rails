import React from 'react'
import { useDispatch, useSelector } from "react-redux";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { Box, Typography, Icon, Grid } from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { makeStyles } from "@mui/styles";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { deleteCompanyById } from "../companiesSlice";

const useStyles = makeStyles(theme => ({
  optionImage: {
    height: '120px',
    width: '240px'
  },
  deleteIcon: {
    cursor: 'pointer'
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
    <Box m={5} sx={{ maxWidth: '535px' }} justifyContent="center">
      <Grid container pb={2}>
        <Grid item xs={11}>
          <Typography variant="h6">{company.attributes.name}</Typography>
        </Grid>
        <Grid item xs={1}>
          <DeleteOutlineIcon onClick={deleteCompany} className={classes.deleteIcon} color="error"/>
        </Grid>
      </Grid>
      <img src={doctrineImgMapping[doctrine.attributes.name]} alt={doctrine.attributes.displayName}
           className={classes.optionImage} />
    </Box>
  )
}