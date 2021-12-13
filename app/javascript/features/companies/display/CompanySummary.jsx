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
    <Box m={4} sx={{ maxWidth: '600px' }} justifyContent="center">
      <Card elevation={3}>
        <CardActionArea>
          <Box sx={{ display: "flex", justifyContent: 'center' }} pt={1} pb={1}>
            <img src={doctrineImgMapping[doctrine.attributes.name]} alt={doctrine.attributes.displayName}
                 className={classes.optionImage} />
          </Box>
          <CardContent>
            <Typography variant="h6">{company.attributes.name}</Typography>
            <Typography variant="body2">Company Stats Here</Typography>
            <Typography variant="body2">Company Stats Here</Typography>
            <Typography variant="body2">Company Stats Here</Typography>
            <Typography variant="body2">Company Stats Here</Typography>
          </CardContent>
        </CardActionArea>
        <CardActions>
          <Grid container>
            <Grid item xs={11}>
              <Button variant="contained" color="secondary">Manage Company</Button>
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