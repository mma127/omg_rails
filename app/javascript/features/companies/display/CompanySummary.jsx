import React from 'react'
import { useDispatch, useSelector } from "react-redux";
import { selectDoctrineById } from "../../doctrines/doctrinesSlice";
import { Box, Button, Card, CardActionArea, CardActions, CardContent, Grid, Typography } from "@mui/material";
import { doctrineImgMapping } from "../../../constants/doctrines";
import { makeStyles } from "@mui/styles";
import DeleteOutlineIcon from '@mui/icons-material/DeleteOutline';
import { deleteCompanyById, setCurrentCompany } from "../companiesSlice";
import { useNavigate } from "react-router-dom";
import { StatsDisplay } from "./StatsDisplay";
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';

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

  const [deleteDialogOpen, setDeleteDialogOpen] = React.useState(false);

  const deleteCompany = () => {
    dispatch(deleteCompanyById({ companyId: company.id }))
  }

  const handleDeleteClick = () => {
    setDeleteDialogOpen(true);
  };

  const handleDeleteCancel = () => {
    setDeleteDialogOpen(false);
  };

  const handleDeleteAction = () => {
    deleteCompany();
    setDeleteDialogOpen(false);
  };

  const managementLink = `/companies/${company.id}`

  const manageCompany = () => {
    dispatch(setCurrentCompany(company))
    navigate(managementLink)
  }

  if (!doctrine) {
    return null
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
              <DeleteOutlineIcon onClick={handleDeleteClick} className={classes.deleteIcon} color="error"/>
            </Grid>
          </Grid>
        </CardActions>
      </Card>
      <Dialog
        open={deleteDialogOpen}
        onClose={handleDeleteCancel}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">
          {"Delete Company?"}
        </DialogTitle>
        <DialogContent>
          <DialogContentText id="alert-dialog-description">
            Are you sure you want to delete this company? <br />
            It cannot be undone.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDeleteCancel}>Cancel</Button>
          <Button onClick={handleDeleteAction} autoFocus>
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  )
}