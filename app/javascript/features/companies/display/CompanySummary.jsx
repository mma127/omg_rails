import React from 'react'
import { useDispatch, useSelector } from "react-redux";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import {
  Box,
  Typography,
  Icon,
  Grid,
  Paper,
  Card,
  CardContent,
  CardActionArea,
  CardMedia,
  CardActions, Button
} from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { makeStyles } from "@mui/styles";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { deleteCompanyById, setCurrentCompany } from "../companiesSlice";
import { Link, useNavigate } from "react-router-dom";
import { StatsDisplay } from "./StatsDisplay";

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
  let navigate = useNavigate()

  const doctrine = useSelector(state => selectDoctrineById(state, company.doctrineId))

  const deleteCompany = () => {
    dispatch(deleteCompanyById({ companyId: company.id }))
  }

  const managementLink = `/companies/${company.id}`

  const manageCompany = () => {
    dispatch(setCurrentCompany(company))
    navigate(managementLink)
  }

  return (
    <Box ml={5} mr={5} mt={1} mb={1} sx={{ maxWidth: '600px', flexGrow: 1, display: "flex" }} justifyContent="center">
      <Card elevation={3} sx={{display: "flex", flexDirection: "column"}}>
        <CardActionArea onClick={manageCompany} sx={{flexGrow: 1}}>
          <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
            <img src={doctrineImgMapping[doctrine.name]} alt={doctrine.displayName}
                 className={classes.optionImage}/>
          </Box>
          <CardContent>
            <Typography variant="h6">{company.name}</Typography>
            <StatsDisplay stats={company.companyStats}/>
          </CardContent>
        </CardActionArea>
        <CardActions>
          <Grid container>
            <Grid item xs={11}>
              <Button variant="contained" onClick={manageCompany} color="secondary">Manage Company</Button>
            </Grid>
            <Grid item xs={1}>
              <DeleteOutlineIcon onClick={deleteCompany} className={classes.deleteIcon} color="error"/>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    </Box>
  )
}