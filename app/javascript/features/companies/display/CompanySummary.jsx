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
import { deleteCompanyById } from "../companiesSlice";
import { Link, useNavigate } from "react-router-dom";

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
    navigate(managementLink)
  }

  return (
    <Box m={4} sx={{ maxWidth: '600px' }} justifyContent="center">
      <Card elevation={3}>
          <CardActionArea onClick={manageCompany}>
            <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
              <img src={doctrineImgMapping[doctrine.name]} alt={doctrine.displayName}
                   className={classes.optionImage} />
            </Box>
            <CardContent>
              <Typography variant="h6">{company.name}</Typography>
              <Typography variant="body2">Company Stats Here</Typography>
              <Typography variant="body2">Company Stats Here</Typography>
              <Typography variant="body2">Company Stats Here</Typography>
              <Typography variant="body2">Company Stats Here</Typography>
            </CardContent>
          </CardActionArea>
        <CardActions>
          <Grid container>
            <Grid item xs={11}>
              <Button variant="contained" to={`/companies/${company.id}`} component={Link} color="secondary">Manage Company</Button>
            </Grid>
            <Grid item xs={1}>
              <DeleteOutlineIcon onClick={deleteCompany} className={classes.deleteIcon} color="error" />
            </Grid>
          </Grid>
        </CardActions>
      </Card>
    </Box>
  )
}